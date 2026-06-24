// lib/presentation/screens/common/inspection_checklist_page.dart
//
// Generic checklist page used by ALL inspection types.
// Pass the sections list from HaulRoadData.sections or StockpileData.sections
// (after migrating stockpile to InspectionSection — see migration note below).

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/presentation/screens/common/inspection_section.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/action_page.dart';

// ignore_for_file: library_private_types_in_public_api

class InspectionChecklistPage extends StatefulWidget {
  final int sectionIndex;
  final List<InspectionSection> sections;
  final Map<String, String> answers;
  final Map<String, String> comments;
  final Map<String, List<String>> mediaFiles;
  final Map<String, String> actions;
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;

  const InspectionChecklistPage({
    super.key,
    required this.sectionIndex,
    required this.sections,
    required this.answers,
    required this.comments,
    required this.mediaFiles,
    required this.actions,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
  });

  @override
  State<InspectionChecklistPage> createState() =>
      _InspectionChecklistPageState();
}

class _InspectionChecklistPageState extends State<InspectionChecklistPage> {
  static const _headerColor = Color(0xFF1F579C);

  late int _currentSectionIndex;
  late Map<String, String> _answers;
  late Map<String, String> _comments;
  late Map<String, List<String>> _mediaFiles;
  late Map<String, String> _actions;

  final Set<String> _expandedNotes = <String>{};
  final Set<String> _savedNotes = <String>{};
  final Map<String, TextEditingController> _controllers = {};
  final ImagePicker _imagePicker = ImagePicker();

  // ─── Init / Dispose ───────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _currentSectionIndex = widget.sectionIndex;
    _answers = Map.from(widget.answers);
    _comments = Map.from(widget.comments);
    _actions = Map.from(widget.actions);
    _mediaFiles = Map.fromEntries(
      widget.mediaFiles.entries
          .map((e) => MapEntry(e.key, List<String>.from(e.value))),
    );
    for (final entry in _comments.entries) {
      if (entry.value.trim().isNotEmpty) _savedNotes.add(entry.key);
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: _headerColor,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
  }

  @override
  void dispose() {
    for (final c in _controllers.values) c.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
    super.dispose();
  }

  // ─── Controllers ──────────────────────────────────────────────────────────

  TextEditingController _controller(String code) =>
      _controllers.putIfAbsent(
          'c:$code', () => TextEditingController(text: _comments[code] ?? ''));

  TextEditingController _answerController(String code) =>
      _controllers.putIfAbsent(
          'a:$code', () => TextEditingController(text: _answers[code] ?? ''));

  // ─── Result builder ───────────────────────────────────────────────────────

  Map<String, String> _buildResult({int? nextSectionIndex}) {
    final result = <String, String>{};
    for (final e in _answers.entries) result['a:${e.key}'] = e.value;
    for (final e in _comments.entries) result['c:${e.key}'] = e.value;
    for (final e in _mediaFiles.entries)
      result['m:${e.key}'] = e.value.join('||');
    for (final e in _actions.entries) result['act:${e.key}'] = e.value;
    if (nextSectionIndex != null) result['__next__'] = '$nextSectionIndex';
    return result;
  }

  void _popWithResult() => Navigator.of(context).pop(_buildResult());
  void _saveAndNext() => Navigator.of(context)
      .pop(_buildResult(nextSectionIndex: _currentSectionIndex + 1));

  // ─── Helpers ──────────────────────────────────────────────────────────────

  InspectionSection get _currentSection =>
      widget.sections[_currentSectionIndex];

  int get _answered => _currentSection.questions
      .where((q) => (_answers[q.code] ?? '').isNotEmpty)
      .length;

  Color _getOptionColor(String option) {
    switch (option) {
      case 'YES':
        return const Color(0xFF10B981);
      case 'NO':
        return const Color(0xFFEF4444);
      case 'NA':
        return const Color(0xFF9CA3AF);
      default:
        return _headerColor;
    }
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  DateTime? _parseStoredDate(String stored) {
    if (stored.isEmpty) return null;
    try {
      final parts = stored.split(' ');
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return DateTime(
        int.parse(parts[2]),
        months.indexOf(parts[1]) + 1,
        int.parse(parts[0]),
      );
    } catch (_) {
      return null;
    }
  }

  // ─── Action ───────────────────────────────────────────────────────────────

  Future<void> _openActionPage(InspectionQuestion question) async {
    final existing = _actions[question.code] != null
        ? ChecklistAction.decode(question.code, _actions[question.code]!)
        : null;

    final result = await Navigator.of(context).push<ChecklistAction?>(
      MaterialPageRoute(
        builder: (_) => ActionPage(
          questionCode: question.code,
          questionText: question.text,
          existingAction: existing,
        ),
      ),
    );

    if (result != null && mounted) {
      setState(() => _actions[question.code] = result.encode());
    }
  }

  // ─── Media ────────────────────────────────────────────────────────────────

  Future<void> _pickFromCamera(String code) async {
    Navigator.of(context).pop();
    try {
      final XFile? file =
          await _imagePicker.pickImage(source: ImageSource.camera, imageQuality: 85);
      if (file != null && mounted) {
        setState(() => _mediaFiles.putIfAbsent(code, () => []).add(file.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Camera error: $e')));
      }
    }
  }

  Future<void> _pickFromGallery(String code) async {
    Navigator.of(context).pop();
    try {
      final XFile? file =
          await _imagePicker.pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (file != null && mounted) {
        setState(() => _mediaFiles.putIfAbsent(code, () => []).add(file.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gallery error: $e')));
      }
    }
  }

  void _showMediaPopup(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                      color: const Color(0xFFE0E3EA),
                      borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FB),
                        borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.perm_media_outlined,
                        color: _headerColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Add Media',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1A2340))),
                      Text('Attach photos to this inspection point',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppColors.secondary.withValues(alpha: 0.6))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildMediaOption(
                icon: Icons.camera_alt_outlined,
                iconBg: const Color(0xFFE8F0FB),
                iconColor: _headerColor,
                label: 'Take Photo',
                subtitle: 'Open camera and capture now',
                onTap: () => _pickFromCamera(code),
              ),
              const SizedBox(height: 10),
              _buildMediaOption(
                icon: Icons.photo_library_outlined,
                iconBg: const Color(0xFFF0FAF5),
                iconColor: const Color(0xFF10B981),
                label: 'Insert from Gallery',
                subtitle: 'Choose an existing photo from your library',
                onTap: () => _pickFromGallery(code),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMediaOption({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE0E3EA)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                  color: iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A2340))),
                  const SizedBox(height: 2),
                  Text(subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: AppColors.secondary.withValues(alpha: 0.6))),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: AppColors.outline.withValues(alpha: 0.5), size: 20),
          ],
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final total = _currentSection.questions.length;
    final isFirst = _currentSectionIndex == 0;
    final isLast = _currentSectionIndex == widget.sections.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(context, total),
          Expanded(child: _buildQuestions(context)),
          _buildFooter(context, isFirst, isLast, total),
        ],
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, int total) {
    final progress = total > 0 ? _answered / total : 0.0;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: _headerColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: statusBarHeight),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _popWithResult,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.chevron_left,
                        color: Colors.white, size: 26),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'SECTION ${_currentSectionIndex + 1} OF ${widget.sections.length}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currentSection.title,
                        style: AppTextStyles.titleLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('PROGRESS',
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white.withValues(alpha: 0.7),
                            letterSpacing: 0.8)),
                    Text('$_answered / $total answered',
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Questions list ───────────────────────────────────────────────────────

  Widget _buildQuestions(BuildContext context) {
    final questions = _currentSection.questions;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: questions.length,
      itemBuilder: (context, index) => _buildQuestionCard(questions[index]),
    );
  }

  Widget _buildQuestionCard(InspectionQuestion question) {
    switch (question.type) {
      case InspectionQuestionType.text:
        return _buildTextInputCard(question);
      case InspectionQuestionType.dropdown:
        return _buildDropdownCard(question);
      case InspectionQuestionType.datepicker:
        return _buildDatePickerCard(question);
      case InspectionQuestionType.yesNo:
        return _buildYesNoCard(question);
    }
  }

  // ─── Shared card shell ────────────────────────────────────────────────────

  Widget _cardShell({required Widget child}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Padding(padding: const EdgeInsets.all(20), child: child),
    );
  }

  Widget _codeBadge(String code) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          color: _headerColor, borderRadius: BorderRadius.circular(10)),
      alignment: Alignment.center,
      child: Text(code,
          style: const TextStyle(
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }

  // ─── Text input card ──────────────────────────────────────────────────────

  Widget _buildTextInputCard(InspectionQuestion question) {
    return _cardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _codeBadge(question.code),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 12),
                  child: Text(question.text,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontSize: 15, height: 1.4)),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: Theme.of(context)
                        .colorScheme
                        .copyWith(primary: _headerColor),
                  ),
                  child: TextField(
                    controller: _answerController(question.code),
                    cursorColor: _headerColor,
                    decoration: InputDecoration(
                      hintText: question.hint ?? 'Enter value...',
                      hintStyle: TextStyle(
                          color: AppColors.outline.withValues(alpha: 0.6),
                          fontSize: 14),
                      filled: true,
                      fillColor: const Color(0xFFF5F7FA),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: Color(0xFFE0E3EA), width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: _headerColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                    ),
                    maxLines: 1,
                    onChanged: (v) =>
                        setState(() => _answers[question.code] = v),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Dropdown card ────────────────────────────────────────────────────────

  Widget _buildDropdownCard(InspectionQuestion question) {
    final selected = _answers[question.code] ?? '';
    final options = question.options ?? [];

    return _cardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _codeBadge(question.code),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 14),
                  child: Text(question.text,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontSize: 15, height: 1.4)),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: options.map((opt) {
                    final isSelected = selected == opt;
                    return GestureDetector(
                      onTap: () => setState(() =>
                          _answers[question.code] = isSelected ? '' : opt),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? _headerColor
                              : const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: isSelected
                                ? _headerColor
                                : const Color(0xFFD5D8E0),
                            width: 1.5,
                          ),
                        ),
                        child: Text(opt,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.onSurface,
                            )),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Date picker card ─────────────────────────────────────────────────────

  Widget _buildDatePickerCard(InspectionQuestion question) {
    final stored = _answers[question.code] ?? '';
    final picked = _parseStoredDate(stored);

    return _cardShell(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _codeBadge(question.code),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6, bottom: 14),
                  child: Text(question.text,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontSize: 15, height: 1.4)),
                ),
                GestureDetector(
                  onTap: () async {
                    final now = DateTime.now();
                    final result = await showDatePicker(
                      context: context,
                      initialDate: picked ?? now,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: Theme.of(context)
                              .colorScheme
                              .copyWith(primary: _headerColor),
                        ),
                        child: child!,
                      ),
                    );
                    if (result != null && mounted) {
                      setState(() =>
                          _answers[question.code] = _formatDate(result));
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: stored.isNotEmpty
                            ? _headerColor.withValues(alpha: 0.5)
                            : const Color(0xFFE0E3EA),
                        width: stored.isNotEmpty ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today_outlined,
                            size: 18,
                            color: stored.isNotEmpty
                                ? _headerColor
                                : AppColors.outline.withValues(alpha: 0.5)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            stored.isNotEmpty ? stored : 'Select date…',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: stored.isNotEmpty
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: stored.isNotEmpty
                                  ? AppColors.onSurface
                                  : AppColors.outline.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        if (stored.isNotEmpty)
                          GestureDetector(
                            onTap: () =>
                                setState(() => _answers.remove(question.code)),
                            child: Icon(Icons.close,
                                size: 16,
                                color:
                                    AppColors.outline.withValues(alpha: 0.5)),
                          ),
                      ],
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

  // ─── Yes/No card ──────────────────────────────────────────────────────────

  Widget _buildYesNoCard(InspectionQuestion question) {
    final code = question.code;
    final answer = _answers[code] ?? '';
    final mediaList = _mediaFiles[code] ?? [];
    final mediaCount = mediaList.length;
    final showNoteField = _expandedNotes.contains(code);
    final isSaved = _savedNotes.contains(code);
    final savedText = _comments[code] ?? '';
    final hasAction = _actions.containsKey(code);

    return _cardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _codeBadge(code),
              const SizedBox(width: 14),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Text(question.text,
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontSize: 15, height: 1.4)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // YES / NO / NA toggle
          _buildAnswerToggle(code, answer),
          const SizedBox(height: 14),

          // Bottom action row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Add note
              GestureDetector(
                onTap: () {
                  if (isSaved) {
                    setState(() {
                      _savedNotes.remove(code);
                      _expandedNotes.add(code);
                    });
                  } else if (!showNoteField) {
                    setState(() => _expandedNotes.add(code));
                  }
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSaved
                            ? Icons.edit_note_outlined
                            : (showNoteField
                                ? Icons.notes_outlined
                                : Icons.add_comment_outlined),
                        size: 15,
                        color: const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        isSaved
                            ? 'Edit note'
                            : (showNoteField ? 'Adding note…' : 'Add note'),
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),

              // Media
              GestureDetector(
                onTap: () => _showMediaPopup(code),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.camera_alt_outlined,
                          size: 15,
                          color: mediaCount > 0
                              ? const Color(0xFF10B981)
                              : const Color(0xFF6B7280)),
                      const SizedBox(width: 5),
                      Text(
                        mediaCount > 0 ? 'Media ($mediaCount)' : 'Media',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: mediaCount > 0
                                ? const Color(0xFF10B981)
                                : const Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Action
              GestureDetector(
                onTap: () => _openActionPage(question),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 11, vertical: 7),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        hasAction ? Icons.bolt : Icons.bolt_outlined,
                        size: 15,
                        color: hasAction
                            ? const Color(0xFFF59E0B)
                            : const Color(0xFF6B7280),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        hasAction ? 'Action ✓' : 'Action',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: hasAction
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF6B7280)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Note: typing state
          if (showNoteField && !isSaved) ...[
            const SizedBox(height: 12),
            Theme(
              data: Theme.of(context).copyWith(
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(primary: _headerColor),
              ),
              child: TextField(
                controller: _controller(code),
                cursorColor: _headerColor,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Add optional notes or evidence reference...',
                  hintStyle: TextStyle(
                      color: AppColors.outline.withValues(alpha: 0.6),
                      fontSize: 14),
                  filled: true,
                  fillColor: const Color(0xFFF5F7FA),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFE0E3EA), width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: _headerColor, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                maxLines: 3,
                minLines: 2,
                onChanged: (v) => setState(() => _comments[code] = v),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedNotes.remove(code);
                      if ((_comments[code] ?? '').trim().isEmpty) {
                        _comments.remove(code);
                        _controller(code).clear();
                      }
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEBEE),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.3)),
                    ),
                    child: const Icon(Icons.close,
                        size: 18, color: Color(0xFFEF4444)),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    final text = _controller(code).text.trim();
                    setState(() {
                      if (text.isNotEmpty) {
                        _comments[code] = text;
                        _savedNotes.add(code);
                      }
                      _expandedNotes.remove(code);
                    });
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                    ),
                    child: const Icon(Icons.check,
                        size: 18, color: Color(0xFF10B981)),
                  ),
                ),
              ],
            ),
          ],

          // Note: saved state
          if (isSaved && savedText.isNotEmpty && !showNoteField) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: _headerColor.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(12),
                border:
                    Border.all(color: _headerColor.withValues(alpha: 0.15)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.notes_outlined,
                      size: 16, color: _headerColor.withValues(alpha: 0.7)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(savedText,
                        style: TextStyle(
                            fontSize: 13,
                            height: 1.5,
                            color: AppColors.onSurface.withValues(alpha: 0.85))),
                  ),
                ],
              ),
            ),
          ],

          // Media thumbnails
          if (mediaList.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: mediaList.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (context, i) => Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: kIsWeb
                          ? Image.network(mediaList[i],
                              width: 80, height: 80, fit: BoxFit.cover)
                          : Image.file(File(mediaList[i]),
                              width: 80, height: 80, fit: BoxFit.cover),
                    ),
                    Positioned(
                      top: 3,
                      right: 3,
                      child: GestureDetector(
                        onTap: () => setState(() => mediaList.removeAt(i)),
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // Action summary card
          if (hasAction) ...[
            const SizedBox(height: 12),
            _buildActionSummaryCard(code, question),
          ],
        ],
      ),
    );
  }

  // ─── Action summary card ──────────────────────────────────────────────────

  Widget _buildActionSummaryCard(String code, InspectionQuestion question) {
    final action = ChecklistAction.decode(code, _actions[code]!);
    if (action == null) return const SizedBox.shrink();

    return GestureDetector(
      onTap: () => _openActionPage(question),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBEB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFF59E0B).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.bolt, size: 18, color: Color(0xFFF59E0B)),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(action.title,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A2340)),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: action.priority.bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color:
                                  action.priority.color.withValues(alpha: 0.4)),
                        ),
                        child: Text(
                          '${action.priority.prefix} ${action.priority.label}',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: action.priority.color),
                        ),
                      ),
                    ],
                  ),
                  if (action.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(action.description,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                            height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.person_outline_rounded,
                          size: 13, color: Color(0xFF9CA3AF)),
                      const SizedBox(width: 4),
                      Text(action.assigneeName,
                          style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF9CA3AF),
                              fontWeight: FontWeight.w500)),
                      if (action.dueDate != null) ...[
                        const SizedBox(width: 12),
                        const Icon(Icons.calendar_today_outlined,
                            size: 12, color: Color(0xFF9CA3AF)),
                        const SizedBox(width: 4),
                        Text(_formatDate(action.dueDate!),
                            style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF9CA3AF),
                                fontWeight: FontWeight.w500)),
                      ],
                      const Spacer(),
                      Text('Tap to edit',
                          style: TextStyle(
                              fontSize: 11,
                              color: const Color(0xFFF59E0B)
                                  .withValues(alpha: 0.8),
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Answer toggle ────────────────────────────────────────────────────────

  Widget _buildAnswerToggle(String code, String currentAnswer) {
    const options = ['YES', 'NO', 'NA'];
    return Row(
      children: options.map((option) {
        final isSelected = currentAnswer == option;
        final displayLabel = option == 'NA' ? 'N/A' : option;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: option != 'NA' ? 8 : 0),
            child: GestureDetector(
              onTap: () =>
                  setState(() => _answers[code] = isSelected ? '' : option),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44,
                decoration: BoxDecoration(
                  color:
                      isSelected ? _getOptionColor(option) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? _getOptionColor(option)
                        : const Color(0xFFD5D8E0),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(displayLabel,
                    style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                        fontSize: 14)),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────

  Widget _buildFooter(
      BuildContext context, bool isFirst, bool isLast, int total) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
              color: AppColors.outline.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 8),
          Text('$_answered of $total answered in this section',
              style: TextStyle(
                  color: AppColors.secondary.withValues(alpha: 0.7),
                  fontSize: 13)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isFirst
                        ? null
                        : () => setState(() => _currentSectionIndex--),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD5D8E0)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('PREVIOUS',
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: isFirst
                                ? AppColors.outline.withValues(alpha: 0.4)
                                : AppColors.onSurface,
                            letterSpacing: 0.5)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: isLast ? _popWithResult : _saveAndNext,
                    style: FilledButton.styleFrom(
                      backgroundColor: _headerColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(isLast ? 'FINISH' : 'SAVE & NEXT',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                letterSpacing: 0.5)),
                        if (!isLast) ...[
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward, size: 18),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}