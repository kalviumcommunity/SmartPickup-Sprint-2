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

----
