import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/di/injection_container.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';

@RoutePage()
class ChecklistOverviewPage extends StatefulWidget {
  const ChecklistOverviewPage({super.key});

  @override
  State<ChecklistOverviewPage> createState() => _ChecklistOverviewPageState();
}

class _ChecklistOverviewPageState extends State<ChecklistOverviewPage> {
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
    super.dispose();
  }

  static const _sectionIcons = [
    Icons.description_outlined,
    Icons.gavel_outlined,
    Icons.assessment_outlined,
    Icons.checklist_outlined,
    Icons.shield_outlined,
    Icons.engineering_outlined,
    Icons.local_fire_department_outlined,
    Icons.health_and_safety_outlined,
  ];

  static const _sectionColors = [
    Color(0xFF2C3E6B),
    Color(0xFFE8703A),
    Color(0xFFE8703A),
    Color(0xFF2C3E6B),
    Color(0xFF4CAF50),
    Color(0xFF9C27B0),
    Color(0xFFFF5722),
    Color(0xFF00BCD4),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChecklistBloc>()..add(const FetchChecklist()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: BlocBuilder<ChecklistBloc, ChecklistState>(
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

            final totalAnswered =
                questions.where((q) => q.answer.isNotEmpty).length;
            final totalQuestions = questions.length;

            return SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),
                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Overall progress card
                          _buildOverallProgress(
                              totalAnswered, totalQuestions),
                          const SizedBox(height: 28),
                          // Section heading
                          Text(
                            'CHECKLIST SECTIONS',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary
                                  .withValues(alpha: 0.7),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Section cards
                          ...List.generate(sections.length, (index) {
                            final section = sections[index];
                            final sectionQuestions = questions
                                .where((q) => q.mainTopic == section)
                                .toList();
                            final answered = sectionQuestions
                                .where((q) => q.answer.isNotEmpty)
                                .length;
                            final total = sectionQuestions.length;
                            final firstSubTopic = sectionQuestions
                                .isNotEmpty
                                ? sectionQuestions.first.subTopic
                                : '';

                            return _buildSectionCard(
                              context: context,
                              index: index,
                              title: section,
                              subtitle: firstSubTopic,
                              answered: answered,
                              total: total,
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  // Bottom navigation bar
                  // _buildBottomBar(context),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFF1F579C),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Inspection Overview',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: const Color(0xFFFFFFFF),
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Select an area to begin inspection',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: const Color(0xFFBDBDBD),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.router.maybePop(),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFF2C3E6B),
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallProgress(int answered, int total) {
    final progress = total > 0 ? answered / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E3EA),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'OVERALL PROGRESS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary.withValues(alpha: 0.6),
                  letterSpacing: 0.8,
                ),
              ),
              Text(
                '$answered / $total Completed',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2C3E6B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE8EAF0),
              valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2C3E6B)),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required int index,
    required String title,
    required String subtitle,
    required int answered,
    required int total,
  }) {
    final progress = total > 0 ? answered / total : 0.0;
    final icon = _sectionIcons[index % _sectionIcons.length];
    final iconColor = _sectionColors[index % _sectionColors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          context.router.push(ChecklistRoute(initialSectionIndex: index));
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE0E3EA),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: iconColor,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              // Title + subtitle + progress
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Part ${index + 1}: $title',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.secondary
                              .withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: const Color(0xFFE8EAF0),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                iconColor,
                              ),
                              minHeight: 5,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$answered / $total',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Chevron
              Icon(
                Icons.chevron_right,
                color: AppColors.outline.withValues(alpha: 0.5),
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomBar(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.description_outlined, 'Audit', true),
          _buildNavItem(Icons.history, 'History', false),
          _buildNavItem(Icons.bar_chart, 'Insights', false),
          _buildNavItem(Icons.settings_outlined, 'Settings', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    final color = isActive
        ? const Color(0xFF2C3E6B)
        : AppColors.outline.withValues(alpha: 0.6);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            color: color,
          ),
        ),
      ],
    );
  }
}
