import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SmartPickupApp());
}

class SmartPickupApp extends StatelessWidget {
  const SmartPickupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartPickup',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const PickupHome(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PickupHome extends StatelessWidget {
  const PickupHome({super.key});

  void bookPickup() {
    FirebaseFirestore.instance.collection("pickups").add({
      "status": "booked",
      "time": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    bool isTablet = width > 600;
    bool isLandscape = width > height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartPickup"),
        centerTitle: true,
      ),

      body: Padding(
        padding: EdgeInsets.all(isTablet ? 24 : 12),

        child: Column(
          children: [

            /// HEADER
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isTablet ? 20 : 14),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                "Pickup Dashboard",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isTablet ? 26 : 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// FIRESTORE LIST
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("pickups")
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;

                  /// TABLET → GRID
                  if (isTablet) {
                    return GridView.count(
                      crossAxisCount: isLandscape ? 3 : 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: docs.map((doc) {
                        return _pickupCard(doc, isTablet);
                      }).toList(),
                    );
                  }

                  /// PHONE → LIST
                  return ListView(
                    children: docs.map((doc) {
                      return _pickupCard(doc, isTablet);
                    }).toList(),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            /// FOOTER BUTTON
            SizedBox(
              width: double.infinity,
              height: isTablet ? 60 : 50,
              child: ElevatedButton(
                onPressed: bookPickup,
                child: Text(
                  "Book Pickup",
                  style: TextStyle(fontSize: isTablet ? 20 : 16),
                ),
              ),
            )
          ],
        ),
      ),

      /// FAB (still kept)
      floatingActionButton: FloatingActionButton(
        onPressed: bookPickup,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// CARD WIDGET
  Widget _pickupCard(doc, bool isTablet) {
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
              color: Colors.green,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "Pickup booked\n${doc["time"].toDate()}",
                style: TextStyle(
                  fontSize: isTablet ? 18 : 14,
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
