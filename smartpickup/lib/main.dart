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
    return Scaffold(
      appBar: AppBar(title: const Text("SmartPickup")),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("pickups")
            .orderBy("time", descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          return ListView(
            children: docs.map((doc) {
              return ListTile(
                title: const Text("Pickup booked"),
                subtitle: Text(doc["time"].toString()),
              );
            }).toList(),
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: bookPickup,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white), 
      ),
    );
  }
}
