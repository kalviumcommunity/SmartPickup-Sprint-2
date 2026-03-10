import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/task_service.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Priority meta-data
// ─────────────────────────────────────────────────────────────────────────────
enum _Priority { low, medium, high }

extension _PriorityExt on _Priority {
  String get label => name[0].toUpperCase() + name.substring(1);
  Color get color => switch (this) {
        _Priority.low => Colors.teal,
        _Priority.medium => Colors.orange,
        _Priority.high => Colors.redAccent,
      };
  IconData get icon => switch (this) {
        _Priority.low => Icons.arrow_downward,
        _Priority.medium => Icons.remove,
        _Priority.high => Icons.arrow_upward,
      };
}

// ─────────────────────────────────────────────────────────────────────────────
// Main screen
// ─────────────────────────────────────────────────────────────────────────────
class FirestoreWritesDemo extends StatefulWidget {
  const FirestoreWritesDemo({super.key});

  @override
  State<FirestoreWritesDemo> createState() => _FirestoreWritesDemoState();
}

class _FirestoreWritesDemoState extends State<FirestoreWritesDemo> {
  final _svc = TaskService();
  final _auth = AuthService();

  String get _uid => _auth.currentUser!.uid;

  // ── Add-form state ─────────────────────────────────────────────────────────
  final _addFormKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  _Priority _selectedPriority = _Priority.medium;
  bool _adding = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  // ── Add a new task (Firestore .add()) ──────────────────────────────────────
  Future<void> _addTask() async {
    if (!_addFormKey.currentState!.validate()) return;
    setState(() => _adding = true);
    try {
      await _svc.addTask(
        uid: _uid,
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        priority: _selectedPriority.name,
      );
      _titleCtrl.clear();
      _descCtrl.clear();
      setState(() => _selectedPriority = _Priority.medium);
      _snack('✅ Task added to Firestore!', Colors.green);
    } catch (e) {
      _snack('❌ Error: $e', Colors.red);
    } finally {
      setState(() => _adding = false);
    }
  }

  // ── Toggle completion (Firestore .update()) ────────────────────────────────
  Future<void> _toggle(String docId, bool current) async {
    try {
      await _svc.toggleComplete(docId, current);
    } catch (e) {
      _snack('❌ Update failed: $e', Colors.red);
    }
  }

  // ── Delete a task ──────────────────────────────────────────────────────────
  Future<void> _delete(String docId) async {
    try {
      await _svc.deleteTask(docId);
      _snack('🗑️ Task deleted', Colors.grey.shade700);
    } catch (e) {
      _snack('❌ Delete failed: $e', Colors.red);
    }
  }

  // ── Open edit bottom sheet (Firestore .update()) ───────────────────────────
  void _openEditSheet(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final tCtrl = TextEditingController(text: data['title'] ?? '');
    final dCtrl = TextEditingController(text: data['description'] ?? '');
    final formKey = GlobalKey<FormState>();
    _Priority priority =
        _Priority.values.firstWhere((p) => p.name == (data['priority'] ?? 'medium'));
    bool saving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const Text(
                  'Edit Task',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E2E)),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: tCtrl,
                  label: 'Title',
                  icon: Icons.title,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Title required' : null,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: dCtrl,
                  label: 'Description',
                  icon: Icons.notes,
                  maxLines: 2,
                  validator: (v) =>
                      v == null || v.trim().isEmpty ? 'Description required' : null,
                ),
                const SizedBox(height: 12),
                _PrioritySelector(
                  selected: priority,
                  onChanged: (p) => setSheetState(() => priority = p),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  label: saving ? 'Saving…' : 'Save Changes',
                  icon: Icons.save,
                  isLoading: saving,
                  width: double.infinity,
                  onPressed: () async {
                    if (!formKey.currentState!.validate()) return;
                    setSheetState(() => saving = true);
                    try {
                      await _svc.updateTask(
                        docId: doc.id,
                        title: tCtrl.text.trim(),
                        description: dCtrl.text.trim(),
                        priority: priority.name,
                      );
                      if (context.mounted) Navigator.pop(context);
                      _snack('✏️ Task updated!', Colors.indigo);
                    } catch (e) {
                      _snack('❌ Update failed: $e', Colors.red);
                    } finally {
                      setSheetState(() => saving = false);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _snack(String msg, Color color) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
        title: const Text('Firestore Writes Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Operation legend ────────────────────────────────────
            _OperationLegend(),
            const SizedBox(height: 20),

            // ── Add task form ────────────────────────────────────────
            _SectionLabel(title: 'Add Task', icon: Icons.add_circle_outline,
                color: Colors.green),
            const SizedBox(height: 10),
            Container(
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
              child: Form(
                key: _addFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: _titleCtrl,
                      label: 'Task Title',
                      hint: 'e.g. Book pickup for Monday',
                      icon: Icons.title,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Title cannot be empty'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      controller: _descCtrl,
                      label: 'Description',
                      hint: 'e.g. Schedule morning collection',
                      icon: Icons.notes,
                      maxLines: 2,
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Description cannot be empty'
                          : null,
                    ),
                    const SizedBox(height: 14),
                    _PrioritySelector(
                      selected: _selectedPriority,
                      onChanged: (p) =>
                          setState(() => _selectedPriority = p),
                    ),
                    const SizedBox(height: 18),
                    CustomButton(
                      label: 'Add Task to Firestore',
                      icon: Icons.cloud_upload_outlined,
                      isLoading: _adding,
                      width: double.infinity,
                      onPressed: _addTask,
                    ),
                    const SizedBox(height: 10),
                    _CodeChip('collection("tasks").add({...})'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ── Live task list from Firestore ────────────────────────
            _SectionLabel(
                title: 'Your Tasks (real-time)',
                icon: Icons.cloud_sync,
                color: Colors.indigo),
            const SizedBox(height: 10),

            StreamBuilder<QuerySnapshot>(
              stream: _svc.getTasks(_uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(color: Colors.green),
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return _ErrorCard(snapshot.error.toString());
                }

                final docs = snapshot.data?.docs ?? [];

                if (docs.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Column(
                      children: [
                        Icon(Icons.inbox_outlined,
                            size: 48, color: Colors.grey),
                        SizedBox(height: 12),
                        Text('No tasks yet. Add one above!',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  );
                }

                return Column(
                  children: docs.map((doc) {
                    final d = doc.data() as Map<String, dynamic>;
                    final priority = _Priority.values.firstWhere(
                      (p) => p.name == (d['priority'] ?? 'medium'),
                      orElse: () => _Priority.medium,
                    );
                    final isCompleted = d['isCompleted'] as bool? ?? false;
                    final ts = d['updatedAt'] as Timestamp?;
                    final updated = ts != null
                        ? _formatDate(ts.toDate())
                        : '—';

                    return _TaskCard(
                      docId: doc.id,
                      title: d['title'] ?? '',
                      description: d['description'] ?? '',
                      priority: priority,
                      isCompleted: isCompleted,
                      updatedAt: updated,
                      onToggle: () => _toggle(doc.id, isCompleted),
                      onEdit: () => _openEditSheet(doc),
                      onDelete: () => _confirmDelete(doc.id),
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(String docId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _delete(docId);
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Task card
// ─────────────────────────────────────────────────────────────────────────────
class _TaskCard extends StatelessWidget {
  final String docId;
  final String title;
  final String description;
  final _Priority priority;
  final bool isCompleted;
  final String updatedAt;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _TaskCard({
    required this.docId,
    required this.title,
    required this.description,
    required this.priority,
    required this.isCompleted,
    required this.updatedAt,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isCompleted
            ? Border.all(color: Colors.grey.shade200)
            : Border.all(color: priority.color.withOpacity(0.25)),
        boxShadow: isCompleted
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Priority dot
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: priority.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: isCompleted
                          ? Colors.grey
                          : const Color(0xFF1E1E2E),
                      decoration: isCompleted
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                // Priority badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: priority.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(priority.icon,
                          size: 11, color: priority.color),
                      const SizedBox(width: 3),
                      Text(
                        priority.label,
                        style: TextStyle(
                            fontSize: 11,
                            color: priority.color,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color:
                    isCompleted ? Colors.grey : const Color(0xFF5C5C7B),
                decoration:
                    isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.access_time,
                    size: 12, color: Colors.grey.shade400),
                const SizedBox(width: 4),
                Text(
                  'Updated $updatedAt',
                  style: TextStyle(
                      fontSize: 11, color: Colors.grey.shade400),
                ),
                const Spacer(),
                // Toggle complete
                _IconBtn(
                  icon: isCompleted
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: isCompleted ? Colors.green : Colors.grey,
                  tooltip: isCompleted
                      ? 'Mark incomplete'
                      : 'Mark complete',
                  onTap: onToggle,
                ),
                // Edit — .update()
                _IconBtn(
                  icon: Icons.edit_outlined,
                  color: Colors.indigo,
                  tooltip: 'Edit (update)',
                  onTap: onEdit,
                ),
                // Delete
                _IconBtn(
                  icon: Icons.delete_outline,
                  color: Colors.redAccent,
                  tooltip: 'Delete',
                  onTap: onDelete,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Priority selector
// ─────────────────────────────────────────────────────────────────────────────
class _PrioritySelector extends StatelessWidget {
  final _Priority selected;
  final ValueChanged<_Priority> onChanged;

  const _PrioritySelector(
      {required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Priority',
          style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF5C5C7B)),
        ),
        const SizedBox(height: 8),
        Row(
          children: _Priority.values.map((p) {
            final isSelected = p == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => onChanged(p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? p.color.withOpacity(0.15)
                        : Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected ? p.color : Colors.grey.shade200,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(p.icon,
                          size: 18,
                          color: isSelected ? p.color : Colors.grey),
                      const SizedBox(height: 4),
                      Text(
                        p.label,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected ? p.color : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Operation legend
// ─────────────────────────────────────────────────────────────────────────────
class _OperationLegend extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const ops = [
      (Icons.add_circle_outline, Colors.green, 'add()',
          'New doc, auto ID'),
      (Icons.article_outlined, Colors.blue, 'set()',
          'Write to known ID'),
      (Icons.edit_outlined, Colors.indigo, 'update()',
          'Modify fields only'),
      (Icons.delete_outline, Colors.redAccent, 'delete()',
          'Remove doc'),
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Firestore Write Operations',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1E1E2E)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: ops
                .map(
                  (o) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: o.$2.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: o.$2.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(o.$1, size: 16, color: o.$2),
                        const SizedBox(width: 6),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '.${o.$3}',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: o.$2,
                                  fontFamily: 'monospace'),
                            ),
                            Text(
                              o.$4,
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Color(0xFF5C5C7B)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shared helpers
// ─────────────────────────────────────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _SectionLabel(
      {required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E1E2E)),
        ),
      ],
    );
  }
}

class _CodeChip extends StatelessWidget {
  final String code;
  const _CodeChip(this.code);

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
        code,
        style: const TextStyle(
            fontSize: 11,
            fontFamily: 'monospace',
            color: Color(0xFF1E1E2E)),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 20, color: color),
        ),
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.redAccent, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
