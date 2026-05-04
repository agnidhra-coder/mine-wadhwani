import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/domain/entities/auth/user_entity.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';

// ignore_for_file: library_private_types_in_public_api

/// Represents a single corrective action tied to a checklist question.
class ChecklistAction {
  final String questionCode;
  final String title;
  final String description;
  final ActionPriority priority;
  final DateTime? dueDate;
  final String assigneeName;

  const ChecklistAction({
    required this.questionCode,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    required this.assigneeName,
  });

  /// Encodes to a single pipe-delimited string for passing through result maps.
  String encode() {
    return [
      title,
      description,
      priority.name,
      dueDate != null
          ? '${dueDate!.year}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}'
          : '',
      assigneeName,
    ].join('|||');
  }

  /// Decodes from the encoded string.
  static ChecklistAction? decode(String questionCode, String encoded) {
    final parts = encoded.split('|||');
    if (parts.length < 5) return null;
    DateTime? dueDate;
    if (parts[3].isNotEmpty) {
      try {
        dueDate = DateTime.parse(parts[3]);
      } catch (_) {}
    }
    return ChecklistAction(
      questionCode: questionCode,
      title: parts[0],
      description: parts[1],
      priority: ActionPriority.values.firstWhere(
        (p) => p.name == parts[2],
        orElse: () => ActionPriority.none,
      ),
      assigneeName: parts[4],
    );
  }
}

enum ActionPriority { high, medium, low, none }

extension ActionPriorityExt on ActionPriority {
  String get label {
    switch (this) {
      case ActionPriority.high:
        return 'High';
      case ActionPriority.medium:
        return 'Medium';
      case ActionPriority.low:
        return 'Low';
      case ActionPriority.none:
        return 'None';
    }
  }

  String get prefix {
    switch (this) {
      case ActionPriority.high:
        return '↑↑';
      case ActionPriority.medium:
        return '↑';
      case ActionPriority.low:
        return '↓';
      case ActionPriority.none:
        return '–';
    }
  }

  Color get color {
    switch (this) {
      case ActionPriority.high:
        return const Color(0xFFEF4444);
      case ActionPriority.medium:
        return const Color(0xFFF59E0B);
      case ActionPriority.low:
        return const Color(0xFF10B981);
      case ActionPriority.none:
        return const Color(0xFF9CA3AF);
    }
  }

  Color get bgColor {
    switch (this) {
      case ActionPriority.high:
        return const Color(0xFFFFEBEE);
      case ActionPriority.medium:
        return const Color(0xFFFFF8E1);
      case ActionPriority.low:
        return const Color(0xFFE8F5E9);
      case ActionPriority.none:
        return const Color(0xFFF3F4F6);
    }
  }
}

class ActionPage extends StatefulWidget {
  final String questionCode;
  final String questionText;

  /// Pass existing action to pre-fill form in edit mode.
  final ChecklistAction? existingAction;

  const ActionPage({
    super.key,
    required this.questionCode,
    required this.questionText,
    this.existingAction,
  });

  @override
  State<ActionPage> createState() => _ActionPageState();
}

class _ActionPageState extends State<ActionPage> {
  static const _headerColor = Color(0xFF1F579C);

  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  ActionPriority _priority = ActionPriority.none;
  DateTime? _dueDate;
  UserEntity? _currentUser;

  bool get _canCreate =>
      _titleController.text.trim().isNotEmpty && _currentUser != null;

  @override
  void initState() {
    super.initState();

    // Pre-fill if editing
    final existing = widget.existingAction;
    if (existing != null) {
      _titleController.text = existing.title;
      _descController.text = existing.description;
      _priority = existing.priority;
      _dueDate = existing.dueDate;
    }

    // Keep status bar consistent with checklist
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _headerColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _create() {
    if (!_canCreate) return;
    final action = ChecklistAction(
      questionCode: widget.questionCode,
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      priority: _priority,
      dueDate: _dueDate,
      assigneeName: _currentUser!.name,
    );
    Navigator.of(context).pop(action);
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: _headerColor,
                onPrimary: Colors.white,
                surface: Colors.white,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is Authenticated) {
          _currentUser = authState.user;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF5F7FA),
          body: Column(
            children: [
              _buildHeader(statusBarHeight),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Left column ─────────────────────────────
                      Expanded(
                        flex: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildQuestionRef(),
                            const SizedBox(height: 20),
                            _buildTitleField(),
                            const SizedBox(height: 16),
                            _buildDescField(),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      // ── Right column ─────────────────────────────
                      Expanded(
                        flex: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildPrioritySection(),
                            const SizedBox(height: 20),
                            _buildDueDateSection(),
                            const SizedBox(height: 20),
                            _buildAssigneeSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(double statusBarHeight) {
    final isEdit = widget.existingAction != null;
    return Container(
      color: _headerColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: statusBarHeight),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // ✕ Close
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(null),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.close,
                        color: Colors.white, size: 20),
                  ),
                ),

                // Title
                Expanded(
                  child: Text(
                    isEdit ? 'Edit Action' : 'Create Action',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),

                // ✓ Create / Save
                GestureDetector(
                  onTap: _canCreate ? _create : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: _canCreate
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isEdit ? 'Save' : 'Create',
                      style: TextStyle(
                        color: _canCreate
                            ? _headerColor
                            : Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Question ref ─────────────────────────────────────────────────────────

  Widget _buildQuestionRef() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: _headerColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _headerColor.withValues(alpha: 0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _headerColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              widget.questionCode,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              widget.questionText,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: const Color(0xFF1A2340).withValues(alpha: 0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Title ────────────────────────────────────────────────────────────────

  Widget _buildTitleField() {
    return _buildCard(
      label: 'TITLE',
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: _headerColor),
        ),
        child: TextField(
          controller: _titleController,
          cursorColor: _headerColor,
          autofocus: true,
          onChanged: (_) => setState(() {}),
          decoration: _inputDecoration('Enter action title...'),
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // ─── Description ─────────────────────────────────────────────────────────

  Widget _buildDescField() {
    return _buildCard(
      label: 'DESCRIPTION',
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme:
              Theme.of(context).colorScheme.copyWith(primary: _headerColor),
        ),
        child: TextField(
          controller: _descController,
          cursorColor: _headerColor,
          maxLines: 4,
          minLines: 3,
          decoration: _inputDecoration(
              'Describe what needs to be done, evidence, or corrective steps...'),
          style: const TextStyle(fontSize: 14, height: 1.5),
        ),
      ),
    );
  }

  // ─── Priority ─────────────────────────────────────────────────────────────

  Widget _buildPrioritySection() {
    return _buildCard(
      label: 'PRIORITY',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: ActionPriority.values.map((p) {
          final isSelected = _priority == p;
          return GestureDetector(
            onTap: () => setState(() => _priority = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(
                  horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? p.bgColor : const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? p.color.withValues(alpha: 0.5)
                      : const Color(0xFFE0E3EA),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    p.prefix,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: isSelected
                          ? p.color
                          : const Color(0xFF9CA3AF),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    p.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? p.color
                          : const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ─── Due date ─────────────────────────────────────────────────────────────

  Widget _buildDueDateSection() {
    return _buildCard(
      label: 'DUE DATE',
      child: GestureDetector(
        onTap: _pickDate,
        child: Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _dueDate != null
                  ? _headerColor.withValues(alpha: 0.4)
                  : const Color(0xFFE0E3EA),
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: _dueDate != null
                    ? _headerColor
                    : const Color(0xFF9CA3AF),
              ),
              const SizedBox(width: 10),
              Text(
                _dueDate != null
                    ? _formatDate(_dueDate!)
                    : 'Select due date',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: _dueDate != null
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: _dueDate != null
                      ? const Color(0xFF1A2340)
                      : const Color(0xFF9CA3AF),
                ),
              ),
              const Spacer(),
              if (_dueDate != null)
                GestureDetector(
                  onTap: () => setState(() => _dueDate = null),
                  child: Icon(Icons.close,
                      size: 16,
                      color: const Color(0xFF9CA3AF).withValues(alpha: 0.8)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Assignee ─────────────────────────────────────────────────────────────

  Widget _buildAssigneeSection() {
    return _buildCard(
      label: 'ASSIGNEE',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: _headerColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _headerColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            // User icon circle
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _headerColor.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_outline_rounded,
                size: 20,
                color: _headerColor,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _currentUser != null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentUser!.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A2340),
                          ),
                        ),
                        Text(
                          'Auto-assigned (logged in user)',
                          style: TextStyle(
                            fontSize: 11,
                            color: const Color(0xFF6B7280)
                                .withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    )
                  : Text(
                      'No user session found',
                      style: TextStyle(
                        fontSize: 14,
                        color: const Color(0xFF9CA3AF).withValues(alpha: 0.8),
                      ),
                    ),
            ),
            Icon(Icons.lock_outline,
                size: 15,
                color: const Color(0xFF9CA3AF).withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }

  // ─── Shared helpers ───────────────────────────────────────────────────────

  Widget _buildCard({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Color(0xFF9CA3AF),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Color(0xFFB0B7C3), fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF5F7FA),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE0E3EA), width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _headerColor, width: 1.5),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}