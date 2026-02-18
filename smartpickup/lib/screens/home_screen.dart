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
                    context, MaterialPageRoute(builder: (_) => const LoginScreen()));
              },
              icon: const Icon(Icons.logout))
        ],
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("pickups")
            .where("uid", isEqualTo: uid)
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          return ListView(
            children: docs.map((doc) {
              return ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text("Pickup booked"),
                subtitle: Text(doc["time"].toDate().toString()),
              );
            }).toList(),
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
