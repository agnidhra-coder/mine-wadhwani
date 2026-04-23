import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_signature/signature.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_data.dart';
import 'package:mine_wadhwani/presentation/screens/stockpile/stockpile_report_preview_page.dart';

class StockpileCompliancePage extends StatefulWidget {
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
  final String inspectorName;
  final String inspectorRole;

  const StockpileCompliancePage({
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
    required this.inspectorName,
    required this.inspectorRole,
  });

  @override
  State<StockpileCompliancePage> createState() =>
      _StockpileCompliancePageState();
}

class _StockpileCompliancePageState extends State<StockpileCompliancePage> {
  static const _headerColor = Color(0xFF1F579C);

  final TextEditingController _observationsController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final HandSignatureControl _signatureControl = HandSignatureControl();
  bool _isSubmitting = false;
  bool _signatureEmpty = true;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.inspectorName;
    _signatureControl.addListener(_onSignatureChanged);
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

  void _onSignatureChanged() {
    final isEmpty = !_signatureControl.hasActivePath &&
        (_signatureControl.paths.isEmpty);
    if (isEmpty != _signatureEmpty) {
      setState(() => _signatureEmpty = isEmpty);
    }
  }

  @override
  void dispose() {
    _observationsController.dispose();
    _nameController.dispose();
    _signatureControl.removeListener(_onSignatureChanged);
    _signatureControl.dispose();
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

  void _validateAndSubmit() async {
    if (_nameController.text.trim().isEmpty) {
      _showError('Please enter your name before submitting.');
      return;
    }
    if (_signatureEmpty) {
      _showError('Please sign before submitting.');
      return;
    }
    setState(() => _isSubmitting = true);
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSubmitting = false);
    // TODO: connect to real API
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle_outline,
                color: Color(0xFF10B981), size: 24),
            SizedBox(width: 10),
            Text('Inspection Submitted'),
          ],
        ),
        content:
            const Text('The inspection has been submitted successfully.'),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: pop to root / home
            },
            style:
                FilledButton.styleFrom(backgroundColor: _headerColor),
            child: const Text('Done'),
          ),
        ],
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
    // Capture signature
  Uint8List? signatureBytes;
try {
  final byteData = await _signatureControl.toImage(
    width: 600,
    height: 200,
    background: Colors.white,
  );
  signatureBytes = byteData?.buffer.asUint8List();
} catch (_) {
  signatureBytes = null;
}

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StockpileReportPreviewPage(
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
          inspectorName: _nameController.text.trim(),
          inspectorRole: widget.inspectorRole,
          observations: _observationsController.text.trim(),
          signatureBytes: signatureBytes,
          reviewedAt: DateTime.now(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: Column(
        children: [
          _buildHeader(statusBarHeight),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left panel — Observations
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 12, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('GENERAL OBSERVATIONS'),
                        const SizedBox(height: 10),
                        _buildObservationsCard(),
                        const SizedBox(height: 16),
                        _buildSectionLabel('INSPECTOR NAME'),
                        const SizedBox(height: 10),
                        _buildNameField(),
                      ],
                    ),
                  ),
                ),
                // Right panel — Signature
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(12, 20, 24, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('SIGNATURE'),
                        const SizedBox(height: 10),
                        _buildSignatureCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

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
                // Inspector badge
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

  Widget _buildObservationsCard() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: _headerColor),
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
            color: AppColors.outline.withValues(alpha: 0.5),
            fontSize: 13,
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFFE0E3EA), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: _headerColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.all(14),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(context)
            .colorScheme
            .copyWith(primary: _headerColor),
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
            borderSide:
                const BorderSide(color: _headerColor, width: 1.5),
          ),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 14, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSignatureCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 220,
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
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                // Signature line
                Positioned(
                  bottom: 48,
                  left: 24,
                  right: 24,
                  child: Container(
                    height: 1,
                    color: const Color(0xFFE0E3EA),
                  ),
                ),
                // Hint text
                if (_signatureEmpty)
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.draw_outlined,
                          size: 28,
                          color: AppColors.outline.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign here',
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                AppColors.outline.withValues(alpha: 0.4),
                          ),
                        ),
                      ],
                    ),
                  ),
                HandSignature(
                  control: _signatureControl,
                  color: const Color(0xFF1A2340),
                  width: 2.0,
                  maxWidth: 5.0,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _signatureEmpty
                  ? 'Draw your signature above'
                  : 'Signature captured ✓',
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
                _signatureControl.clear();
                setState(() => _signatureEmpty = true);
              },
              icon: const Icon(Icons.refresh, size: 14),
              label: const Text('Clear'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.secondary,
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 4),
                textStyle: const TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

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
                // Preview & Export
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: _openPreview,
                      icon: const Icon(Icons.visibility_outlined, size: 18),
                      label: const Text(
                        'Preview & Export',
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
                // Submit & Close
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: FilledButton.icon(
                      onPressed: _canSubmit && !_isSubmitting
                          ? _validateAndSubmit
                          : null,
                      icon: _isSubmitting
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send_rounded, size: 18),
                      label: Text(
                        _isSubmitting ? 'Submitting...' : 'Submit & Close',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: _canSubmit
                            ? _headerColor
                            : const Color(0xFFE0E3EA),
                        foregroundColor: _canSubmit
                            ? Colors.white
                            : const Color(0xFFBDBDBD),
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

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.secondary.withValues(alpha: 0.7),
        letterSpacing: 1.0,
      ),
    );
  }
}