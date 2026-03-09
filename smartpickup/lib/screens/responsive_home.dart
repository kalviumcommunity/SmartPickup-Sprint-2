import 'package:flutter/material.dart';
import '../widgets/custom_button.dart';
import '../widgets/info_card.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Breakpoints
// ─────────────────────────────────────────────────────────────────────────────
class _BP {
  static const double mobile = 600;
  static const double tablet = 900;
}

// ─────────────────────────────────────────────────────────────────────────────
// Main screen
// ─────────────────────────────────────────────────────────────────────────────
class ResponsiveHome extends StatelessWidget {
  const ResponsiveHome({super.key});

  @override
  Widget build(BuildContext context) {
    // MediaQuery — device-level metrics
    final mq = MediaQuery.of(context);
    final screenWidth = mq.size.width;
    final screenHeight = mq.size.height;
    final isLandscape = mq.orientation == Orientation.landscape;
    final isTablet = screenWidth >= _BP.mobile;
    final isDesktop = screenWidth >= _BP.tablet;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Responsive Design Demo'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Chip(
              backgroundColor: Colors.white24,
              label: Text(
                '${screenWidth.toInt()} px',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── 1. Hero banner — scales with MediaQuery ────────────────
            _HeroBanner(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isTablet: isTablet,
            ),
            SizedBox(height: isTablet ? 28 : 20),

            // ── 2. Stats row — switches between 2-col and 4-col ────────
            _SectionLabel(
              title: 'Stats Overview',
              badge: isTablet ? 'Tablet – 4 columns' : 'Mobile – 2 columns',
              badgeColor: isTablet ? Colors.teal : Colors.orange,
            ),
            const SizedBox(height: 10),
            _StatsGrid(isTablet: isTablet, isDesktop: isDesktop),
            SizedBox(height: isTablet ? 28 : 20),

            // ── 3. LayoutBuilder — card grid vs list ───────────────────
            _SectionLabel(
              title: 'LayoutBuilder — Grid vs List',
              badge: null,
            ),
            const SizedBox(height: 10),
            LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final cols = w >= _BP.tablet
                    ? (isLandscape ? 4 : 3)
                    : w >= _BP.mobile
                        ? 2
                        : 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _ConstraintBadge(width: w, cols: cols),
                    const SizedBox(height: 10),
                    cols == 1 ? const _PickupList() : _PickupGrid(cols: cols),
                  ],
                );
              },
            ),
            SizedBox(height: isTablet ? 28 : 20),

            // ── 4. Orientation-aware panel ─────────────────────────────
            _SectionLabel(
              title: 'Orientation-Aware Layout',
              badge: isLandscape ? 'Landscape' : 'Portrait',
              badgeColor: isLandscape ? Colors.purple : Colors.green,
            ),
            const SizedBox(height: 10),
            _OrientationPanel(
                isLandscape: isLandscape, isTablet: isTablet),
            SizedBox(height: isTablet ? 28 : 20),

            // ── 5. MediaQuery — proportional containers ────────────────
            _SectionLabel(
              title: 'MediaQuery — Proportional Sizing',
              badge: null,
            ),
            const SizedBox(height: 10),
            _ProportionalContainers(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
            ),
            SizedBox(height: isTablet ? 28 : 20),

            // ── 6. Device info card ────────────────────────────────────
            _SectionLabel(title: 'Device Info via MediaQuery', badge: null),
            const SizedBox(height: 10),
            _DeviceInfoCard(mq: mq),
            SizedBox(height: isTablet ? 32 : 24),

            // ── 7. CTA ─────────────────────────────────────────────────
            CustomButton(
              label: 'Book a Pickup',
              icon: Icons.local_shipping,
              width: double.infinity,
              onPressed: () {},
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. Hero Banner
// ─────────────────────────────────────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;
  final bool isTablet;

  const _HeroBanner({
    required this.screenWidth,
    required this.screenHeight,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: (screenHeight * 0.18).clamp(110.0, 200.0),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF66BB6A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(isTablet ? 24 : 16),
      ),
      padding: EdgeInsets.all(isTablet ? 28 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'SmartPickup Dashboard',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 26 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${screenWidth.toInt()} × ${screenHeight.toInt()} px',
            style: TextStyle(
              color: Colors.white70,
              fontSize: isTablet ? 14 : 12,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. Stats Grid
// ─────────────────────────────────────────────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  final bool isTablet;
  final bool isDesktop;

  const _StatsGrid({required this.isTablet, required this.isDesktop});

  static const _stats = [
    (Icons.local_shipping, 'Total Pickups', '48', Colors.green),
    (Icons.pending_actions, 'Pending', '3', Colors.orange),
    (Icons.check_circle_outline, 'Completed', '44', Colors.teal),
    (Icons.cancel_outlined, 'Cancelled', '1', Colors.red),
  ];

  @override
  Widget build(BuildContext context) {
    final cols = isDesktop ? 4 : isTablet ? 4 : 2;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: isTablet ? 1.4 : 1.2,
      ),
      itemCount: _stats.length,
      itemBuilder: (_, i) {
        final s = _stats[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(s.$1, color: s.$4, size: isTablet ? 32 : 26),
              const SizedBox(height: 8),
              Text(
                s.$3,
                style: TextStyle(
                  fontSize: isTablet ? 26 : 22,
                  fontWeight: FontWeight.bold,
                  color: s.$4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                s.$2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  color: const Color(0xFF5C5C7B),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3a. Pickup List (mobile — 1 col)
// ─────────────────────────────────────────────────────────────────────────────
class _PickupList extends StatelessWidget {
  const _PickupList();

  static const _items = [
    ('Pickup #1042', '10:00 AM · Today', Icons.local_shipping, Colors.green),
    ('Pickup #1043', '2:30 PM · Today', Icons.pending, Colors.orange),
    ('Pickup #1044', 'Completed · Yesterday', Icons.check_circle, Colors.teal),
    ('Pickup #1045', 'Scheduled · Tomorrow', Icons.schedule, Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: _items
          .map(
            (item) => InfoCard(
              title: item.$1,
              subtitle: item.$2,
              icon: item.$3,
              iconColor: item.$4,
            ),
          )
          .toList(),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3b. Pickup Grid (tablet — 2+ cols via LayoutBuilder)
// ─────────────────────────────────────────────────────────────────────────────
class _PickupGrid extends StatelessWidget {
  final int cols;

  const _PickupGrid({required this.cols});

  static const _items = [
    ('Pickup #1042', '10:00 AM · Today', Icons.local_shipping, Color(0xFF2E7D32)),
    ('Pickup #1043', '2:30 PM · Today', Icons.pending, Colors.orange),
    ('Pickup #1044', 'Completed · Yesterday', Icons.check_circle, Colors.teal),
    ('Pickup #1045', 'Scheduled · Tomorrow', Icons.schedule, Colors.purple),
    ('Pickup #1046', '9:00 AM · Tomorrow', Icons.local_shipping, Color(0xFF2E7D32)),
    ('Pickup #1047', 'Pending review', Icons.hourglass_top, Colors.deepOrange),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: _items.length,
      itemBuilder: (_, i) {
        final item = _items[i];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: item.$4.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(item.$3, color: item.$4, size: 22),
              ),
              const SizedBox(height: 10),
              Text(
                item.$1,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF1E1E2E),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.$2,
                style: const TextStyle(fontSize: 11, color: Color(0xFF5C5C7B)),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. Orientation-Aware Panel
// ─────────────────────────────────────────────────────────────────────────────
class _OrientationPanel extends StatelessWidget {
  final bool isLandscape;
  final bool isTablet;

  const _OrientationPanel({
    required this.isLandscape,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final panel1 = _PanelBox(
      label: isLandscape ? 'Active Pickups' : 'Mobile Summary',
      value: '12',
      icon: Icons.local_shipping,
      color: Colors.green,
      isTablet: isTablet,
    );
    final panel2 = _PanelBox(
      label: isLandscape ? 'Completed Today' : 'Quick Stats',
      value: '8',
      icon: Icons.check_circle_outline,
      color: Colors.teal,
      isTablet: isTablet,
    );
    final panel3 = _PanelBox(
      label: 'Pending',
      value: '3',
      icon: Icons.pending_actions,
      color: Colors.orange,
      isTablet: isTablet,
    );

    if (isLandscape) {
      return Row(
        children: [
          Expanded(child: panel1),
          const SizedBox(width: 12),
          Expanded(child: panel2),
          const SizedBox(width: 12),
          Expanded(child: panel3),
        ],
      );
    } else {
      return Column(
        children: [
          panel1,
          const SizedBox(height: 12),
          panel2,
        ],
      );
    }
  }
}

class _PanelBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isTablet;

  const _PanelBox({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: isTablet ? 36 : 28),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: isTablet ? 28 : 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: isTablet ? 13 : 12,
                  color: const Color(0xFF5C5C7B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. Proportional Containers (MediaQuery)
// ─────────────────────────────────────────────────────────────────────────────
class _ProportionalContainers extends StatelessWidget {
  final double screenWidth;
  final double screenHeight;

  const _ProportionalContainers({
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProportionalBar(
          label: '80% of screen width',
          width: screenWidth * 0.8,
          color: Colors.green,
        ),
        const SizedBox(height: 10),
        _ProportionalBar(
          label: '60% of screen width',
          width: screenWidth * 0.6,
          color: Colors.teal,
        ),
        const SizedBox(height: 10),
        _ProportionalBar(
          label: '40% of screen width',
          width: screenWidth * 0.4,
          color: Colors.orange,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          height: screenHeight * 0.06,
          decoration: BoxDecoration(
            color: Colors.purple.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              '6% of screen height  (${(screenHeight * 0.06).toInt()} px)',
              style: const TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProportionalBar extends StatelessWidget {
  final String label;
  final double width;
  final Color color;

  const _ProportionalBar({
    required this.label,
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: width,
        height: 44,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.4)),
        ),
        child: Center(
          child: Text(
            '$label  (${width.toInt()} px)',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 6. Device Info Card
// ─────────────────────────────────────────────────────────────────────────────
class _DeviceInfoCard extends StatelessWidget {
  final MediaQueryData mq;

  const _DeviceInfoCard({required this.mq});

  @override
  Widget build(BuildContext context) {
    final rows = [
      ('Screen Width', '${mq.size.width.toInt()} px'),
      ('Screen Height', '${mq.size.height.toInt()} px'),
      ('Device Pixel Ratio', mq.devicePixelRatio.toStringAsFixed(2)),
      ('Text Scale Factor', mq.textScaler.toString()),
      ('Orientation', mq.orientation.name),
      ('Top Padding (notch)', '${mq.padding.top.toInt()} px'),
      ('Bottom Padding', '${mq.padding.bottom.toInt()} px'),
      (
        'Breakpoint',
        mq.size.width >= _BP.tablet
            ? 'Desktop ≥ ${_BP.tablet.toInt()}'
            : mq.size.width >= _BP.mobile
                ? 'Tablet ≥ ${_BP.mobile.toInt()}'
                : 'Mobile < ${_BP.mobile.toInt()}'
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final isLast = e.key == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      e.value.$1,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF5C5C7B),
                      ),
                    ),
                    Text(
                      e.value.$2,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E1E2E),
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast) const Divider(height: 1, indent: 16, endIndent: 16),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  final String? badge;
  final Color? badgeColor;

  const _SectionLabel({required this.title, this.badge, this.badgeColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E1E2E),
          ),
        ),
        if (badge != null) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: (badgeColor ?? Colors.green).withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badge!,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: badgeColor ?? Colors.green,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ConstraintBadge extends StatelessWidget {
  final double width;
  final int cols;

  const _ConstraintBadge({required this.width, required this.cols});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.indigo.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'LayoutBuilder constraint: ${width.toInt()} px → $cols column${cols > 1 ? 's' : ''}',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.indigo,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
