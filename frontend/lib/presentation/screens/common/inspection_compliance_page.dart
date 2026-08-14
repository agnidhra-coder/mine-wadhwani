// lib/presentation/screens/common/inspection_compliance_page.dart
//
// Generic sign-off / compliance page used by ALL inspection types.
// Replaces StockpileCompliancePage. Pass any List<InspectionSection>.

import 'dart:convert';
import 'dart:ui' as ui;

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
import 'package:mine_wadhwani/data/models/health_assessment/health_assessment_model.dart';
import 'package:mine_wadhwani/presentation/screens/common/inspection_report_preview_page.dart';
import 'package:mine_wadhwani/presentation/screens/common/inspection_section.dart';

// ── Custom Signature Painter ───────────────────────────────────────────────
class _SignaturePainter extends CustomPainter {
  final List<List<Offset>> strokes;
  final List<Offset> currentStroke;

  _SignaturePainter({required this.strokes, required this.currentStroke});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    for (final stroke in [...strokes, currentStroke]) {
      if (stroke.isEmpty) continue;
      if (stroke.length == 1) {
        canvas.drawCircle(stroke.first, 1.5,
            Paint()
              ..color = Colors.black
              ..style = PaintingStyle.fill);
        continue;
      }
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (int i = 1; i < stroke.length - 1; i++) {
        final mid = Offset(
          (stroke[i].dx + stroke[i + 1].dx) / 2,
          (stroke[i].dy + stroke[i + 1].dy) / 2,
        );
        path.quadraticBezierTo(stroke[i].dx, stroke[i].dy, mid.dx, mid.dy);
      }
      path.lineTo(stroke.last.dx, stroke.last.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(_SignaturePainter old) =>
      old.strokes != strokes || old.currentStroke != currentStroke;
}

// ── Main Page ──────────────────────────────────────────────────────────────
class InspectionCompliancePage extends StatefulWidget {
  final String company;
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;
  final List<InspectionSection> sections;
  final Map<String, String> answers;
  final Map<String, String> comments;
  final Map<String, List<String>> mediaFiles;
  final Map<String, String> actions;
  final String inspectorName;
  final String inspectorRole;
  final HealthAssessmentModel? healthAssessment;

  const InspectionCompliancePage({
    super.key,
    required this.company,
    required this.mineName,
    required this.mineType,
    required this.area,
    required this.shift,
    required this.inspectionType,
    required this.sections,
    required this.answers,
    required this.comments,
    required this.mediaFiles,
    required this.actions,
    required this.inspectorName,
    required this.inspectorRole,
    this.healthAssessment,
  });

  @override
  State<InspectionCompliancePage> createState() =>
      _InspectionCompliancePageState();
}

class _InspectionCompliancePageState extends State<InspectionCompliancePage> {
  static const _headerColor = Color(0xFF1F579C);

  final TextEditingController _observationsController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  final List<List<Offset>> _strokes = [];
  List<Offset> _currentStroke = [];
  bool _signatureEmpty = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.inspectorName;
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
    _observationsController.dispose();
    _nameController.dispose();
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

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty && !_signatureEmpty;

  // ─── Signature capture ────────────────────────────────────────────────────

  Future<Uint8List?> _captureSignature() async {
    if (_strokes.isEmpty) return null;
    try {
      final recorder = ui.PictureRecorder();
      final canvas =
          Canvas(recorder, const Rect.fromLTWH(0, 0, 600, 200));
      canvas.drawRect(const Rect.fromLTWH(0, 0, 600, 200),
          Paint()..color = Colors.white);
      _SignaturePainter(strokes: _strokes, currentStroke: [])
          .paint(canvas, const Size(600, 200));
      final picture = recorder.endRecording();
      final img = await picture.toImage(600, 200);
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  // ─── Submit ───────────────────────────────────────────────────────────────

  void _validateAndSubmit(BuildContext context) async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name before submitting.');
      return;
    }
    if (_signatureEmpty) {
      _showError('Please sign before submitting.');
      return;
    }

    final checklistData = <ChecklistModel>[];
    for (final section in widget.sections) {
      for (final q in section.questions) {
        checklistData.add(ChecklistModel(
          mainTopic: section.title,
          subTopic: '',
          questionCode: q.code,
          questionText: q.text,
          answer: widget.answers[q.code] ?? '',
          comment: widget.comments[q.code] ?? '',
          imageUrls: widget.mediaFiles[q.code] ?? [],
          action: widget.actions[q.code] ?? '',
        ));
      }
    }

    final authState = context.read<AuthBloc>().state;
    final supervisorId = authState is Authenticated ? authState.user.id : '';

    String signatureBase64 = '';
    final signatureBytes = await _captureSignature();
    if (signatureBytes != null) {
      signatureBase64 = base64Encode(signatureBytes);
    }

    if (!mounted) return;

    context.read<ChecklistBloc>().add(SetCustomChecklistData(checklistData));
    context.read<ChecklistBloc>().add(
          SubmitChecklist(
            supervisorId: supervisorId,
            mineName: widget.mineName,
            mineType: widget.mineType,
            area: widget.area,
            shift: widget.shift,
            inspectionType: widget.inspectionType,
            completed: true,
            observations: _observationsController.text.trim(),
            signature: signatureBase64,
          ),
        );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<void> _openPreview() async {
    if (!_canSubmit) return;
    final signatureBytes = await _captureSignature();
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => InspectionReportPreviewPage(
          company: widget.company,
          mineName: widget.mineName,
          mineType: widget.mineType,
          area: widget.area,
          shift: widget.shift,
          inspectionType: widget.inspectionType,
          sections: widget.sections,
          answers: widget.answers,
          comments: widget.comments,
          mediaFiles: widget.mediaFiles,
          actions: widget.actions,
          inspectorName: _nameController.text.trim(),
          inspectorRole: widget.inspectorRole,
          observations: _observationsController.text.trim(),
          signatureBytes: signatureBytes,
          reviewedAt: DateTime.now(),
          healthAssessment: widget.healthAssessment,
        ),
      ),
    );
  }

  // ─── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return BlocProvider(
      create: (_) => sl<ChecklistBloc>(),
      child: BlocConsumer<ChecklistBloc, ChecklistState>(
        listener: (context, state) {
          if (state is ChecklistSubmitted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                title: const Row(
                  children: [
                    Icon(Icons.check_circle_outline,
                        color: Color(0xFF10B981), size: 24),
                    SizedBox(width: 10),
                    Text('Inspection Submitted'),
                  ],
                ),
                content: const Text(
                    'The inspection has been submitted and saved successfully.'),
                actions: [
                  FilledButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    style: FilledButton.styleFrom(
                        backgroundColor: _headerColor),
                    child: const Text('Done'),
                  ),
                ],
              ),
            );
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
            body: Column(
              children: [
                _buildHeader(statusBarHeight),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Left panel — Observations + Name
                      Expanded(
                        flex: 5,
                        child: SingleChildScrollView(
                          padding:
                              const EdgeInsets.fromLTRB(24, 20, 12, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('GENERAL OBSERVATIONS',
                                  optional: true),
                              const SizedBox(height: 10),
                              _buildObservationsCard(),
                              const SizedBox(height: 16),
                              _buildSectionLabel('EVALUATOR NAME'),
                              const SizedBox(height: 10),
                              _buildNameField(),
                            ],
                          ),
                        ),
                      ),
                      // Right panel — Signature
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12, 20, 24, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionLabel('SIGNATURE'),
                              const SizedBox(height: 10),
                              SizedBox(
                                height: 200,
                                child: _buildSignatureCanvas(),
                              ),
                              const SizedBox(height: 8),
                              _buildSignatureFooter(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                _buildFooter(context, isSubmitting),
              ],
            ),
          );
        },
      ),
    );
  }

  // ─── Header ───────────────────────────────────────────────────────────────

  Widget _buildHeader(double statusBarHeight) {
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
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
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
                        'Complete Inspection',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Sign off before submitting or previewing',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final user =
                        state is Authenticated ? state.user : null;
                    if (user == null) return const SizedBox.shrink();
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.person_outline,
                              color: Colors.white, size: 14),
                          const SizedBox(width: 6),
                          Text(
                            '${user.name}  •  ${user.role}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Signature canvas ─────────────────────────────────────────────────────

  Widget _buildSignatureCanvas() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _signatureEmpty
              ? const Color(0xFFE0E3EA)
              : _headerColor.withValues(alpha: 0.4),
          width: _signatureEmpty ? 1 : 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Stack(
          fit: StackFit.expand,
          children: [
            GestureDetector(
              onPanStart: (details) {
                setState(() {
                  _currentStroke = [details.localPosition];
                  _signatureEmpty = false;
                });
              },
              onPanUpdate: (details) {
                setState(() => _currentStroke.add(details.localPosition));
              },
              onPanEnd: (_) {
                setState(() {
                  if (_currentStroke.isNotEmpty) {
                    _strokes.add(List.of(_currentStroke));
                  }
                  _currentStroke = [];
                });
              },
              child: CustomPaint(
                painter: _SignaturePainter(
                    strokes: _strokes, currentStroke: _currentStroke),
                child: const SizedBox.expand(),
              ),
            ),
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: IgnorePointer(
                child: Container(height: 1, color: const Color(0xFFE0E3EA)),
              ),
            ),
            if (_signatureEmpty)
              IgnorePointer(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.draw_outlined,
                          size: 28,
                          color: AppColors.outline.withValues(alpha: 0.4)),
                      const SizedBox(height: 8),
                      Text('Sign here',
                          style: TextStyle(
                              fontSize: 13,
                              color:
                                  AppColors.outline.withValues(alpha: 0.4))),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignatureFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          _signatureEmpty ? 'Draw your signature above' : 'Signature captured ✓',
          style: TextStyle(
            fontSize: 12,
            color: _signatureEmpty
                ? AppColors.secondary.withValues(alpha: 0.6)
                : const Color(0xFF10B981),
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton.icon(
          onPressed: () {
            setState(() {
              _strokes.clear();
              _currentStroke = [];
              _signatureEmpty = true;
            });
          },
          icon: const Icon(Icons.refresh, size: 14),
          label: const Text('Clear'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            textStyle: const TextStyle(fontSize: 12),
          ),
        ),
      ],
    );
  }

  // ─── Form fields ──────────────────────────────────────────────────────────

  Widget _buildObservationsCard() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme:
            Theme.of(context).colorScheme.copyWith(primary: _headerColor),
      ),
      child: TextField(
        controller: _observationsController,
        cursorColor: _headerColor,
        maxLines: 6,
        minLines: 6,
        decoration: InputDecoration(
          hintText:
              'Enter general observations, hazards noted, or recommendations for corrective action...',
          hintStyle: TextStyle(
              color: AppColors.outline.withValues(alpha: 0.5), fontSize: 13),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFE0E3EA), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _headerColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme:
            Theme.of(context).colorScheme.copyWith(primary: _headerColor),
      ),
      child: TextField(
        controller: _nameController,
        cursorColor: _headerColor,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: 'Full name of inspector',
          prefixIcon: const Icon(Icons.person_outline,
              color: _headerColor, size: 20),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFE0E3EA), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: _headerColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  // ─── Footer ───────────────────────────────────────────────────────────────

  Widget _buildFooter(BuildContext context, bool isSubmitting) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Divider(color: Color(0xFFE0E3EA), height: 1),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _canSubmit ? _openPreview : null,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text('Preview & Export',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3)),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _canSubmit
                            ? _headerColor
                            : const Color(0xFFBDBDBD),
                        side: BorderSide(
                          color: _canSubmit
                              ? _headerColor
                              : const Color(0xFFE0E3EA),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        backgroundColor: _canSubmit
                            ? _headerColor.withValues(alpha: 0.05)
                            : const Color(0xFFF5F5F5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _canSubmit && !isSubmitting
                          ? () => _validateAndSubmit(context)
                          : null,
                      icon: isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.send_rounded, size: 18),
                      label: Text(
                        isSubmitting ? 'Submitting...' : 'Submit & Close',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor:
                            _canSubmit ? _headerColor : const Color(0xFFE0E3EA),
                        foregroundColor:
                            _canSubmit ? Colors.white : const Color(0xFFBDBDBD),
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

  Widget _buildSectionLabel(String label, {bool optional = false}) {
    return Row(
      children: [
        Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: AppColors.secondary.withValues(alpha: 0.7),
              letterSpacing: 1.0,
            )),
        if (optional) ...[
          const SizedBox(width: 6),
          Text('(optional)',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: AppColors.secondary.withValues(alpha: 0.45),
                letterSpacing: 0.2,
              )),
        ],
      ],
    );
  }
}