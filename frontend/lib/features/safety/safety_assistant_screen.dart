import 'package:flutter/material.dart';

<<<<<<< HEAD
class SafetyAssistantScreen extends StatelessWidget {
  const SafetyAssistantScreen({super.key});

  @override
  Widget build(BuildContext context) {
=======
class SafetyAssistantScreen extends StatefulWidget {
  const SafetyAssistantScreen({super.key});

  @override
  State<SafetyAssistantScreen> createState() => _SafetyAssistantScreenState();
}

class _SafetyAssistantScreenState extends State<SafetyAssistantScreen> {
  bool _isChecking = false;
  String? _resultType; // 'price' or 'safety'

  @override
  Widget build(BuildContext context) {
    const primaryGreen = Color(0xFF006233);
    const accentRed = Color(0xFFC1272D);

>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
<<<<<<< HEAD
          'Safety & Travel Guide',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFC1272D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFC1272D), Color(0xFF006233)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Column(
                children: [
                  Icon(Icons.shield, size: 60, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    'Morocco: Essential Safety',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    '& Travel Guide',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
=======
          "Local Safety & Prices",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.gpp_good,
                      size: 60,
                      color: primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 15),
                  const Text(
                    "Ask your Moroccan Fixer",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "Get fair prices and stay safe in the Medina.",
                    style: TextStyle(color: Colors.grey),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
                  ),
                ],
              ),
            ),

<<<<<<< HEAD
            // Emergency Numbers Section
            _buildSection(
              title: '🚨 Emergency Numbers (Toll-Free)',
              color: const Color(0xFFC1272D),
              children: [
                _buildEmergencyCard(
                  icon: Icons.local_police,
                  title: 'Police (Urban Areas)',
                  number: '19',
                  color: Colors.blue,
                ),
                _buildEmergencyCard(
                  icon: Icons.security,
                  title: 'Royal Gendarmerie',
                  subtitle: '(Rural Areas & Highways)',
                  number: '177',
                  color: Colors.green,
                ),
                _buildEmergencyCard(
                  icon: Icons.local_hospital,
                  title: 'Ambulance & Fire Brigade',
                  number: '15',
                  color: Colors.red,
                ),
                _buildInfoCard(
                  icon: Icons.medical_services,
                  title: 'SOS Médecins',
                  subtitle: '(Private Emergency Doctor)',
                  info: '+212 5 22 98 98 98',
                  note: 'Consult local listings for other cities',
                  color: Colors.teal,
                ),
              ],
            ),

            // Health & Hygiene
            _buildSection(
              title: '🏥 Health & Hygiene',
              color: const Color(0xFF006233),
              children: [
                _buildTipCard(
                  icon: Icons.water_drop,
                  title: 'Drinking Water',
                  tip: 'It is highly recommended to drink bottled water only. Avoid tap water unless boiled.',
                  color: Colors.blue,
                ),
                _buildTipCard(
                  icon: Icons.local_pharmacy,
                  title: 'Pharmacies',
                  tip: 'Look for the Green Cross neon sign. Pharmacists are well-trained and can assist with minor ailments.',
                  color: Colors.green,
                ),
                _buildNoteCard(
                  text: '"Pharmacie de Garde" refers to pharmacies open 24/7 or on weekends.',
                ),
              ],
            ),

            // Personal Safety Tips
            _buildSection(
              title: '🛡️ Personal Safety Tips',
              color: Colors.orange,
              children: [
                _buildTipCard(
                  icon: Icons.badge,
                  title: 'Official Guides',
                  tip: 'Only hire guides who display an official badge issued by the Ministry of Tourism. Politely decline offers from unofficial guides on the street.',
                  color: const Color(0xFF006233),
                ),
                _buildTipCard(
                  icon: Icons.shopping_bag,
                  title: 'Crowded Areas',
                  tip: 'Be mindful of your belongings in busy Souks (markets) and tourist hotspots to prevent pickpocketing.',
                  color: Colors.amber,
                ),
                _buildTipCard(
                  icon: Icons.nightlight,
                  title: 'Night Travel',
                  tip: 'Stick to well-lit, busy streets at night. Avoid walking alone in isolated areas.',
                  color: Colors.indigo,
                ),
              ],
            ),

            // Transportation Safety
            _buildSection(
              title: '🚕 Transportation Safety',
              color: Colors.deepOrange,
              children: [
                _buildTransportCard(
                  icon: Icons.local_taxi,
                  title: 'Petit Taxi (Small Taxis)',
                  description: 'Specific color for each city (e.g., Red in Casablanca, Blue in Rabat). They operate within city limits.',
                  tip: 'Always insist on using the meter ("Compteur").',
                  color: Colors.blue,
                ),
                _buildTransportCard(
                  icon: Icons.airport_shuttle,
                  title: 'Grand Taxi (Large Taxis)',
                  description: 'Shared taxis used for longer distances or fixed routes. Prices are usually fixed per seat.',
                  tip: null,
                  color: Colors.orange,
                ),
              ],
            ),

            // Local Etiquette & Laws
            _buildSection(
              title: '🤝 Local Etiquette & Laws',
              color: const Color(0xFF006233),
              children: [
                _buildTipCard(
                  icon: Icons.camera_alt,
                  title: 'Photography',
                  tip: 'Always ask for permission before taking photos of locals. Strictly avoid photographing police, military personnel, or government buildings.',
                  color: Colors.purple,
                ),
                _buildTipCard(
                  icon: Icons.checkroom,
                  title: 'Dress Code',
                  tip: 'While major cities are modern, it is respectful to dress modestly, especially when visiting rural areas or near mosques.',
                  color: Colors.pink,
                ),
                _buildTipCard(
                  icon: Icons.attach_money,
                  title: 'Currency',
                  tip: 'The currency is the Moroccan Dirham (MAD). Keep some cash on hand as smaller vendors may not accept cards.',
                  color: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 30),
=======
            const SizedBox(height: 35),

            // Action Cards
            _buildActionCard(
              title: "Check a Fair Price",
              subtitle: "Avoid overpaying for leather, spices, or taxis.",
              icon: Icons.sell,
              color: primaryGreen,
              onTap: () => _showSearchModal("price"),
            ),
            const SizedBox(height: 15),
            _buildActionCard(
              title: "Get Safety Advice",
              subtitle: "How to handle 'faux guides' or late-night walks.",
              icon: Icons.security,
              color: accentRed,
              onTap: () => _showSearchModal("safety"),
            ),

            const SizedBox(height: 30),

            const Text(
              "2026 Price Benchmarks",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            _buildPriceTable(),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
          ],
        ),
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildSection({
    required String title,
    required Color color,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required String number,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              number,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
=======
  Widget _buildActionCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              radius: 25,
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    String? subtitle,
    required String info,
    String? note,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  info,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                if (note != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    note,
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String tip,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  tip,
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportCard({
    required IconData icon,
    required String title,
    required String description,
    String? tip,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 13,
            ),
          ),
          if (tip != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tips_and_updates, color: Colors.amber, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Tip: $tip',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
=======
  Widget _buildPriceTable() {
    final List<Map<String, String>> prices = [
      {"item": "Petit Taxi (Small Trip)", "price": "10-20 MAD"},
      {"item": "Leather Pouf (Average)", "price": "150-300 MAD"},
      {"item": "Street Food Tagine", "price": "40-70 MAD"},
      {"item": "Guided Tour (Half Day)", "price": "200-350 MAD"},
    ];

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F7F4),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: const Color(0xFF006233).withOpacity(0.3)),
      ),
      child: Column(
        children: prices
            .map(
              (p) => ListTile(
                title: Text(p['item']!),
                trailing: Text(
                  p['price']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF006233),
                  ),
                ),
                dense: true,
              ),
            )
            .toList(),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
      ),
    );
  }

<<<<<<< HEAD
  Widget _buildNoteCard({required String text}) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.black87,
              ),
            ),
          ),
        ],
=======
  void _showSearchModal(String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 20,
          right: 20,
          top: 25,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              type == "price"
                  ? "What are you buying?"
                  : "What's the situation?",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(
                hintText: type == "price"
                    ? "e.g. Berber Carpet in Fes"
                    : "e.g. Someone following me",
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: type == "price"
                      ? const Color(0xFF006233)
                      : const Color(0xFFC1272D),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text("Get AI Advice"),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
      ),
    );
  }
}
