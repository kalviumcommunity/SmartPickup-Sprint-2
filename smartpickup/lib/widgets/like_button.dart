import 'package:flutter/material.dart';

/// A reusable stateful like-button widget with animated toggle.
///
/// Usage:
/// ```dart
/// LikeButton(initialCount: 24)
/// ```
class LikeButton extends StatefulWidget {
  final int initialCount;

  const LikeButton({super.key, this.initialCount = 0});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton>
    with SingleTickerProviderStateMixin {
  bool _isLiked = false;
  late int _count;
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _count = widget.initialCount;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.8,
      upperBound: 1.2,
      value: 1.0,
    );
    _scale = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _isLiked = !_isLiked;
      _count += _isLiked ? 1 : -1;
    });
    _controller.forward(from: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scale,
            child: Icon(
              _isLiked ? Icons.favorite : Icons.favorite_border,
              color: _isLiked ? Colors.redAccent : Colors.grey,
              size: 26,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '$_count',
            style: TextStyle(
              color: _isLiked ? Colors.redAccent : Colors.grey,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
