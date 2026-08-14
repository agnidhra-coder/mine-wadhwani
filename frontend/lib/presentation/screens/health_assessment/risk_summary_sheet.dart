import 'dart:math' as math;
import 'package:flutter/material.dart';

class RiskSummarySheet extends StatefulWidget {
  final int flagCount;
  final int totalChecks;
  final List<String> flagDetails;

  const RiskSummarySheet({
    super.key,
    required this.flagCount,
    required this.totalChecks,
    required this.flagDetails,
  });

  static Future<void> show(
    BuildContext context, {
    required int flagCount,
    required int totalChecks,
    required List<String> flagDetails,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RiskSummarySheet(
        flagCount: flagCount,
        totalChecks: totalChecks,
        flagDetails: flagDetails,
      ),
    );
  }

  @override
  State<RiskSummarySheet> createState() => _RiskSummarySheetState();
}

class _RiskSummarySheetState extends State<RiskSummarySheet>
    with SingleTickerProviderStateMixin {
  static const _headerColor = Color(0xFF1F579C);

  bool _analyzing = true;
  late AnimationController _controller;
  late Animation<double> _gaugeAnimation;

  int get _score {
    if (widget.totalChecks == 0) return 0;
    final ratio = widget.flagCount / widget.totalChecks;
    return (ratio * 100).clamp(0, 100).round();
  }

  String get _riskLabel {
    if (widget.flagCount == 0) return 'Low';
    if (widget.flagCount <= 2) return 'Medium';
    return 'High';
  }

  Color get _riskColor {
    if (widget.flagCount == 0) return const Color(0xFF10B981);
    if (widget.flagCount <= 2) return const Color(0xFFF59E0B);
    return const Color(0xFFEF4444);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _gaugeAnimation = Tween<double>(begin: 0, end: _score.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() => _analyzing = false);
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E3EA),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Health Risk Summary',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1A2340)),
            ),
            const SizedBox(height: 4),
            Text(
              'Based on readings entered for this shift',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 180,
              child: _analyzing ? _buildAnalyzing() : _buildGauge(),
            ),
            const SizedBox(height: 8),
            if (!_analyzing) ...[
              AnimatedOpacity(
                opacity: _analyzing ? 0 : 1,
                duration: const Duration(milliseconds: 400),
                child: Column(
                  children: [
                    if (widget.flagDetails.isNotEmpty) _buildFlagDetails(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _headerColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 0,
                ),
                child: const Text('Continue', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyzing() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.4, end: 1.0),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeInOut,
            builder: (context, value, child) => Opacity(
              opacity: value,
              child: SizedBox(
                width: 56,
                height: 56,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(_headerColor.withValues(alpha: 0.6)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Analyzing readings...',
              style: TextStyle(fontSize: 13, color: Colors.grey[500], fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildGauge() {
    return AnimatedBuilder(
      animation: _gaugeAnimation,
      builder: (context, child) {
        return Column(
          children: [
            SizedBox(
              width: 220,
              height: 130,
              child: CustomPaint(
                painter: _GaugePainter(
                  value: _gaugeAnimation.value,
                  color: _riskColor,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${_gaugeAnimation.value.round()}',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: _riskColor,
                          ),
                        ),
                        Text(
                          _riskLabel.toUpperCase(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: _riskColor,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFlagDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: _riskColor.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _riskColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${widget.flagCount} of ${widget.totalChecks} readings flagged',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _riskColor)),
          const SizedBox(height: 6),
          ...widget.flagDetails.map((d) => Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text('• $d', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              )),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double value; // 0-100
  final Color color;

  _GaugePainter({required this.value, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 10;

    // Background track (semicircle, 180°)
    final trackPaint = Paint()
      ..color = const Color(0xFFE8EAF0)
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      trackPaint,
    );

    // Foreground arc (animated fill)
    final sweep = (value.clamp(0, 100) / 100) * math.pi;
    final fillPaint = Paint()
      ..color = color
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweep,
      false,
      fillPaint,
    );

    // Tick marks
    final tickPaint = Paint()
      ..color = const Color(0xFFD5D8E0)
      ..strokeWidth = 1.5;

    for (int i = 0; i <= 10; i++) {
      final angle = math.pi + (i / 10) * math.pi;
      final outer = Offset(
        center.dx + (radius + 12) * math.cos(angle),
        center.dy + (radius + 12) * math.sin(angle),
      );
      final inner = Offset(
        center.dx + (radius + 4) * math.cos(angle),
        center.dy + (radius + 4) * math.sin(angle),
      );
      canvas.drawLine(inner, outer, tickPaint);
    }
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) =>
      oldDelegate.value != value || oldDelegate.color != color;
}