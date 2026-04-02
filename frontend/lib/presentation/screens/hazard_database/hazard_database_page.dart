import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/data/models/hazard/hazard_entry.dart';

@RoutePage()
class HazardDatabasePage extends StatefulWidget {
  const HazardDatabasePage({super.key});

  @override
  State<HazardDatabasePage> createState() => _HazardDatabasePageState();
}

class _HazardDatabasePageState extends State<HazardDatabasePage> {
  Map<String, Map<String, List<HazardEntry>>>? _data;
  bool _isLoading = true;

  // Sidebar expand/collapse state (independent of selection)
  final Set<String> _expandedCategories = {};

  // Currently selected sheet for the detail panel
  String? _activeCategory;
  String? _activeSheet;

  static const _categories = ['General', 'Surface', 'Underground'];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jsonString =
        await rootBundle.loadString('assets/json/hazard_database.json');
    final Map<String, dynamic> raw = json.decode(jsonString);

    final parsed = <String, Map<String, List<HazardEntry>>>{};
    for (final category in raw.keys) {
      debugPrint('Parsing category: $category');
      final sheets = raw[category] as Map<String, dynamic>;
      parsed[category] = {};
      for (final sheetName in sheets.keys) {
        debugPrint('Parsing sheet: $sheetName');
        final entries = (sheets[sheetName] as List)
            .map((e) => HazardEntry.fromJson(e as Map<String, dynamic>))
            .toList();
        parsed[category]![sheetName] = entries;
      }
    }

    setState(() {
      _data = parsed;
      _expandedCategories.add(_categories.first);
      _activeCategory = _categories.first;
      _activeSheet = parsed[_categories.first]?.keys.first;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hazard Database'),
        scrolledUnderElevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                _buildSidebar(),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(child: _buildDetailPanel()),
              ],
            ),
    );
  }

  Widget _buildSidebar() {
    final data = _data!;
    return SizedBox(
      width: 250,
      child: Container(
        color: AppColors.background,
        child: ListView(
          children: _categories.map((category) {
            final sheetNames = data[category]?.keys.toList() ?? [];
            final isExpanded = _expandedCategories.contains(category);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (isExpanded) {
                        _expandedCategories.remove(category);
                      } else {
                        _expandedCategories.add(category);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    color: AppColors.primary.withValues(alpha: 0.05),
                    child: Row(
                      children: [
                        Icon(
                          isExpanded
                              ? Icons.expand_more
                              : Icons.chevron_right,
                          size: 20,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            category.toUpperCase(),
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Text(
                          '${sheetNames.length}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.outline,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (isExpanded)
                  ...sheetNames.map((name) {
                    final isSelected =
                        _activeCategory == category && _activeSheet == name;
                    return InkWell(
                      onTap: () => setState(() {
                        _activeCategory = category;
                        _activeSheet = name;
                      }),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border(
                            bottom: BorderSide(
                              color:
                                  AppColors.outline.withValues(alpha: 0.2),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 28),
                          child: Text(
                            name,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: isSelected
                                  ? AppColors.onPrimary
                                  : AppColors.onSurface,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDetailPanel() {
    if (_activeSheet == null || _activeCategory == null) {
      return const Center(
        child: Text(
          'Select a hazard category from the sidebar',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    final entries = _data![_activeCategory]?[_activeSheet!];
    if (entries == null || entries.isEmpty) {
      return Center(
        child: Text(
          'No data available for $_activeSheet',
          style: AppTextStyles.bodyLarge,
        ),
      );
    }

    final hasSubActivity = entries.any((e) => e.subActivity.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(
              bottom: BorderSide(
                color: AppColors.outline.withValues(alpha: 0.2),
              ),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _activeSheet!,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${entries.length} entries',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: hasSubActivity
              ? _buildGroupedBySubActivity(entries)
              : _buildGroupedByHazard(entries),
        ),
      ],
    );
  }

  Widget _buildGroupedBySubActivity(List<HazardEntry> entries) {
    final subActivities = <String>[];
    final grouped = <String, List<HazardEntry>>{};
    for (final e in entries) {
      final key = e.subActivity.isNotEmpty ? e.subActivity : 'General';
      if (!grouped.containsKey(key)) {
        subActivities.add(key);
        grouped[key] = [];
      }
      grouped[key]!.add(e);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: subActivities.length,
      itemBuilder: (context, index) {
        final subActivity = subActivities[index];
        final subEntries = grouped[subActivity]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                subActivity,
                style: AppTextStyles.titleLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
            _buildHazardTable(subEntries),
            const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildGroupedByHazard(List<HazardEntry> entries) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: _buildHazardTable(entries),
    );
  }

  Widget _buildHazardTable(List<HazardEntry> entries) {
    return Table(
      border: TableBorder.all(
        color: AppColors.outline.withValues(alpha: 0.3),
        width: 1,
      ),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(3),
        2: FlexColumnWidth(3),
        3: FlexColumnWidth(2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
          ),
          children: [
            _headerCell('Hazard'),
            _headerCell('Mechanism'),
            _headerCell('Control'),
            _headerCell('References'),
          ],
        ),
        ...entries.map(
          (e) => TableRow(
            children: [
              _dataCell(e.hazard),
              _dataCell(e.mechanism),
              _dataCell(e.control),
              _dataCell(e.references),
            ],
          ),
        ),
      ],
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: AppTextStyles.labelLarge.copyWith(
          color: AppColors.primary,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _dataCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(
        text,
        style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
      ),
    );
  }
}
