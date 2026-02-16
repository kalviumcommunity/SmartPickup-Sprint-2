import 'package:flutter/material.dart';

void main() {
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

class PickupHome extends StatefulWidget {
  const PickupHome({super.key});

  @override
  State<PickupHome> createState() => _PickupHomeState();
}

class _PickupHomeState extends State<PickupHome> {
  int pickupCount = 0;

  void bookPickup() {
    setState(() {
      pickupCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SmartPickup")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.local_shipping, size: 80, color: Colors.green),
            const SizedBox(height: 20),
            const Text("Total Pickups Booked:", style: TextStyle(fontSize: 18)),
            Text(
              "$pickupCount",
              style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: bookPickup,
              child: const Text("Book Pickup"),
            )
          ],
        ),
      ),
    );
  }
}
