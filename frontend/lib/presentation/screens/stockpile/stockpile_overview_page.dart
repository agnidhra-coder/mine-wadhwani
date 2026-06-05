// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mine_wadhwani/core/di/injection_container.dart';
// import 'package:mine_wadhwani/core/theme/app_colors.dart';
// import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
// import 'package:mine_wadhwani/data/models/checklist/checklist_model.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';
// import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_bloc.dart';
// import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_event.dart';
// import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_state.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_checklist_page.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_compliance_page.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// enum _OverviewMenuOption { saveDraft, exitInspection }

// @RoutePage()
// class StockpileOverviewPage extends StatefulWidget {
//   final String mineName;
//   final String mineType;
//   final String area;
//   final int shift;
//   final String inspectionType;
//   final String company;

//   const StockpileOverviewPage({
//     super.key,
//     required this.mineName,
//     required this.mineType,
//     required this.area,
//     required this.shift,
//     required this.inspectionType,
//     required this.company,
//   });

//   @override
//   State<StockpileOverviewPage> createState() => _StockpileOverviewPageState();
// }

// class _StockpileOverviewPageState extends State<StockpileOverviewPage> {
//   final List<StockpileSection> _sections = StockpileData.sections;
//   final Map<String, String> _answers = {};
//   final Map<String, String> _comments = {};
//   final Map<String, List<String>> _mediaFiles = {};
//   final Map<String, String> _actions = {};

//   static const _headerColor = Color(0xFF1F579C);

//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: _headerColor,
//       statusBarIconBrightness: Brightness.light,
//       statusBarBrightness: Brightness.dark,
//     ));
//   }

//   @override
//   void dispose() {
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//     ));
//     super.dispose();
//   }

//   static const _sectionIcons = [
//     Icons.assignment_outlined,
//     Icons.terrain_outlined,
//     Icons.local_fire_department_outlined,
//     Icons.lock_outlined,
//     Icons.add_road_outlined,
//     Icons.water_drop_outlined,
//     Icons.task_outlined,
//     Icons.health_and_safety_outlined,
//     Icons.construction_outlined,
//   ];

//   static const _sectionColors = [
//     Color(0xFF002F8E),
//     Color(0xFF545353),
//     Color(0xFFE70303),
//     Color(0xFFFF5900),
//     Color(0xFFBCA000),
//     Color(0xFF1565C0),
//     Color(0xFF007B25),
//     Color(0xFF4527A0),
//     Color(0xFF6D4C41),
//   ];

//   int _answeredInSection(StockpileSection section) {
//     return section.questions
//         .where((q) => (_answers[q.code] ?? '').isNotEmpty)
//         .length;
//   }

//   int _totalAnswered() =>
//       _sections.fold(0, (sum, s) => sum + _answeredInSection(s));

//   int _totalQuestions() =>
//       _sections.fold(0, (sum, s) => sum + s.questions.length);

//   bool get _hasAnyAnswer => _answers.values.any((v) => v.isNotEmpty);

//   void _handleMenuOption(_OverviewMenuOption option) {
//     switch (option) {
//       case _OverviewMenuOption.saveDraft:
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Draft saved')),
//         );
//         break;
//       case _OverviewMenuOption.exitInspection:
//         context.router.popUntilRoot();
//         break;
//     }
//   }

//   void _saveDraft(BuildContext context) {
//     final checklistData = <ChecklistModel>[];

//     for (final section in _sections) {
//       for (final q in section.questions) {
//         checklistData.add(ChecklistModel(
//           mainTopic: section.title,
//           subTopic: '',
//           questionCode: q.code,
//           questionText: q.text,
//           answer: _answers[q.code] ?? '',
//           comment: _comments[q.code] ?? '',
//           imageUrls: _mediaFiles[q.code] ?? [],
//           action: _actions[q.code] ?? '',
//         ));
//       }
//     }

//     final authState = context.read<AuthBloc>().state;
//     final supervisorId =
//         authState is Authenticated ? authState.user.id : '';

//     context.read<ChecklistBloc>().add(SetCustomChecklistData(checklistData));

//     context.read<ChecklistBloc>().add(
//           SubmitChecklist(
//             supervisorId: supervisorId,
//             mineName: widget.mineName,
//             mineType: widget.mineType,
//             area: widget.area,
//             shift: widget.shift,
//             inspectionType: widget.inspectionType,
//             completed: false,
//           ),
//         );
//   }

//   // ─── Shared section push/pop logic ────────────────────────────────────────
//   //
//   // All navigation to StockpileChecklistPage goes through this method.
//   // After the checklist page pops, we:
//   //   1. Apply all returned data (answers, comments, media, actions) to state.
//   //   2. Check for the optional '__next__' key — if present, auto-open the
//   //      next section (set by SAVE & NEXT), saving and advancing in one go.

//   Future<void> _openSection(int index) async {
//     if (index < 0 || index >= _sections.length) return;

//     final result = await Navigator.of(context).push<Map<String, String>>(
//       MaterialPageRoute(
//         builder: (_) => StockpileChecklistPage(
//           sectionIndex: index,
//           sections: _sections,
//           answers: Map.from(_answers),
//           comments: Map.from(_comments),
//           mediaFiles: Map.fromEntries(
//             _mediaFiles.entries
//                 .map((e) => MapEntry(e.key, List<String>.from(e.value))),
//           ),
//           actions: Map.from(_actions),
//           mineName: widget.mineName,
//           mineType: widget.mineType,
//           area: widget.area,
//           shift: widget.shift,
//           inspectionType: widget.inspectionType,
//         ),
//       ),
//     );

//     if (result == null || !mounted) return;

//     // ── Apply returned data ─────────────────────────────────────────────────
//     setState(() {
//       for (final entry in result.entries) {
//         if (entry.key == '__next__') continue; // handled below

//         if (entry.key.startsWith('a:')) {
//           _answers[entry.key.substring(2)] = entry.value;
//         } else if (entry.key.startsWith('c:')) {
//           _comments[entry.key.substring(2)] = entry.value;
//         } else if (entry.key.startsWith('m:')) {
//           final code = entry.key.substring(2);
//           if (entry.value.isEmpty) {
//             _mediaFiles.remove(code);
//           } else {
//             _mediaFiles[code] = entry.value.split('||');
//           }
//         } else if (entry.key.startsWith('act:')) {
//           final code = entry.key.substring(4);
//           if (entry.value.isEmpty) {
//             _actions.remove(code);
//           } else {
//             _actions[code] = entry.value;
//           }
//         }
//       }
//     });

//     // ── Auto-open next section if SAVE & NEXT was pressed ──────────────────
//     final nextStr = result['__next__'];
//     if (nextStr != null && mounted) {
//       final nextIndex = int.tryParse(nextStr);
//       if (nextIndex != null && nextIndex < _sections.length) {
//         // Defer until after the current frame so setState above completes and
//         // the overview's progress bar re-renders before we push again.
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (mounted) _openSection(nextIndex);
//         });
//       }
//     }
//   }

//   // ─────────────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final totalAnswered = _totalAnswered();
//     final totalQuestions = _totalQuestions();

//     return BlocProvider(
//       create: (_) => sl<ChecklistBloc>(),
//       child: BlocConsumer<ChecklistBloc, ChecklistState>(
//         listener: (context, state) {
//           if (state is ChecklistSubmitted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Draft saved successfully!'),
//                 backgroundColor: Colors.green,
//               ),
//             );
//           } else if (state is ChecklistError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: AppColors.error,
//               ),
//             );
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: const Color(0xFFF5F7FA),
//             extendBodyBehindAppBar: false,
//             bottomNavigationBar: _buildStickyFooter(context),
//             body: Column(
//               children: [
//                 _buildHeader(context, totalAnswered, totalQuestions),
//                 Expanded(
//                   child: SingleChildScrollView(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 32, vertical: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text(
//                           'CHECKLIST SECTIONS',
//                           style: TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w700,
//                             color: AppColors.secondary.withValues(alpha: 0.7),
//                             letterSpacing: 1.0,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         ...List.generate(_sections.length, (index) {
//                           final section = _sections[index];
//                           final answered = _answeredInSection(section);
//                           final total = section.questions.length;
//                           return _buildSectionCard(
//                             context: context,
//                             index: index,
//                             section: section,
//                             answered: answered,
//                             total: total,
//                           );
//                         }),
//                         const SizedBox(height: 40),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, int answered, int total) {
//     final progress = total > 0 ? answered / total : 0.0;
//     final statusBarHeight = MediaQuery.of(context).padding.top;

//     return Container(
//       color: _headerColor,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: statusBarHeight),
//           Padding(
//             padding:
//                 const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () => context.router.maybePop(),
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(Icons.arrow_back,
//                         color: Colors.white, size: 20),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Stockpile Inspection Checklist',
//                         style: AppTextStyles.headlineMedium.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w800,
//                           fontSize: 22,
//                         ),
//                       ),
//                       const SizedBox(height: 2),
//                       BlocBuilder<AuthBloc, AuthState>(
//                         builder: (context, state) {
//                           final user =
//                               state is Authenticated ? state.user : null;
//                           return Text(
//                             user != null
//                                 ? 'Inspected by: ${user.name}  •  ${user.role}'
//                                 : 'Select a section to begin inspection',
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               color: Colors.white.withValues(alpha: 0.75),
//                               fontSize: 13,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 PopupMenuButton<_OverviewMenuOption>(
//                   onSelected: _handleMenuOption,
//                   color: Colors.white,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   icon: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(Icons.more_vert,
//                         color: Colors.white, size: 22),
//                   ),
//                   itemBuilder: (_) => [
//                     PopupMenuItem(
//                       value: _OverviewMenuOption.exitInspection,
//                       child: Row(
//                         children: const [
//                           Icon(Icons.exit_to_app_outlined,
//                               size: 20, color: Color(0xFFD32F2F)),
//                           SizedBox(width: 12),
//                           Text(
//                             'Exit Inspection',
//                             style: TextStyle(color: Color(0xFFD32F2F)),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'OVERALL PROGRESS',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white.withValues(alpha: 0.7),
//                         letterSpacing: 0.9,
//                       ),
//                     ),
//                     Text(
//                       '$answered / $total Completed',
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: LinearProgressIndicator(
//                     value: progress,
//                     backgroundColor: Colors.white.withValues(alpha: 0.25),
//                     valueColor:
//                         const AlwaysStoppedAnimation<Color>(Colors.white),
//                     minHeight: 7,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStickyFooter(BuildContext context) {
//     final enabled = _hasAnyAnswer;

//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
//       child: SafeArea(
//         top: false,
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Divider(
//               color: Color(0xFFE0E3EA),
//               height: 1,
//               thickness: 1,
//             ),
//             const SizedBox(height: 14),
//             Row(
//               children: [
//                 // Save Draft
//                 Expanded(
//                   child: SizedBox(
//                     height: 50,
//                     child: OutlinedButton.icon(
//                       onPressed: enabled
//                           ? () => _saveDraft(context)
//                           : null,
//                       icon: Icon(
//                         Icons.save_outlined,
//                         size: 18,
//                         color: enabled
//                             ? _headerColor
//                             : const Color(0xFFBDBDBD),
//                       ),
//                       label: Text(
//                         'Save Draft',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.3,
//                           color: enabled
//                               ? _headerColor
//                               : const Color(0xFFBDBDBD),
//                         ),
//                       ),
//                       style: OutlinedButton.styleFrom(
//                         side: BorderSide(
//                           color: enabled
//                               ? _headerColor
//                               : const Color(0xFFE0E3EA),
//                           width: 1.5,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                         backgroundColor: enabled
//                             ? _headerColor.withValues(alpha: 0.05)
//                             : const Color(0xFFF5F7FA),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 // Complete Inspection
//                 Expanded(
//                   child: SizedBox(
//                     height: 50,
//                     child: FilledButton.icon(
//                       onPressed: enabled
//                           ? () {
//                               final authState =
//                                   context.read<AuthBloc>().state;
//                               final user = authState is Authenticated
//                                   ? authState.user
//                                   : null;
//                               Navigator.of(context).push(
//                                 MaterialPageRoute(
//                                   builder: (_) => StockpileCompliancePage(
//                                     company: widget.company,
//                                     mineName: widget.mineName,
//                                     mineType: widget.mineType,
//                                     area: widget.area,
//                                     shift: widget.shift,
//                                     inspectionType: widget.inspectionType,
//                                     sections: _sections,
//                                     answers: Map.from(_answers),
//                                     comments: Map.from(_comments),
//                                     mediaFiles: Map.fromEntries(
//                                       _mediaFiles.entries.map(
//                                         (e) => MapEntry(
//                                             e.key,
//                                             List<String>.from(e.value)),
//                                       ),
//                                     ),
//                                     actions: Map.from(_actions),
//                                     inspectorName: user?.name ?? '',
//                                     inspectorRole: user?.role ?? '',
//                                   ),
//                                 ),
//                               );
//                             }
//                           : null,
//                       icon: const Icon(Icons.check_circle_outline, size: 18),
//                       label: const Text(
//                         'Complete Inspection',
//                         style: TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w700,
//                           letterSpacing: 0.3,
//                         ),
//                       ),
//                       style: FilledButton.styleFrom(
//                         backgroundColor: enabled
//                             ? _headerColor
//                             : const Color(0xFFE0E3EA),
//                         foregroundColor: enabled
//                             ? Colors.white
//                             : const Color(0xFFBDBDBD),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
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
//         // All section navigation goes through _openSection, which handles
//         // both normal back-navigation and SAVE & NEXT auto-advance.
//         onTap: () => _openSection(index),
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
//                             color:
//                                 AppColors.secondary.withValues(alpha: 0.7),
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
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/data/models/draft/inspection_draft_model.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:mine_wadhwani/presentation/bloc/draft_bloc/draft_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/draft_bloc/draft_event.dart';
import 'package:mine_wadhwani/presentation/bloc/draft_bloc/draft_state.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_checklist_page.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_compliance_page.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

enum _OverviewMenuOption { exitInspection }

@RoutePage()
class StockpileOverviewPage extends StatefulWidget {
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;
  final String company;

  /// Non-null when this page was opened by resuming a saved draft.
  /// Used to overwrite the same draft (not create a new one) on re-save,
  /// and to delete it from storage after a successful final submission.
  final String? draftId;
  final InspectionDraft? draft;

  const StockpileOverviewPage({
    super.key,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
    required this.company,
    this.draftId,
    this.draft,
  });

  @override
  State<StockpileOverviewPage> createState() => _StockpileOverviewPageState();
}

class _StockpileOverviewPageState extends State<StockpileOverviewPage> {
  final List<StockpileSection> _sections = StockpileData.sections;
  final Map<String, String> _answers = {};
  final Map<String, String> _comments = {};
  final Map<String, List<String>> _mediaFiles = {};
  final Map<String, String> _actions = {};

  /// Stable draft ID — reused on every "Save Draft" press so that we
  /// overwrite the same record instead of creating duplicates.
  late final String _draftId;

  static const _headerColor = Color(0xFF1F579C);

  @override
  void initState() {
    super.initState();

    // Re-use the incoming draft id or mint a fresh one.
    _draftId = widget.draftId ??
        '${widget.mineName}_${widget.area}_${widget.shift}_${DateTime.now().millisecondsSinceEpoch}';

    if (widget.draft != null) {
      for (final ans in widget.draft!.answers) {
        final code = ans['code'] as String? ?? '';
        if (code.isNotEmpty) {
          _answers[code] = ans['answer'] as String? ?? '';
          _comments[code] = ans['comment'] as String? ?? '';
          _actions[code] = ans['action'] as String? ?? '';
          final media = ans['media'] as String? ?? '';
          if (media.isNotEmpty) {
            _mediaFiles[code] = media.split('||');
          }
        }
      }
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
    Icons.assignment_outlined,
    Icons.terrain_outlined,
    Icons.local_fire_department_outlined,
    Icons.lock_outlined,
    Icons.add_road_outlined,
    Icons.water_drop_outlined,
    Icons.task_outlined,
    Icons.health_and_safety_outlined,
    Icons.construction_outlined,
  ];

  static const _sectionColors = [
    Color(0xFF002F8E),
    Color(0xFF545353),
    Color(0xFFE70303),
    Color(0xFFFF5900),
    Color(0xFFBCA000),
    Color(0xFF1565C0),
    Color(0xFF007B25),
    Color(0xFF4527A0),
    Color(0xFF6D4C41),
  ];

  // ─── Helpers ──────────────────────────────────────────────────────────────

  int _answeredInSection(StockpileSection section) =>
      section.questions
          .where((q) => (_answers[q.code] ?? '').isNotEmpty)
          .length;

  int _totalAnswered() =>
      _sections.fold(0, (sum, s) => sum + _answeredInSection(s));

  int _totalQuestions() =>
      _sections.fold(0, (sum, s) => sum + s.questions.length);

  bool get _hasAnyAnswer => _answers.values.any((v) => v.isNotEmpty);

  // ─── Menu ─────────────────────────────────────────────────────────────────

  void _handleMenuOption(_OverviewMenuOption option) {
    switch (option) {
      case _OverviewMenuOption.exitInspection:
        context.router.popUntilRoot();
        break;
    }
  }

  // ─── Save Draft ───────────────────────────────────────────────────────────
  //
  // Builds an InspectionDraft from the current in-memory state and hands it
  // to DraftBloc. The bloc persists it to SharedPreferences and emits
  // DraftSaved, which our BlocListener catches to show the snackbar.

  void _saveDraft(BuildContext context) {
    final totalAnswered = _totalAnswered();
    final totalQuestions = _totalQuestions();

    // Flatten all question answers into the generic answers list.
    final answers = <Map<String, dynamic>>[];
    for (final section in _sections) {
      for (final q in section.questions) {
        answers.add({
          'code': q.code,
          'answer': _answers[q.code] ?? '',
          'comment': _comments[q.code] ?? '',
          'action': _actions[q.code] ?? '',
          'media': (_mediaFiles[q.code] ?? []).join('||'),
          'section': section.title,
        });
      }
    }

    final draft = InspectionDraft(
      id: _draftId,
      mineName: widget.mineName,
      mineType: widget.mineType,
      area: widget.area,
      shift: widget.shift,
      inspectionType: widget.inspectionType,
      savedAt: DateTime.now(),
      answeredCount: totalAnswered,
      totalCount: totalQuestions,
      answers: answers,
    );

    // DraftBloc is provided above this widget in the tree (via HomePage or
    // the route that opens StockpileOverviewPage). Using sl<> as fallback.
    final draftBloc = context.read<DraftBloc>();
    draftBloc.add(SaveDraft(draft));
  }

  // ─── Complete Inspection ──────────────────────────────────────────────────
  //
  // After the inspector submits the final report we delete the local draft so
  // it no longer appears in "Pending Inspections".

  void _onCompleteInspection(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState is Authenticated ? authState.user : null;

    Navigator.of(context)
        .push<bool>(
      MaterialPageRoute(
        builder: (_) => StockpileCompliancePage(
          company: widget.company,
          mineName: widget.mineName,
          mineType: widget.mineType,
          area: widget.area,
          shift: widget.shift,
          inspectionType: widget.inspectionType,
          sections: _sections,
          answers: Map.from(_answers),
          comments: Map.from(_comments),
          mediaFiles: Map.fromEntries(
            _mediaFiles.entries
                .map((e) => MapEntry(e.key, List<String>.from(e.value))),
          ),
          actions: Map.from(_actions),
          inspectorName: user?.name ?? '',
          inspectorRole: user?.role ?? '',
        ),
      ),
    )
        .then((submitted) {
      // StockpileCompliancePage should pop with `true` on successful submit.
      if (submitted == true && mounted) {
        context.read<DraftBloc>().add(DeleteDraft(_draftId));
      }
    });
  }

  // ─── Section navigation ───────────────────────────────────────────────────

  Future<void> _openSection(int index) async {
    if (index < 0 || index >= _sections.length) return;

    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (_) => StockpileChecklistPage(
          sectionIndex: index,
          sections: _sections,
          answers: Map.from(_answers),
          comments: Map.from(_comments),
          mediaFiles: Map.fromEntries(
            _mediaFiles.entries
                .map((e) => MapEntry(e.key, List<String>.from(e.value))),
          ),
          actions: Map.from(_actions),
          mineName: widget.mineName,
          mineType: widget.mineType,
          area: widget.area,
          shift: widget.shift,
          inspectionType: widget.inspectionType,
        ),
      ),
    );

    if (result == null || !mounted) return;

    setState(() {
      for (final entry in result.entries) {
        if (entry.key == '__next__') continue;

        if (entry.key.startsWith('a:')) {
          _answers[entry.key.substring(2)] = entry.value;
        } else if (entry.key.startsWith('c:')) {
          _comments[entry.key.substring(2)] = entry.value;
        } else if (entry.key.startsWith('m:')) {
          final code = entry.key.substring(2);
          if (entry.value.isEmpty) {
            _mediaFiles.remove(code);
          } else {
            _mediaFiles[code] = entry.value.split('||');
          }
        } else if (entry.key.startsWith('act:')) {
          final code = entry.key.substring(4);
          if (entry.value.isEmpty) {
            _actions.remove(code);
          } else {
            _actions[code] = entry.value;
          }
        }
      }
    });

    final nextStr = result['__next__'];
    if (nextStr != null && mounted) {
      final nextIndex = int.tryParse(nextStr);
      if (nextIndex != null && nextIndex < _sections.length) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _openSection(nextIndex);
        });
      }
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final totalAnswered = _totalAnswered();
    final totalQuestions = _totalQuestions();

    // BlocListener watches DraftBloc for save/error feedback.
    return BlocListener<DraftBloc, DraftState>(
      listener: (context, state) {
        if (state is DraftSaved) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Draft saved — find it under Pending Inspections'),
              backgroundColor: Color(0xFF3DAA6E),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is DraftError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save draft: ${state.message}'),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        extendBodyBehindAppBar: false,
        bottomNavigationBar: _buildStickyFooter(context),
        body: Column(
          children: [
            _buildHeader(context, totalAnswered, totalQuestions),
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
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
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

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
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                        'Stockpile Inspection Checklist',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, authState) {
                          final user = authState is Authenticated
                              ? authState.user
                              : null;
                          return Text(
                            user != null
                                ? 'Inspected by: ${user.name}  •  ${user.role}'
                                : 'Select a section to begin inspection',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 13,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<_OverviewMenuOption>(
                  onSelected: _handleMenuOption,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                      value: _OverviewMenuOption.exitInspection,
                      child: Row(
                        children: const [
                          Icon(Icons.exit_to_app_outlined,
                              size: 20, color: Color(0xFFD32F2F)),
                          SizedBox(width: 12),
                          Text('Exit Inspection',
                              style: TextStyle(color: Color(0xFFD32F2F))),
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

  // ─── Sticky footer ────────────────────────────────────────────────────────

  Widget _buildStickyFooter(BuildContext context) {
    final enabled = _hasAnyAnswer;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Color(0xFFE0E3EA), height: 1, thickness: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                // ── Save Draft ──────────────────────────────────────────────
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: enabled ? () => _saveDraft(context) : null,
                      icon: Icon(
                        Icons.save_outlined,
                        size: 18,
                        color: enabled ? _headerColor : const Color(0xFFBDBDBD),
                      ),
                      label: Text(
                        'Save Draft',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                          color:
                              enabled ? _headerColor : const Color(0xFFBDBDBD),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(
                          color: enabled
                              ? _headerColor
                              : const Color(0xFFE0E3EA),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        backgroundColor: enabled
                            ? _headerColor.withValues(alpha: 0.05)
                            : const Color(0xFFF5F7FA),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // ── Complete Inspection ─────────────────────────────────────
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: enabled
                          ? () => _onCompleteInspection(context)
                          : null,
                      icon: const Icon(Icons.check_circle_outline, size: 18),
                      label: const Text(
                        'Complete Inspection',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            enabled ? _headerColor : const Color(0xFFE0E3EA),
                        foregroundColor:
                            enabled ? Colors.white : const Color(0xFFBDBDBD),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── Section card ─────────────────────────────────────────────────────────

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
        onTap: () => _openSection(index),
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
                            color:
                                AppColors.secondary.withValues(alpha: 0.7),
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