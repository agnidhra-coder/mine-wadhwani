import 'dart:typed_data';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/di/injection_container.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/data/models/checklist/pending_image.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';

@RoutePage()
class ChecklistPage extends StatefulWidget {
  final int initialSectionIndex;
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;

  const ChecklistPage({
    super.key,
    @PathParam('sectionIndex') this.initialSectionIndex = 0,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
  });

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  late int _currentSectionIndex = widget.initialSectionIndex;
  final Map<String, TextEditingController> _commentControllers = {};

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    for (final controller in _commentControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _getCommentController(
      String questionCode, String initialText) {
    if (!_commentControllers.containsKey(questionCode)) {
      _commentControllers[questionCode] =
          TextEditingController(text: initialText);
    }
    return _commentControllers[questionCode]!;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<ChecklistBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: BlocConsumer<ChecklistBloc, ChecklistState>(
          listener: (context, state) {
            if (state is ChecklistSubmitted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Checklist submitted successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              context.router.maybePop();
            } else if (state is ChecklistError) {
              debugPrint("error: ${state.message}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is ChecklistLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            final questions = _getQuestions(state);
            if (questions == null) {
              return const Center(child: Text('Failed to load checklist.'));
            }

            final sections = _getSections(questions);
            if (sections.isEmpty) {
              return const Center(child: Text('No questions found.'));
            }

            if (_currentSectionIndex >= sections.length) {
              _currentSectionIndex = 0;
            }

            final currentSection = sections[_currentSectionIndex];
            final sectionQuestions = questions
                .where((q) => q.mainTopic == currentSection)
                .toList();

            return SafeArea(
              child: Column(
                children: [
                  _buildSectionHeader(
                      currentSection, sections.length, context),
                  _buildProgressBar(sectionQuestions),
                  Expanded(
                    child: _buildQuestionsContent(
                        sectionQuestions, context),
                  ),
                  _buildSectionFooter(
                      sectionQuestions, sections.length, context, state, questions),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  List<ChecklistModel>? _getQuestions(ChecklistState state) {
    if (state is ChecklistLoaded) return state.questions;
    if (state is ChecklistSubmitting) return state.questions;
    return null;
  }

  List<String> _getSections(List<ChecklistModel> questions) {
    final seen = <String>{};
    final sections = <String>[];
    for (final q in questions) {
      if (seen.add(q.mainTopic)) {
        sections.add(q.mainTopic);
      }
    }
    return sections;
  }

  Widget _buildSectionHeader(
      String sectionName, int totalSections, BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 8, right: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: () => context.router.maybePop(),
            color: AppColors.onSurface,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SECTION - ${_currentSectionIndex + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  sectionName,
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

  Widget _buildProgressBar(List<ChecklistModel> sectionQuestions) {
    final answered =
        sectionQuestions.where((q) => q.answer.isNotEmpty).length;
    final total = sectionQuestions.length;
    final progress = total > 0 ? answered / total : 0.0;

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

  Widget _buildQuestionsContent(
      List<ChecklistModel> sectionQuestions, BuildContext context) {
    // Group by sub-topic preserving order
    final subTopics = <String>[];
    final subTopicQuestions = <String, List<ChecklistModel>>{};
    for (final q in sectionQuestions) {
      if (!subTopicQuestions.containsKey(q.subTopic)) {
        subTopics.add(q.subTopic);
        subTopicQuestions[q.subTopic] = [];
      }
      subTopicQuestions[q.subTopic]!.add(q);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: subTopics.length,
      itemBuilder: (context, index) {
        final subTopic = subTopics[index];
        final questions = subTopicQuestions[subTopic]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subTopic.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 12),
                child: Text(
                  subTopic,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
            ],
            ...questions.map(
              (q) => _buildQuestionCard(q, context),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuestionCard(ChecklistModel question, BuildContext context) {
    final hasAnswer = question.answer.isNotEmpty;
    final checklistState = context.watch<ChecklistBloc>().state;
    final List<PendingImage> pendingImages = checklistState is ChecklistLoaded
        ? (checklistState.pendingImages[question.questionCode]?.cast<PendingImage>() ?? <PendingImage>[])
        : <PendingImage>[];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E3EA),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number + text
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E6B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    question.questionCode,
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
                      question.questionText,
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

            // YES / NO / N/A toggle buttons
            _buildAnswerToggle(question, context),

            // Comment section - show COMMENTS label if answered
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
            ] else ...[
              const SizedBox(height: 10),
            ],

            // Comment text field
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE0E3EA),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _getCommentController(
                    question.questionCode, question.comment),
                decoration: InputDecoration(
                  hintText: hasAnswer
                      ? 'Add optional notes or evidence reference...'
                      : 'Comment (optional)',
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
                  context.read<ChecklistBloc>().add(
                        UpdateComment(
                          questionCode: question.questionCode,
                          comment: value,
                        ),
                      );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Image thumbnails (pending local images)
            if (pendingImages.isNotEmpty) ...[
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: pendingImages.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.memory(
                            pendingImages[index].bytes,
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: GestureDetector(
                            onTap: () {
                              context.read<ChecklistBloc>().add(
                                    RemoveLocalImage(
                                      questionCode: question.questionCode,
                                      imageIndex: index,
                                    ),
                                  );
                            },
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],

            // Add Media button
            _buildAddMediaButton(question, context),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImages(
      ChecklistModel question, BuildContext context) async {
    final picker = ImagePicker();

    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Select Image Source',
                style: AppTextStyles.titleLarge.copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E6B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.camera_alt_rounded,
                      color: Color(0xFF2C3E6B)),
                ),
                title: const Text('Camera',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Take a photo'),
                onTap: () => Navigator.pop(ctx, ImageSource.camera),
              ),
              ListTile(
                leading: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E6B).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.photo_library_rounded,
                      color: Color(0xFF2C3E6B)),
                ),
                title: const Text('Gallery',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                subtitle: const Text('Choose from gallery'),
                onTap: () => Navigator.pop(ctx, ImageSource.gallery),
              ),
            ],
          ),
        ),
      ),
    );

    if (source == null || !context.mounted) return;

    List<XFile> xFiles = [];

    if (source == ImageSource.gallery) {
      xFiles = await picker.pickMultiImage(
        imageQuality: 80,
        maxWidth: 1920,
      );
    } else {
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
      );
      if (image != null) {
        xFiles = [image];
      }
    }

    if (xFiles.isNotEmpty && context.mounted) {
      // Read bytes from each XFile for cross-platform display
      final pendingImages = <PendingImage>[];
      for (final xFile in xFiles) {
        final bytes = await xFile.readAsBytes();
        pendingImages.add(PendingImage(filePath: xFile.path, bytes: Uint8List.fromList(bytes)));
      }

      if (context.mounted) {
        context.read<ChecklistBloc>().add(
              AddLocalImages(
                questionCode: question.questionCode,
                images: pendingImages,
              ),
            );
      }
    }
  }

  Widget _buildAddMediaButton(
      ChecklistModel question, BuildContext context) {
    return GestureDetector(
      onTap: () => _pickImages(question, context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color(0xFFD5D8E0),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.add_a_photo_rounded,
              size: 18,
              color: Color(0xFF2C3E6B),
            ),
            const SizedBox(width: 8),
            Text(
              'Add Media',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF2C3E6B).withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerToggle(ChecklistModel question, BuildContext context) {
    const options = ['YES', 'NO', 'NA'];

    return Row(
      children: options.map((option) {
        final isSelected = question.answer == option;
        final displayLabel = option == 'NA' ? 'N/A' : option;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: option != 'NA' ? 8 : 0,
              left: option != 'YES' ? 0 : 0,
            ),
            child: GestureDetector(
              onTap: () {
                context.read<ChecklistBloc>().add(
                      UpdateAnswer(
                        questionCode: question.questionCode,
                        answer: isSelected ? '' : option,
                      ),
                    );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 44,
                decoration: BoxDecoration(
                  color: isSelected
                      ? const Color(0xFF2C3E6B)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF2C3E6B)
                        : const Color(0xFFD5D8E0),
                    width: 1.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  displayLabel,
                  style: TextStyle(
                    color: isSelected
                        ? Colors.white
                        : AppColors.onSurface,
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

  Widget _buildSectionFooter(
    List<ChecklistModel> sectionQuestions,
    int totalSections,
    BuildContext context,
    ChecklistState state,
    List<ChecklistModel> allQuestions,
  ) {
    final answered =
        sectionQuestions.where((q) => q.answer.isNotEmpty).length;
    final total = sectionQuestions.length;
    final isFirst = _currentSectionIndex == 0;
    final isLast = _currentSectionIndex == totalSections - 1;
    final isSubmitting = state is ChecklistSubmitting;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: AppColors.outline.withValues(alpha: 0.15),
            height: 1,
          ),
          const SizedBox(height: 8),
          Text(
            '$answered of $total answered in this section',
            style: TextStyle(
              color: AppColors.secondary.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // PREVIOUS button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isFirst
                        ? null
                        : () {
                            setState(() {
                              _currentSectionIndex--;
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: isFirst
                            ? const Color(0xFFD5D8E0)
                            : const Color(0xFFD5D8E0),
                      ),
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
              // SAVE & NEXT / SUBMIT button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: FilledButton(
                    onPressed: isSubmitting
                        ? null
                        : () {
                            if (isLast) {
                              // Submit
                              final authState =
                                  context.read<AuthBloc>().state;
                              final supervisorId =
                                  authState is Authenticated
                                      ? authState.user.id
                                      : '';
                              context.read<ChecklistBloc>().add(
                                    SubmitChecklist(
                                      supervisorId: supervisorId,
                                      mineName: widget.mineName,
                                      mineType: widget.mineType,
                                      area: widget.area,
                                      shift: widget.shift,
                                      inspectionType: widget.inspectionType,
                                    ),
                                  );
                            } else {
                              setState(() {
                                _currentSectionIndex++;
                              });
                            }
                          },
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2A47),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isSubmitting)
                          const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        else ...[
                          Text(
                            isLast ? 'SUBMIT' : 'SAVE & NEXT',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                          if (!isLast) ...[
                            const SizedBox(width: 8),
                            const Icon(Icons.arrow_forward,
                                size: 18),
                          ],
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
