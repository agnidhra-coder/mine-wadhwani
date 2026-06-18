import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MineInfoPage extends StatelessWidget {
  final String mineName;
  final String mineType;
  final String company;
  final String subsidiary;

  const MineInfoPage({
    super.key,
    required this.mineName,
    required this.mineType,
    required this.company,
    required this.subsidiary,
  });

  static const Color navyBlue = Color(0xFF1F579C);
  static const Color lightBg = Color(0xFFF5F7FA);
  static const Color greenAccent = Color(0xFF3DAA6E);

  // ── Replace with your actual mine info website URL ──────────────────
  static const String _mineWebsiteUrl = 'https://bcclweb.in/?page_id=6322';
  // ────────────────────────────────────────────────────────────────────

  Future<void> _launchWebsite() async {
    final uri = Uri.parse(_mineWebsiteUrl);
    try {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      await launchUrl(
        uri,
        mode: LaunchMode.inAppWebView,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBg,
      appBar: AppBar(
        backgroundColor: navyBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mine Info',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Review before inspection',
              style: TextStyle(fontSize: 11, color: Colors.white60),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Scrollable content ──────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mine identity header
                  _buildMineHeader(),
                  const SizedBox(height: 20),

                  // Overview paragraph + stats
                  _buildSectionTitle('Overview'),
                  const SizedBox(height: 10),
                  _buildOverviewText(),
                  const SizedBox(height: 20),

                  // Key mine details
                  _buildSectionTitle('Mine Details'),
                  const SizedBox(height: 10),
                  _buildInfoCard([
                    _infoRow('Location', 'Dhanbad, Jharkhand'),
                    _infoRow('Established', '1972'),
                    _infoRow('Total Area', '2,500 - 3,500 hectares'),
                    _infoRow('Pit Depth', '~85 m (open pit)'),
                    _infoRow('Coal Grade', 'Coking'),
                    _infoRow('Annual Capacity', '1.8 Million Tonnes'),
                    _infoRow('Regulatory Zone', 'DGMS Zone III'),
                    _infoRow('Safety Rating', 'B+ (Good)',
                        valueColor: greenAccent),
                  ]),
                  const SizedBox(height: 20),

                  // Hazard profile
                  _buildSectionTitle('Hazard & Risk Profile'),
                  const SizedBox(height: 10),
                  _buildInfoCard([
                    _infoRow('Flooding Risk', 'Medium',
                        valueColor: const Color(0xFFBA7517)),
                    _infoRow('Slope Stability', 'Moderate concern',
                        valueColor: const Color(0xFFBA7517)),
                    _infoRow('Dust Level (SPM)', '320 µg/m³ — High',
                        valueColor: Colors.red[700]!),
                    _infoRow('Blast Frequency', '2× per day'),
                    _infoRow('Groundwater', 'Monitored, stable'),
                    _infoRow('Gas Hazard', 'Low (opencast)',
                        valueColor: greenAccent),
                  ]),
                  const SizedBox(height: 20),

                  // Open action items
                  _buildSectionTitle('Open Action Items'),
                  const SizedBox(height: 10),
                  _buildActionItem(
                    severity: 'High',
                    severityColor: Colors.red[700]!,
                    severityBg: const Color(0xFFFCEBEB),
                    description:
                        'Conveyor belt guard missing at Bench 3',
                    daysOpen: 12,
                  ),
                  const SizedBox(height: 8),
                  _buildActionItem(
                    severity: 'Medium',
                    severityColor: const Color(0xFF854F0B),
                    severityBg: const Color(0xFFFAEEDA),
                    description:
                        'Dust suppression system partially offline near loading bay',
                    daysOpen: 7,
                  ),
                  const SizedBox(height: 8),
                  _buildActionItem(
                    severity: 'Low',
                    severityColor: const Color(0xFF3B6D11),
                    severityBg: const Color(0xFFEAF3DE),
                    description:
                        'Emergency signage update pending at entry gate',
                    daysOpen: 3,
                  ),
                  const SizedBox(height: 20),

                  // Last inspections
                  _buildSectionTitle('Last 3 Inspections'),
                  const SizedBox(height: 10),
                  _buildInfoCard([
                    _inspectionRow(
                        'General Safety', '02 Apr 2026', 88, Colors.green),
                    _inspectionRow(
                        'Environmental', '18 Mar 2026', 71, Colors.orange),
                    _inspectionRow(
                        'Equipment Check', '05 Mar 2026', 59, Colors.red),
                  ]),
                  const SizedBox(height: 20),

                  // Emergency contacts
                  _buildSectionTitle('Emergency Contacts'),
                  const SizedBox(height: 10),
                  _buildInfoCard([
                    _infoRow('General Manager', 'Name · +91 94301 XXXXX',
                        valueColor: navyBlue),
                    _infoRow('Project Officer', 'Name · +91 98310 XXXXX',
                        valueColor: navyBlue),
                    _infoRow('Mine Manager', 'Name · +91 94301 XXXXX',
                        valueColor: navyBlue),
                    _infoRow('Safety Officer', 'Name · +91 94301 XXXXX',
                        valueColor: navyBlue),
                    _infoRow('Public Control Room', 'not avalaible',
                        valueColor: navyBlue),
                    _infoRow('Medical Centre', 'not avalaible',
                        valueColor: navyBlue),
                    _infoRow('Fire Station', 'not avalaible',
                        valueColor: navyBlue),
                  ]),
                  const SizedBox(height: 20),

                  // Website link
                  _buildWebsiteLink(),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // ── Sticky accept button ────────────────────────────────────
          _buildAcceptBar(context),
        ],
      ),
    );
  }

  Widget _buildMineHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: navyBlue,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.terrain_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mineName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$subsidiary · $mineType',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white70),
                ),
                const SizedBox(height: 3),
                Text(
                  company,
                  style: const TextStyle(
                      fontSize: 11, color: Colors.white54),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: greenAccent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: greenAccent.withValues(alpha: 0.5), width: 1),
            ),
            child: const Text(
              'Active',
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7EEAAA)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewText() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'The $mineName is an ${mineType.toLowerCase()} coking coal mine operated by '
            '$subsidiary under $company, located in Dhanbad, Jharkhand. This area is part of the famous Jharia coalfield, known for high-quality coking coal used in steel production.'
            ' The area has significant coal reserves of around 331 million tonnes, making it an important contributor to India’s coal production. The mines extract both metallurgical (coking) and thermal coal.'
            ' However, Kusunda Area faces major challenges such as mine fires and land subsidence, which are common in the Jharia coalfield due to over a century of mining. ',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 10),
          _statRow(Icons.bar_chart_rounded, 'Daily Output', '4,200 tonnes/day'),
          _statRow(Icons.track_changes_rounded, 'Monthly Target', '82% achieved'),
          _statRow(Icons.people_rounded, 'Workforce', '214 workers'),
          _statRow(Icons.precision_manufacturing_rounded, 'Active Equipment', '5 Excavators, 20 Dumpers'),
        ],
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 15, color: navyBlue),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: navyBlue,
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildInfoCard(List<Widget> rows) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(children: rows),
    );
  }

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ),
          Expanded(
            flex: 5,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: valueColor ?? const Color(0xFF1A1A2E),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inspectionRow(
      String type, String date, int score, Color dotColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration:
                BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(type,
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E))),
          ),
          Text(date,
              style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          const SizedBox(width: 10),
          Text(
            '$score/100',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: dotColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required String severity,
    required Color severityColor,
    required Color severityBg,
    required String description,
    required int daysOpen,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: severityBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              severity,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: severityColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              description,
              style: const TextStyle(
                  fontSize: 12, color: Color(0xFF1A1A2E), height: 1.4),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            '${daysOpen}d',
            style: TextStyle(fontSize: 11, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteLink() {
    return GestureDetector(
      onTap: _launchWebsite,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: navyBlue.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: navyBlue.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(Icons.language_rounded, size: 18, color: navyBlue),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full mine details on official website',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: navyBlue,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _mineWebsiteUrl,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[500],
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.open_in_new_rounded,
                size: 16, color: navyBlue),
          ],
        ),
      ),
    );
  }

  Widget _buildAcceptBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            top: BorderSide(color: Colors.grey.shade200, width: 0.5)),
      ),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(true),
          icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
          label: const Text(
            'I have reviewed — proceed',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: navyBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}