import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
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
            children: [

              /// FORM ASSIGNMENT
              Padding(
                padding: const EdgeInsets.all(12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/form');
                  },
                  child: const Text("Open User Input Form"),
                ),
              ),

              /// SCROLLABLE ASSIGNMENT
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/scroll');
                  },
                  child: const Text("Open Scrollable Views"),
                ),
              ),

              ...docs.map((doc) {
                return ListTile(
                  leading: const Icon(Icons.local_shipping),
                  title: const Text("Pickup booked"),
                  subtitle: Text(doc["time"].toDate().toString()),
                );
              })
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