import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';

@RoutePage()
class HazardDatabaseOverviewPage extends StatefulWidget {
  const HazardDatabaseOverviewPage({super.key});

  @override
  State<HazardDatabaseOverviewPage> createState() =>
      _HazardDatabaseOverviewPageState();
}

class _HazardDatabaseOverviewPageState
    extends State<HazardDatabaseOverviewPage> {
  Map<String, int>? _subSectionCounts;
  bool _isLoading = true;

  static const _categories = ['General', 'Surface', 'Underground'];

  static const _sectionDescriptions = {
    'General': 'Common hazards across all mining operations',
    'Surface': 'Surface mining specific hazards & controls',
    'Underground': 'Underground mining specific hazards & controls',
  };

  static const _sectionIcons = [
    Icons.public_outlined,
    Icons.terrain_outlined,
    Icons.hardware_outlined,
  ];

  static const _sectionColors = [
    Color(0xFF2C3E6B),
    Color(0xFFE8703A),
    Color(0xFF4CAF50),
  ];

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _loadData();
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

  Future<void> _loadData() async {
    final jsonString =
        await rootBundle.loadString('assets/json/hazard_database.json');
    final Map<String, dynamic> raw = json.decode(jsonString);

    final counts = <String, int>{};
    for (final category in raw.keys) {
      final sheets = raw[category] as Map<String, dynamic>;
      counts[category] = sheets.length;
    }

    setState(() {
      _subSectionCounts = counts;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'HAZARD CATEGORIES',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.secondary
                                  .withValues(alpha: 0.7),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ..._buildSectionCards(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: () => context.router.maybePop(),
            color: AppColors.onSurface,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hazard Database',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 26,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Reference guide for hazards, mechanisms & controls',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSectionCards() {
    final availableCategories =
        _categories.where((c) => _subSectionCounts!.containsKey(c)).toList();

    return List.generate(availableCategories.length, (index) {
      final category = availableCategories[index];
      final subSectionCount = _subSectionCounts![category] ?? 0;
      final icon = _sectionIcons[index % _sectionIcons.length];
      final iconColor = _sectionColors[index % _sectionColors.length];
      final description = _sectionDescriptions[category] ?? '';

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: GestureDetector(
          onTap: () {
            context.router.push(
                HazardDatabaseRoute(initialSectionIndex: index));
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
                // Title + description + sheet count
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (description.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          description,
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.secondary
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        '$subSectionCount sub-sections',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: iconColor,
                        ),
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
    });
  }
}
