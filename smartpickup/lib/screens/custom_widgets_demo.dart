import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/like_button.dart';

/// Demonstrates every reusable custom widget in one place.
class CustomWidgetsDemo extends StatefulWidget {
  const CustomWidgetsDemo({super.key});

  @override
  State<CustomWidgetsDemo> createState() => _CustomWidgetsDemoState();
}

class _CustomWidgetsDemoState extends State<CustomWidgetsDemo> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isSubmitting = false;

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);
      await Future.delayed(const Duration(seconds: 2)); // simulate network call
      setState(() => _isSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Form submitted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ── Section header helper ────────────────────────────────────────────────
  Widget _sectionHeader(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2E),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 13, color: Color(0xFF5C5C7B)),
          ),
          const SizedBox(height: 8),
          const Divider(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Custom Widgets Demo'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Hero banner ─────────────────────────────────────────────
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2E7D32), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.widgets_outlined, color: Colors.white, size: 36),
                  SizedBox(height: 10),
                  Text(
                    'Reusable Custom Widgets',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'CustomButton · InfoCard · CustomTextField · LikeButton',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),

            // ══════════════════════════════════════════════════════════
            // 1. CustomButton — multiple variants
            // ══════════════════════════════════════════════════════════
            _sectionHeader(
              '1. CustomButton',
              'Reused with different labels, colours & icons',
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: CustomButton(
                label: 'Book a Pickup',
                icon: Icons.local_shipping,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pickup booked!')),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: CustomButton(
                label: 'View Schedule',
                icon: Icons.calendar_today,
                color: Colors.teal,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening schedule…')),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: CustomButton(
                label: 'Cancel Pickup',
                icon: Icons.cancel_outlined,
                color: Colors.redAccent,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pickup cancelled.')),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: CustomButton(
                label: 'Loading…',
                isLoading: true,
                onPressed: null,
              ),
            ),

            // ══════════════════════════════════════════════════════════
            // 2. InfoCard — multiple instances
            // ══════════════════════════════════════════════════════════
            _sectionHeader(
              '2. InfoCard',
              'Same widget, different content & colours',
            ),

            InfoCard(
              title: 'Total Pickups',
              subtitle: '12 completed this month',
              icon: Icons.local_shipping,
              iconColor: Colors.green,
              onTap: () {},
            ),

            InfoCard(
              title: 'Pending Requests',
              subtitle: '3 awaiting confirmation',
              icon: Icons.hourglass_top,
              iconColor: Colors.orange,
              onTap: () {},
            ),

            InfoCard(
              title: 'My Profile',
              subtitle: 'View and edit account details',
              icon: Icons.person_outline,
              iconColor: Colors.teal,
              onTap: () {},
            ),

            InfoCard(
              title: 'Notifications',
              subtitle: '2 unread alerts',
              icon: Icons.notifications_outlined,
              iconColor: Colors.purple,
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '2',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),

            // ══════════════════════════════════════════════════════════
            // 3. CustomTextField — used in a real form
            // ══════════════════════════════════════════════════════════
            _sectionHeader(
              '3. CustomTextField',
              'Reused for name, email, and password inputs',
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      label: 'Full Name',
                      hint: 'John Doe',
                      icon: Icons.person_outline,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Name is required' : null,
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'you@example.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Enter a valid email',
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Min 6 characters',
                      icon: Icons.lock_outline,
                      obscureText: true,
                      validator: (v) =>
                          v != null && v.length >= 6 ? null : 'Password too short',
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      label: 'Submit Form',
                      icon: Icons.check_circle_outline,
                      onPressed: _submit,
                      isLoading: _isSubmitting,
                      width: double.infinity,
                    ),
                  ],
                ),
              ),
            ),

            // ══════════════════════════════════════════════════════════
            // 4. LikeButton — placed on multiple "post" cards
            // ══════════════════════════════════════════════════════════
            _sectionHeader(
              '4. LikeButton',
              'Stateful widget reused on every post card',
            ),

            ...[
              ('Pickup Request #1042', 'Scheduled for 10:00 AM', 18),
              ('Pickup Request #1043', 'Scheduled for 2:30 PM', 5),
              ('Pickup Request #1044', 'Completed yesterday', 31),
            ].map(
              (item) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.local_shipping, color: Colors.green),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.$1,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            Text(item.$2,
                                style: const TextStyle(
                                    fontSize: 12, color: Color(0xFF5C5C7B))),
                          ],
                        ),
                      ),
                      LikeButton(initialCount: item.$3),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
