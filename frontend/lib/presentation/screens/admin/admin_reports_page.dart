import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';

// Dummy data generator
List<FlSpot> _generateSpots(double base, double variance, int count) {
  final rng = Random(base.toInt());
  return List.generate(count, (i) {
    return FlSpot(
      i.toDouble(),
      base + (rng.nextDouble() - 0.5) * variance,
    );
  });
}

@RoutePage()
class AdminReportsPage extends StatefulWidget {
  const AdminReportsPage({super.key});

  @override
  State<AdminReportsPage> createState() => _AdminReportsPageState();
}

class _AdminReportsPageState extends State<AdminReportsPage> {
  String _selectedMine = 'Mine A';
  String _selectedPeriod = '24h';

  static const _mines = [
    'Mine A',
    'Mine B',
    'Mine C',
    'Mine D',
  ];

  static const _periods = ['24h', '7d', '30d'];

  int get _pointCount => switch (_selectedPeriod) {
        '24h' => 24,
        '7d' => 7,
        '30d' => 30,
        _ => 24,
      };

  String get _xLabel => switch (_selectedPeriod) {
        '24h' => 'Hours',
        '7d' => 'Days',
        '30d' => 'Days',
        _ => 'Hours',
      };

  @override
  Widget build(BuildContext context) {
    final seed = _selectedMine.hashCode + _selectedPeriod.hashCode;
    final ch4Spots =
        _generateSpots(1.2 + (seed % 3) * 0.1, 0.8, _pointCount);
    final o2Spots =
        _generateSpots(19.5 + (seed % 2) * 0.2, 1.5, _pointCount);
    final co2Spots =
        _generateSpots(0.5 + (seed % 4) * 0.05, 0.4, _pointCount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gas Monitoring Reports'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filters
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedMine,
                    decoration: InputDecoration(
                      labelText: 'Mine Site',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    items: _mines
                        .map((m) =>
                            DropdownMenuItem(value: m, child: Text(m)))
                        .toList(),
                    onChanged: (v) =>
                        setState(() => _selectedMine = v ?? _selectedMine),
                  ),
                ),
                const SizedBox(width: 16),
                SegmentedButton<String>(
                  segments: _periods
                      .map((p) =>
                          ButtonSegment(value: p, label: Text(p)))
                      .toList(),
                  selected: {_selectedPeriod},
                  onSelectionChanged: (v) =>
                      setState(() => _selectedPeriod = v.first),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Summary cards
            Row(
              children: [
                _SummaryCard(
                  title: 'CH\u2084 (Methane)',
                  value:
                      '${ch4Spots.map((s) => s.y).reduce(max).toStringAsFixed(2)}%',
                  subtitle: 'Peak in period',
                  icon: Icons.local_fire_department,
                  color: Colors.orange,
                  status: ch4Spots.map((s) => s.y).reduce(max) > 1.5
                      ? 'Warning'
                      : 'Normal',
                ),
                const SizedBox(width: 16),
                _SummaryCard(
                  title: 'O\u2082 (Oxygen)',
                  value:
                      '${o2Spots.map((s) => s.y).reduce(min).toStringAsFixed(1)}%',
                  subtitle: 'Minimum in period',
                  icon: Icons.air,
                  color: Colors.blue,
                  status: o2Spots.map((s) => s.y).reduce(min) < 19.0
                      ? 'Low'
                      : 'Normal',
                ),
                const SizedBox(width: 16),
                _SummaryCard(
                  title: 'CO\u2082 (Carbon Dioxide)',
                  value:
                      '${co2Spots.map((s) => s.y).reduce(max).toStringAsFixed(2)}%',
                  subtitle: 'Peak in period',
                  icon: Icons.cloud_outlined,
                  color: Colors.grey,
                  status: co2Spots.map((s) => s.y).reduce(max) > 0.5
                      ? 'Elevated'
                      : 'Normal',
                ),
              ],
            ),
            const SizedBox(height: 32),

            // CH4 Chart
            _GasChart(
              title: 'CH\u2084 — Methane Levels',
              spots: ch4Spots,
              lineColor: Colors.orange,
              fillColor: Colors.orange.withValues(alpha: 0.15),
              yLabel: 'CH\u2084 %',
              xLabel: _xLabel,
              minY: 0,
              maxY: 2.5,
              thresholdY: 1.5,
              thresholdLabel: 'Safety limit (1.5%)',
            ),
            const SizedBox(height: 32),

            // O2 Chart
            _GasChart(
              title: 'O\u2082 — Oxygen Levels',
              spots: o2Spots,
              lineColor: Colors.blue,
              fillColor: Colors.blue.withValues(alpha: 0.15),
              yLabel: 'O\u2082 %',
              xLabel: _xLabel,
              minY: 17,
              maxY: 22,
              thresholdY: 19.0,
              thresholdLabel: 'Min safe level (19%)',
              thresholdAbove: false,
            ),
            const SizedBox(height: 32),

            // CO2 Chart
            _GasChart(
              title: 'CO\u2082 — Carbon Dioxide Levels',
              spots: co2Spots,
              lineColor: Colors.grey[700]!,
              fillColor: Colors.grey.withValues(alpha: 0.15),
              yLabel: 'CO\u2082 %',
              xLabel: _xLabel,
              minY: 0,
              maxY: 1.2,
              thresholdY: 0.5,
              thresholdLabel: 'Safety limit (0.5%)',
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String status;

  const _SummaryCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final isNormal = status == 'Normal';

    return Expanded(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Text(value,
                        style: AppTextStyles.headlineMedium
                            .copyWith(fontSize: 24)),
                    Text(subtitle,
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: Colors.grey[500], fontSize: 13)),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isNormal ? Colors.green[50] : Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: isNormal ? Colors.green[700] : Colors.orange[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GasChart extends StatelessWidget {
  final String title;
  final List<FlSpot> spots;
  final Color lineColor;
  final Color fillColor;
  final String yLabel;
  final String xLabel;
  final double minY;
  final double maxY;
  final double thresholdY;
  final String thresholdLabel;
  final bool thresholdAbove;

  const _GasChart({
    required this.title,
    required this.spots,
    required this.lineColor,
    required this.fillColor,
    required this.yLabel,
    required this.xLabel,
    required this.minY,
    required this.maxY,
    required this.thresholdY,
    required this.thresholdLabel,
    this.thresholdAbove = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: AppTextStyles.titleLarge),
                Row(
                  children: [
                    Container(
                      width: 12,
                      height: 3,
                      color: Colors.red[300],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      thresholdLabel,
                      style: TextStyle(
                        color: Colors.red[400],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  minY: minY,
                  maxY: maxY,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: (maxY - minY) / 5,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: Colors.grey[200]!,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[300]!),
                      left: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text(xLabel,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 12)),
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: spots.length > 10
                            ? (spots.length / 6).ceilToDouble()
                            : 1,
                        getTitlesWidget: (value, meta) {
                          if (value == value.roundToDouble() &&
                              value >= 0 &&
                              value < spots.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 11,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text(yLabel,
                          style: TextStyle(
                              color: Colors.grey[500], fontSize: 12)),
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        interval: (maxY - minY) / 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toStringAsFixed(1),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: thresholdY,
                        color: Colors.red[300]!,
                        strokeWidth: 2,
                        dashArray: [8, 4],
                      ),
                    ],
                  ),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y.toStringAsFixed(2)}%',
                            TextStyle(
                              color: lineColor,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: lineColor,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: spots.length <= 10,
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        color: fillColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
