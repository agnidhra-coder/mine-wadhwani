// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mine_wadhwani/core/theme/app_colors.dart';
// import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_checklist_page.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// @RoutePage()
// class StockpileOverviewPage extends StatefulWidget {
//   final String mineName;
//   final String mineType;
//   final String area;
//   final int shift;
//   final String inspectionType;

//   const StockpileOverviewPage({
//     super.key,
//     required this.mineName,
//     required this.mineType,
//     required this.area,
//     required this.shift,
//     required this.inspectionType,
//   });

//   @override
//   State<StockpileOverviewPage> createState() => _StockpileOverviewPageState();
// }

// class _StockpileOverviewPageState extends State<StockpileOverviewPage> {
//   final List<StockpileSection> _sections = StockpileData.sections;
//   final Map<String, String> _answers = {};
//   final Map<String, String> _comments = {};

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   static const _sectionIcons = [
//     Icons.info_outline,
//     Icons.terrain_outlined,
//     Icons.local_fire_department_outlined,
//     Icons.water_drop_outlined,
//   ];

//   static const _sectionColors = [
//     Color(0xFF2C3E6B),
//     Color(0xFFE8703A),
//     Color(0xFFFF5722),
//     Color(0xFF2196F3),
//   ];

//   int _answeredInSection(StockpileSection section) {
//     return section.questions
//         .where((q) => (_answers[q.code] ?? '').isNotEmpty)
//         .length;
//   }

//   int _totalAnswered() {
//     return _sections.fold(0, (sum, s) => sum + _answeredInSection(s));
//   }

//   int _totalQuestions() {
//     return _sections.fold(0, (sum, s) => sum + s.questions.length);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final totalAnswered = _totalAnswered();
//     final totalQuestions = _totalQuestions();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             Expanded(
//               child: SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildOverallProgress(totalAnswered, totalQuestions),
//                     const SizedBox(height: 28),
//                     Text(
//                       'CHECKLIST SECTIONS',
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: AppColors.secondary.withValues(alpha: 0.7),
//                         letterSpacing: 1.0,
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     ...List.generate(_sections.length, (index) {
//                       final section = _sections[index];
//                       final answered = _answeredInSection(section);
//                       final total = section.questions.length;
//                       return _buildSectionCard(
//                         context: context,
//                         index: index,
//                         section: section,
//                         answered: answered,
//                         total: total,
//                       );
//                     }),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       color: const Color(0xFF1F579C),
//       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Stockpile Inspection',
//                   style: AppTextStyles.headlineMedium.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.w800,
//                     fontSize: 26,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   'Select a section to begin inspection',
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     color: const Color(0xFFBDBDBD),
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           GestureDetector(
//             onTap: () => context.router.maybePop(),
//             child: Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF2C3E6B),
//                 borderRadius: BorderRadius.circular(22),
//               ),
//               child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildOverallProgress(int answered, int total) {
//     final progress = total > 0 ? answered / total : 0.0;

//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Column(
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'OVERALL INSPECTION PROGRESS',
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                   color: AppColors.secondary.withValues(alpha: 0.6),
//                   letterSpacing: 0.8,
//                 ),
//               ),
//               Text(
//                 '$answered / $total Completed',
//                 style: const TextStyle(
//                   fontSize: 15,
//                   fontWeight: FontWeight.w700,
//                   color: Color(0xFF2C3E6B),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(6),
//             child: LinearProgressIndicator(
//               value: progress,
//               backgroundColor: const Color(0xFFE8EAF0),
//               valueColor:
//                   const AlwaysStoppedAnimation<Color>(Color(0xFF2C3E6B)),
//               minHeight: 8,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionCard({
//     required BuildContext context,
//     required int index,
//     required StockpileSection section,
//     required int answered,
//     required int total,
//   }) {
//     final progress = total > 0 ? answered / total : 0.0;
//     final icon = _sectionIcons[index % _sectionIcons.length];
//     final iconColor = _sectionColors[index % _sectionColors.length];

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: GestureDetector(
//         onTap: () async {
//           final result = await Navigator.of(context).push<Map<String, String>>(
//             MaterialPageRoute(
//               builder: (_) => StockpileChecklistPage(
//                 sectionIndex: index,
//                 sections: _sections,
//                 answers: Map.from(_answers),
//                 comments: Map.from(_comments),
//                 mineName: widget.mineName,
//                 mineType: widget.mineType,
//                 area: widget.area,
//                 shift: widget.shift,
//                 inspectionType: widget.inspectionType,
//               ),
//             ),
//           );
//           if (result != null && mounted) {
//             setState(() {
//               for (final entry in result.entries) {
//                 if (entry.key.startsWith('a:')) {
//                   _answers[entry.key.substring(2)] = entry.value;
//                 } else if (entry.key.startsWith('c:')) {
//                   _comments[entry.key.substring(2)] = entry.value;
//                 }
//               }
//             });
//           }
//         },
//         child: Container(
//           padding: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: const Color(0xFFE0E3EA)),
//           ),
//           child: Row(
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: iconColor.withValues(alpha: 0.12),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(icon, color: iconColor, size: 22),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Section ${index + 1}: ${section.title}',
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 2),
//                     Text(
//                       '${section.questions.length} inspection points',
//                       style: TextStyle(
//                         fontSize: 13,
//                         color: AppColors.secondary.withValues(alpha: 0.7),
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Row(
//                       children: [
//                         Expanded(
//                           child: ClipRRect(
//                             borderRadius: BorderRadius.circular(4),
//                             child: LinearProgressIndicator(
//                               value: progress,
//                               backgroundColor: const Color(0xFFE8EAF0),
//                               valueColor:
//                                   AlwaysStoppedAnimation<Color>(iconColor),
//                               minHeight: 5,
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           '$answered / $total',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.secondary.withValues(alpha: 0.7),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Icon(
//                 Icons.chevron_right,
//                 color: AppColors.outline.withValues(alpha: 0.5),
//                 size: 24,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/di/injection_container.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_checklist_page.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

enum _OverviewMenuOption { saveDraft, exitInspection }

@RoutePage()
class StockpileOverviewPage extends StatefulWidget {
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;

  const StockpileOverviewPage({
    super.key,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
  });

  @override
  State<StockpileOverviewPage> createState() => _StockpileOverviewPageState();
}

class _StockpileOverviewPageState extends State<StockpileOverviewPage> {
  final List<StockpileSection> _sections = StockpileData.sections;
  final Map<String, String> _answers = {};
  final Map<String, String> _comments = {};

  /// Persisted media across section visits: code → list of image paths
  final Map<String, List<String>> _mediaFiles = {};

  static const _headerColor = Color(0xFF1F579C);

  @override
  void initState() {
    super.initState();
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

  static const _sectionIcons = [
    Icons.info_outline,
    Icons.terrain_outlined,
    Icons.local_fire_department_outlined,
    Icons.water_drop_outlined,
  ];

  static const _sectionColors = [
    Color(0xFF2C3E6B),
    Color(0xFFE8703A),
    Color(0xFFFF5722),
    Color(0xFF2196F3),
  ];

  int _answeredInSection(StockpileSection section) {
    return section.questions
        .where((q) => (_answers[q.code] ?? '').isNotEmpty)
        .length;
  }

  int _totalAnswered() =>
      _sections.fold(0, (sum, s) => sum + _answeredInSection(s));

  int _totalQuestions() =>
      _sections.fold(0, (sum, s) => sum + s.questions.length);

  void _handleMenuOption(_OverviewMenuOption option) {
    switch (option) {
      case _OverviewMenuOption.saveDraft:
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Draft saved')),
        );
        break;
      case _OverviewMenuOption.exitInspection:
        context.router.popUntilRoot();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalAnswered = _totalAnswered();
    final totalQuestions = _totalQuestions();

    return BlocProvider(
      create: (_) => sl<ChecklistBloc>(),
      child: BlocConsumer<ChecklistBloc, ChecklistState>(
        listener: (context, state) {
          if (state is ChecklistSubmitted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Stockpile Inspection Submitted!'),
                backgroundColor: Colors.green,
              ),
            );
            context.router.maybePop();
          } else if (state is ChecklistError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isSubmitting = state is ChecklistSubmitting;

          return Scaffold(
            backgroundColor: const Color(0xFFF5F7FA),
            extendBodyBehindAppBar: false,
            body: Column(
              children: [
                _buildHeader(context, totalAnswered, totalQuestions),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          'CHECKLIST SECTIONS',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondary.withValues(alpha: 0.7),
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...List.generate(_sections.length, (index) {
                          final section = _sections[index];
                          final answered = _answeredInSection(section);
                          final total = section.questions.length;
                          return _buildSectionCard(
                            context: context,
                            index: index,
                            section: section,
                            answered: answered,
                            total: total,
                          );
                        }),
                        const SizedBox(height: 24),
                        if (totalAnswered == totalQuestions)
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: isSubmitting
                                  ? null
                                  : () {
                                      _submitInspection(context);
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFF1E2A47),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isSubmitting
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'SUBMIT INSPECTION',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            ),
                          ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _submitInspection(BuildContext context) {
    // Map StockpileData into ChecklistModel so ChecklistBloc can submit it
    final checklistData = <ChecklistModel>[];

    for (final section in _sections) {
      for (final q in section.questions) {
        checklistData.add(ChecklistModel(
          mainTopic: section.title,
          subTopic: '',
          questionCode: q.code,
          questionText: q.text,
          answer: _answers[q.code] ?? '',
          imageUrls: _mediaFiles[q.code] ?? [],
        ));
      }
    }

    final authState = context.read<AuthBloc>().state;
    final supervisorId =
        authState is Authenticated ? authState.user.id : '';

    // First load the generated checklist into the Bloc
    context.read<ChecklistBloc>().add(SetCustomChecklistData(checklistData));

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
  }

  Widget _buildHeader(BuildContext context, int answered, int total) {
    final progress = total > 0 ? answered / total : 0.0;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      color: _headerColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: statusBarHeight),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context.router.maybePop(),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Stockpile Inspection',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Select a section to begin inspection',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_OverviewMenuOption>(
                  onSelected: _handleMenuOption,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  icon: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(Icons.more_vert,
                        color: Colors.white, size: 22),
                  ),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: _OverviewMenuOption.saveDraft,
                      child: Row(
                        children: const [
                          Icon(Icons.save_outlined,
                              size: 20, color: Color(0xFF2C3E6B)),
                          SizedBox(width: 12),
                          Text('Save Draft'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: _OverviewMenuOption.exitInspection,
                      child: Row(
                        children: const [
                          Icon(Icons.exit_to_app_outlined,
                              size: 20, color: Color(0xFFD32F2F)),
                          SizedBox(width: 12),
                          Text(
                            'Exit Inspection',
                            style: TextStyle(color: Color(0xFFD32F2F)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OVERALL PROGRESS',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 0.9,
                      ),
                    ),
                    Text(
                      '$answered / $total Completed',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white.withValues(alpha: 0.25),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 7,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required BuildContext context,
    required int index,
    required StockpileSection section,
    required int answered,
    required int total,
  }) {
    final progress = total > 0 ? answered / total : 0.0;
    final icon = _sectionIcons[index % _sectionIcons.length];
    final iconColor = _sectionColors[index % _sectionColors.length];

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).push<Map<String, String>>(
            MaterialPageRoute(
              builder: (_) => StockpileChecklistPage(
                sectionIndex: index,
                sections: _sections,
                answers: Map.from(_answers),
                comments: Map.from(_comments),
                // Pass a deep copy of media so checklist starts with existing photos
                mediaFiles: Map.fromEntries(
                  _mediaFiles.entries.map(
                    (e) => MapEntry(e.key, List<String>.from(e.value)),
                  ),
                ),
                mineName: widget.mineName,
                mineType: widget.mineType,
                area: widget.area,
                shift: widget.shift,
                inspectionType: widget.inspectionType,
              ),
            ),
          );

          if (result != null && mounted) {
            setState(() {
              for (final entry in result.entries) {
                if (entry.key.startsWith('a:')) {
                  // answers
                  _answers[entry.key.substring(2)] = entry.value;
                } else if (entry.key.startsWith('c:')) {
                  // comments
                  _comments[entry.key.substring(2)] = entry.value;
                } else if (entry.key.startsWith('m:')) {
                  // media — stored as pipe-separated paths
                  final code = entry.key.substring(2);
                  if (entry.value.isEmpty) {
                    _mediaFiles.remove(code);
                  } else {
                    _mediaFiles[code] = entry.value.split('||');
                  }
                }
              }
            });
          }
        },
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0E3EA)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Section ${index + 1}: ${section.title}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${section.questions.length} inspection points',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.secondary.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: progress,
                              backgroundColor: const Color(0xFFE8EAF0),
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(iconColor),
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
                            color: AppColors.secondary.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
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
}