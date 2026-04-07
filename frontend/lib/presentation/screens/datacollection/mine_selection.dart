import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';

@RoutePage()
class MineSelectionPage extends StatefulWidget {
  const MineSelectionPage({super.key});

  @override
  State<MineSelectionPage> createState() => _MineSelectionPageState();
}

class _MineSelectionPageState extends State<MineSelectionPage> {
  static const Color navyBlue = Color(0xFF1F579C);
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color greenAccent = Color(0xFF3DAA6E);

  String? _selectedMine;
  String? _selectedMineType;
  String? _selectedArea;
  String? _selectedCompany;

  final List<String> _companies = [
  'Coal India Limited',
  'Singareni Collieries Company',
  'Gujarat Mineral Development Corp',
  'Hindustan Copper Limited',
  'National Mineral Development Corp',
  'Steel Authority of India',
  'Tata Steel Mining',
  'Vedanta Resources',
  'Adani Enterprises',
  'JSW Steel',
  ];

  final List<String> _mines = [
    'Bharat Coking Coal Ltd',
    'Central Coalfields Ltd',
    'Eastern Coalfields Ltd',
    'Mahanadi Coalfields Ltd',
    'Northern Coalfields Ltd',
    'South Eastern Coalfields Ltd',
    'Western Coalfields Ltd',
    'Singareni Collieries',
    'Gujarat Mineral Development',
    'Hindustan Copper Ltd',
  ];

  final List<String> _mineTypes = [
    'Opencast',
    'Underground',
    'Coal',
    'Metal',
    'Non-Metal',
  ];

  final List<String> _areas = [
    // 'Panel',
    // 'Face',
    // 'Haul road',
    // 'CHP',
    // 'Workshop',
    // 'Substation',
    // 'Pump house',
    // 'Magazine',
    // 'Shaft/In-bye/Out-bye',
    'Working Face',
    'Travelling Galleries',
    'Hauling Roadways',
    'Man-riding Roadways',
    'Pumping Area',
    'Pillar',
    'Rest Shelter',
    'Underground Substation',
    'Explosive Magazine',
  ];

  bool get _canProceed =>
    _selectedMine != null &&
    _selectedMineType != null &&
    _selectedArea != null &&
    _selectedCompany != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildProgressBar(step: 1, total: 2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                    icon: Icons.location_on_rounded,
                    title: 'Mine Details',
                    subtitle: 'Select the mine and inspection area',
                  ),
                  const SizedBox(height: 24),
                  _buildDropdownCard(
                    label: 'Company Name',
                    hint: 'Select company',
                    icon: Icons.domain_rounded,
                    value: _selectedCompany,
                    items: _companies,
                    onChanged: (val) => setState(() => _selectedCompany = val),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownCard(
                    label: 'Mine Name',
                    hint: 'Select mine',
                    icon: Icons.business_rounded,
                    value: _selectedMine,
                    items: _mines,
                    onChanged: (val) => setState(() => _selectedMine = val),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownCard(
                    label: 'Mine Type',
                    hint: 'Select mine type',
                    icon: Icons.category_rounded,
                    value: _selectedMineType,
                    items: _mineTypes,
                    onChanged: (val) =>
                        setState(() => _selectedMineType = val),
                  ),
                  const SizedBox(height: 16),
                  _buildDropdownCard(
                    label: 'Area for Inspection',
                    hint: 'Select area',
                    icon: Icons.map_rounded,
                    value: _selectedArea,
                    items: _areas,
                    onChanged: (val) => setState(() => _selectedArea = val),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _canProceed
                          ? () {
                              context.router.push(
                                ShiftSelectionRoute(
                                  mineName: _selectedMine!,
                                  mineType: _selectedMineType!,
                                  area: _selectedArea!,
                                ),
                              );
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
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
      title: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Start Inspection',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            'Step 1 of 2',
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
            color: navyBlue.withValues(alpha: 0.08),
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
