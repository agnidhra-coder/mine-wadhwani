import 'package:flutter/material.dart';
import 'package:mine_wadhwani/data/models/health_assessment/health_assessment_model.dart';
import 'package:mine_wadhwani/presentation/screens/health_assessment/risk_summary_sheet.dart';

class HealthAssessmentPromptPage extends StatefulWidget {
  final String mineName;
  final String area;
  final int shift;
  final String inspectionType;

  const HealthAssessmentPromptPage({
    super.key,
    required this.mineName,
    required this.area,
    required this.shift,
    required this.inspectionType,
  });

  @override
  State<HealthAssessmentPromptPage> createState() =>
      _HealthAssessmentPromptPageState();
}

class _HealthAssessmentPromptPageState
    extends State<HealthAssessmentPromptPage> {
  static const _headerColor = Color(0xFF1F579C);
  static const _flagColor = Color(0xFFEF4444);
  static const _flagBg = Color(0xFFFEF2F2);

  bool? _wantsAssessment;
  String? _selectedZone;
  bool _zoneWasAutoSelected = false;
  final Set<String> _selectedModes = {};

  final Map<String, TextEditingController> _aqmControllers = {};
  final Map<String, TextEditingController> _droneControllers = {};
  final TextEditingController _notesController = TextEditingController();

  // Each worker gets its own set of controllers, keyed by a unique id.
  final List<String> _workerIds = [];
  final Map<String, TextEditingController> _workerNameControllers = {};
  final Map<String, TextEditingController> _workerHrControllers = {};
  final Map<String, TextEditingController> _workerSpo2Controllers = {};
  int _workerCounter = 0;

  final List<String> _zones = [
    'Pit A',
    'Pit B',
    'Dump Yard',
    'Haul Road',
    'Stockpile Area',
    'Loading Point',
  ];

  final List<String> _aqmFields = ['PM2.5 (µg/m³)', 'CO (ppm)', 'Dust Level (mg/m³)'];
  final List<String> _droneFields = ['Thermal Flag', 'PPE Compliance', 'Observation'];

  final List<Map<String, dynamic>> _modes = [
    {'label': 'AQM Reading', 'value': 'AQM', 'icon': Icons.air_rounded},
    {'label': 'Drone Sweep', 'value': 'Drone', 'icon': Icons.flight_rounded},
    {'label': 'Smartwatch Spot-Check', 'value': 'Smartwatch', 'icon': Icons.watch_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _autoSelectZone();
  }

  void _autoSelectZone() {
    if (widget.inspectionType == 'Stockpile inspection') {
      _selectedZone = 'Stockpile Area';
      _zoneWasAutoSelected = true;
    } else if (widget.inspectionType == 'Haul Road inspection') {
      _selectedZone = 'Haul Road';
      _zoneWasAutoSelected = true;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    for (final c in _aqmControllers.values) c.dispose();
    for (final c in _droneControllers.values) c.dispose();
    for (final c in _workerNameControllers.values) c.dispose();
    for (final c in _workerHrControllers.values) c.dispose();
    for (final c in _workerSpo2Controllers.values) c.dispose();
    super.dispose();
  }

  TextEditingController _aqmController(String key) =>
      _aqmControllers.putIfAbsent(key, () => TextEditingController());

  TextEditingController _droneController(String key) =>
      _droneControllers.putIfAbsent(key, () => TextEditingController());

  void _addWorker() {
    final id = 'w${_workerCounter++}';
    setState(() {
      _workerIds.add(id);
      _workerNameControllers[id] = TextEditingController();
      _workerHrControllers[id] = TextEditingController();
      _workerSpo2Controllers[id] = TextEditingController();
    });
  }

  void _removeWorker(String id) {
    setState(() {
      _workerIds.remove(id);
      _workerNameControllers.remove(id)?.dispose();
      _workerHrControllers.remove(id)?.dispose();
      _workerSpo2Controllers.remove(id)?.dispose();
    });
  }

  bool get _canSubmit =>
      _selectedZone != null && _selectedModes.isNotEmpty && _hasAnyData;

  bool get _hasAnyData {
    for (final id in _workerIds) {
      if ((_workerNameControllers[id]?.text.trim() ?? '').isNotEmpty) return true;
      if ((_workerHrControllers[id]?.text.trim() ?? '').isNotEmpty) return true;
      if ((_workerSpo2Controllers[id]?.text.trim() ?? '').isNotEmpty) return true;
    }
    for (final field in _aqmFields) {
      if (_aqmController(field).text.trim().isNotEmpty) return true;
    }
    for (final field in _droneFields) {
      if (_droneController(field).text.trim().isNotEmpty) return true;
    }
    return false;
  }

  bool _isHrFlagged(String value) {
    final hr = double.tryParse(value);
    if (hr == null) return false;
    return hr < HealthThresholds.minHeartRate || hr > HealthThresholds.maxHeartRate;
  }

  bool _isSpo2Flagged(String value) {
    final s = double.tryParse(value);
    if (s == null) return false;
    return s < HealthThresholds.minSpo2;
  }

  bool _isAqmFieldFlagged(String label, String value) {
    final v = double.tryParse(value);
    if (v == null) return false;
    if (label == 'PM2.5 (µg/m³)') return v > HealthThresholds.maxPm25;
    if (label == 'CO (ppm)') return v > HealthThresholds.maxCo;
    if (label == 'Dust Level (mg/m³)') return v > HealthThresholds.maxDust;
    return false;
  }

  int get _liveFlagCount {
    int count = 0;
    for (final id in _workerIds) {
      final hr = _workerHrControllers[id]?.text ?? '';
      final spo2 = _workerSpo2Controllers[id]?.text ?? '';
      if (_isHrFlagged(hr) || _isSpo2Flagged(spo2)) count++;
    }
    for (final field in _aqmFields) {
      final value = _aqmController(field).text;
      if (_isAqmFieldFlagged(field, value)) count++;
    }
    return count;
  }

  void _skip() {
    Navigator.of(context).pop(HealthAssessmentModel.skipped());
  }

  void _submit() {
    if (!_canSubmit) return;

    final aqmReadings = <String, String>{};
    if (_selectedModes.contains('AQM')) {
      for (final field in _aqmFields) {
        final text = _aqmController(field).text.trim();
        if (text.isNotEmpty) aqmReadings[field] = text;
      }
    }

    final droneReadings = <String, String>{};
    if (_selectedModes.contains('Drone')) {
      for (final field in _droneFields) {
        final text = _droneController(field).text.trim();
        if (text.isNotEmpty) droneReadings[field] = text;
      }
    }

    final workerReadings = <WorkerReading>[];
    if (_selectedModes.contains('Smartwatch')) {
      for (final id in _workerIds) {
        final name = _workerNameControllers[id]?.text.trim() ?? '';
        final hr = _workerHrControllers[id]?.text.trim() ?? '';
        final spo2 = _workerSpo2Controllers[id]?.text.trim() ?? '';
        if (name.isNotEmpty || hr.isNotEmpty || spo2.isNotEmpty) {
          workerReadings.add(WorkerReading(name: name, heartRate: hr, spo2: spo2));
        }
      }
    }

    Navigator.of(context).pop(HealthAssessmentModel(
      conducted: true,
      zone: _selectedZone!,
      modes: _selectedModes.toList(),
      aqmReadings: aqmReadings,
      droneReadings: droneReadings,
      workerReadings: workerReadings,
      notes: _notesController.text.trim(),
      assessedAt: DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_wantsAssessment == null) _buildYesNoCard(),
            if (_wantsAssessment == true) _buildAssessmentForm(),
          ],
        ),
      ),
      bottomNavigationBar: _wantsAssessment == true ? _buildSubmitBar() : null,
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: _headerColor,
      foregroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🩺 Worker Health Assessment',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                Text('Optional — before checklist',
                    style: TextStyle(fontSize: 11, color: Colors.white60)),
              ],
            ),
          ),
          if (_wantsAssessment == true && _liveFlagCount > 0) _buildFlagBadge(),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _skip,
          child: Text(
            _wantsAssessment == null ? 'Skip' : 'Cancel',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildFlagBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.warning_amber_rounded, color: _flagColor, size: 15),
          const SizedBox(width: 5),
          Text('$_liveFlagCount',
              style: const TextStyle(color: _flagColor, fontSize: 13, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _buildYesNoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      clipBehavior: Clip.antiAlias,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 640;

          final imageWidget = ClipRRect(
            borderRadius: isWide
                ? const BorderRadius.only(
                    topLeft: Radius.circular(16), bottomLeft: Radius.circular(16))
                : const BorderRadius.only(
                    topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            child: Image.asset(
              'assets/images/worker_health_assessment.png',
              fit: BoxFit.cover,
              height: isWide ? null : 180,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(
                height: isWide ? null : 180,
                color: const Color(0xFFE4EBF2),
                alignment: Alignment.center,
                child: const Icon(Icons.image_outlined, color: _headerColor, size: 40),
              ),
            ),
          );

          final contentWidget = Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EBF2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(Icons.health_and_safety_rounded, color: _headerColor, size: 26),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Do you want to conduct a health assessment for workers in this shift/zone?',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E), height: 1.4),
                ),
                const SizedBox(height: 6),
                Text(
                  'Uses AQM readings, drone sweep results, or smartwatch spot-checks. This step is optional and can be skipped.',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _skip,
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: const BorderSide(color: Color(0xFFD5D8E0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('No', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => setState(() => _wantsAssessment = true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _headerColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        child: const Text('Yes', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );

          if (isWide) {
            return IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(flex: 5, child: imageWidget),
                  Expanded(flex: 6, child: contentWidget),
                ],
              ),
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [imageWidget, contentWidget],
            );
          }
        },
      ),
    );
  }

  Widget _buildAssessmentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('ZONE / AREA'),
        const SizedBox(height: 10),
        _buildZoneDropdown(),
        const SizedBox(height: 22),
        _label('ASSESSMENT MODE'),
        const SizedBox(height: 10),
        _buildModeChips(),
        const SizedBox(height: 22),
        if (_selectedModes.contains('AQM')) _buildAqmCard(),
        if (_selectedModes.contains('Drone')) _buildDroneCard(),
        if (_selectedModes.contains('Smartwatch')) _buildSmartwatchSection(),
        _label('NOTES (OPTIONAL)'),
        const SizedBox(height: 10),
        _buildNotesField(),
        const SizedBox(height: 90),
      ],
    );
  }

  Widget _buildFlagBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _flagBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _flagColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: _flagColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '$_liveFlagCount health flag${_liveFlagCount == 1 ? '' : 's'} raised — readings are outside safe range. You can still continue.',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _flagColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(
        text,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _headerColor, letterSpacing: 0.5),
      );

  Widget _buildZoneDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _zoneWasAutoSelected ? _headerColor.withValues(alpha: 0.4) : const Color(0xFFE0E3EA),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedZone,
              hint: Text('Select zone', style: TextStyle(color: Colors.grey[400])),
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: _headerColor),
              items: _zones.map((z) => DropdownMenuItem(value: z, child: Text(z))).toList(),
              onChanged: (val) => setState(() {
                _selectedZone = val;
                _zoneWasAutoSelected = false;
              }),
            ),
          ),
        ),
        if (_zoneWasAutoSelected) ...[
          const SizedBox(height: 6),
          Text('Auto-selected based on inspection type — tap to change',
              style: TextStyle(fontSize: 11, color: Colors.grey[500], fontStyle: FontStyle.italic)),
        ],
      ],
    );
  }

  Widget _buildModeChips() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _modes.map((mode) {
        final value = mode['value'] as String;
        final isSelected = _selectedModes.contains(value);
        return GestureDetector(
          onTap: () => setState(() {
            if (isSelected) {
              _selectedModes.remove(value);
            } else {
              _selectedModes.add(value);
              if (value == 'Smartwatch' && _workerIds.isEmpty) _addWorker();
            }
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? _headerColor : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isSelected ? _headerColor : const Color(0xFFD5D8E0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(mode['icon'] as IconData, size: 18, color: isSelected ? Colors.white : const Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Text(mode['label'] as String,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : const Color(0xFF1A1A2E))),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildAqmCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.air_rounded, size: 16, color: _headerColor),
              SizedBox(width: 8),
              Text('AQM Reading', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ..._aqmFields.map((field) => _flaggableField(
                controller: _aqmController(field),
                label: field,
                isFlagged: () => _isAqmFieldFlagged(field, _aqmController(field).text),
                flagMessage: 'Above safe limit',
              )),
        ],
      ),
    );
  }

  Widget _buildDroneCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.flight_rounded, size: 16, color: _headerColor),
              SizedBox(width: 8),
              Text('Drone Sweep', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ..._droneFields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: TextField(
                  controller: _droneController(field),
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: field,
                    isDense: true,
                    filled: true,
                    fillColor: const Color(0xFFF5F7FA),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildSmartwatchSection() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.watch_rounded, size: 16, color: _headerColor),
              SizedBox(width: 8),
              Text('Smartwatch Spot-Check', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 12),
          ..._workerIds.asMap().entries.map((entry) {
            final index = entry.key;
            final id = entry.value;
            return _buildWorkerCard(id, index + 1);
          }),
          const SizedBox(height: 4),
          OutlinedButton.icon(
            onPressed: _addWorker,
            icon: const Icon(Icons.add_rounded, size: 18, color: _headerColor),
            label: const Text('Add Another Worker', style: TextStyle(color: _headerColor, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: _headerColor),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkerCard(String id, int number) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: _headerColor, borderRadius: BorderRadius.circular(8)),
                alignment: Alignment.center,
                child: Text('$number', style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Text('Worker $number', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
              const Spacer(),
              if (_workerIds.length > 1)
                GestureDetector(
                  onTap: () => _removeWorker(id),
                  child: const Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFF9CA3AF)),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _workerNameControllers[id],
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Worker Name',
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF5F7FA),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          _flaggableField(
            controller: _workerHrControllers[id]!,
            label: 'Heart Rate (bpm)',
            isFlagged: () => _isHrFlagged(_workerHrControllers[id]!.text),
            flagMessage: 'Outside safe range (${HealthThresholds.minHeartRate.toInt()}–${HealthThresholds.maxHeartRate.toInt()} bpm)',
          ),
          _flaggableField(
            controller: _workerSpo2Controllers[id]!,
            label: 'SpO2 (%)',
            isFlagged: () => _isSpo2Flagged(_workerSpo2Controllers[id]!.text),
            flagMessage: 'Below safe oxygen level (< ${HealthThresholds.minSpo2.toInt()}%)',
          ),
        ],
      ),
    );
  }

  Widget _flaggableField({
    required TextEditingController controller,
    required String label,
    required bool Function() isFlagged,
    required String flagMessage,
  }) {
    final flagged = isFlagged();
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: label,
              isDense: true,
              filled: true,
              fillColor: flagged ? _flagBg : const Color(0xFFF5F7FA),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: flagged ? const BorderSide(color: _flagColor, width: 1.4) : BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: flagged ? const BorderSide(color: _flagColor, width: 1.4) : BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              suffixIcon: flagged ? const Icon(Icons.warning_amber_rounded, color: _flagColor, size: 20) : null,
            ),
          ),
          if (flagged) ...[
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text('⚠️ $flagMessage', style: const TextStyle(fontSize: 11, color: _flagColor, fontWeight: FontWeight.w600)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildNotesField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E3EA)),
      ),
      child: TextField(
        controller: _notesController,
        maxLines: 3,
        decoration: const InputDecoration(
          hintText: 'Any additional observations...',
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildSubmitBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_liveFlagCount > 0) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: _flagBg,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _flagColor.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_amber_rounded, color: _flagColor, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '$_liveFlagCount reading${_liveFlagCount == 1 ? '' : 's'} flagged outside safe range',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _flagColor),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: OutlinedButton(
                      onPressed: _canSubmit ? _showRiskSummary : null,
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: _canSubmit ? _headerColor : const Color(0xFFD5D8E0)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Text('View Risk Summary',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: _canSubmit ? _headerColor : const Color(0xFFBDBDBD))),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _canSubmit ? _submit : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _headerColor,
              disabledBackgroundColor: Colors.grey.shade300,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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

  void _showRiskSummary() {
    final details = <String>[];
    for (final id in _workerIds) {
      final name = _workerNameControllers[id]?.text.trim() ?? 'Worker';
      final hr = _workerHrControllers[id]?.text ?? '';
      final spo2 = _workerSpo2Controllers[id]?.text ?? '';
      if (_isHrFlagged(hr)) details.add('$name — Heart rate outside safe range');
      if (_isSpo2Flagged(spo2)) details.add('$name — Low SpO2');
    }
    for (final field in _aqmFields) {
      final value = _aqmController(field).text;
      if (_isAqmFieldFlagged(field, value)) details.add('AQM — $field outside safe limit');
    }

    final totalChecks = _workerIds.length * 2 + _aqmFields.length;

    RiskSummarySheet.show(
      context,
      flagCount: _liveFlagCount,
      totalChecks: totalChecks,
      flagDetails: details,
    );
  }
}