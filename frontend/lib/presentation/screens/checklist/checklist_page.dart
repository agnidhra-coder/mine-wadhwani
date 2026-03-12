import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/di/injection_container.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';

@RoutePage()
class ChecklistPage extends StatefulWidget {
  const ChecklistPage({super.key});

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  int _selectedTopicIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChecklistBloc>()..add(const FetchChecklist()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Compliance Checklist'),
          scrolledUnderElevation: 0,
        ),
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
              debugPrint('Checklist error: ${state.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Something went wrong. Please try again.'),
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

            final topics = _getUniqueTopics(questions);
            if (topics.isEmpty) {
              return const Center(child: Text('No questions found.'));
            }

            if (_selectedTopicIndex >= topics.length) {
              _selectedTopicIndex = 0;
            }

            final selectedTopic = topics[_selectedTopicIndex];
            final topicQuestions = questions
                .where((q) => q.mainTopic == selectedTopic)
                .toList();

            return Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      _buildTopicsSidebar(topics, context),
                      const VerticalDivider(width: 1, thickness: 1),
                      Expanded(
                        child: _buildQuestionsPanel(
                            topicQuestions, selectedTopic, context),
                      ),
                    ],
                  ),
                ),
                _buildBottomBar(context, state, questions),
              ],
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

  List<String> _getUniqueTopics(List<ChecklistModel> questions) {
    final seen = <String>{};
    final topics = <String>[];
    for (final q in questions) {
      if (seen.add(q.mainTopic)) {
        topics.add(q.mainTopic);
      }
    }
    return topics;
  }

  Widget _buildTopicsSidebar(List<String> topics, BuildContext context) {
    return SizedBox(
      width: 250,
      child: Container(
        color: AppColors.background,
        child: ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            final isSelected = index == _selectedTopicIndex;
            return InkWell(
              onTap: () => setState(() => _selectedTopicIndex = index),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  border: Border(
                    bottom: BorderSide(
                      color: AppColors.outline.withValues(alpha: 0.2),
                    ),
                  ),
                ),
                child: Text(
                  topics[index],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildQuestionsPanel(
    List<ChecklistModel> questions,
    String topic,
    BuildContext context,
  ) {
    // Group by sub-topic preserving order
    final subTopics = <String>[];
    final subTopicQuestions = <String, List<ChecklistModel>>{};
    for (final q in questions) {
      if (!subTopicQuestions.containsKey(q.subTopic)) {
        subTopics.add(q.subTopic);
        subTopicQuestions[q.subTopic] = [];
      }
      subTopicQuestions[q.subTopic]!.add(q);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subTopics.length,
      itemBuilder: (context, index) {
        final subTopic = subTopics[index];
        final subQuestions = subTopicQuestions[subTopic]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subTopic.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: Text(
                  subTopic,
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ...subQuestions.map(
              (q) => _buildQuestionCard(q, context),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildQuestionCard(ChecklistModel question, BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1,
      child: ExpansionTile(
        shape: const Border(),
        collapsedShape: const Border(),
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                question.questionCode,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                question.questionText,
                style: AppTextStyles.bodyMedium,
              ),
            ),
            if (question.answer.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: _buildAnswerBadge(question.answer),
              ),
          ],
        ),
        children: [
          _buildAnswerSelector(question, context),
          const SizedBox(height: 12),
          _buildCommentField(question, context),
        ],
      ),
    );
  }

  Widget _buildAnswerBadge(String answer) {
    final color = switch (answer) {
      'YES' => Colors.green,
      'NO' => Colors.red,
      'NA' => Colors.grey,
      _ => Colors.grey,
    };
    final displayLabel = answer == 'NA' ? 'N/A' : answer;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        displayLabel,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildAnswerSelector(
      ChecklistModel question, BuildContext context) {
    return Row(
      children: [
        const Text('Answer: ', style: AppTextStyles.bodyMedium),
        const SizedBox(width: 12),
        ...['YES', 'NO', 'NA'].map((option) {
          final isSelected = question.answer == option;
          final color = switch (option) {
            'YES' => Colors.green,
            'NO' => Colors.red,
            'NA' => Colors.grey,
            _ => Colors.grey,
          };
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(option == 'NA' ? 'N/A' : option),
              selected: isSelected,
              selectedColor: color.withValues(alpha: 0.2),
              side: BorderSide(
                color: isSelected ? color : AppColors.outline,
              ),
              labelStyle: TextStyle(
                color: isSelected ? color : AppColors.onSurface,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              onSelected: (_) {
                context.read<ChecklistBloc>().add(
                      UpdateAnswer(
                        questionCode: question.questionCode,
                        answer: isSelected ? '' : option,
                      ),
                    );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCommentField(
      ChecklistModel question, BuildContext context) {
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Comment (optional)',
        border: OutlineInputBorder(),
        isDense: true,
      ),
      controller: TextEditingController(text: question.comment),
      onChanged: (value) {
        context.read<ChecklistBloc>().add(
              UpdateComment(
                questionCode: question.questionCode,
                comment: value,
              ),
            );
      },
      maxLines: 2,
    );
  }

  Widget _buildBottomBar(
    BuildContext context,
    ChecklistState state,
    List<ChecklistModel> questions,
  ) {
    final isSubmitting = state is ChecklistSubmitting;
    final answeredCount = questions.where((q) => q.answer.isNotEmpty).length;
    final totalCount = questions.length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            '$answeredCount / $totalCount answered',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondary,
            ),
          ),
          const Spacer(),
          FilledButton.icon(
            onPressed: isSubmitting
                ? null
                : () {
                    final authState = context.read<AuthBloc>().state;
                    final supervisorId = authState is Authenticated
                        ? authState.user.id
                        : '';
                    context.read<ChecklistBloc>().add(
                          SubmitChecklist(supervisorId: supervisorId),
                        );
                  },
            icon: isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send),
            label: Text(isSubmitting ? 'Submitting...' : 'Submit'),
          ),
        ],
      ),
    );
  }
}
