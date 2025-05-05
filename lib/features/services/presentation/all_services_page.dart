import 'package:flutter/material.dart';

class AllServicesPage extends StatelessWidget {
  const AllServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcha servislar'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildCategorySection('Soch xizmatlari', _getHairServices()),
          const SizedBox(height: 24),
          _buildCategorySection('Massaj xizmatlari', _getMassageServices()),
          const SizedBox(height: 24),
          _buildCategorySection('Tirnoq xizmatlari', _getNailServices()),
          const SizedBox(height: 24),
          _buildCategorySection('Boshqa xizmatlar', _getOtherServices()),
        ],
      ),
    );
  }

  Widget _buildCategorySection(String title, List<Map<String, dynamic>> services) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...services.map((service) => _buildServiceItem(service)).toList(),
      ],
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> service) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.pink.shade100,
          child: Icon(
            service['icon'] as IconData,
            color: Colors.pink,
          ),
        ),
        title: Text(service['name'] as String),
        subtitle: Text('${service['duration']} • ${service['price']} so\'m'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          // Navigate to service details or booking
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getHairServices() {
    return [
      {
        'name': 'Soch kesish',
        'icon': Icons.content_cut,
        'duration': '30 daqiqa',
        'price': '50,000',
      },
      {
        'name': 'Soch bo\'yash',
        'icon': Icons.color_lens,
        'duration': '2 soat',
        'price': '250,000',
      },
      {
        'name': 'Soch ukladkasi',
        'icon': Icons.brush,
        'duration': '45 daqiqa',
        'price': '80,000',
      },
    ];
  }

  List<Map<String, dynamic>> _getMassageServices() {
    return [
      {
        'name': 'Klassik massaj',
        'icon': Icons.spa,
        'duration': '1 soat',
        'price': '150,000',
      },
      {
        'name': 'Sport massaji',
        'icon': Icons.fitness_center,
        'duration': '45 daqiqa',
        'price': '180,000',
      },
    ];
  }

  List<Map<String, dynamic>> _getNailServices() {
    return [
      {
        'name': 'Manikur',
        'icon': Icons.brush,
        'duration': '40 daqiqa',
        'price': '60,000',
      },
      {
        'name': 'Pedikur',
        'icon': Icons.brush,
        'duration': '50 daqiqa',
        'price': '80,000',
      },
    ];
  }

  List<Map<String, dynamic>> _getOtherServices() {
    return [
      {
        'name': 'Makiyaj',
        'icon': Icons.face,
        'duration': '1 soat',
        'price': '120,000',
      },
      {
        'name': 'Qosh korektsiyasi',
        'icon': Icons.remove_red_eye,
        'duration': '30 daqiqa',
        'price': '40,000',
      },
    ];
  }
}
