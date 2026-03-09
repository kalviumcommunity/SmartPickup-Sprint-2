import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Navigation helper — animated push used by home_screen
// ─────────────────────────────────────────────────────────────────────────────
Route<void> animationsDemoRoute() => PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const AnimationsDemo(),
      transitionsBuilder: (_, animation, __, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
        child: child,
      ),
    );

// ─────────────────────────────────────────────────────────────────────────────
// Main Demo Screen
// ─────────────────────────────────────────────────────────────────────────────
class AnimationsDemo extends StatefulWidget {
  const AnimationsDemo({super.key});

  @override
  State<AnimationsDemo> createState() => _AnimationsDemoState();
}

class _AnimationsDemoState extends State<AnimationsDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Animations & Transitions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          // ── Hero banner ─────────────────────────────────────────────
          _SectionBanner(),
          SizedBox(height: 24),

          // ── 1. Implicit — AnimatedContainer ─────────────────────────
          _SectionHeader(
            number: '1',
            title: 'AnimatedContainer',
            subtitle: 'Implicit — tap to animate size, colour & radius',
          ),
          SizedBox(height: 10),
          _AnimatedContainerDemo(),
          SizedBox(height: 28),

          // ── 2. Implicit — AnimatedOpacity ───────────────────────────
          _SectionHeader(
            number: '2',
            title: 'AnimatedOpacity',
            subtitle: 'Implicit — fade an image in and out',
          ),
          SizedBox(height: 10),
          _AnimatedOpacityDemo(),
          SizedBox(height: 28),

          // ── 3. Implicit — AnimatedCrossFade ─────────────────────────
          _SectionHeader(
            number: '3',
            title: 'AnimatedCrossFade',
            subtitle: 'Implicit — cross-fade between two widgets',
          ),
          SizedBox(height: 10),
          _AnimatedCrossFadeDemo(),
          SizedBox(height: 28),

          // ── 4. Implicit — AnimatedSwitcher ──────────────────────────
          _SectionHeader(
            number: '4',
            title: 'AnimatedSwitcher',
            subtitle: 'Implicit — scale-swap a counter value',
          ),
          SizedBox(height: 10),
          _AnimatedSwitcherDemo(),
          SizedBox(height: 28),

          // ── 5. Explicit — RotationTransition ────────────────────────
          _SectionHeader(
            number: '5',
            title: 'RotationTransition',
            subtitle: 'Explicit — AnimationController spins the icon',
          ),
          SizedBox(height: 10),
          _RotationDemo(),
          SizedBox(height: 28),

          // ── 6. Explicit — SlideTransition ───────────────────────────
          _SectionHeader(
            number: '6',
            title: 'SlideTransition',
            subtitle: 'Explicit — slide a card in from the left',
          ),
          SizedBox(height: 10),
          _SlideDemo(),
          SizedBox(height: 28),

          // ── 7. Explicit — ScaleTransition + FadeTransition ──────────
          _SectionHeader(
            number: '7',
            title: 'ScaleTransition + FadeTransition',
            subtitle: 'Explicit — scale + fade a badge simultaneously',
          ),
          SizedBox(height: 10),
          _ScaleFadeDemo(),
          SizedBox(height: 28),

          // ── 8. Staggered list ────────────────────────────────────────
          _SectionHeader(
            number: '8',
            title: 'Staggered List Animation',
            subtitle: 'Explicit — items slide-in one after another',
          ),
          SizedBox(height: 10),
          _StaggeredListDemo(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Banner
// ─────────────────────────────────────────────────────────────────────────────
class _SectionBanner extends StatelessWidget {
  const _SectionBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset('assets/images/logo.png', width: 56, height: 56),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Flutter Animations',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Implicit · Explicit · Page Transitions',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Section header
// ─────────────────────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;

  const _SectionHeader({
    required this.number,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E2E),
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF5C5C7B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. AnimatedContainer
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedContainerDemo extends StatefulWidget {
  const _AnimatedContainerDemo();

  @override
  State<_AnimatedContainerDemo> createState() => _AnimatedContainerDemoState();
}

class _AnimatedContainerDemoState extends State<_AnimatedContainerDemo> {
  bool _toggled = false;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          Center(
            child: GestureDetector(
              onTap: () => setState(() => _toggled = !_toggled),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeInOut,
                width: _toggled ? 220 : 110,
                height: _toggled ? 110 : 110,
                decoration: BoxDecoration(
                  color: _toggled ? Colors.teal : Colors.green,
                  borderRadius:
                      BorderRadius.circular(_toggled ? 55 : 16),
                  boxShadow: [
                    BoxShadow(
                      color: (_toggled ? Colors.teal : Colors.green)
                          .withOpacity(0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _toggled ? Icons.check_circle : Icons.local_shipping,
                        color: Colors.white,
                        size: _toggled ? 36 : 32,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _toggled ? 'Done!' : 'Tap me',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          _CodeBadge(
            'AnimatedContainer(duration: 600ms, curve: easeInOut)',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. AnimatedOpacity
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedOpacityDemo extends StatefulWidget {
  const _AnimatedOpacityDemo();

  @override
  State<_AnimatedOpacityDemo> createState() => _AnimatedOpacityDemoState();
}

class _AnimatedOpacityDemoState extends State<_AnimatedOpacityDemo> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.05,
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeInOut,
            child: Image.asset(
              'assets/images/logo.png',
              width: 100,
              height: 100,
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: _visible ? 'Fade Out' : 'Fade In',
            icon: _visible ? Icons.visibility_off : Icons.visibility,
            color: Colors.indigo,
            onPressed: () => setState(() => _visible = !_visible),
          ),
          const SizedBox(height: 10),
          _CodeBadge('AnimatedOpacity(opacity: ${_visible ? 1.0 : 0.05}, duration: 800ms)'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. AnimatedCrossFade
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedCrossFadeDemo extends StatefulWidget {
  const _AnimatedCrossFadeDemo();

  @override
  State<_AnimatedCrossFadeDemo> createState() =>
      _AnimatedCrossFadeDemoState();
}

class _AnimatedCrossFadeDemoState extends State<_AnimatedCrossFadeDemo> {
  bool _showFirst = true;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 500),
            crossFadeState: _showFirst
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/truck.png', width: 40),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup Booked',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1B5E20))),
                      Text('Arrives at 10:00 AM',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF5C5C7B))),
                    ],
                  ),
                ],
              ),
            ),
            secondChild: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/star.png', width: 40),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup Completed!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal)),
                      Text('Thank you for using SmartPickup',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF5C5C7B))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: _showFirst ? 'Mark Complete' : 'Reset',
            icon: _showFirst ? Icons.check : Icons.refresh,
            color: _showFirst ? Colors.teal : Colors.grey,
            onPressed: () => setState(() => _showFirst = !_showFirst),
          ),
          const SizedBox(height: 10),
          const _CodeBadge('AnimatedCrossFade(duration: 500ms)'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. AnimatedSwitcher
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedSwitcherDemo extends StatefulWidget {
  const _AnimatedSwitcherDemo();

  @override
  State<_AnimatedSwitcherDemo> createState() => _AnimatedSwitcherDemoState();
}

class _AnimatedSwitcherDemoState extends State<_AnimatedSwitcherDemo> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => ScaleTransition(
              scale: animation,
              child: FadeTransition(opacity: animation, child: child),
            ),
            child: Text(
              '$_count',
              key: ValueKey<int>(_count),
              style: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                label: '−',
                color: Colors.redAccent,
                onPressed:
                    _count > 0 ? () => setState(() => _count--) : null,
              ),
              const SizedBox(width: 16),
              CustomButton(
                label: '+',
                color: Colors.green,
                onPressed: () => setState(() => _count++),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const _CodeBadge(
              'AnimatedSwitcher(ScaleTransition + FadeTransition)'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. RotationTransition (Explicit)
// ─────────────────────────────────────────────────────────────────────────────
class _RotationDemo extends StatefulWidget {
  const _RotationDemo();

  @override
  State<_RotationDemo> createState() => _RotationDemoState();
}

class _RotationDemoState extends State<_RotationDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _spinning = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _spinning = !_spinning);
    if (_spinning) {
      _ctrl.repeat();
    } else {
      _ctrl.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          RotationTransition(
            turns: _ctrl,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Image.asset('assets/images/logo.png',
                    width: 60, height: 60),
              ),
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: _spinning ? 'Stop' : 'Spin',
            icon: _spinning ? Icons.stop : Icons.rotate_right,
            color: _spinning ? Colors.redAccent : Colors.green,
            onPressed: _toggle,
          ),
          const SizedBox(height: 10),
          const _CodeBadge(
              'RotationTransition(turns: AnimationController..repeat())'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. SlideTransition (Explicit)
// ─────────────────────────────────────────────────────────────────────────────
class _SlideDemo extends StatefulWidget {
  const _SlideDemo();

  @override
  State<_SlideDemo> createState() => _SlideDemoState();
}

class _SlideDemoState extends State<_SlideDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _offset;
  bool _shown = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _offset = Tween<Offset>(
      begin: const Offset(-1.2, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _shown = !_shown);
    if (_shown) {
      _ctrl.forward(from: 0);
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          SlideTransition(
            position: _offset,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Image.asset('assets/icons/truck.png', width: 36),
                  const SizedBox(width: 12),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Pickup #1048',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('Scheduled for 3:00 PM',
                          style: TextStyle(
                              fontSize: 12, color: Color(0xFF5C5C7B))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: _shown ? 'Slide Out' : 'Slide In',
            icon: _shown ? Icons.arrow_back : Icons.arrow_forward,
            color: Colors.teal,
            onPressed: _toggle,
          ),
          const SizedBox(height: 10),
          const _CodeBadge(
              'SlideTransition(Offset(-1.2,0)→(0,0), easeOutCubic)'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 7. ScaleTransition + FadeTransition (Explicit, combined)
// ─────────────────────────────────────────────────────────────────────────────
class _ScaleFadeDemo extends StatefulWidget {
  const _ScaleFadeDemo();

  @override
  State<_ScaleFadeDemo> createState() => _ScaleFadeDemoState();
}

class _ScaleFadeDemoState extends State<_ScaleFadeDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _fade;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scale =
        CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _visible = !_visible);
    if (_visible) {
      _ctrl.forward(from: 0);
    } else {
      _ctrl.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          ScaleTransition(
            scale: _scale,
            child: FadeTransition(
              opacity: _fade,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.amber.shade100,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: Colors.amber),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/icons/star.png', width: 28),
                    const SizedBox(width: 8),
                    const Text(
                      'Pickup Confirmed!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          CustomButton(
            label: _visible ? 'Hide Badge' : 'Show Badge',
            icon: _visible ? Icons.close : Icons.star,
            color: Colors.amber.shade700,
            onPressed: _toggle,
          ),
          const SizedBox(height: 10),
          const _CodeBadge(
              'ScaleTransition(elasticOut) + FadeTransition(easeIn)'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 8. Staggered list
// ─────────────────────────────────────────────────────────────────────────────
class _StaggeredListDemo extends StatefulWidget {
  const _StaggeredListDemo();

  @override
  State<_StaggeredListDemo> createState() => _StaggeredListDemoState();
}

class _StaggeredListDemoState extends State<_StaggeredListDemo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  bool _shown = false;

  static const _items = [
    (Icons.local_shipping, 'Book Pickup', Colors.green),
    (Icons.calendar_today, 'View Schedule', Colors.teal),
    (Icons.star, 'Rate Service', Colors.amber),
    (Icons.person_outline, 'My Profile', Colors.indigo),
  ];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _replay() {
    setState(() => _shown = true);
    _ctrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return _DemoCard(
      child: Column(
        children: [
          if (!_shown)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: CustomButton(
                label: 'Play Staggered Animation',
                icon: Icons.play_arrow,
                color: Colors.deepPurple,
                onPressed: _replay,
              ),
            ),
          if (_shown) ...[
            ..._items.asMap().entries.map((e) {
              final i = e.key;
              final item = e.value;
              // Each item starts at a staggered interval
              final start = i * 0.2;
              final end = start + 0.5;
              final anim = Tween<Offset>(
                begin: const Offset(0, 0.6),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(
                  parent: _ctrl,
                  curve: Interval(start, end, curve: Curves.easeOutCubic),
                ),
              );
              final fadeAnim = Tween<double>(begin: 0, end: 1).animate(
                CurvedAnimation(
                  parent: _ctrl,
                  curve: Interval(start, end, curve: Curves.easeIn),
                ),
              );
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: SlideTransition(
                  position: anim,
                  child: FadeTransition(
                    opacity: fadeAnim,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: item.$3.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child:
                                Icon(item.$1, color: item.$3, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            item.$2,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E1E2E),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 4),
            TextButton.icon(
              onPressed: _replay,
              icon: const Icon(Icons.replay, size: 16),
              label: const Text('Replay'),
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF5C5C7B)),
            ),
          ],
          const SizedBox(height: 6),
          const _CodeBadge(
              'SlideTransition + FadeTransition with staggered Interval()'),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────
class _DemoCard extends StatelessWidget {
  final Widget child;

  const _DemoCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _CodeBadge extends StatelessWidget {
  final String text;

  const _CodeBadge(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E2E).withOpacity(0.06),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          fontFamily: 'monospace',
          color: Color(0xFF1E1E2E),
        ),
      ),
    );
  }
}
