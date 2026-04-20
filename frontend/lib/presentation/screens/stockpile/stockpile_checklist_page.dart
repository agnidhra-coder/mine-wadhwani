import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// ignore_for_file: library_private_types_in_public_api

class StockpileChecklistPage extends StatefulWidget {
  final int sectionIndex;
  final List<StockpileSection> sections;
  final Map<String, String> answers;
  final Map<String, String> comments;
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;

  const StockpileChecklistPage({
    super.key,
    required this.sectionIndex,
    required this.sections,
    required this.answers,
    required this.comments,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
  });

  @override
  State<StockpileChecklistPage> createState() => _StockpileChecklistPageState();
}

class _StockpileChecklistPageState extends State<StockpileChecklistPage> {
  late int _currentSectionIndex;
  late Map<String, String> _answers;
  late Map<String, String> _comments;
  final Set<String> _expandedNotes = <String>{};
  final Map<String, TextEditingController> _controllers = {};

    Color _getOptionColor(String option) {
    switch (option) {
      case 'YES':
        return Color(0xFF10B981);
      case 'NO':
        return Color(0xFFEF4444);
      case 'NA':
        return Color(0xFF9CA3AF);
      default:
        return const Color(0xFF1F579C);
    }
  }

  @override
  void initState() {
    super.initState();
    _currentSectionIndex = widget.sectionIndex;
    _answers = Map.from(widget.answers);
    _comments = Map.from(widget.comments);
    _expandedNotes.addAll(
      _comments.entries
          .where((entry) => entry.value.trim().isNotEmpty)
          .map((entry) => entry.key),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // For yes/no questions: keyed by 'c:code' → comment controller
  // For text questions:   keyed by 'a:code' → answer controller
  TextEditingController _controller(String code) {
    return _controllers.putIfAbsent(
      'c:$code',
      () => TextEditingController(text: _comments[code] ?? ''),
    );
  }

  TextEditingController _answerController(String code) {
    return _controllers.putIfAbsent(
      'a:$code',
      () => TextEditingController(text: _answers[code] ?? ''),
    );
  }

  void _popWithResult() {
    final result = <String, String>{};
    for (final entry in _answers.entries) {
      result['a:${entry.key}'] = entry.value;
    }
    for (final entry in _comments.entries) {
      result['c:${entry.key}'] = entry.value;
    }
    Navigator.of(context).pop(result);
  }

  StockpileSection get _currentSection =>
      widget.sections[_currentSectionIndex];

  int get _answered =>
      _currentSection.questions
          .where((q) => (_answers[q.code] ?? '').isNotEmpty)
          .length;

  @override
  Widget build(BuildContext context) {
    final total = _currentSection.questions.length;
    final isFirst = _currentSectionIndex == 0;
    final isLast = _currentSectionIndex == widget.sections.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildProgressBar(total),
            Expanded(
              child: _buildQuestions(context),
            ),
            _buildFooter(context, isFirst, isLast, total),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF1F579C),
      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 8, right: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: _popWithResult,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 254, 255).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SECTION ${_currentSectionIndex + 1} OF ${widget.sections.length}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _currentSection.title,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int total) {
    final progress = total > 0 ? _answered / total : 0.0;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 2),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: const Color(0xFFE8EAF0),
        valueColor:
            const AlwaysStoppedAnimation<Color>(Color(0xFF2C3E6B)),
        minHeight: 4,
      ),
    );
  }

  Widget _buildQuestions(BuildContext context) {
    final questions = _currentSection.questions;
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: questions.length,
      itemBuilder: (context, index) => _buildQuestionCard(questions[index]),
    );
  }

  Widget _buildQuestionCard(StockpileQuestion question) {
    if (question.type == StockpileQuestionType.text) {
      return _buildTextInputCard(question);
    }
    return _buildYesNoCard(question);
  }

  Widget _buildTextInputCard(StockpileQuestion question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF1F579C),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(
                question.code,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 12),
                    child: Text(
                      question.text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F7FA),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE0E3EA)),
                    ),
                    child: TextField(
                      controller: _answerController(question.code),
                      decoration: InputDecoration(
                        hintText: question.hint ?? 'Enter value...',
                        hintStyle: TextStyle(
                          color: AppColors.outline.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                      maxLines: 1,
                      onChanged: (value) {
                        setState(() {
                          _answers[question.code] = value;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildYesNoCard(StockpileQuestion question) {
    final answer = _answers[question.code] ?? '';
    final hasAnswer = answer.isNotEmpty;
    final hasComment = (_comments[question.code] ?? '').trim().isNotEmpty;
    final showNoteField = _expandedNotes.contains(question.code) || hasComment;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F579C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    question.code,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      question.text,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAnswerToggle(question.code, answer),
            if (hasAnswer) ...[
              const SizedBox(height: 14),
              Text(
                'COMMENTS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary.withValues(alpha: 0.7),
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 6),
            ] else
              const SizedBox(height: 10),
            if (showNoteField)
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE0E3EA)),
                ),
                child: TextField(
                  controller: _controller(question.code),
                  decoration: InputDecoration(
                    hintText: 'Add optional notes or evidence reference...',
                    hintStyle: TextStyle(
                      color: AppColors.outline.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  maxLines: 3,
                  minLines: 2,
                  onChanged: (value) {
                    setState(() {
                      _comments[question.code] = value;
                      if (value.trim().isNotEmpty) {
                        _expandedNotes.add(question.code);
                      }
                    });
                  },
                ),
              )
            else
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _expandedNotes.add(question.code);
                    });
                  },
                  icon: const Icon(Icons.add_comment_outlined, size: 18),
                  label: const Text('Add note'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1F579C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

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
              onTap: () {
                setState(() {
                  _answers[code] = isSelected ? '' : option;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44,
                decoration: BoxDecoration(
                color: isSelected
                    ? _getOptionColor(option)
                    : Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? _getOptionColor(option)
                      : const Color(0xFFD5D8E0),
                  width: 1.5,
                ),
              ),
                alignment: Alignment.center,
                child: Text(
                  displayLabel,
                  style: TextStyle(
                    color: isSelected ? Colors.white : AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(
      BuildContext context, bool isFirst, bool isLast, int total) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: AppColors.outline.withValues(alpha: 0.15), height: 1),
          const SizedBox(height: 8),
          Text(
            '$_answered of $total answered in this section',
            style: TextStyle(
              color: AppColors.secondary.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isFirst
                        ? null
                        : () {
                            setState(() => _currentSectionIndex--);
                          },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFD5D8E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'PREVIOUS',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isFirst
                            ? AppColors.outline.withValues(alpha: 0.4)
                            : AppColors.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: () {
                      if (isLast) {
                        _popWithResult();
                      } else {
                        setState(() => _currentSectionIndex++);
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1F579C),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isLast ? 'DONE' : 'SAVE & NEXT',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                        ),
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
