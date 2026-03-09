import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void bookPickup(String uid) {
    FirebaseFirestore.instance.collection("pickups").add({
      "uid": uid,
      "status": "booked",
      "time": Timestamp.now(),
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();
    final uid = auth.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartPickup"),
        actions: [
          IconButton(
            onPressed: () async {
              await auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("pickups")
            .where("uid", isEqualTo: uid)
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView(
            padding: const EdgeInsets.only(top: 12, bottom: 24),
            children: [
              // ── Sprint assignment navigation ─────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: CustomButton(
                  label: 'Open User Input Form',
                  icon: Icons.edit_note,
                  onPressed: () => Navigator.pushNamed(context, '/form'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: CustomButton(
                  label: 'Open Scrollable Views',
                  icon: Icons.list_alt,
                  color: Colors.teal,
                  onPressed: () => Navigator.pushNamed(context, '/scroll'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: CustomButton(
                  label: 'Open State Management Demo',
                  icon: Icons.tune,
                  color: Colors.indigo,
                  onPressed: () => Navigator.pushNamed(context, '/state-demo'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: CustomButton(
                  label: 'Open Custom Widgets Demo',
                  icon: Icons.widgets_outlined,
                  color: Colors.orange,
                  onPressed: () => Navigator.pushNamed(context, '/widgets-demo'),
                ),
              ),

              const Padding(
                padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                child: Text(
                  'Your Pickups',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E1E2E),
                  ),
                ),
              ),

              if (docs.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 32),
                  child: Center(
                    child: Text(
                      'No pickups yet. Tap + to book one!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),

              ...docs.map((doc) {
                return InfoCard(
                  title: 'Pickup booked',
                  subtitle: doc["time"].toDate().toString(),
                  icon: Icons.local_shipping,
                  iconColor: Colors.green,
                );
              }),
            ],
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => bookPickup(uid),
        child: const Icon(Icons.add),
      ),
    );
  }
}