import 'package:flutter/material.dart';

class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    bool isTablet = screenWidth > 600;
    bool isLandscape = screenWidth > screenHeight;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responsive Home"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 12),
        child: Column(
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 24 : 16),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                "SmartPickup Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 28 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// MAIN CONTENT
            Expanded(
              child: isTablet
                  ? GridView.count(
                      crossAxisCount: isLandscape ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: List.generate(
                        8,
                        (index) => _buildCard(isTablet),
                      ),
                    )
                  : ListView.builder(
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return _buildCard(isTablet);
                      },
                    ),
            ),

            const SizedBox(height: 12),

            /// FOOTER BUTTON
            SizedBox(
              width: double.infinity,
              height: isTablet ? 60 : 50,
              child: ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Add Pickup",
                  style: TextStyle(fontSize: isTablet ? 20 : 16),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// CARD WIDGET
  Widget _buildCard(bool isTablet) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 20 : 12),
        child: Row(
          children: [
            Icon(
              Icons.local_shipping,
              size: isTablet ? 40 : 28,
              color: Colors.blue,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Pickup Request",
                style: TextStyle(
                  fontSize: isTablet ? 20 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
