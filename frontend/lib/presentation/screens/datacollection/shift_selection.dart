import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';

@RoutePage()
class ShiftSelectionPage extends StatefulWidget {
  final String mineName;
  final String mineType;
  final String area;

  const ShiftSelectionPage({
    super.key,
    required this.mineName,
    required this.mineType,
    required this.area,
  });

  @override
  State<ShiftSelectionPage> createState() => _ShiftSelectionPageState();
}

class _ShiftSelectionPageState extends State<ShiftSelectionPage> {
  static const Color navyBlue = Color(0xFF1F579C);
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color greenAccent = Color(0xFF3DAA6E);

  String? _selectedShift;
  String? _selectedInspectionType;

  final List<Map<String, dynamic>> _shifts = [
    {'label': 'Shift 1', 'value': '1', 'time': '6:00 AM – 2:00 PM'},
    {'label': 'Shift 2', 'value': '2', 'time': '2:00 PM – 10:00 PM'},
    {'label': 'Shift 3', 'value': '3', 'time': '10:00 PM – 6:00 AM'},
  ];

  final List<String> _inspectionTypes = [
    'Daily statutory inspection',
    'Safety inspection',
    'Ventilation inspection',
    'Machinery inspection',
    'Electrical inspection',
    'Roadway inspection',
    'Roof & support inspection',
    'Explosive magazine inspection',
    'Dust/noise inspection',
    'Contractor work inspection',
    'PPE compliance inspection',
  ];

  bool get _canProceed =>
      _selectedShift != null && _selectedInspectionType != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressBar(step: 2, total: 2),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Summary card from previous screen
                  _buildSummaryCard(),

                  const SizedBox(height: 24),

                  _buildSectionHeader(
                    icon: Icons.access_time_rounded,
                    title: 'Shift & Inspection',
                    subtitle: 'Select shift and type of inspection',
                  ),

                  const SizedBox(height: 20),

                  // Shift selector (tap cards)
                  const Text(
                    'SHIFT',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: navyBlue,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: _shifts.map((shift) {
                      final isSelected = _selectedShift == shift['value'];
                      return Expanded(
                        child: GestureDetector(
                          onTap: () =>
                              setState(() => _selectedShift = shift['value']),
                          child: Container(
                            margin: EdgeInsets.only(
                              right: shift['value'] != '3' ? 10 : 0,
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? navyBlue : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected
                                    ? navyBlue
                                    : Colors.grey.shade200,
                                width: isSelected ? 2 : 1,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: navyBlue.withValues(alpha: 0.2),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.wb_sunny_rounded,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.grey[400],
                                  size: 20,
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  shift['label'],
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF1A1A2E),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  shift['time'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 9,
                                    color: isSelected
                                        ? Colors.white60
                                        : Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Inspection type dropdown
                  _buildDropdownCard(
                    label: 'Inspection Type',
                    hint: 'Select inspection type',
                    icon: Icons.assignment_rounded,
                    value: _selectedInspectionType,
                    items: _inspectionTypes,
                    onChanged: (val) =>
                        setState(() => _selectedInspectionType = val),
                  ),

                  const SizedBox(height: 32),

                  // Next Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _canProceed
                          ? () {
                              context.router.push(const ChecklistOverviewRoute());
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navyBlue,
                        disabledBackgroundColor: Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Text(
                            'Next',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: navyBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_rounded),
        onPressed: () => context.router.maybePop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Start Inspection',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Step 2 of 2',
            style: TextStyle(fontSize: 11, color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar({required int step, required int total}) {
    return Container(
      color: navyBlue,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      child: Row(
        children: List.generate(total, (index) {
          final isActive = index < step;
          return Expanded(
            child: Container(
              margin: EdgeInsets.only(right: index < total - 1 ? 8 : 0),
              height: 4,
              decoration: BoxDecoration(
                color: isActive ? greenAccent : Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navyBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
        color: navyBlue.withValues(alpha: 0.12),
      ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'SELECTED DETAILS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: navyBlue,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 10),
          _summaryRow(Icons.business_rounded, 'Mine', widget.mineName),
          const SizedBox(height: 6),
          _summaryRow(Icons.category_rounded, 'Type', widget.mineType),
          const SizedBox(height: 6),
          _summaryRow(Icons.map_rounded, 'Area', widget.area),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 14, color: navyBlue),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: navyBlue.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: navyBlue, size: 22),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownCard({
    required String label,
    required String hint,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value != null
              ? navyBlue.withValues(alpha: 0.3)
              : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: navyBlue),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: navyBlue,
                  letterSpacing: 0.5,
                ),
              ),
              if (value != null) ...[
                const Spacer(),
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: Color(0xFF3DAA6E),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(color: Colors.grey[400], fontSize: 14),
              ),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: navyBlue),
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF1A1A2E),
                fontWeight: FontWeight.w500,
              ),
              items: items
                  .map((item) => DropdownMenuItem(
                        value: item,
                        child: Text(item),
                      ))
                  .toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}