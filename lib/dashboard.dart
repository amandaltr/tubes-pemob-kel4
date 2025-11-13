import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  // Dummy data
  final double totalBalance = 2000000;
  final double totalExpense = 560000;
  final double expensePercent = 0.3;

  // Dummy transactions
  List<Map<String, dynamic>> get aprilTransactions => [
    {
      'icon': FontAwesomeIcons.moneyBillTrendUp,
      'title': 'Allowance',
      'time': '18:27 · Oct 17',
      'tag': 'Monthly',
      'amount': '+Rp1,000,000',
      'amountColor': Colors.green
    },
    {
      'icon': FontAwesomeIcons.shoppingBag,
      'title': 'Groceries',
      'time': '17:00 · Oct 14',
      'tag': 'Pantry',
      'amount': '-Rp50,000',
      'amountColor': Colors.red
    },
    {
      'icon': FontAwesomeIcons.house,
      'title': 'Rent',
      'time': '08:30 · Oct 10',
      'tag': 'Housing',
      'amount': '-Rp500,000',
      'amountColor': Colors.red
    },
    {
      'icon': FontAwesomeIcons.bus,
      'title': 'Transport',
      'time': '09:30 · Oct 08',
      'tag': 'Bus Fare',
      'amount': '-Rp3,000',
      'amountColor': Colors.red
    },
  ];

  List<Map<String, dynamic>> get marchTransactions => [
    {
      'icon': FontAwesomeIcons.utensils,
      'title': 'Dinner',
      'time': '19:30 · Mar 31',
      'tag': 'Food',
      'amount': '-Rp70,400',
      'amountColor': Colors.red
    },
  ];

  @override
  Widget build(BuildContext context) {
    const Color mainPurple = Color(0xFF4A3AFF);
    const Color paleBackground = Color(0xFFF5F6FA);

    String fmtRp(double v) {
      final intVal = v.round();
      String s = intVal.toString();
      String out = '';
      int count = 0;
      for (int i = s.length - 1; i >= 0; i--) {
        out = s[i] + out;
        count++;
        if (count % 3 == 0 && i != 0) out = '.$out';
      }
      return 'Rp$out';
    }

    return Scaffold(
      backgroundColor: mainPurple,
      appBar: AppBar(
        backgroundColor: mainPurple,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Total Balance Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A4DFF), Color(0xFF7A6CFF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Total Balance',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      fmtRp(totalBalance),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Expense Summary
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Income',
                                style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            Text(fmtRp(totalBalance),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total Expense',
                                style: TextStyle(color: Colors.white70)),
                            const SizedBox(height: 6),
                            Text('-${fmtRp(totalExpense)}',
                                style: const TextStyle(
                                    color: Color(0xFFFFC100),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearPercentIndicator(
                    lineHeight: 10,
                    percent: expensePercent.clamp(0.0, 1.0),
                    progressColor: Colors.tealAccent.shade400,
                    backgroundColor: Colors.white24,
                    barRadius: const Radius.circular(10),
                  ),
                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      '30% of your expenses. Looks good.',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),

            // Transactions
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: paleBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                    topRight: Radius.circular(36),
                  ),
                ),
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Recent Transactions',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.filter_list),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.only(bottom: 20),
                          children: [
                            monthSection('October', aprilTransactions),
                            const SizedBox(height: 12),
                            monthSection('March', marchTransactions),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Bottom Navigation Bar (tanpa floating)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedItemColor: mainPurple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: 'Transactions'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline), label: 'Add'),
          BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_outlined), label: 'Reports'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  // ===== Helper Widgets =====
  Widget monthSection(String month, List<Map<String, dynamic>> txs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(month,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        ...txs.map((t) => transactionTile(t)),
      ],
    );
  }

  Widget transactionTile(Map<String, dynamic> t) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFE7E7FF),
            child: FaIcon(t['icon'], color: const Color(0xFF4A3AFF), size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t['title'],
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(t['time'],
                    style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(t['tag'],
                  style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 6),
              Text(
                t['amount'],
                style: TextStyle(
                    color: t['amountColor'], fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
