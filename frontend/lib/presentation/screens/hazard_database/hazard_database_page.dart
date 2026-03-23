import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/data/models/hazard/hazard_entry.dart';

@RoutePage()
class HazardDatabasePage extends StatefulWidget {
  final int initialSectionIndex;

  const HazardDatabasePage({super.key, @PathParam('sectionIndex') this.initialSectionIndex = 0});

  @override
  State<HazardDatabasePage> createState() => _HazardDatabasePageState();
}

class _HazardDatabasePageState extends State<HazardDatabasePage> {
  Map<String, Map<String, List<HazardEntry>>>? _data;
  bool _isLoading = true;
  late int _currentSectionIndex = widget.initialSectionIndex;
  int _selectedSheetIndex = 0;

  static const _categories = ['General', 'Surface', 'Underground'];

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

    final parsed = <String, Map<String, List<HazardEntry>>>{};
    for (final category in raw.keys) {
      final sheets = raw[category] as Map<String, dynamic>;
      parsed[category] = {};
      for (final sheetName in sheets.keys) {
        final entries = (sheets[sheetName] as List)
            .map((e) => HazardEntry.fromJson(e as Map<String, dynamic>))
            .toList();
        parsed[category]![sheetName] = entries;
      }
    }

    setState(() {
      _data = parsed;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = _data!;
    final availableCategories =
        _categories.where((c) => data.containsKey(c)).toList();

    if (availableCategories.isEmpty) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F7FA),
        body: Center(child: Text('No hazard data found.')),
      );
    }

    if (_currentSectionIndex >= availableCategories.length) {
      _currentSectionIndex = 0;
    }

    final currentCategory = availableCategories[_currentSectionIndex];
    final sheets = data[currentCategory]!;
    final sheetNames = sheets.keys.toList();

    if (_selectedSheetIndex >= sheetNames.length) {
      _selectedSheetIndex = 0;
    }

    final selectedSheetName = sheetNames[_selectedSheetIndex];
    final selectedEntries = sheets[selectedSheetName]!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildSectionHeader(
                currentCategory, availableCategories.length),
            _buildProgressBar(availableCategories.length),
            Expanded(
              child: Row(
                children: [
                  // Sheet sidebar
                  _buildSheetSidebar(sheetNames),
                  // Divider
                  Container(
                    width: 1,
                    color: const Color(0xFFE0E3EA),
                  ),
                  // Content panel
                  Expanded(
                    child: _buildContentPanel(
                        selectedSheetName, selectedEntries),
                  ),
                ],
              ),
            ),
            _buildSectionFooter(
              availableCategories.length,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String categoryName, int totalSections) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 12, bottom: 8, left: 8, right: 16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: () => context.router.maybePop(),
            color: AppColors.onSurface,
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.outline.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'SECTION - ${_currentSectionIndex + 1}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.secondary,
                    fontSize: 13,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  categoryName,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }

  Widget _buildProgressBar(int totalSections) {
    final progress =
        totalSections > 0 ? (_currentSectionIndex + 1) / totalSections : 0.0;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(bottom: 2),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: const Color(0xFFE8EAF0),
        valueColor:
            const AlwaysStoppedAnimation<Color>(Color(0xFF2C3E6B)),
        minHeight: 4,
      ),
    );
  }

  Widget _buildSheetSidebar(List<String> sheetNames) {
    return SizedBox(
      width: 220,
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                itemCount: sheetNames.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedSheetIndex;
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _selectedSheetIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF2C3E6B)
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: isSelected
                                ? const Color(0xFF2C3E6B)
                                : Colors.transparent,
                            width: 3,
                          ),
                          bottom: BorderSide(
                            color: const Color(0xFFE0E3EA)
                                .withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      child: Text(
                        sheetNames[index],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSelected
                              ? Colors.white
                              : AppColors.onSurface,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentPanel(
      String sheetName, List<HazardEntry> entries) {
    final hasSubActivity = entries.any((e) => e.subActivity.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sheet title bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: const BoxDecoration(
            color: Color(0xFFF5F7FA),
            border: Border(
              bottom: BorderSide(
                color: Color(0xFFE0E3EA),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  sheetName,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C3E6B).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${entries.length} entries',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E6B),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Entries
        Expanded(
          child: hasSubActivity
              ? _buildGroupedContent(entries)
              : _buildFlatContent(entries),
        ),
      ],
    );
  }

  Widget _buildGroupedContent(List<HazardEntry> entries) {
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: subActivities.length,
      itemBuilder: (context, index) {
        final subActivity = subActivities[index];
        final subEntries = grouped[subActivity]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sub-activity heading
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C3E6B),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      subActivity,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2C3E6B),
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ...List.generate(
              subEntries.length,
              (i) => _buildHazardCard(subEntries[i], i + 1),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }

  Widget _buildFlatContent(List<HazardEntry> entries) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return _buildHazardCard(entries[index], index + 1);
      },
    );
  }

  Widget _buildHazardCard(HazardEntry entry, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE0E3EA),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hazard name with index badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C3E6B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$index',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      entry.hazard,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Mechanism
            if (entry.mechanism.isNotEmpty)
              _buildInfoRow('MECHANISM', entry.mechanism),

            // Control
            if (entry.control.isNotEmpty)
              _buildInfoRow('CONTROL', entry.control),

            // References
            if (entry.references.isNotEmpty)
              _buildInfoRow('REFERENCES', entry.references),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.secondary.withValues(alpha: 0.7),
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFFE0E3EA),
                width: 1,
              ),
            ),
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionFooter(
    int totalSections,
  ) {
    final isFirst = _currentSectionIndex == 0;
    final isLast = _currentSectionIndex == totalSections - 1;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(
            color: AppColors.outline.withValues(alpha: 0.15),
            height: 1,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // PREVIOUS button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: OutlinedButton(
                    onPressed: isFirst
                        ? null
                        : () {
                            setState(() {
                              _currentSectionIndex--;
                              _selectedSheetIndex = 0;
                            });
                          },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Color(0xFFD5D8E0),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Text(
                      'PREVIOUS',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isFirst
                            ? AppColors.outline.withValues(alpha: 0.4)
                            : AppColors.onSurface,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // NEXT / DONE button
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: isLast
                      ? FilledButton(
                          onPressed: () => context.router.maybePop(),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2A47),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Text(
                            'DONE',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              letterSpacing: 0.5,
                            ),
                          ),
                        )
                      : FilledButton(
                          onPressed: () {
                            setState(() {
                              _currentSectionIndex++;
                              _selectedSheetIndex = 0;
                            });
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF1E2A47),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'NEXT',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, size: 18),
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
