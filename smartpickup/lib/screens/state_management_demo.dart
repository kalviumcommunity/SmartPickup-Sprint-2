import 'package:flutter/material.dart';

class StateManagementDemo extends StatefulWidget {
  const StateManagementDemo({super.key});

  @override
  State<StateManagementDemo> createState() => _StateManagementDemoState();
}

class _StateManagementDemoState extends State<StateManagementDemo> {
  int _counter = 0;
  bool _isDarkMode = false;
  int _likeCount = 0;
  bool _isLiked = false;

  // ── Counter helpers ──────────────────────────────────────────────────────
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _decrementCounter() {
    setState(() {
      if (_counter > 0) _counter--;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }

  // ── Theme toggle ─────────────────────────────────────────────────────────
  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  // ── Like counter ─────────────────────────────────────────────────────────
  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  // ── Threshold colour for the counter card ────────────────────────────────
  Color get _counterCardColor {
    if (_counter >= 10) return Colors.redAccent.shade100;
    if (_counter >= 5) return Colors.greenAccent.shade100;
    return Colors.white;
  }

  String get _counterMessage {
    if (_counter >= 10) return '🔥 On fire!';
    if (_counter >= 5) return '✅ Great job!';
    return '👇 Press a button below';
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isDarkMode ? const Color(0xFF1E1E2E) : const Color(0xFFF5F5F5);
    final cardColor = _isDarkMode ? const Color(0xFF2A2A3C) : Colors.white;
    final textColor = _isDarkMode ? Colors.white : const Color(0xFF1E1E2E);
    final subTextColor =
        _isDarkMode ? Colors.white70 : const Color(0xFF5C5C7B);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: _isDarkMode ? const Color(0xFF2A2A3C) : Colors.green,
        foregroundColor: Colors.white,
        title: const Text('State Management Demo'),
        actions: [
          IconButton(
            tooltip: 'Toggle Theme',
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Section label ───────────────────────────────────────────
            Text(
              'Counter Demo',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),

            // ── Counter card (changes colour based on value) ─────────────
            AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              decoration: BoxDecoration(
                color: _isDarkMode ? cardColor : _counterCardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _counterMessage,
                    style: TextStyle(fontSize: 16, color: subTextColor),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_counter',
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.bold,
                      color: _isDarkMode ? Colors.greenAccent : Colors.green,
                    ),
                  ),
                  Text(
                    'times',
                    style: TextStyle(fontSize: 16, color: subTextColor),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Counter buttons ──────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  label: '− Decrement',
                  color: Colors.redAccent,
                  onPressed: _counter > 0 ? _decrementCounter : null,
                ),
                const SizedBox(width: 12),
                _ActionButton(
                  label: '+ Increment',
                  color: Colors.green,
                  onPressed: _incrementCounter,
                ),
              ],
            ),

            const SizedBox(height: 12),

            Center(
              child: TextButton.icon(
                onPressed: _resetCounter,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Reset'),
                style: TextButton.styleFrom(
                  foregroundColor: subTextColor,
                ),
              ),
            ),

            const SizedBox(height: 32),
            Divider(color: subTextColor.withOpacity(0.3)),
            const SizedBox(height: 24),

            // ── Theme toggle card ────────────────────────────────────────
            Text(
              'Theme Toggle',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _isDarkMode ? 'Dark Mode' : 'Light Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        'Tap to toggle theme',
                        style: TextStyle(fontSize: 13, color: subTextColor),
                      ),
                    ],
                  ),
                  Switch(
                    value: _isDarkMode,
                    activeColor: Colors.greenAccent,
                    onChanged: (_) => _toggleTheme(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            Divider(color: subTextColor.withOpacity(0.3)),
            const SizedBox(height: 24),

            // ── Like counter card ────────────────────────────────────────
            Text(
              'Like Counter',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SmartPickup Post',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '$_likeCount ${_likeCount == 1 ? 'like' : 'likes'}',
                        style: TextStyle(fontSize: 13, color: subTextColor),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => ScaleTransition(
                      scale: animation,
                      child: child,
                    ),
                    child: IconButton(
                      key: ValueKey(_isLiked),
                      icon: Icon(
                        _isLiked ? Icons.favorite : Icons.favorite_border,
                        color: _isLiked ? Colors.redAccent : subTextColor,
                        size: 32,
                      ),
                      onPressed: _toggleLike,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ── Reusable button widget (StatelessWidget example) ─────────────────────────
class _ActionButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback? onPressed;

  const _ActionButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 15)),
    );
  }
}
