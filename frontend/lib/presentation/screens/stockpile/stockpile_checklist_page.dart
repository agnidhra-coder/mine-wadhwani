// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mine_wadhwani/core/theme/app_colors.dart';
// import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// // ignore_for_file: library_private_types_in_public_api

// class StockpileChecklistPage extends StatefulWidget {
//   final int sectionIndex;
//   final List<StockpileSection> sections;
//   final Map<String, String> answers;
//   final Map<String, String> comments;
//   final String mineName;
//   final String mineType;
//   final String area;
//   final int shift;
//   final String inspectionType;

//   const StockpileChecklistPage({
//     super.key,
//     required this.sectionIndex,
//     required this.sections,
//     required this.answers,
//     required this.comments,
//     required this.mineName,
//     required this.mineType,
//     required this.area,
//     required this.shift,
//     required this.inspectionType,
//   });

//   @override
//   State<StockpileChecklistPage> createState() => _StockpileChecklistPageState();
// }

// class _StockpileChecklistPageState extends State<StockpileChecklistPage> {
//   late int _currentSectionIndex;
//   late Map<String, String> _answers;
//   late Map<String, String> _comments;
//   final Set<String> _expandedNotes = <String>{};
//   final Map<String, TextEditingController> _controllers = {};

//     Color _getOptionColor(String option) {
//     switch (option) {
//       case 'YES':
//         return Color(0xFF10B981);
//       case 'NO':
//         return Color(0xFFEF4444);
//       case 'NA':
//         return Color(0xFF9CA3AF);
//       default:
//         return const Color(0xFF1F579C);
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _currentSectionIndex = widget.sectionIndex;
//     _answers = Map.from(widget.answers);
//     _comments = Map.from(widget.comments);
//     _expandedNotes.addAll(
//       _comments.entries
//           .where((entry) => entry.value.trim().isNotEmpty)
//           .map((entry) => entry.key),
//     );
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//   }

//   @override
//   void dispose() {
//     for (final c in _controllers.values) {
//       c.dispose();
//     }
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     super.dispose();
//   }

//   // For yes/no questions: keyed by 'c:code' → comment controller
//   // For text questions:   keyed by 'a:code' → answer controller
//   TextEditingController _controller(String code) {
//     return _controllers.putIfAbsent(
//       'c:$code',
//       () => TextEditingController(text: _comments[code] ?? ''),
//     );
//   }

//   TextEditingController _answerController(String code) {
//     return _controllers.putIfAbsent(
//       'a:$code',
//       () => TextEditingController(text: _answers[code] ?? ''),
//     );
//   }

//   void _popWithResult() {
//     final result = <String, String>{};
//     for (final entry in _answers.entries) {
//       result['a:${entry.key}'] = entry.value;
//     }
//     for (final entry in _comments.entries) {
//       result['c:${entry.key}'] = entry.value;
//     }
//     Navigator.of(context).pop(result);
//   }

//   StockpileSection get _currentSection =>
//       widget.sections[_currentSectionIndex];

//   int get _answered =>
//       _currentSection.questions
//           .where((q) => (_answers[q.code] ?? '').isNotEmpty)
//           .length;

//   @override
//   Widget build(BuildContext context) {
//     final total = _currentSection.questions.length;
//     final isFirst = _currentSectionIndex == 0;
//     final isLast = _currentSectionIndex == widget.sections.length - 1;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             _buildProgressBar(total),
//             Expanded(
//               child: _buildQuestions(context),
//             ),
//             _buildFooter(context, isFirst, isLast, total),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Container(
//       color: const Color(0xFF1F579C),
//       padding: const EdgeInsets.only(top: 12, bottom: 8, left: 8, right: 16),
//       child: Row(
//         children: [
//           IconButton(
//             icon: const Icon(Icons.chevron_left, size: 28),
//             onPressed: _popWithResult,
//             color: const Color.fromARGB(255, 255, 255, 255),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: const Color.fromARGB(255, 255, 254, 255).withValues(alpha: 0.3),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   'SECTION ${_currentSectionIndex + 1} OF ${widget.sections.length}',
//                   style: AppTextStyles.bodyMedium.copyWith(
//                     color: const Color.fromARGB(255, 255, 255, 255),
//                     fontSize: 13,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 Text(
//                   _currentSection.title,
//                   style: AppTextStyles.titleLarge.copyWith(
//                     fontWeight: FontWeight.w700,
//                     fontSize: 18,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 44),
//         ],
//       ),
//     );
//   }

//   Widget _buildProgressBar(int total) {
//     final progress = total > 0 ? _answered / total : 0.0;
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.only(bottom: 2),
//       child: LinearProgressIndicator(
//         value: progress,
//         backgroundColor: const Color(0xFFE8EAF0),
//         valueColor:
//             const AlwaysStoppedAnimation<Color>(Color(0xFF2C3E6B)),
//         minHeight: 4,
//       ),
//     );
//   }

//   Widget _buildQuestions(BuildContext context) {
//     final questions = _currentSection.questions;
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       itemCount: questions.length,
//       itemBuilder: (context, index) => _buildQuestionCard(questions[index]),
//     );
//   }

//   Widget _buildQuestionCard(StockpileQuestion question) {
//     if (question.type == StockpileQuestionType.text) {
//       return _buildTextInputCard(question);
//     }
//     return _buildYesNoCard(question);
//   }

//   Widget _buildTextInputCard(StockpileQuestion question) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: const Color(0xFF1F579C),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 question.code,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6, bottom: 12),
//                     child: Text(
//                       question.text,
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontSize: 15,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                   Container(
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF5F7FA),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(color: const Color(0xFFE0E3EA)),
//                     ),
//                     child: TextField(
//                       controller: _answerController(question.code),
//                       decoration: InputDecoration(
//                         hintText: question.hint ?? 'Enter value...',
//                         hintStyle: TextStyle(
//                           color: AppColors.outline.withValues(alpha: 0.6),
//                           fontSize: 14,
//                         ),
//                         border: InputBorder.none,
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 14,
//                         ),
//                       ),
//                       maxLines: 1,
//                       onChanged: (value) {
//                         setState(() {
//                           _answers[question.code] = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildYesNoCard(StockpileQuestion question) {
//     final answer = _answers[question.code] ?? '';
//     final hasAnswer = answer.isNotEmpty;
//     final hasComment = (_comments[question.code] ?? '').trim().isNotEmpty;
//     final showNoteField = _expandedNotes.contains(question.code) || hasComment;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFF1F579C),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     question.code,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       question.text,
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontSize: 15,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildAnswerToggle(question.code, answer),
//             if (hasAnswer) ...[
//               const SizedBox(height: 14),
//               Text(
//                 'COMMENTS',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.secondary.withValues(alpha: 0.7),
//                   letterSpacing: 0.8,
//                 ),
//               ),
//               const SizedBox(height: 6),
//             ] else
//               const SizedBox(height: 10),
//             if (showNoteField)
//               Container(
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFF5F7FA),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(color: const Color(0xFFE0E3EA)),
//                 ),
//                 child: TextField(
//                   controller: _controller(question.code),
//                   decoration: InputDecoration(
//                     hintText: 'Add optional notes or evidence reference...',
//                     hintStyle: TextStyle(
//                       color: AppColors.outline.withValues(alpha: 0.6),
//                       fontSize: 14,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                   ),
//                   maxLines: 3,
//                   minLines: 2,
//                   onChanged: (value) {
//                     setState(() {
//                       _comments[question.code] = value;
//                       if (value.trim().isNotEmpty) {
//                         _expandedNotes.add(question.code);
//                       }
//                     });
//                   },
//                 ),
//               )
//             else
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton.icon(
//                   onPressed: () {
//                     setState(() {
//                       _expandedNotes.add(question.code);
//                     });
//                   },
//                   icon: const Icon(Icons.add_comment_outlined, size: 18),
//                   label: const Text('Add note'),
//                   style: TextButton.styleFrom(
//                     foregroundColor: const Color(0xFF1F579C),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 4,
//                       vertical: 8,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnswerToggle(String code, String currentAnswer) {
//     const options = ['YES', 'NO', 'NA'];

//     return Row(
//       children: options.map((option) {
//         final isSelected = currentAnswer == option;
//         final displayLabel = option == 'NA' ? 'N/A' : option;

//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(right: option != 'NA' ? 8 : 0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _answers[code] = isSelected ? '' : option;
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 height: 44,
//                 decoration: BoxDecoration(
//                 color: isSelected
//                     ? _getOptionColor(option)
//                     : Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: isSelected
//                       ? _getOptionColor(option)
//                       : const Color(0xFFD5D8E0),
//                   width: 1.5,
//                 ),
//               ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   displayLabel,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : AppColors.onSurface,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildFooter(
//       BuildContext context, bool isFirst, bool isLast, int total) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Divider(color: AppColors.outline.withValues(alpha: 0.15), height: 1),
//           const SizedBox(height: 8),
//           Text(
//             '$_answered of $total answered in this section',
//             style: TextStyle(
//               color: AppColors.secondary.withValues(alpha: 0.7),
//               fontSize: 13,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: OutlinedButton(
//                     onPressed: isFirst
//                         ? null
//                         : () {
//                             setState(() => _currentSectionIndex--);
//                           },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFFD5D8E0)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: Text(
//                       'PREVIOUS',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14,
//                         color: isFirst
//                             ? AppColors.outline.withValues(alpha: 0.4)
//                             : AppColors.onSurface,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: FilledButton(
//                     onPressed: () {
//                       if (isLast) {
//                         _popWithResult();
//                       } else {
//                         setState(() => _currentSectionIndex++);
//                       }
//                     },
//                     style: FilledButton.styleFrom(
//                       backgroundColor: const Color(0xFF1F579C),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           isLast ? 'DONE' : 'SAVE & NEXT',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontSize: 14,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                         if (!isLast) ...[
//                           const SizedBox(width: 8),
//                           const Icon(Icons.arrow_forward, size: 18),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:mine_wadhwani/core/theme/app_colors.dart';
// import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// // ignore_for_file: library_private_types_in_public_api

// class StockpileChecklistPage extends StatefulWidget {
//   final int sectionIndex;
//   final List<StockpileSection> sections;
//   final Map<String, String> answers;
//   final Map<String, String> comments;
//   final String mineName;
//   final String mineType;
//   final String area;
//   final int shift;
//   final String inspectionType;

//   const StockpileChecklistPage({
//     super.key,
//     required this.sectionIndex,
//     required this.sections,
//     required this.answers,
//     required this.comments,
//     required this.mineName,
//     required this.mineType,
//     required this.area,
//     required this.shift,
//     required this.inspectionType,
//   });

//   @override
//   State<StockpileChecklistPage> createState() => _StockpileChecklistPageState();
// }

// class _StockpileChecklistPageState extends State<StockpileChecklistPage> {
//   static const _headerColor = Color(0xFF1F579C);

//   late int _currentSectionIndex;
//   late Map<String, String> _answers;
//   late Map<String, String> _comments;
//   final Set<String> _expandedNotes = <String>{};
//   final Map<String, TextEditingController> _controllers = {};

//   Color _getOptionColor(String option) {
//     switch (option) {
//       case 'YES':
//         return const Color(0xFF10B981);
//       case 'NO':
//         return const Color(0xFFEF4444);
//       case 'NA':
//         return const Color(0xFF9CA3AF);
//       default:
//         return _headerColor;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _currentSectionIndex = widget.sectionIndex;
//     _answers = Map.from(widget.answers);
//     _comments = Map.from(widget.comments);
//     _expandedNotes.addAll(
//       _comments.entries
//           .where((entry) => entry.value.trim().isNotEmpty)
//           .map((entry) => entry.key),
//     );
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     // Extend blue into the status bar
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: _headerColor,
//       statusBarIconBrightness: Brightness.light,
//       statusBarBrightness: Brightness.dark,
//     ));
//   }

//   @override
//   void dispose() {
//     for (final c in _controllers.values) {
//       c.dispose();
//     }
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//       DeviceOrientation.portraitUp,
//       DeviceOrientation.portraitDown,
//     ]);
//     // Restore default status bar
//     SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//     ));
//     super.dispose();
//   }

//   TextEditingController _controller(String code) {
//     return _controllers.putIfAbsent(
//       'c:$code',
//       () => TextEditingController(text: _comments[code] ?? ''),
//     );
//   }

//   TextEditingController _answerController(String code) {
//     return _controllers.putIfAbsent(
//       'a:$code',
//       () => TextEditingController(text: _answers[code] ?? ''),
//     );
//   }

//   void _popWithResult() {
//     final result = <String, String>{};
//     for (final entry in _answers.entries) {
//       result['a:${entry.key}'] = entry.value;
//     }
//     for (final entry in _comments.entries) {
//       result['c:${entry.key}'] = entry.value;
//     }
//     Navigator.of(context).pop(result);
//   }

//   StockpileSection get _currentSection =>
//       widget.sections[_currentSectionIndex];

//   int get _answered =>
//       _currentSection.questions
//           .where((q) => (_answers[q.code] ?? '').isNotEmpty)
//           .length;

//   @override
//   Widget build(BuildContext context) {
//     final total = _currentSection.questions.length;
//     final isFirst = _currentSectionIndex == 0;
//     final isLast = _currentSectionIndex == widget.sections.length - 1;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: Column(
//         children: [
//           _buildHeader(context, total),
//           Expanded(
//             child: _buildQuestions(context),
//           ),
//           _buildFooter(context, isFirst, isLast, total),
//         ],
//       ),
//     );
//   }

//   /// Unified blue header: status bar + nav row + section info + progress bar
//   Widget _buildHeader(BuildContext context, int total) {
//     final progress = total > 0 ? _answered / total : 0.0;
//     final statusBarHeight = MediaQuery.of(context).padding.top;

//     return Container(
//       color: _headerColor,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           // Push content below the system status bar
//           SizedBox(height: statusBarHeight),

//           // ── Nav row: back button + section info + spacer ──────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Rounded back button
//                 GestureDetector(
//                   onTap: _popWithResult,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(
//                       Icons.chevron_left,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),

//                 // Section badge + title
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       // "SECTION X OF Y" pill badge
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.18),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'SECTION ${_currentSectionIndex + 1} OF ${widget.sections.length}',
//                           style: AppTextStyles.bodyMedium.copyWith(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.6,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       // Section title — always white
//                       Text(
//                         _currentSection.title,
//                         style: AppTextStyles.titleLarge.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 18,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),

//                 // Mirror spacer so title stays centred
//                 const SizedBox(width: 40),
//               ],
//             ),
//           ),

//           // ── Progress bar inside the blue header ───────────────────
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'PROGRESS',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white.withValues(alpha: 0.7),
//                         letterSpacing: 0.8,
//                       ),
//                     ),
//                     Text(
//                       '$_answered / $total answered',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: LinearProgressIndicator(
//                     value: progress,
//                     backgroundColor: Colors.white.withValues(alpha: 0.25),
//                     valueColor:
//                         const AlwaysStoppedAnimation<Color>(Colors.white),
//                     minHeight: 6,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestions(BuildContext context) {
//     final questions = _currentSection.questions;
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       itemCount: questions.length,
//       itemBuilder: (context, index) => _buildQuestionCard(questions[index]),
//     );
//   }

//   Widget _buildQuestionCard(StockpileQuestion question) {
//     if (question.type == StockpileQuestionType.text) {
//       return _buildTextInputCard(question);
//     }
//     return _buildYesNoCard(question);
//   }

//   Widget _buildTextInputCard(StockpileQuestion question) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: _headerColor,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 question.code,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6, bottom: 12),
//                     child: Text(
//                       question.text,
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontSize: 15,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                   // Theme-colored text field — no pink
//                   Theme(
//                     data: Theme.of(context).copyWith(
//                       colorScheme: Theme.of(context).colorScheme.copyWith(
//                             primary: _headerColor,
//                           ),
//                     ),
//                     child: TextField(
//                       controller: _answerController(question.code),
//                       cursorColor: _headerColor,
//                       decoration: InputDecoration(
//                         hintText: question.hint ?? 'Enter value...',
//                         hintStyle: TextStyle(
//                           color: AppColors.outline.withValues(alpha: 0.6),
//                           fontSize: 14,
//                         ),
//                         filled: true,
//                         fillColor: const Color(0xFFF5F7FA),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                               color: Color(0xFFE0E3EA), width: 1),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                               color: _headerColor, width: 1.5),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 14,
//                         ),
//                       ),
//                       maxLines: 1,
//                       onChanged: (value) {
//                         setState(() {
//                           _answers[question.code] = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildYesNoCard(StockpileQuestion question) {
//     final answer = _answers[question.code] ?? '';
//     final hasAnswer = answer.isNotEmpty;
//     final hasComment = (_comments[question.code] ?? '').trim().isNotEmpty;
//     final showNoteField = _expandedNotes.contains(question.code) || hasComment;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: _headerColor,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     question.code,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       question.text,
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontSize: 15,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             _buildAnswerToggle(question.code, answer),
//             if (hasAnswer) ...[
//               const SizedBox(height: 14),
//               Text(
//                 'COMMENTS',
//                 style: TextStyle(
//                   fontSize: 11,
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.secondary.withValues(alpha: 0.7),
//                   letterSpacing: 0.8,
//                 ),
//               ),
//               const SizedBox(height: 6),
//             ] else
//               const SizedBox(height: 10),
//             if (showNoteField)
//               // Theme override prevents the pink/red focus highlight
//               Theme(
//                 data: Theme.of(context).copyWith(
//                   colorScheme: Theme.of(context).colorScheme.copyWith(
//                         primary: _headerColor,
//                       ),
//                 ),
//                 child: TextField(
//                   controller: _controller(question.code),
//                   cursorColor: _headerColor,
//                   decoration: InputDecoration(
//                     hintText: 'Add optional notes or evidence reference...',
//                     hintStyle: TextStyle(
//                       color: AppColors.outline.withValues(alpha: 0.6),
//                       fontSize: 14,
//                     ),
//                     filled: true,
//                     fillColor: const Color(0xFFF5F7FA),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                           color: Color(0xFFE0E3EA), width: 1),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:
//                           const BorderSide(color: _headerColor, width: 1.5),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                   ),
//                   maxLines: 3,
//                   minLines: 2,
//                   onChanged: (value) {
//                     setState(() {
//                       _comments[question.code] = value;
//                       if (value.trim().isNotEmpty) {
//                         _expandedNotes.add(question.code);
//                       }
//                     });
//                   },
//                 ),
//               )
//             else
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: TextButton.icon(
//                   onPressed: () {
//                     setState(() {
//                       _expandedNotes.add(question.code);
//                     });
//                   },
//                   icon: const Icon(Icons.add_comment_outlined, size: 18),
//                   label: const Text('Add note'),
//                   style: TextButton.styleFrom(
//                     foregroundColor: _headerColor,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 4,
//                       vertical: 8,
//                     ),
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnswerToggle(String code, String currentAnswer) {
//     const options = ['YES', 'NO', 'NA'];

//     return Row(
//       children: options.map((option) {
//         final isSelected = currentAnswer == option;
//         final displayLabel = option == 'NA' ? 'N/A' : option;

//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(right: option != 'NA' ? 8 : 0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _answers[code] = isSelected ? '' : option;
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? _getOptionColor(option)
//                       : Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: isSelected
//                         ? _getOptionColor(option)
//                         : const Color(0xFFD5D8E0),
//                     width: 1.5,
//                   ),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   displayLabel,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : AppColors.onSurface,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildFooter(
//       BuildContext context, bool isFirst, bool isLast, int total) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Divider(color: AppColors.outline.withValues(alpha: 0.15), height: 1),
//           const SizedBox(height: 8),
//           Text(
//             '$_answered of $total answered in this section',
//             style: TextStyle(
//               color: AppColors.secondary.withValues(alpha: 0.7),
//               fontSize: 13,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: OutlinedButton(
//                     onPressed: isFirst
//                         ? null
//                         : () {
//                             setState(() => _currentSectionIndex--);
//                           },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFFD5D8E0)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: Text(
//                       'PREVIOUS',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14,
//                         color: isFirst
//                             ? AppColors.outline.withValues(alpha: 0.4)
//                             : AppColors.onSurface,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: FilledButton(
//                     onPressed: () {
//                       if (isLast) {
//                         _popWithResult();
//                       } else {
//                         setState(() => _currentSectionIndex++);
//                       }
//                     },
//                     style: FilledButton.styleFrom(
//                       backgroundColor: _headerColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           isLast ? 'DONE' : 'SAVE & NEXT',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontSize: 14,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                         if (!isLast) ...[
//                           const SizedBox(width: 8),
//                           const Icon(Icons.arrow_forward, size: 18),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mine_wadhwani/core/theme/app_colors.dart';
// import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// // ignore_for_file: library_private_types_in_public_api

// class StockpileChecklistPage extends StatefulWidget {
//   final int sectionIndex;
//   final List<StockpileSection> sections;
//   final Map<String, String> answers;
//   final Map<String, String> comments;
//   final String mineName;
//   final String mineType;
//   final String area;
//   final int shift;
//   final String inspectionType;

//   const StockpileChecklistPage({
//     super.key,
//     required this.sectionIndex,
//     required this.sections,
//     required this.answers,
//     required this.comments,
//     required this.mineName,
//     required this.mineType,
//     required this.area,
//     required this.shift,
//     required this.inspectionType,
//   });

//   @override
//   State<StockpileChecklistPage> createState() => _StockpileChecklistPageState();
// }

// class _StockpileChecklistPageState extends State<StockpileChecklistPage> {
//   static const _headerColor = Color(0xFF1F579C);

//   late int _currentSectionIndex;
//   late Map<String, String> _answers;
//   late Map<String, String> _comments;
//   final Set<String> _expandedNotes = <String>{};
//   final Map<String, TextEditingController> _controllers = {};

//   /// code → list of picked image paths (for display / upload later)
//   final Map<String, List<String>> _mediaFiles = {};

//   final ImagePicker _imagePicker = ImagePicker();

//   Color _getOptionColor(String option) {
//     switch (option) {
//       case 'YES':
//         return const Color(0xFF10B981);
//       case 'NO':
//         return const Color(0xFFEF4444);
//       case 'NA':
//         return const Color(0xFF9CA3AF);
//       default:
//         return _headerColor;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _currentSectionIndex = widget.sectionIndex;
//     _answers = Map.from(widget.answers);
//     _comments = Map.from(widget.comments);
//     _expandedNotes.addAll(
//       _comments.entries
//           .where((entry) => entry.value.trim().isNotEmpty)
//           .map((entry) => entry.key),
//     );
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
//     for (final c in _controllers.values) {
//       c.dispose();
//     }
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

//   TextEditingController _controller(String code) {
//     return _controllers.putIfAbsent(
//       'c:$code',
//       () => TextEditingController(text: _comments[code] ?? ''),
//     );
//   }

//   TextEditingController _answerController(String code) {
//     return _controllers.putIfAbsent(
//       'a:$code',
//       () => TextEditingController(text: _answers[code] ?? ''),
//     );
//   }

//   void _popWithResult() {
//     final result = <String, String>{};
//     for (final entry in _answers.entries) {
//       result['a:${entry.key}'] = entry.value;
//     }
//     for (final entry in _comments.entries) {
//       result['c:${entry.key}'] = entry.value;
//     }
//     Navigator.of(context).pop(result);
//   }

//   StockpileSection get _currentSection =>
//       widget.sections[_currentSectionIndex];

//   int get _answered =>
//       _currentSection.questions
//           .where((q) => (_answers[q.code] ?? '').isNotEmpty)
//           .length;

//   // ─── Media helpers ────────────────────────────────────────────────────────

//   Future<void> _pickFromCamera(String code) async {
//     Navigator.of(context).pop(); // close bottom sheet first
//     final XFile? file = await _imagePicker.pickImage(
//       source: ImageSource.camera,
//       imageQuality: 85,
//     );
//     if (file != null && mounted) {
//       setState(() {
//         _mediaFiles.putIfAbsent(code, () => []).add(file.path);
//       });
//     }
//   }

//   Future<void> _pickFromGallery(String code) async {
//     Navigator.of(context).pop(); // close bottom sheet first
//     final XFile? file = await _imagePicker.pickImage(
//       source: ImageSource.gallery,
//       imageQuality: 85,
//     );
//     if (file != null && mounted) {
//       setState(() {
//         _mediaFiles.putIfAbsent(code, () => []).add(file.path);
//       });
//     }
//   }

//   void _showMediaPopup(String code) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Handle bar
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE0E3EA),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 18),
//               // Title row
//               Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F0FB),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(
//                       Icons.perm_media_outlined,
//                       color: _headerColor,
//                       size: 20,
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         'Add Media',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.w700,
//                           color: Color(0xFF1A2340),
//                         ),
//                       ),
//                       Text(
//                         'Attach photos to this inspection point',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: AppColors.secondary.withValues(alpha: 0.6),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               // Take photo
//               _buildMediaOption(
//                 icon: Icons.camera_alt_outlined,
//                 iconBg: const Color(0xFFE8F0FB),
//                 iconColor: _headerColor,
//                 label: 'Take Photo',
//                 subtitle: 'Open camera and capture now',
//                 onTap: () => _pickFromCamera(code),
//               ),
//               const SizedBox(height: 10),
//               // Gallery
//               _buildMediaOption(
//                 icon: Icons.photo_library_outlined,
//                 iconBg: const Color(0xFFF0FAF5),
//                 iconColor: const Color(0xFF10B981),
//                 label: 'Insert from Gallery',
//                 subtitle: 'Choose from your photo library',
//                 onTap: () => _pickFromGallery(code),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required Color iconBg,
//     required Color iconColor,
//     required String label,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF5F7FA),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: const Color(0xFFE0E3EA)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                 color: iconBg,
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Icon(icon, color: iconColor, size: 22),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     label,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: Color(0xFF1A2340),
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: AppColors.secondary.withValues(alpha: 0.6),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.chevron_right,
//               color: AppColors.outline.withValues(alpha: 0.5),
//               size: 20,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final total = _currentSection.questions.length;
//     final isFirst = _currentSectionIndex == 0;
//     final isLast = _currentSectionIndex == widget.sections.length - 1;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: Column(
//         children: [
//           _buildHeader(context, total),
//           Expanded(child: _buildQuestions(context)),
//           _buildFooter(context, isFirst, isLast, total),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, int total) {
//     final progress = total > 0 ? _answered / total : 0.0;
//     final statusBarHeight = MediaQuery.of(context).padding.top;

//     return Container(
//       color: _headerColor,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: statusBarHeight),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: _popWithResult,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(
//                       Icons.chevron_left,
//                       color: Colors.white,
//                       size: 26,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.18),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'SECTION ${_currentSectionIndex + 1} OF ${widget.sections.length}',
//                           style: AppTextStyles.bodyMedium.copyWith(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.6,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         _currentSection.title,
//                         style: AppTextStyles.titleLarge.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 18,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 40),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'PROGRESS',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w700,
//                         color: Colors.white.withValues(alpha: 0.7),
//                         letterSpacing: 0.8,
//                       ),
//                     ),
//                     Text(
//                       '$_answered / $total answered',
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: LinearProgressIndicator(
//                     value: progress,
//                     backgroundColor: Colors.white.withValues(alpha: 0.25),
//                     valueColor:
//                         const AlwaysStoppedAnimation<Color>(Colors.white),
//                     minHeight: 6,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestions(BuildContext context) {
//     final questions = _currentSection.questions;
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       itemCount: questions.length,
//       itemBuilder: (context, index) => _buildQuestionCard(questions[index]),
//     );
//   }

//   Widget _buildQuestionCard(StockpileQuestion question) {
//     if (question.type == StockpileQuestionType.text) {
//       return _buildTextInputCard(question);
//     }
//     return _buildYesNoCard(question);
//   }

//   Widget _buildTextInputCard(StockpileQuestion question) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                 color: _headerColor,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               alignment: Alignment.center,
//               child: Text(
//                 question.code,
//                 style: const TextStyle(
//                   color: Colors.white,
//                   fontSize: 12,
//                   fontWeight: FontWeight.w700,
//                 ),
//               ),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6, bottom: 12),
//                     child: Text(
//                       question.text,
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontSize: 15,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                   Theme(
//                     data: Theme.of(context).copyWith(
//                       colorScheme: Theme.of(context).colorScheme.copyWith(
//                             primary: _headerColor,
//                           ),
//                     ),
//                     child: TextField(
//                       controller: _answerController(question.code),
//                       cursorColor: _headerColor,
//                       decoration: InputDecoration(
//                         hintText: question.hint ?? 'Enter value...',
//                         hintStyle: TextStyle(
//                           color: AppColors.outline.withValues(alpha: 0.6),
//                           fontSize: 14,
//                         ),
//                         filled: true,
//                         fillColor: const Color(0xFFF5F7FA),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                               color: Color(0xFFE0E3EA), width: 1),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                               color: _headerColor, width: 1.5),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 16,
//                           vertical: 14,
//                         ),
//                       ),
//                       maxLines: 1,
//                       onChanged: (value) {
//                         setState(() {
//                           _answers[question.code] = value;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildYesNoCard(StockpileQuestion question) {
//     final answer = _answers[question.code] ?? '';
//     final hasComment = (_comments[question.code] ?? '').trim().isNotEmpty;
//     final showNoteField =
//         _expandedNotes.contains(question.code) || hasComment;
//     final mediaCount = _mediaFiles[question.code]?.length ?? 0;

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Question header ──────────────────────────────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                     color: _headerColor,
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                   alignment: Alignment.center,
//                   child: Text(
//                     question.code,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(
//                       question.text,
//                       style: AppTextStyles.bodyMedium.copyWith(
//                         fontSize: 15,
//                         height: 1.4,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // ── YES / NO / NA toggle ─────────────────────────────
//             _buildAnswerToggle(question.code, answer),
//             const SizedBox(height: 14),

//             // ── Bottom action row: Add note (left) | Media + Action (right) ─
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // ── Add note — LEFT ──────────────────────────────
//                 GestureDetector(
//                   onTap: () {
//                     setState(() => _expandedNotes.add(question.code));
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 11, vertical: 7),
//                     decoration: BoxDecoration(
//                       color: showNoteField
//                           ? _headerColor.withValues(alpha: 0.08)
//                           : const Color(0xFFF5F7FA),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: showNoteField
//                             ? _headerColor.withValues(alpha: 0.3)
//                             : const Color(0xFFE0E3EA),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           showNoteField
//                               ? Icons.edit_note_outlined
//                               : Icons.add_comment_outlined,
//                           size: 15,
//                           color: _headerColor,
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           showNoteField ? 'Note added' : 'Add note',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: _headerColor,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const Spacer(),

//                 // ── Media button — RIGHT ─────────────────────────
//                 GestureDetector(
//                   onTap: () => _showMediaPopup(question.code),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 11, vertical: 7),
//                     decoration: BoxDecoration(
//                       color: mediaCount > 0
//                           ? const Color(0xFF10B981).withValues(alpha: 0.08)
//                           : const Color(0xFFF5F7FA),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(
//                         color: mediaCount > 0
//                             ? const Color(0xFF10B981).withValues(alpha: 0.4)
//                             : const Color(0xFFE0E3EA),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.camera_alt_outlined,
//                           size: 15,
//                           color: mediaCount > 0
//                               ? const Color(0xFF10B981)
//                               : AppColors.secondary,
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           mediaCount > 0
//                               ? 'Media ($mediaCount)'
//                               : 'Media',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: mediaCount > 0
//                                 ? const Color(0xFF10B981)
//                                 : AppColors.secondary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),

//                 // ── Action button — RIGHT ────────────────────────
//                 GestureDetector(
//                   onTap: () {
//                
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text('Action options coming soon'),
//                         duration: Duration(seconds: 1),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 11, vertical: 7),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF5F7FA),
//                       borderRadius: BorderRadius.circular(10),
//                       border: Border.all(color: const Color(0xFFE0E3EA)),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           Icons.bolt_outlined,
//                           size: 15,
//                           color: AppColors.secondary,
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           'Action',
//                           style: TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: AppColors.secondary,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // ── Note text field (shown after "Add note" tapped) ──
//             if (showNoteField) ...[
//               const SizedBox(height: 12),
//               Theme(
//                 data: Theme.of(context).copyWith(
//                   colorScheme: Theme.of(context).colorScheme.copyWith(
//                         primary: _headerColor,
//                       ),
//                 ),
//                 child: TextField(
//                   controller: _controller(question.code),
//                   cursorColor: _headerColor,
//                   decoration: InputDecoration(
//                     hintText: 'Add optional notes or evidence reference...',
//                     hintStyle: TextStyle(
//                       color: AppColors.outline.withValues(alpha: 0.6),
//                       fontSize: 14,
//                     ),
//                     filled: true,
//                     fillColor: const Color(0xFFF5F7FA),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                           color: Color(0xFFE0E3EA), width: 1),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                           color: _headerColor, width: 1.5),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 14,
//                     ),
//                   ),
//                   maxLines: 3,
//                   minLines: 2,
//                   onChanged: (value) {
//                     setState(() {
//                       _comments[question.code] = value;
//                       if (value.trim().isNotEmpty) {
//                         _expandedNotes.add(question.code);
//                       }
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnswerToggle(String code, String currentAnswer) {
//     const options = ['YES', 'NO', 'NA'];

//     return Row(
//       children: options.map((option) {
//         final isSelected = currentAnswer == option;
//         final displayLabel = option == 'NA' ? 'N/A' : option;

//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(right: option != 'NA' ? 8 : 0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _answers[code] = isSelected ? '' : option;
//                 });
//               },
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? _getOptionColor(option)
//                       : Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: isSelected
//                         ? _getOptionColor(option)
//                         : const Color(0xFFD5D8E0),
//                     width: 1.5,
//                   ),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(
//                   displayLabel,
//                   style: TextStyle(
//                     color: isSelected ? Colors.white : AppColors.onSurface,
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildFooter(
//       BuildContext context, bool isFirst, bool isLast, int total) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Divider(
//               color: AppColors.outline.withValues(alpha: 0.15), height: 1),
//           const SizedBox(height: 8),
//           Text(
//             '$_answered of $total answered in this section',
//             style: TextStyle(
//               color: AppColors.secondary.withValues(alpha: 0.7),
//               fontSize: 13,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: OutlinedButton(
//                     onPressed: isFirst
//                         ? null
//                         : () {
//                             setState(() => _currentSectionIndex--);
//                           },
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFFD5D8E0)),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: Text(
//                       'PREVIOUS',
//                       style: TextStyle(
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14,
//                         color: isFirst
//                             ? AppColors.outline.withValues(alpha: 0.4)
//                             : AppColors.onSurface,
//                         letterSpacing: 0.5,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: FilledButton(
//                     onPressed: () {
//                       if (isLast) {
//                         _popWithResult();
//                       } else {
//                         setState(() => _currentSectionIndex++);
//                       }
//                     },
//                     style: FilledButton.styleFrom(
//                       backgroundColor: _headerColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(
//                           isLast ? 'DONE' : 'SAVE & NEXT',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontSize: 14,
//                             letterSpacing: 0.5,
//                           ),
//                         ),
//                         if (!isLast) ...[
//                           const SizedBox(width: 8),
//                           const Icon(Icons.arrow_forward, size: 18),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/foundation.dart'; // added for kIsWeb
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:mine_wadhwani/core/theme/app_colors.dart';
// import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
// import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// // ignore_for_file: library_private_types_in_public_api

// class StockpileChecklistPage extends StatefulWidget {
//   final int sectionIndex;
//   final List<StockpileSection> sections;
//   final Map<String, String> answers;
//   final Map<String, String> comments;
//   final Map<String, List<String>> mediaFiles; // ← new
//   final String mineName;
//   final String mineType;
//   final String area;
//   final int shift;
//   final String inspectionType;

//   const StockpileChecklistPage({
//     super.key,
//     required this.sectionIndex,
//     required this.sections,
//     required this.answers,
//     required this.comments,
//     required this.mediaFiles, // ← new
//     required this.mineName,
//     required this.mineType,
//     required this.area,
//     required this.shift,
//     required this.inspectionType,
//   });

//   @override
//   State<StockpileChecklistPage> createState() => _StockpileChecklistPageState();
// }

// class _StockpileChecklistPageState extends State<StockpileChecklistPage> {
//   static const _headerColor = Color(0xFF1F579C);

//   late int _currentSectionIndex;
//   late Map<String, String> _answers;
//   late Map<String, String> _comments;

//   final Set<String> _expandedNotes = <String>{};
//   final Set<String> _savedNotes = <String>{};
//   final Map<String, TextEditingController> _controllers = {};

//   /// code → list of image paths — seeded from widget.mediaFiles
//   late Map<String, List<String>> _mediaFiles;

//   final ImagePicker _imagePicker = ImagePicker();

//   Color _getOptionColor(String option) {
//     switch (option) {
//       case 'YES':
//         return const Color(0xFF10B981);
//       case 'NO':
//         return const Color(0xFFEF4444);
//       case 'NA':
//         return const Color(0xFF9CA3AF);
//       default:
//         return _headerColor;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     _currentSectionIndex = widget.sectionIndex;
//     _answers = Map.from(widget.answers);
//     _comments = Map.from(widget.comments);

//     // Deep-copy media so edits don't mutate the parent's map
//     _mediaFiles = Map.fromEntries(
//       widget.mediaFiles.entries.map(
//         (e) => MapEntry(e.key, List<String>.from(e.value)),
//       ),
//     );

//     for (final entry in _comments.entries) {
//       if (entry.value.trim().isNotEmpty) _savedNotes.add(entry.key);
//     }

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
//     for (final c in _controllers.values) c.dispose();
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

//   TextEditingController _controller(String code) => _controllers.putIfAbsent(
//         'c:$code',
//         () => TextEditingController(text: _comments[code] ?? ''),
//       );

//   TextEditingController _answerController(String code) =>
//       _controllers.putIfAbsent(
//         'a:$code',
//         () => TextEditingController(text: _answers[code] ?? ''),
//       );

//   /// Returns answers + comments + media back to the overview page.
//   /// Keys:  a:<code>  → answer string
//   ///        c:<code>  → comment string
//   ///        m:<code>  → image paths joined by '||'
//   void _popWithResult() {
//     final result = <String, String>{};

//     for (final e in _answers.entries) {
//       result['a:${e.key}'] = e.value;
//     }
//     for (final e in _comments.entries) {
//       result['c:${e.key}'] = e.value;
//     }
//     // Encode every media list (even empty ones so deletions propagate)
//     for (final e in _mediaFiles.entries) {
//       result['m:${e.key}'] = e.value.join('||');
//     }

//     Navigator.of(context).pop(result);
//   }

//   StockpileSection get _currentSection =>
//       widget.sections[_currentSectionIndex];

//   int get _answered => _currentSection.questions
//       .where((q) => (_answers[q.code] ?? '').isNotEmpty)
//       .length;

//   // ─── Media ────────────────────────────────────────────────────────────────

//   Future<void> _pickFromCamera(String code) async {
//     Navigator.of(context).pop();
//     try {
//       final XFile? file = await _imagePicker.pickImage(
//         source: ImageSource.camera,
//         imageQuality: 85,
//       );
//       if (file != null && mounted) {
//         setState(() => _mediaFiles.putIfAbsent(code, () => []).add(file.path));
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Camera error: $e')),
//         );
//       }
//     }
//   }

//   Future<void> _pickFromGallery(String code) async {
//     Navigator.of(context).pop();
//     try {
//       final XFile? file = await _imagePicker.pickImage(
//         source: ImageSource.gallery,
//         imageQuality: 85,
//       );
//       if (file != null && mounted) {
//         setState(() => _mediaFiles.putIfAbsent(code, () => []).add(file.path));
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Gallery error: $e')),
//         );
//       }
//     }
//   }

//   void _showMediaPopup(String code) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(
//                   width: 40,
//                   height: 4,
//                   decoration: BoxDecoration(
//                     color: const Color(0xFFE0E3EA),
//                     borderRadius: BorderRadius.circular(2),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 18),
//               Row(
//                 children: [
//                   Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFE8F0FB),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.perm_media_outlined,
//                         color: _headerColor, size: 20),
//                   ),
//                   const SizedBox(width: 12),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Add Media',
//                           style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.w700,
//                               color: Color(0xFF1A2340))),
//                       Text('Attach photos to this inspection point',
//                           style: TextStyle(
//                               fontSize: 12,
//                               color: AppColors.secondary
//                                   .withValues(alpha: 0.6))),
//                     ],
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 20),
//               _buildMediaOption(
//                 icon: Icons.camera_alt_outlined,
//                 iconBg: const Color(0xFFE8F0FB),
//                 iconColor: _headerColor,
//                 label: 'Take Photo',
//                 subtitle: 'Open camera and capture now',
//                 onTap: () => _pickFromCamera(code),
//               ),
//               const SizedBox(height: 10),
//               _buildMediaOption(
//                 icon: Icons.photo_library_outlined,
//                 iconBg: const Color(0xFFF0FAF5),
//                 iconColor: const Color(0xFF10B981),
//                 label: 'Insert from Gallery',
//                 subtitle: 'Choose an existing photo from your library',
//                 onTap: () => _pickFromGallery(code),
//               ),
//               const SizedBox(height: 8),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildMediaOption({
//     required IconData icon,
//     required Color iconBg,
//     required Color iconColor,
//     required String label,
//     required String subtitle,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: const Color(0xFFF5F7FA),
//           borderRadius: BorderRadius.circular(14),
//           border: Border.all(color: const Color(0xFFE0E3EA)),
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 44,
//               height: 44,
//               decoration: BoxDecoration(
//                   color: iconBg, borderRadius: BorderRadius.circular(12)),
//               child: Icon(icon, color: iconColor, size: 22),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(label,
//                       style: const TextStyle(
//                           fontSize: 15,
//                           fontWeight: FontWeight.w600,
//                           color: Color(0xFF1A2340))),
//                   const SizedBox(height: 2),
//                   Text(subtitle,
//                       style: TextStyle(
//                           fontSize: 12,
//                           color:
//                               AppColors.secondary.withValues(alpha: 0.6))),
//                 ],
//               ),
//             ),
//             Icon(Icons.chevron_right,
//                 color: AppColors.outline.withValues(alpha: 0.5), size: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─────────────────────────────────────────────────────────────────────────

//   @override
//   Widget build(BuildContext context) {
//     final total = _currentSection.questions.length;
//     final isFirst = _currentSectionIndex == 0;
//     final isLast = _currentSectionIndex == widget.sections.length - 1;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FA),
//       body: Column(
//         children: [
//           _buildHeader(context, total),
//           Expanded(child: _buildQuestions(context)),
//           _buildFooter(context, isFirst, isLast, total),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, int total) {
//     final progress = total > 0 ? _answered / total : 0.0;
//     final statusBarHeight = MediaQuery.of(context).padding.top;

//     return Container(
//       color: _headerColor,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           SizedBox(height: statusBarHeight),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: _popWithResult,
//                   child: Container(
//                     width: 40,
//                     height: 40,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.15),
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: const Icon(Icons.chevron_left,
//                         color: Colors.white, size: 26),
//                   ),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 12, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white.withValues(alpha: 0.18),
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         child: Text(
//                           'SECTION ${_currentSectionIndex + 1} OF ${widget.sections.length}',
//                           style: AppTextStyles.bodyMedium.copyWith(
//                             color: Colors.white,
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             letterSpacing: 0.6,
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         _currentSection.title,
//                         style: AppTextStyles.titleLarge.copyWith(
//                           color: Colors.white,
//                           fontWeight: FontWeight.w700,
//                           fontSize: 18,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 40),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.fromLTRB(20, 2, 20, 14),
//             child: Column(
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text('PROGRESS',
//                         style: TextStyle(
//                             fontSize: 11,
//                             fontWeight: FontWeight.w700,
//                             color: Colors.white.withValues(alpha: 0.7),
//                             letterSpacing: 0.8)),
//                     Text('$_answered / $total answered',
//                         style: const TextStyle(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                             color: Colors.white)),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(6),
//                   child: LinearProgressIndicator(
//                     value: progress,
//                     backgroundColor: Colors.white.withValues(alpha: 0.25),
//                     valueColor:
//                         const AlwaysStoppedAnimation<Color>(Colors.white),
//                     minHeight: 6,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildQuestions(BuildContext context) {
//     final questions = _currentSection.questions;
//     return ListView.builder(
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
//       itemCount: questions.length,
//       itemBuilder: (context, index) => _buildQuestionCard(questions[index]),
//     );
//   }

//   Widget _buildQuestionCard(StockpileQuestion question) {
//     if (question.type == StockpileQuestionType.text) {
//       return _buildTextInputCard(question);
//     }
//     return _buildYesNoCard(question);
//   }

//   Widget _buildTextInputCard(StockpileQuestion question) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: 36,
//               height: 36,
//               decoration: BoxDecoration(
//                   color: _headerColor,
//                   borderRadius: BorderRadius.circular(10)),
//               alignment: Alignment.center,
//               child: Text(question.code,
//                   style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w700)),
//             ),
//             const SizedBox(width: 14),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(top: 6, bottom: 12),
//                     child: Text(question.text,
//                         style: AppTextStyles.bodyMedium
//                             .copyWith(fontSize: 15, height: 1.4)),
//                   ),
//                   Theme(
//                     data: Theme.of(context).copyWith(
//                       colorScheme: Theme.of(context)
//                           .colorScheme
//                           .copyWith(primary: _headerColor),
//                     ),
//                     child: TextField(
//                       controller: _answerController(question.code),
//                       cursorColor: _headerColor,
//                       decoration: InputDecoration(
//                         hintText: question.hint ?? 'Enter value...',
//                         hintStyle: TextStyle(
//                             color: AppColors.outline.withValues(alpha: 0.6),
//                             fontSize: 14),
//                         filled: true,
//                         fillColor: const Color(0xFFF5F7FA),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                               color: Color(0xFFE0E3EA), width: 1),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                               color: _headerColor, width: 1.5),
//                         ),
//                         contentPadding: const EdgeInsets.symmetric(
//                             horizontal: 16, vertical: 14),
//                       ),
//                       maxLines: 1,
//                       onChanged: (v) =>
//                           setState(() => _answers[question.code] = v),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildYesNoCard(StockpileQuestion question) {
//     final code = question.code;
//     final answer = _answers[code] ?? '';
//     final mediaList = _mediaFiles[code] ?? [];
//     final mediaCount = mediaList.length;
//     final showNoteField = _expandedNotes.contains(code);
//     final isSaved = _savedNotes.contains(code);
//     final savedText = _comments[code] ?? '';

//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: const Color(0xFFE0E3EA)),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Question header ──────────────────────────────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 36,
//                   height: 36,
//                   decoration: BoxDecoration(
//                       color: _headerColor,
//                       borderRadius: BorderRadius.circular(10)),
//                   alignment: Alignment.center,
//                   child: Text(code,
//                       style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700)),
//                 ),
//                 const SizedBox(width: 14),
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.only(top: 6),
//                     child: Text(question.text,
//                         style: AppTextStyles.bodyMedium
//                             .copyWith(fontSize: 15, height: 1.4)),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),

//             // ── YES / NO / NA toggle ─────────────────────────────
//             _buildAnswerToggle(code, answer),
//             const SizedBox(height: 14),

//             // ── Bottom action row ────────────────────────────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Add note — LEFT
//                 GestureDetector(
//                   onTap: () {
//                     if (isSaved) {
//                       setState(() {
//                         _savedNotes.remove(code);
//                         _expandedNotes.add(code);
//                       });
//                     } else if (!showNoteField) {
//                       setState(() => _expandedNotes.add(code));
//                     }
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 11, vertical: 7),
//                     decoration: const BoxDecoration(),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(
//                           isSaved
//                               ? Icons.edit_note_outlined
//                               : (showNoteField
//                                   ? Icons.notes_outlined
//                                   : Icons.add_comment_outlined),
//                           size: 15,
//                           color: const Color(0xFF6B7280),
//                         ),
//                         const SizedBox(width: 5),
//                         Text(
//                           isSaved
//                               ? 'Edit note'
//                               : (showNoteField ? 'Adding note…' : 'Add note'),
//                           style: const TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: Color(0xFF6B7280)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),

//                 const Spacer(),

//                 // Media — RIGHT
//                 GestureDetector(
//                   onTap: () => _showMediaPopup(code),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 11, vertical: 7),
//                     decoration: const BoxDecoration(),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Icon(Icons.camera_alt_outlined,
//                             size: 15,
//                             color: mediaCount > 0
//                                 ? const Color(0xFF10B981)
//                                 : const Color(0xFF6B7280)),
//                         const SizedBox(width: 5),
//                         Text(
//                           mediaCount > 0 ? 'Media ($mediaCount)' : 'Media',
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w600,
//                               color: mediaCount > 0
//                                   ? const Color(0xFF10B981)
//                                   : const Color(0xFF6B7280)),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),

//                 // Action — RIGHT
//                 GestureDetector(
//                   onTap: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Action options coming soon'),
//                           duration: Duration(seconds: 1)),
//                     );
//                   },
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 11, vertical: 7),
//                     decoration: const BoxDecoration(),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.bolt_outlined,
//                             size: 15, color: Color(0xFF6B7280)),
//                         const SizedBox(width: 5),
//                         const Text('Action',
//                             style: TextStyle(
//                                 fontSize: 12,
//                                 fontWeight: FontWeight.w600,
//                                 color: Color(0xFF6B7280))),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // ── Note: typing state ───────────────────────────────
//             if (showNoteField && !isSaved) ...[
//               const SizedBox(height: 12),
//               Theme(
//                 data: Theme.of(context).copyWith(
//                   colorScheme: Theme.of(context)
//                       .colorScheme
//                       .copyWith(primary: _headerColor),
//                 ),
//                 child: TextField(
//                   controller: _controller(code),
//                   cursorColor: _headerColor,
//                   autofocus: true,
//                   decoration: InputDecoration(
//                     hintText: 'Add optional notes or evidence reference...',
//                     hintStyle: TextStyle(
//                         color: AppColors.outline.withValues(alpha: 0.6),
//                         fontSize: 14),
//                     filled: true,
//                     fillColor: const Color(0xFFF5F7FA),
//                     enabledBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide: const BorderSide(
//                           color: Color(0xFFE0E3EA), width: 1),
//                     ),
//                     focusedBorder: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(12),
//                       borderSide:
//                           const BorderSide(color: _headerColor, width: 1.5),
//                     ),
//                     contentPadding: const EdgeInsets.symmetric(
//                         horizontal: 16, vertical: 14),
//                   ),
//                   maxLines: 3,
//                   minLines: 2,
//                   onChanged: (v) => setState(() => _comments[code] = v),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 children: [
//                   const Spacer(),
//                   // ✗ Discard
//                   GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         _expandedNotes.remove(code);
//                         if ((_comments[code] ?? '').trim().isEmpty) {
//                           _comments.remove(code);
//                           _controller(code).clear();
//                         }
//                       });
//                     },
//                     child: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFFFEBEE),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                             color: const Color(0xFFEF4444)
//                                 .withValues(alpha: 0.3)),
//                       ),
//                       child: const Icon(Icons.close,
//                           size: 18, color: Color(0xFFEF4444)),
//                     ),
//                   ),
//                   const SizedBox(width: 8),
//                   // ✓ Confirm
//                   GestureDetector(
//                     onTap: () {
//                       final text = _controller(code).text.trim();
//                       setState(() {
//                         if (text.isNotEmpty) {
//                           _comments[code] = text;
//                           _savedNotes.add(code);
//                         }
//                         _expandedNotes.remove(code);
//                       });
//                     },
//                     child: Container(
//                       width: 36,
//                       height: 36,
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE8F5E9),
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(
//                             color: const Color(0xFF10B981)
//                                 .withValues(alpha: 0.4)),
//                       ),
//                       child: const Icon(Icons.check,
//                           size: 18, color: Color(0xFF10B981)),
//                     ),
//                   ),
//                 ],
//               ),
//             ],

//             // ── Note: saved/read-only state ──────────────────────
//             if (isSaved && savedText.isNotEmpty && !showNoteField) ...[
//               const SizedBox(height: 12),
//               Container(
//                 width: double.infinity,
//                 padding: const EdgeInsets.symmetric(
//                     horizontal: 14, vertical: 12),
//                 decoration: BoxDecoration(
//                   color: _headerColor.withValues(alpha: 0.05),
//                   borderRadius: BorderRadius.circular(12),
//                   border: Border.all(
//                       color: _headerColor.withValues(alpha: 0.15)),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Icon(Icons.notes_outlined,
//                         size: 16,
//                         color: _headerColor.withValues(alpha: 0.7)),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(savedText,
//                           style: TextStyle(
//                               fontSize: 13,
//                               height: 1.5,
//                               color: AppColors.onSurface
//                                   .withValues(alpha: 0.85))),
//                     ),
//                   ],
//                 ),
//               ),
//             ],

//             // ── Media thumbnails ─────────────────────────────────
//             if (mediaList.isNotEmpty) ...[
//               const SizedBox(height: 12),
//               SizedBox(
//                 height: 80,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   itemCount: mediaList.length,
//                   separatorBuilder: (_, __) => const SizedBox(width: 8),
//                   itemBuilder: (context, i) => Stack(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(10),
//                         child: kIsWeb
//                             ? Image.network(
//                                 mediaList[i],
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               )
//                             : Image.file(
//                                 File(mediaList[i]),
//                                 width: 80,
//                                 height: 80,
//                                 fit: BoxFit.cover,
//                               ),
//                       ),
//                       Positioned(
//                         top: 3,
//                         right: 3,
//                         child: GestureDetector(
//                           onTap: () =>
//                               setState(() => mediaList.removeAt(i)),
//                           child: Container(
//                             width: 20,
//                             height: 20,
//                             decoration: BoxDecoration(
//                               color: Colors.black.withValues(alpha: 0.6),
//                               shape: BoxShape.circle,
//                             ),
//                             child: const Icon(Icons.close,
//                                 size: 12, color: Colors.white),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildAnswerToggle(String code, String currentAnswer) {
//     const options = ['YES', 'NO', 'NA'];
//     return Row(
//       children: options.map((option) {
//         final isSelected = currentAnswer == option;
//         final displayLabel = option == 'NA' ? 'N/A' : option;
//         return Expanded(
//           child: Padding(
//             padding: EdgeInsets.only(right: option != 'NA' ? 8 : 0),
//             child: GestureDetector(
//               onTap: () =>
//                   setState(() => _answers[code] = isSelected ? '' : option),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 height: 44,
//                 decoration: BoxDecoration(
//                   color: isSelected ? _getOptionColor(option) : Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(
//                     color: isSelected
//                         ? _getOptionColor(option)
//                         : const Color(0xFFD5D8E0),
//                     width: 1.5,
//                   ),
//                 ),
//                 alignment: Alignment.center,
//                 child: Text(displayLabel,
//                     style: TextStyle(
//                         color: isSelected
//                             ? Colors.white
//                             : AppColors.onSurface,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 14)),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }

//   Widget _buildFooter(
//       BuildContext context, bool isFirst, bool isLast, int total) {
//     return Container(
//       color: Colors.white,
//       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Divider(
//               color: AppColors.outline.withValues(alpha: 0.15), height: 1),
//           const SizedBox(height: 8),
//           Text('$_answered of $total answered in this section',
//               style: TextStyle(
//                   color: AppColors.secondary.withValues(alpha: 0.7),
//                   fontSize: 13)),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: OutlinedButton(
//                     onPressed: isFirst
//                         ? null
//                         : () => setState(() => _currentSectionIndex--),
//                     style: OutlinedButton.styleFrom(
//                       side: const BorderSide(color: Color(0xFFD5D8E0)),
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                     ),
//                     child: Text('PREVIOUS',
//                         style: TextStyle(
//                             fontWeight: FontWeight.w700,
//                             fontSize: 14,
//                             color: isFirst
//                                 ? AppColors.outline.withValues(alpha: 0.4)
//                                 : AppColors.onSurface,
//                             letterSpacing: 0.5)),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: SizedBox(
//                   height: 50,
//                   child: FilledButton(
//                     onPressed: () => isLast
//                         ? _popWithResult()
//                         : setState(() => _currentSectionIndex++),
//                     style: FilledButton.styleFrom(
//                       backgroundColor: _headerColor,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(14)),
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Text(isLast ? 'FINISH' : 'SAVE & NEXT',
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 14,
//                                 letterSpacing: 0.5)),
//                         if (!isLast) ...[
//                           const SizedBox(width: 8),
//                           const Icon(Icons.arrow_forward, size: 18),
//                         ],
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/action_page.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

// ignore_for_file: library_private_types_in_public_api

class StockpileChecklistPage extends StatefulWidget {
  final int sectionIndex;
  final List<StockpileSection> sections;
  final Map<String, String> answers;
  final Map<String, String> comments;
  final Map<String, List<String>> mediaFiles;
  final Map<String, String> actions; // ← new: encoded action per question code
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
    required this.mediaFiles,
    required this.actions, // ← new
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
  static const _headerColor = Color(0xFF1F579C);

  late int _currentSectionIndex;
  late Map<String, String> _answers;
  late Map<String, String> _comments;
  late Map<String, List<String>> _mediaFiles;
  late Map<String, String> _actions; // ← new

  final Set<String> _expandedNotes = <String>{};
  final Set<String> _savedNotes = <String>{};
  final Map<String, TextEditingController> _controllers = {};

  final ImagePicker _imagePicker = ImagePicker();

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

  @override
  void initState() {
    super.initState();
    _currentSectionIndex = widget.sectionIndex;
    _answers = Map.from(widget.answers);
    _comments = Map.from(widget.comments);
    _actions = Map.from(widget.actions); // ← new

    // Deep-copy media so edits don't mutate the parent's map
    _mediaFiles = Map.fromEntries(
      widget.mediaFiles.entries.map(
        (e) => MapEntry(e.key, List<String>.from(e.value)),
      ),
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

  TextEditingController _controller(String code) => _controllers.putIfAbsent(
        'c:$code',
        () => TextEditingController(text: _comments[code] ?? ''),
      );

  TextEditingController _answerController(String code) =>
      _controllers.putIfAbsent(
        'a:$code',
        () => TextEditingController(text: _answers[code] ?? ''),
      );

  /// Returns answers + comments + media + actions back to the overview page.
  /// Keys:  a:<code>   → answer string
  ///        c:<code>   → comment string
  ///        m:<code>   → image paths joined by '||'
  ///        act:<code> → encoded action string
  void _popWithResult() {
    final result = <String, String>{};
    for (final e in _answers.entries) result['a:${e.key}'] = e.value;
    for (final e in _comments.entries) result['c:${e.key}'] = e.value;
    for (final e in _mediaFiles.entries) result['m:${e.key}'] = e.value.join('||');
    for (final e in _actions.entries) result['act:${e.key}'] = e.value; // ← new
    Navigator.of(context).pop(result);
  }

  StockpileSection get _currentSection =>
      widget.sections[_currentSectionIndex];

  int get _answered => _currentSection.questions
      .where((q) => (_answers[q.code] ?? '').isNotEmpty)
      .length;

  // ─── Action ───────────────────────────────────────────────────────────────

  Future<void> _openActionPage(StockpileQuestion question) async {
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

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ─── Media ────────────────────────────────────────────────────────────────

  Future<void> _pickFromCamera(String code) async {
    Navigator.of(context).pop();
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );
      if (file != null && mounted) {
        setState(() => _mediaFiles.putIfAbsent(code, () => []).add(file.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Camera error: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery(String code) async {
    Navigator.of(context).pop();
    try {
      final XFile? file = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (file != null && mounted) {
        setState(() => _mediaFiles.putIfAbsent(code, () => []).add(file.path));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gallery error: $e')),
        );
      }
    }
  }

  void _showMediaPopup(String code) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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
                    borderRadius: BorderRadius.circular(2),
                  ),
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
                      borderRadius: BorderRadius.circular(12),
                    ),
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

  // ─────────────────────────────────────────────────────────────────────────

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

  Widget _buildQuestionCard(StockpileQuestion question) {
    if (question.type == StockpileQuestionType.text) {
      return _buildTextInputCard(question);
    }
    return _buildYesNoCard(question);
  }

  // ─── Text input card ──────────────────────────────────────────────────────

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
                  color: _headerColor,
                  borderRadius: BorderRadius.circular(10)),
              alignment: Alignment.center,
              child: Text(question.code,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w700)),
            ),
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
                          borderSide: const BorderSide(
                              color: Color(0xFFE0E3EA), width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                              color: _headerColor, width: 1.5),
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
      ),
    );
  }

  // ─── Yes/No card ──────────────────────────────────────────────────────────

  Widget _buildYesNoCard(StockpileQuestion question) {
    final code = question.code;
    final answer = _answers[code] ?? '';
    final mediaList = _mediaFiles[code] ?? [];
    final mediaCount = mediaList.length;
    final showNoteField = _expandedNotes.contains(code);
    final isSaved = _savedNotes.contains(code);
    final savedText = _comments[code] ?? '';
    final hasAction = _actions.containsKey(code);

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
            // ── Question header ──────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                      color: _headerColor,
                      borderRadius: BorderRadius.circular(10)),
                  alignment: Alignment.center,
                  child: Text(code,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
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

            // ── YES / NO / NA toggle ─────────────────────────────
            _buildAnswerToggle(code, answer),
            const SizedBox(height: 14),

            // ── Bottom action row ────────────────────────────────
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add note — LEFT
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
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 7),
                    decoration: const BoxDecoration(),
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

                // Media — RIGHT
                GestureDetector(
                  onTap: () => _showMediaPopup(code),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 7),
                    decoration: const BoxDecoration(),
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

                // Action — RIGHT (turns amber when created)
                GestureDetector(
                  onTap: () => _openActionPage(question),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 7),
                    decoration: const BoxDecoration(),
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

            // ── Note: typing state ───────────────────────────────
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
                      borderSide: const BorderSide(
                          color: Color(0xFFE0E3EA), width: 1),
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
                  // ✗ Discard
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
                            color: const Color(0xFFEF4444)
                                .withValues(alpha: 0.3)),
                      ),
                      child: const Icon(Icons.close,
                          size: 18, color: Color(0xFFEF4444)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // ✓ Confirm
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
                            color: const Color(0xFF10B981)
                                .withValues(alpha: 0.4)),
                      ),
                      child: const Icon(Icons.check,
                          size: 18, color: Color(0xFF10B981)),
                    ),
                  ),
                ],
              ),
            ],

            // ── Note: saved/read-only state ──────────────────────
            if (isSaved && savedText.isNotEmpty && !showNoteField) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: _headerColor.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: _headerColor.withValues(alpha: 0.15)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.notes_outlined,
                        size: 16,
                        color: _headerColor.withValues(alpha: 0.7)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(savedText,
                          style: TextStyle(
                              fontSize: 13,
                              height: 1.5,
                              color: AppColors.onSurface
                                  .withValues(alpha: 0.85))),
                    ),
                  ],
                ),
              ),
            ],

            // ── Media thumbnails ─────────────────────────────────
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
                            ? Image.network(
                                mediaList[i],
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(mediaList[i]),
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                      ),
                      Positioned(
                        top: 3,
                        right: 3,
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => mediaList.removeAt(i)),
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

            // ── Action summary card ──────────────────────────────
            if (hasAction) ...[
              const SizedBox(height: 12),
              _buildActionSummaryCard(code, question),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Action summary card ──────────────────────────────────────────────────

  Widget _buildActionSummaryCard(String code, StockpileQuestion question) {
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
            color: const Color(0xFFF59E0B).withValues(alpha: 0.4),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Lightning icon badge
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
                  // Title + priority chip
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          action.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A2340),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: action.priority.bgColor,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: action.priority.color.withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          '${action.priority.prefix} ${action.priority.label}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: action.priority.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Description
                  if (action.description.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    Text(
                      action.description,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF6B7280), height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  // Assignee + due date + tap to edit
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
                  color: isSelected ? _getOptionColor(option) : Colors.white,
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
                        color: isSelected ? Colors.white : AppColors.onSurface,
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
                    onPressed: () => isLast
                        ? _popWithResult()
                        : setState(() => _currentSectionIndex++),
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