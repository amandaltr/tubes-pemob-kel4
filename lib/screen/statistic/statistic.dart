import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class StatisticPage extends StatefulWidget {
  const StatisticPage({super.key});

  @override
  State<StatisticPage> createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  String filter = "Weekly"; // Daily | Weekly | Monthly | Year

  Stream<QuerySnapshot<Map<String, dynamic>>> getTransactions() {
    // ✅ urut pakai Timestamp
    return FirebaseFirestore.instance
        .collection("transactions")
        .orderBy("createdAt", descending: false)
        .snapshots();
  }

  double _amount(dynamic raw) {
    if (raw == null) return 0;
    if (raw is num) return raw.toDouble();
    return double.tryParse(raw.toString()) ?? 0;
  }

  bool _isIncome(String type) => type.toLowerCase() == "income";
  bool _isExpense(String type) =>
      type.toLowerCase() == "spend" || type.toLowerCase() == "expense";

  DateTime? _dt(Map<String, dynamic> r) {
    final raw = r["createdAt"];
    if (raw is Timestamp) return raw.toDate();
    return null; // kalau ada data lama yang belum punya createdAt, dia akan diskip
  }

  Map<String, double> _totals(List<Map<String, dynamic>> rows) {
    double income = 0, expense = 0;
    for (final r in rows) {
      final type = (r["type"] ?? "").toString();
      final amt = _amount(r["amount"]);
      if (_isIncome(type)) income += amt;
      if (_isExpense(type)) expense += amt;
    }
    return {"income": income, "expense": expense, "balance": income - expense};
  }

  late List<double> incomeBuckets;
  late List<double> expenseBuckets;

  int _daysInMonth(DateTime d) {
    final firstNextMonth = DateTime(d.year, d.month + 1, 1);
    return firstNextMonth.subtract(const Duration(days: 1)).day;
  }

  void _buildBuckets(List<Map<String, dynamic>> rows) {
    final now = DateTime.now();

    if (filter == "Daily") {
      incomeBuckets = List.filled(24, 0);
      expenseBuckets = List.filled(24, 0);

      for (final r in rows) {
        final dt = _dt(r);
        if (dt == null) continue;
        if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
          final amt = _amount(r["amount"]);
          final type = (r["type"] ?? "").toString();
          if (_isIncome(type)) incomeBuckets[dt.hour] += amt;
          if (_isExpense(type)) expenseBuckets[dt.hour] += amt;
        }
      }
      return;
    }

    if (filter == "Weekly") {
      incomeBuckets = List.filled(7, 0);
      expenseBuckets = List.filled(7, 0);

      final startOfWeek = DateTime(now.year, now.month, now.day)
          .subtract(Duration(days: now.weekday - 1)); // Senin
      final end = startOfWeek.add(const Duration(days: 7));

      for (final r in rows) {
        final dt = _dt(r);
        if (dt == null) continue;
        if (!dt.isBefore(startOfWeek) && dt.isBefore(end)) {
          final idx = dt.weekday - 1;
          final amt = _amount(r["amount"]);
          final type = (r["type"] ?? "").toString();
          if (_isIncome(type)) incomeBuckets[idx] += amt;
          if (_isExpense(type)) expenseBuckets[idx] += amt;
        }
      }
      return;
    }

    if (filter == "Monthly") {
      final days = _daysInMonth(now);
      incomeBuckets = List.filled(days, 0);
      expenseBuckets = List.filled(days, 0);

      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 1);

      for (final r in rows) {
        final dt = _dt(r);
        if (dt == null) continue;
        if (!dt.isBefore(start) && dt.isBefore(end)) {
          final idx = dt.day - 1;
          final amt = _amount(r["amount"]);
          final type = (r["type"] ?? "").toString();
          if (_isIncome(type)) incomeBuckets[idx] += amt;
          if (_isExpense(type)) expenseBuckets[idx] += amt;
        }
      }
      return;
    }

    // Year
    incomeBuckets = List.filled(12, 0);
    expenseBuckets = List.filled(12, 0);

    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year + 1, 1, 1);

    for (final r in rows) {
      final dt = _dt(r);
      if (dt == null) continue;
      if (!dt.isBefore(start) && dt.isBefore(end)) {
        final idx = dt.month - 1;
        final amt = _amount(r["amount"]);
        final type = (r["type"] ?? "").toString();
        if (_isIncome(type)) incomeBuckets[idx] += amt;
        if (_isExpense(type)) expenseBuckets[idx] += amt;
      }
    }
  }

  double _maxY() {
    double m = 0;
    for (int i = 0; i < incomeBuckets.length; i++) {
      if (incomeBuckets[i] > m) m = incomeBuckets[i];
      if (expenseBuckets[i] > m) m = expenseBuckets[i];
    }
    return m <= 0 ? 10 : m * 1.2;
  }

  double _chartWidth() {
    if (filter == "Daily") return 24 * 22;
    if (filter == "Weekly") return 7 * 44;
    if (filter == "Monthly") return incomeBuckets.length * 18;
    return 12 * 44;
  }

  List<BarChartGroupData> _groups() {
    return List.generate(incomeBuckets.length, (i) {
      return BarChartGroupData(
        x: i,
        barsSpace: 6,
        barRods: [
          BarChartRodData(toY: incomeBuckets[i], width: 10),
          BarChartRodData(toY: expenseBuckets[i], width: 10),
        ],
      );
    });
  }

  Widget _bottomTitle(double value, TitleMeta meta) {
    final i = value.toInt();
    if (filter == "Daily") {
      if (i % 3 != 0) return const SizedBox.shrink();
      return Text("${i}h", style: const TextStyle(fontSize: 10));
    }
    if (filter == "Weekly") {
      const days = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
      if (i < 0 || i > 6) return const SizedBox.shrink();
      return Text(days[i], style: const TextStyle(fontSize: 10));
    }
    if (filter == "Monthly") {
      if ((i + 1) % 3 != 0) return const SizedBox.shrink();
      return Text("${i + 1}", style: const TextStyle(fontSize: 10));
    }
    const months = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
    if (i < 0 || i > 11) return const SizedBox.shrink();
    return Text(months[i], style: const TextStyle(fontSize: 10));
  }

  Widget _chip(String name) {
    final active = filter == name;
    return InkWell(
      onTap: () => setState(() => filter = name),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF5338FF) : const Color(0xFFF2F3F7),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: getTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Firestore error: ${snapshot.error}"));
            }

            final rows = (snapshot.data?.docs ?? []).map((d) => d.data()).toList();

            final totals = _totals(rows);
            _buildBuckets(rows);

            return SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Analysis",
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Balance: Rp${(totals["balance"] ?? 0).toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text("Spend: Rp${(totals["expense"] ?? 0).toStringAsFixed(0)}",
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),

                  const SizedBox(height: 14),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_chip("Daily"), _chip("Weekly"), _chip("Monthly"), _chip("Year")],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 14,
                          offset: Offset(0, 6),
                          color: Color(0x12000000),
                        )
                      ],
                    ),
                    child: SizedBox(
                      height: 260,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: _chartWidth(),
                          child: BarChart(
                            BarChartData(
                              maxY: _maxY(),
                              barGroups: _groups(),
                              borderData: FlBorderData(show: false),
                              titlesData: FlTitlesData(
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 44,
                                    getTitlesWidget: (v, meta) =>
                                        Text(v.toInt().toString(), style: const TextStyle(fontSize: 10)),
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 28,
                                    getTitlesWidget: _bottomTitle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
