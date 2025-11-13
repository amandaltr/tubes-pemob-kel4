import 'package:flutter/material.dart';

class WishesScreen extends StatelessWidget {
  const WishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "WISHES",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildWishCard(
              title: "Labuan Bajo",
              imageAsset: "assets/images/labuan_bajo.jpg",
              saved: 14000000,
              percentage: 80,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWishCard({
    required String title,
    required String imageAsset,
    required int saved,
    required int percentage,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan title dan menu icon
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  Icons.more_horiz,
                  color: Colors.grey.shade700,
                  size: 30,
                ),
              ],
            ),
          ),

          // Image dari assets (Landscape: 330 x 90)
          Center(
            child: Container(
              width: 330,
              height: 90,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  imageAsset,
                  width: 330,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 330,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 16),

          // Save amount dan percentage
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Save : Rp ${_formatNumber(saved)}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
                Text(
                  "$percentage %",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 12),

          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade400),
                minHeight: 10,
              ),
            ),
          ),

          SizedBox(height: 16),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
    );
  }
}