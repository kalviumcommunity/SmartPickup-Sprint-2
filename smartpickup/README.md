# SmartPickup

A Flutter application demonstrating Firebase authentication, Firestore integration, scrollable UI layouts, user input forms, and **local UI state management with `setState()`**.

---

## Sprint 2 – State Management with setState

### What this screen demonstrates

`lib/screens/state_management_demo.dart` contains three interactive sections, all driven by `setState()`:

| Section | State variable(s) | Behaviour |
|---|---|---|
| **Counter** | `_counter` | Increment / decrement / reset; background colour changes at thresholds |
| **Theme Toggle** | `_isDarkMode` | Switch flips the entire screen between light and dark |
| **Like Counter** | `_isLiked`, `_likeCount` | Heart icon animates and count updates on tap |

---

### Key Code Snippets

#### 1. Declaring state variables inside `State<T>`

```dart
class _StateManagementDemoState extends State<StateManagementDemo> {
  int  _counter  = 0;
  bool _isDarkMode = false;
  int  _likeCount  = 0;
  bool _isLiked    = false;
```

#### 2. Updating state with `setState()`

```dart
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

void _toggleTheme() {
  setState(() {
    _isDarkMode = !_isDarkMode;
  });
}

void _toggleLike() {
  setState(() {
    _isLiked  = !_isLiked;
    _likeCount += _isLiked ? 1 : -1;
  });
}
```

#### 3. Conditional UI based on local state

```dart
// Counter card background changes colour based on the count value
Color get _counterCardColor {
  if (_counter >= 10) return Colors.redAccent.shade100;
  if (_counter >= 5)  return Colors.greenAccent.shade100;
  return Colors.white;
}

// The AnimatedContainer re-renders with the new colour every setState() call
AnimatedContainer(
  duration: const Duration(milliseconds: 400),
  color: _isDarkMode ? cardColor : _counterCardColor,
  child: Text('$_counter'),
)
```

#### 4. `_ActionButton` as a `StatelessWidget`

```dart
// Reusable button that holds NO state of its own – pure StatelessWidget
class _ActionButton extends StatelessWidget {
  final String label;
  final Color  color;
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
      style: ElevatedButton.styleFrom(backgroundColor: color),
      child: Text(label),
    );
  }
}
```

---

### Screenshots

> **Before any interaction (counter = 0, light mode)**
>
> *(White card background, heart outline, light scaffold)*

> **Counter ≥ 5 (green threshold)**
>
> *(Card background turns `Colors.greenAccent`)*

> **Counter ≥ 10 (red threshold)**
>
> *(Card background turns `Colors.redAccent`)*

> **Dark mode enabled**
>
> *(Full screen switches to dark palette via a single `setState()` call)*

> **Like toggled**
>
> *(Heart icon animates from outline → filled red; count increments)*

---

### Reflection

**1. What is the difference between Stateless and Stateful widgets?**

A `StatelessWidget` is immutable – once built, its properties never change. It is ideal for purely presentational content (logos, labels, icons). A `StatefulWidget` owns a `State` object that can hold mutable variables; every time those variables change through `setState()`, Flutter schedules a targeted rebuild of that widget's subtree.

**2. Why is `setState()` important for Flutter's reactive model?**

Flutter follows a *declarative* UI paradigm: the framework redraws the screen by calling `build()` whenever it is told something changed. `setState()` is the signal that tells the framework "my data changed – please rebuild". Without it, variable mutations happen in memory but the widget tree stays stale and the user sees nothing new.

**3. How can improper use of `setState()` affect performance?**

- **Calling `setState()` inside `build()`** causes an infinite rebuild loop and crashes the app.
- **Placing large widget trees inside a single `StatefulWidget`** means every call to `setState()` rebuilds the entire subtree, even parts that didn't change. The fix is to extract smaller `StatefulWidget`s so only the affected node rebuilds.
- **Updating state too frequently** (e.g., on every frame from an animation controller without `AnimatedWidget`) can drop the frame rate and cause jank.

---

## Getting Started

```bash
cd smartpickup
flutter pub get
flutter run
```

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

---

## Sprint 2 – Reusable Custom Widgets

### What this sprint demonstrates

`lib/widgets/` contains four custom widgets that are reused across multiple screens, keeping the UI code DRY and consistent.

| Widget file | Type | Used in |
|---|---|---|
| `custom_button.dart` | `StatelessWidget` | `HomeScreen`, `LoginScreen`, `SignupScreen`, `CustomWidgetsDemo` |
| `info_card.dart` | `StatelessWidget` | `HomeScreen` (pickup list), `CustomWidgetsDemo` |
| `custom_text_field.dart` | `StatefulWidget` | `LoginScreen`, `SignupScreen`, `CustomWidgetsDemo` |
| `like_button.dart` | `StatefulWidget` | `CustomWidgetsDemo` (3 post cards) |

---

### Widget definitions

#### `CustomButton` — `lib/widgets/custom_button.dart`

```dart
class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.color,
    this.icon,
    this.isLoading = false,
    this.width,
  });

  @override
  Widget build(BuildContext context) { ... }
}
```

**Reused with different props across screens:**

```dart
// HomeScreen – book a pickup
CustomButton(
  label: 'Open Custom Widgets Demo',
  icon: Icons.widgets_outlined,
  color: Colors.orange,
  onPressed: () => Navigator.pushNamed(context, '/widgets-demo'),
),

// LoginScreen – full-width with loading state
CustomButton(
  label: 'Login',
  icon: Icons.login,
  onPressed: loading ? null : login,
  isLoading: loading,
  width: double.infinity,
),

// CustomWidgetsDemo – cancel variant
CustomButton(
  label: 'Cancel Pickup',
  icon: Icons.cancel_outlined,
  color: Colors.redAccent,
  onPressed: () { ... },
),
```

---

#### `InfoCard` — `lib/widgets/info_card.dart`

```dart
class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final VoidCallback? onTap;
  final Widget? trailing;
  ...
}
```

**Reused across screens:**

```dart
// HomeScreen – each Firestore pickup document
InfoCard(
  title: 'Pickup booked',
  subtitle: doc["time"].toDate().toString(),
  icon: Icons.local_shipping,
  iconColor: Colors.green,
),

// CustomWidgetsDemo – stats tiles
InfoCard(
  title: 'Total Pickups',
  subtitle: '12 completed this month',
  icon: Icons.local_shipping,
  iconColor: Colors.green,
  onTap: () {},
),
InfoCard(
  title: 'Notifications',
  subtitle: '2 unread alerts',
  icon: Icons.notifications_outlined,
  iconColor: Colors.purple,
  trailing: Badge(label: Text('2')),
),
```

---

#### `CustomTextField` — `lib/widgets/custom_text_field.dart`

A `StatefulWidget` that manages its own password-visibility toggle internally.

```dart
// LoginScreen
CustomTextField(
  controller: emailController,
  label: 'Email',
  icon: Icons.email_outlined,
  keyboardType: TextInputType.emailAddress,
),
CustomTextField(
  controller: passController,
  label: 'Password',
  icon: Icons.lock_outline,
  obscureText: true,   // eye-icon toggle built in
),

// SignupScreen — identical fields, different controllers
CustomTextField(controller: email, label: 'Email', ...),
CustomTextField(controller: pass,  label: 'Password', obscureText: true, ...),
```

---

#### `LikeButton` — `lib/widgets/like_button.dart`

A self-contained `StatefulWidget` with a scale animation — drop it anywhere with no external state needed.

```dart
// Three independent instances on post cards
LikeButton(initialCount: 18),
LikeButton(initialCount: 5),
LikeButton(initialCount: 31),
```

---

### Screenshots

> **HomeScreen** — navigation buttons now use `CustomButton`; pickup list uses `InfoCard`

> **LoginScreen / SignupScreen** — inputs use `CustomTextField` with eye toggle; submit uses `CustomButton` with loading spinner

> **CustomWidgetsDemo** — all four widgets displayed together:
> - Four `CustomButton` variants (default, teal, red, loading)
> - Four `InfoCard` instances (green, orange, teal, purple with badge)
> - `CustomTextField` trio inside a validated form
> - Three `LikeButton` instances on pickup post cards

---

### Reflection

**1. How do reusable widgets improve development efficiency?**

Instead of copy-pasting the same `ElevatedButton` or `TextField` decoration in every screen, a single widget file is the only place that needs to change. Updating the button's border-radius or adding an icon prefix propagates instantly to every screen — one edit, zero regressions.

**2. What challenges did you face while designing modular components?**

The main challenge was deciding which props to expose vs. hard-code. Too few parameters and the widget is inflexible (e.g., can't change colour per use-case); too many and the API becomes confusing. The sweet spot was exposing the most common variations (`color`, `icon`, `isLoading`) while providing sensible defaults.

`CustomTextField`'s password-visibility toggle was also a good example of *encapsulating* stateful behaviour inside the widget itself so callers don't need to manage `_obscure` state.

**3. How could your team apply this approach to your full project?**

Every screen that shares a design element — pickup status badges, user avatars, map cards, rating stars — can become a widget in `lib/widgets/`. Combined with a shared `AppTheme` class for colours and text styles, the team can build new screens by composing small, tested building-blocks rather than writing raw Material widgets from scratch.

---

## Sprint 2 – Responsive Design with MediaQuery and LayoutBuilder

### What this screen demonstrates

`lib/screens/responsive_home.dart` is a fully responsive dashboard that adapts to **any screen size or orientation** using two Flutter tools:

| Tool | Purpose |
|---|---|
| `MediaQuery` | Reads device-level metrics (screen width/height, orientation, pixel ratio, padding) |
| `LayoutBuilder` | Reads parent **constraint** width to build different widget trees |

The screen is divided into six live sections, each highlighting a different technique:

| Section | Technique used | Behaviour |
|---|---|---|
| **Hero Banner** | `MediaQuery` | Height = 18 % of screen height, clamped 110–200 px |
| **Stats Grid** | `MediaQuery` breakpoint | 2 columns on mobile, 4 on tablet/desktop |
| **Grid vs List** | `LayoutBuilder` constraints | 1 col → list; 2 col → grid at 600 px; 3–4 col at 900 px |
| **Orientation Panel** | `MediaQuery` orientation | Column in portrait, Row in landscape |
| **Proportional Bars** | `MediaQuery` | Containers sized at 80 %, 60 %, 40 % of screen width |
| **Device Info Card** | `MediaQuery` | Live table of all MediaQueryData values |

---

### Key Code Snippets

#### 1. Reading device metrics with `MediaQuery`

```dart
final mq          = MediaQuery.of(context);
final screenWidth  = mq.size.width;
final screenHeight = mq.size.height;
final isLandscape  = mq.orientation == Orientation.landscape;
final isTablet     = screenWidth >= 600;
```

#### 2. Proportional sizing with `MediaQuery`

```dart
// Hero banner — 18 % of screen height, never below 110 or above 200 px
AnimatedContainer(
  height: (screenHeight * 0.18).clamp(110.0, 200.0),
  width: double.infinity,
  ...
)

// Bar — 80 % of screen width
Container(width: screenWidth * 0.8, ...)
```

#### 3. Conditional columns with `MediaQuery` breakpoints

```dart
// Stats grid switches between 2-col (mobile) and 4-col (tablet/desktop)
final cols = isDesktop ? 4 : isTablet ? 4 : 2;

GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: cols,
    ...
  ),
  ...
)
```

#### 4. Different widget trees with `LayoutBuilder`

```dart
LayoutBuilder(
  builder: (context, constraints) {
    final w = constraints.maxWidth;          // parent box width, not screen width

    final cols = w >= 900
        ? (isLandscape ? 4 : 3)
        : w >= 600
            ? 2
            : 1;

    return cols == 1 ? const _PickupList() : _PickupGrid(cols: cols);
  },
)
```

#### 5. Orientation-aware layout

```dart
// Portrait  → Column  |  Landscape → Row
if (isLandscape) {
  return Row(
    children: [Expanded(child: panel1), ..., Expanded(child: panel3)],
  );
} else {
  return Column(children: [panel1, panel2]);
}
```

#### 6. Adaptive padding & font sizes

```dart
// All spacing and font sizes scale with the isTablet flag
padding: EdgeInsets.all(isTablet ? 24 : 16),
fontSize: isTablet ? 26 : 20,
```

---

### Screenshots

> **Mobile portrait (< 600 px)**
>
> *(Single-column list, 2-col stats grid, portrait panel)*

> **Tablet portrait (≥ 600 px)**
>
> *(2-column pickup grid, 4-col stats, larger fonts & padding)*

> **Tablet landscape (≥ 900 px)**
>
> *(3–4 column grid, Row orientation panel, full-width hero)*

---

### Reflection

**1. Why is responsiveness important in mobile development?**

Users open apps on devices ranging from 320 px compact phones to 1280 px foldables and tablets. Hard-coded pixel values break layouts on any device they weren't designed for. Responsive design means the same codebase delivers a comfortable, overflow-free experience everywhere — directly impacting retention and accessibility.

**2. How does `LayoutBuilder` differ from `MediaQuery`?**

`MediaQuery.of(context).size` gives the **entire device screen** dimensions — it is a global value unaffected by padding, navigation bars, or parent containers. `LayoutBuilder` gives the **available width of the immediate parent widget**. This matters inside `Column`, `Drawer`, or `SliverList` where the parent is narrower than the full screen. Use `MediaQuery` for global decisions (overall breakpoint, orientation) and `LayoutBuilder` for local, context-aware decisions (how many columns fit inside *this* card or panel).

**3. How could your team use these tools to scale the app design efficiently?**

- Define shared breakpoint constants (`_BP.mobile`, `_BP.tablet`) in a single file so every screen uses identical thresholds.
- Build responsive wrappers (e.g. `ResponsiveGrid`) as reusable widgets so individual screens declare *what* to show, not *how* to arrange it.
- `LayoutBuilder` inside `CustomCard` lets the card reflow its own internal layout independently of the parent screen — no extra props needed.
- Combine with `OrientationBuilder` for targeted landscape-only changes without duplicating full screen code.

---

## Running locally

```bash
cd smartpickup
flutter pub get
flutter run          # connects to a running emulator / device
# or
flutter run -d linux # run on the Linux desktop target
```

----
