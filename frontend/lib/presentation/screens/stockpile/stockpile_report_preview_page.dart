import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/action_page.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';

class StockpileReportPreviewPage extends StatefulWidget {
  final String company;
  final String mineName;
  final String mineType;
  final String area;
  final int shift;
  final String inspectionType;
  final List<StockpileSection> sections;
  final Map<String, String> answers;
  final Map<String, String> comments;
  final Map<String, List<String>> mediaFiles;
  final Map<String, String> actions; // ← NEW
  final String inspectorName;
  final String inspectorRole;
  final String observations;
  final Uint8List? signatureBytes;
  final DateTime reviewedAt;

  const StockpileReportPreviewPage({
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
    required this.actions, // ← NEW
    required this.inspectorName,
    required this.inspectorRole,
    required this.observations,
    required this.signatureBytes,
    required this.reviewedAt,
  });

  @override
  State<StockpileReportPreviewPage> createState() =>
      _StockpileReportPreviewPageState();
}

class _StockpileReportPreviewPageState
    extends State<StockpileReportPreviewPage> {
  static const _headerColor = Color(0xFF1F579C);
  bool _isGenerating = false;

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

  // ── Computed values ─────────────────────────────────────────────────

  int get _totalAnswered => widget.sections
      .fold(0, (sum, s) => sum + _answeredInSection(s));

  int get _totalQuestions =>
      widget.sections.fold(0, (sum, s) => sum + s.questions.length);

  int _answeredInSection(StockpileSection s) => s.questions
      .where((q) => (widget.answers[q.code] ?? '').isNotEmpty)
      .length;

  int get _flaggedCount => widget.answers.values
      .where((v) => v == 'NO')
      .length;

  // ← FIXED: count actual created actions, not NO answers
  int get _actionsCount => widget.actions.length;

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour < 12 ? 'AM' : 'PM';
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, $h:$m $ampm';
  }

  String _formatShortDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  Color _answerColor(String answer) {
    switch (answer) {
      case 'YES':
        return const Color(0xFF10B981);
      case 'NO':
        return const Color(0xFFEF4444);
      case 'NA':
        return const Color(0xFF9CA3AF);
      default:
        return const Color(0xFFE0E3EA);
    }
  }

  // ── PDF Generation ───────────────────────────────────────────────────

  Future<Uint8List> _generatePdf() async {
    final pdf = pw.Document();

    pw.ImageProvider? logoImage;
    try {
      final logoData = await rootBundle.load('assets/images/app_icon.png');
      logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
    } catch (_) {}

    pw.ImageProvider? sigImage;
    if (widget.signatureBytes != null) {
      sigImage = pw.MemoryImage(widget.signatureBytes!);
    }

    final scorePercent = _totalQuestions > 0
        ? (_totalAnswered / _totalQuestions * 100).toStringAsFixed(0)
        : '0';

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) => [
          // ── Header ──────────────────────────────────────────────────
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              if (logoImage != null)
                pw.Container(
                  width: 56,
                  height: 56,
                  child: pw.Image(logoImage),
                ),
              if (logoImage != null) pw.SizedBox(width: 14),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Stockpile Inspection',
                      style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#1F579C'),
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      widget.inspectionType,
                      style: pw.TextStyle(
                        fontSize: 11,
                        color: PdfColor.fromHex('#6B7280'),
                      ),
                    ),
                  ],
                ),
              ),
              pw.Container(
                padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex('#D1FAE5'),
                  borderRadius: pw.BorderRadius.circular(20),
                ),
                child: pw.Text(
                  'Complete',
                  style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#065F46'),
                  ),
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 16),

          // ── Score row ────────────────────────────────────────────────
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                  color: PdfColor.fromHex('#E0E3EA'), width: 1),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              children: [
                _pdfScoreCell(
                    'Score',
                    '$_totalAnswered / $_totalQuestions ($scorePercent%)',
                    flex: 3),
                _pdfDivider(),
                _pdfScoreCell('Flagged items', '$_flaggedCount', flex: 2),
                _pdfDivider(),
                _pdfScoreCell('Actions', '$_actionsCount', flex: 2),
              ],
            ),
          ),
          pw.SizedBox(height: 16),

          // ── Conducted on / Evaluator ─────────────────────────────────
          pw.Container(
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                  color: PdfColor.fromHex('#E0E3EA'), width: 1),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Conducted on',
                            style: pw.TextStyle(
                                fontSize: 9,
                                color: PdfColor.fromHex('#9CA3AF'))),
                        pw.SizedBox(height: 3),
                        pw.Text(_formatDate(widget.reviewedAt),
                            style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#1A2340'))),
                      ],
                    ),
                  ),
                ),
                pw.Container(
                    width: 1,
                    height: 40,
                    color: PdfColor.fromHex('#E0E3EA')),
                pw.Expanded(
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(10),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Evaluator',
                            style: pw.TextStyle(
                                fontSize: 9,
                                color: PdfColor.fromHex('#9CA3AF'))),
                        pw.SizedBox(height: 3),
                        pw.Text(
                            '${widget.inspectorName} (${widget.inspectorRole})',
                            style: pw.TextStyle(
                                fontSize: 11,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColor.fromHex('#1A2340'))),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // ── Inspection Details ───────────────────────────────────────
          pw.Text('INSPECTION DETAILS',
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#1F579C'),
                  letterSpacing: 0.5)),
          pw.SizedBox(height: 8),
          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(
                  color: PdfColor.fromHex('#E0E3EA'), width: 1),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                _pdfDetailRow('Company', widget.company),
                _pdfDetailRow('Subsidiary', widget.mineName),
                _pdfDetailRow('Mine Type', widget.mineType),
                _pdfDetailRow('Mine Name', widget.area),
                _pdfDetailRow('Shift', 'Shift ${widget.shift}'),
                _pdfDetailRow('Inspection Type', widget.inspectionType),
              ],
            ),
          ),
          pw.SizedBox(height: 20),

          // ── Flagged Items ────────────────────────────────────────────
          if (_flaggedCount > 0) ...[
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FEF2F2'),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Flagged items',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#991B1B'))),
                  pw.Text('$_flaggedCount flagged',
                      style: pw.TextStyle(
                          fontSize: 11,
                          color: PdfColor.fromHex('#991B1B'))),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            ...widget.sections.expand((section) {
              final flagged = section.questions
                  .where((q) => widget.answers[q.code] == 'NO')
                  .toList();
              if (flagged.isEmpty) return <pw.Widget>[];
              return [
                pw.Text(
                  'SECTION ${widget.sections.indexOf(section) + 1}: ${section.title.toUpperCase()}',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#6B7280'),
                      letterSpacing: 0.5),
                ),
                pw.SizedBox(height: 4),
                ...flagged.map((q) => pw.Padding(
                      padding: const pw.EdgeInsets.only(bottom: 6),
                      child: pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Expanded(
                            child: pw.Text(
                              '${q.code}. ${q.text}',
                              style: pw.TextStyle(
                                  fontSize: 10,
                                  color: PdfColor.fromHex('#374151')),
                            ),
                          ),
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: pw.BoxDecoration(
                              color: PdfColor.fromHex('#EF4444'),
                              borderRadius: pw.BorderRadius.circular(4),
                            ),
                            child: pw.Text('NO',
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColors.white)),
                          ),
                        ],
                      ),
                    )),
                pw.SizedBox(height: 8),
              ];
            }),
            pw.SizedBox(height: 12),
          ],

          // ── Actions ──────────────────────────────────────────────────
          if (widget.actions.isNotEmpty) ...[
            pw.Container(
              padding: const pw.EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#FFFBEB'),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Actions',
                      style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColor.fromHex('#92400E'))),
                  pw.Text(
                      '${widget.actions.length} action${widget.actions.length == 1 ? '' : 's'}',
                      style: pw.TextStyle(
                          fontSize: 11,
                          color: PdfColor.fromHex('#92400E'))),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            ...widget.sections.expand((section) {
              final actionQuestions = section.questions
                  .where((q) => widget.actions.containsKey(q.code))
                  .toList();
              if (actionQuestions.isEmpty) return <pw.Widget>[];
              return [
                pw.Text(
                  'SECTION ${widget.sections.indexOf(section) + 1}: ${section.title.toUpperCase()}',
                  style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#6B7280'),
                      letterSpacing: 0.5),
                ),
                pw.SizedBox(height: 4),
                ...actionQuestions.map((q) {
                  final action =
                      ChecklistAction.decode(q.code, widget.actions[q.code]!);
                  if (action == null) return pw.SizedBox();
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(10),
                      decoration: pw.BoxDecoration(
                        color: PdfColor.fromHex('#FFFBEB'),
                        borderRadius: pw.BorderRadius.circular(6),
                        border: pw.Border.all(
                            color: PdfColor.fromHex('#F59E0B'), width: 0.5),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment:
                                pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Expanded(
                                child: pw.Text(
                                  '${q.code}. ${action.title}',
                                  style: pw.TextStyle(
                                      fontSize: 10,
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColor.fromHex('#1A2340')),
                                ),
                              ),
                              pw.Text(
                                '${action.priority.prefix} ${action.priority.label}',
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: PdfColor.fromHex('#F59E0B')),
                              ),
                            ],
                          ),
                          if (action.description.isNotEmpty) ...[
                            pw.SizedBox(height: 3),
                            pw.Text(action.description,
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    color: PdfColor.fromHex('#6B7280'))),
                          ],
                          pw.SizedBox(height: 4),
                          pw.Text(
                            'Assignee: ${action.assigneeName}'
                            '${action.dueDate != null ? '   Due: ${_formatShortDate(action.dueDate!)}' : ''}',
                            style: pw.TextStyle(
                                fontSize: 9,
                                color: PdfColor.fromHex('#9CA3AF')),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                pw.SizedBox(height: 8),
              ];
            }),
            pw.SizedBox(height: 12),
          ],

          // ── Checklist Summary ────────────────────────────────────────
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(
                horizontal: 12, vertical: 8),
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex('#EFF6FF'),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            child: pw.Text('CHECKLIST SUMMARY',
                style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#1F579C'))),
          ),
          pw.SizedBox(height: 8),
          ...widget.sections.asMap().entries.map((entry) {
            final i = entry.key;
            final section = entry.value;
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Section ${i + 1}: ${section.title}',
                  style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromHex('#1A2340')),
                ),
                pw.SizedBox(height: 4),
                ...section.questions.map((q) {
                  final answer = widget.answers[q.code] ?? '';
                  final comment = widget.comments[q.code] ?? '';
                  final isUnanswered = answer.isEmpty;
                  PdfColor ansColor;
                  switch (answer) {
                    case 'YES':
                      ansColor = PdfColor.fromHex('#10B981');
                      break;
                    case 'NO':
                      ansColor = PdfColor.fromHex('#EF4444');
                      break;
                    case 'NA':
                      ansColor = PdfColor.fromHex('#9CA3AF');
                      break;
                    default:
                      ansColor = PdfColor.fromHex('#D1D5DB');
                  }
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 5),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Expanded(
                              child: pw.Text(
                                '${q.code}. ${q.text}',
                                style: pw.TextStyle(
                                    fontSize: 10,
                                    color: isUnanswered
                                        ? PdfColor.fromHex('#F59E0B')
                                        : PdfColor.fromHex('#374151')),
                              ),
                            ),
                            pw.SizedBox(width: 8),
                            pw.Container(
                              padding: const pw.EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: pw.BoxDecoration(
                                color: isUnanswered
                                    ? PdfColor.fromHex('#FEF3C7')
                                    : ansColor,
                                borderRadius: pw.BorderRadius.circular(4),
                              ),
                              child: pw.Text(
                                isUnanswered
                                    ? '—'
                                    : (answer == 'NA' ? 'N/A' : answer),
                                style: pw.TextStyle(
                                    fontSize: 9,
                                    fontWeight: pw.FontWeight.bold,
                                    color: isUnanswered
                                        ? PdfColor.fromHex('#92400E')
                                        : PdfColors.white),
                              ),
                            ),
                          ],
                        ),
                        if (comment.isNotEmpty)
                          pw.Padding(
                            padding:
                                const pw.EdgeInsets.only(top: 2, left: 12),
                            child: pw.Text(
                              'Note: $comment',
                              style: pw.TextStyle(
                                  fontSize: 9,
                                  color: PdfColor.fromHex('#6B7280'),
                                  fontStyle: pw.FontStyle.italic),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                pw.SizedBox(height: 10),
              ],
            );
          }),

          // ── Observations ─────────────────────────────────────────────
          if (widget.observations.isNotEmpty) ...[
            pw.Text('General observation/recommendation',
                style: pw.TextStyle(
                    fontSize: 11,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#1A2340'))),
            pw.SizedBox(height: 6),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                    color: PdfColor.fromHex('#E0E3EA'), width: 1),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Text(widget.observations,
                  style: pw.TextStyle(
                      fontSize: 10,
                      color: PdfColor.fromHex('#374151'),
                      lineSpacing: 4)),
            ),
            pw.SizedBox(height: 16),
          ],

          // ── Signature ────────────────────────────────────────────────
          pw.Text('Name and Signature of the evaluator',
              style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#1A2340'))),
          pw.SizedBox(height: 8),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(widget.inspectorName,
                        style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColor.fromHex('#1A2340'))),
                    pw.Text(widget.inspectorRole,
                        style: pw.TextStyle(
                            fontSize: 10,
                            color: PdfColor.fromHex('#6B7280'))),
                  ],
                ),
              ),
              if (sigImage != null)
                pw.Container(
                  width: 180,
                  height: 60,
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(
                        color: PdfColor.fromHex('#E0E3EA'), width: 1),
                    borderRadius: pw.BorderRadius.circular(6),
                  ),
                  child: pw.Image(sigImage, fit: pw.BoxFit.contain),
                ),
            ],
          ),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _pdfScoreCell(String label, String value, {int flex = 1}) {
    return pw.Expanded(
      flex: flex,
      child: pw.Padding(
        padding:
            const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(label,
                style: pw.TextStyle(
                    fontSize: 9, color: PdfColor.fromHex('#6B7280'))),
            pw.SizedBox(height: 3),
            pw.Text(value,
                style: pw.TextStyle(
                    fontSize: 12,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColor.fromHex('#1A2340'))),
          ],
        ),
      ),
    );
  }

  pw.Widget _pdfDivider() {
    return pw.Container(
        width: 1, height: 48, color: PdfColor.fromHex('#E0E3EA'));
  }

  pw.Widget _pdfDetailRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 5),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 110,
            child: pw.Text('$label:',
                style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColor.fromHex('#6B7280'))),
          ),
          pw.Text(value,
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColor.fromHex('#1A2340'))),
        ],
      ),
    );
  }

  Future<void> _downloadPdf() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = await _generatePdf();
      final fileName =
          'stockpile_inspection_${DateTime.now().millisecondsSinceEpoch}.pdf';

      if (kIsWeb) {
        await Printing.sharePdf(
          bytes: bytes,
          filename: fileName,
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Saved: $fileName'),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle_outline,
                      color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  Text('Saved: $fileName'),
                ],
              ),
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  Future<void> _sharePdf() async {
    setState(() => _isGenerating = true);
    try {
      final bytes = await _generatePdf();
      await Printing.sharePdf(
        bytes: bytes,
        filename:
            'stockpile_inspection_${widget.area}_shift${widget.shift}.pdf',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: const Color(0xFFEF4444),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  // ── Build ────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final scorePercent = _totalQuestions > 0
        ? (_totalAnswered / _totalQuestions * 100).toStringAsFixed(0)
        : '0';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(statusBarHeight),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Report card ────────────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE0E3EA)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header inside card
                        Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'assets/images/app_icon.png',
                                  width: 56,
                                  height: 56,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Stockpile Inspection',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF1A2340),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      widget.inspectionType,
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: AppColors.secondary
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD1FAE5),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Complete',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Divider(color: Color(0xFFE0E3EA), height: 1),

                        // Score row
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              _scoreCell(
                                'Score',
                                '$_totalAnswered / $_totalQuestions ($scorePercent%)',
                                flex: 3,
                              ),
                              const VerticalDivider(
                                  color: Color(0xFFE0E3EA), width: 1),
                              _scoreCell(
                                'Flagged items',
                                '$_flaggedCount',
                                flex: 2,
                                valueColor: _flaggedCount > 0
                                    ? const Color(0xFFEF4444)
                                    : null,
                              ),
                              const VerticalDivider(
                                  color: Color(0xFFE0E3EA), width: 1),
                              _scoreCell(
                                'Actions',
                                '$_actionsCount',
                                flex: 2,
                                valueColor: _actionsCount > 0
                                    ? const Color(0xFFF59E0B)
                                    : null,
                              ),
                            ],
                          ),
                        ),

                        const Divider(color: Color(0xFFE0E3EA), height: 1),

                        // Conducted on / Evaluator
                        IntrinsicHeight(
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Conducted on',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.secondary
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        _formatDate(widget.reviewedAt),
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A2340),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const VerticalDivider(
                                  color: Color(0xFFE0E3EA), width: 1),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Evaluator',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: AppColors.secondary
                                              .withValues(alpha: 0.6),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '${widget.inspectorName} (${widget.inspectorRole})',
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF1A2340),
                                        ),
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
                  ),

                  const SizedBox(height: 20),

                  // ── Inspection Details ─────────────────────────────
                  _sectionTitle('INSPECTION DETAILS'),
                  const SizedBox(height: 10),
                  _detailsCard(),

                  // ── Flagged Items ──────────────────────────────────
                  if (_flaggedCount > 0) ...[
                    const SizedBox(height: 20),
                    _flaggedItemsSection(),
                  ],

                  // ── Actions ────────────────────────────────────────
                  if (_actionsCount > 0) ...[
                    const SizedBox(height: 20),
                    _actionsSection(),
                  ],

                  // ── Checklist Summary ──────────────────────────────
                  const SizedBox(height: 20),
                  _checklistSummarySection(),

                  // ── Observations ───────────────────────────────────
                  if (widget.observations.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _sectionTitle('GENERAL OBSERVATION/RECOMMENDATION'),
                    const SizedBox(height: 10),
                    _observationsCard(),
                  ],

                  // ── Signature ──────────────────────────────────────
                  const SizedBox(height: 20),
                  _signatureSection(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────

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
                        'Report Preview',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Read-only — download or share below',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_isGenerating)
                  const Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
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

  // ── Score cell ────────────────────────────────────────────────────────

  Widget _scoreCell(String label, String value,
      {int flex = 1, Color? valueColor}) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.secondary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: valueColor ?? const Color(0xFF1A2340),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Section title ─────────────────────────────────────────────────────

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary.withValues(alpha: 0.7),
        letterSpacing: 1.0,
      ),
    );
  }

  // ── Details card ──────────────────────────────────────────────────────

  Widget _detailsCard() {
    final details = [
      ['Company', widget.company],
      ['Subsidiary', widget.mineName],
      ['Mine Type', widget.mineType],
      ['Mine Name', widget.area],
      ['Shift', 'Shift ${widget.shift}'],
      ['Inspection Type', widget.inspectionType],
    ];
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Column(
        children: details.map((row) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: Text(
                    '${row[0]}:',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    row[1],
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A2340),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Flagged items section ─────────────────────────────────────────────

  Widget _flaggedItemsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFEF2F2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Flagged items',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF991B1B),
                ),
              ),
              Text(
                '$_flaggedCount flagged',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF991B1B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...widget.sections.asMap().entries.expand((entry) {
          final i = entry.key;
          final section = entry.value;
          final flagged = section.questions
              .where((q) => widget.answers[q.code] == 'NO')
              .toList();
          if (flagged.isEmpty) return <Widget>[];
          return [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'SECTION ${i + 1}: ${section.title.toUpperCase()}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary.withValues(alpha: 0.6),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...flagged.map((q) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${q.code}. ${q.text}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'NO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ];
        }),
      ],
    );
  }

  // ── Actions section ───────────────────────────────────────────────────

  Widget _actionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Actions',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF92400E),
                ),
              ),
              Text(
                '$_actionsCount action${_actionsCount == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF92400E),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...widget.sections.asMap().entries.expand((entry) {
          final i = entry.key;
          final section = entry.value;
          final actionQuestions = section.questions
              .where((q) => widget.actions.containsKey(q.code))
              .toList();
          if (actionQuestions.isEmpty) return <Widget>[];
          return [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(
                'SECTION ${i + 1}: ${section.title.toUpperCase()}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.secondary.withValues(alpha: 0.6),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            ...actionQuestions.map((q) {
              final action = ChecklistAction.decode(
                  q.code, widget.actions[q.code]!);
              if (action == null) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          const Color(0xFFF59E0B).withValues(alpha: 0.4),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lightning icon badge
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF59E0B)
                              .withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.bolt,
                            size: 16, color: Color(0xFFF59E0B)),
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
                                    '${q.code}. ${action.title}',
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
                                    borderRadius:
                                        BorderRadius.circular(20),
                                    border: Border.all(
                                      color: action.priority.color
                                          .withValues(alpha: 0.4),
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
                              const SizedBox(height: 4),
                              Text(
                                action.description,
                                style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF6B7280),
                                    height: 1.4),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                            const SizedBox(height: 6),
                            // Assignee + due date
                            Row(
                              children: [
                                const Icon(
                                    Icons.person_outline_rounded,
                                    size: 13,
                                    color: Color(0xFF9CA3AF)),
                                const SizedBox(width: 4),
                                Text(
                                  action.assigneeName,
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF9CA3AF),
                                      fontWeight: FontWeight.w500),
                                ),
                                if (action.dueDate != null) ...[
                                  const SizedBox(width: 12),
                                  const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 12,
                                      color: Color(0xFF9CA3AF)),
                                  const SizedBox(width: 4),
                                  Text(
                                    _formatShortDate(action.dueDate!),
                                    style: const TextStyle(
                                        fontSize: 11,
                                        color: Color(0xFF9CA3AF),
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ];
        }),
      ],
    );
  }

  // ── Checklist summary ─────────────────────────────────────────────────

  Widget _checklistSummarySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Text(
            'CHECKLIST SUMMARY/AUDIT',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F579C),
            ),
          ),
        ),
        const SizedBox(height: 12),
        ...widget.sections.asMap().entries.map((entry) {
          final i = entry.key;
          final section = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Section ${i + 1}: ${section.title}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A2340),
                  ),
                ),
                const SizedBox(height: 8),
                ...section.questions.map((q) {
                  final answer = widget.answers[q.code] ?? '';
                  final comment = widget.comments[q.code] ?? '';
                  final mediaList = widget.mediaFiles[q.code] ?? [];
                  final isUnanswered = answer.isEmpty;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                '${q.code}. ${q.text}',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: isUnanswered
                                      ? const Color(0xFFF59E0B)
                                      : const Color(0xFF374151),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isUnanswered
                                    ? const Color(0xFFFEF3C7)
                                    : _answerColor(answer),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isUnanswered
                                    ? '—'
                                    : (answer == 'NA' ? 'N/A' : answer),
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isUnanswered
                                      ? const Color(0xFF92400E)
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (comment.isNotEmpty || mediaList.isNotEmpty)
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4, left: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (comment.isNotEmpty)
                                  Text(
                                    'Note: $comment',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.secondary
                                          .withValues(alpha: 0.7),
                                    ),
                                  ),
                                if (mediaList.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  SizedBox(
                                    height: 50,
                                    child: ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: mediaList.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(width: 6),
                                      itemBuilder: (_, idx) => ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(6),
                                        child: kIsWeb
                                            ? Image.network(
                                                mediaList[idx],
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.file(
                                                File(mediaList[idx]),
                                                width: 50,
                                                height: 50,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ── Observations card ─────────────────────────────────────────────────

  Widget _observationsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Text(
        widget.observations,
        style: const TextStyle(
          fontSize: 13,
          color: Color(0xFF374151),
          height: 1.6,
        ),
      ),
    );
  }

  // ── Signature section ─────────────────────────────────────────────────

  Widget _signatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('NAME AND SIGNATURE OF THE EVALUATOR'),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.inspectorName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A2340),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.inspectorRole,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.secondary.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            if (widget.signatureBytes != null) ...[
              const SizedBox(width: 24),
              Container(
                width: 200,
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE0E3EA)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.memory(
                    widget.signatureBytes!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  // ── Footer ────────────────────────────────────────────────────────────

  Widget _buildFooter() {
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
                // Download
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _isGenerating ? null : _downloadPdf,
                      icon: _isGenerating
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: _headerColor),
                            )
                          : const Icon(Icons.download_outlined, size: 18),
                      label: const Text(
                        'Download',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _headerColor,
                        side: const BorderSide(
                            color: _headerColor, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        backgroundColor:
                            _headerColor.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Share
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _isGenerating ? null : _sharePdf,
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text(
                        'Share',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _headerColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
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
}