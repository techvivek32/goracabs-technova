import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'taxi_booking_screen.dart';
import 'outstation_screen.dart';
import 'rental_screen.dart';
import 'hire_driver_screen.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

  final List<Map<String, dynamic>> _services = const [
    {'icon': 'assets/images/texi.png', 'label': 'Taxi', 'subtitle': 'Quick rides within the city', 'color': Color(0xFF2196F3), 'bgColor': Color(0xFFE3F2FD)},
    {'icon': 'assets/images/outstation.png', 'label': 'Outstation Trip', 'subtitle': 'Long distance travel', 'color': Color(0xFF4CAF50), 'bgColor': Color(0xFFE8F5E9)},
    {'icon': 'assets/images/rental.png', 'label': 'Rental Package', 'subtitle': 'Hourly car rental', 'color': Color(0xFFFF9800), 'bgColor': Color(0xFFFFF3E0)},
    {'icon': 'assets/images/hiredriver.png', 'label': 'Hire Driver', 'subtitle': 'Get a professional driver', 'color': Color(0xFF9C27B0), 'bgColor': Color(0xFFF3E5F5)},
  ];

  final List<List<String>> _features = const [
    ['Point to point', 'Multiple stops', 'Instant booking'],
    ['One-way & Round trip', 'Multiple cities', 'Flexible timing'],
    ['4hr, 8hr, 12hr packages', 'Unlimited stops', 'Fixed pricing'],
    ['Use your own car', 'Experienced drivers', 'Hourly/Daily basis'],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Service'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: _services.asMap().entries.map((entry) {
          final index = entry.key;
          final service = entry.value;
          return Column(
            children: [
              _buildServiceCard(
                context,
                service,
                _features[index],
                () {
                  if (service['label'] == 'Taxi') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const TaxiBookingScreen()));
                  } else if (service['label'] == 'Outstation Trip') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const OutstationScreen()));
                  } else if (service['label'] == 'Rental Package') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RentalScreen()));
                  } else if (service['label'] == 'Hire Driver') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HireDriverScreen()));
                  }
                },
              ),
              if (index < _services.length - 1) const SizedBox(height: 16),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, Map<String, dynamic> service, List<String> features, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: service['bgColor'] as Color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      service['icon'] as String,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service['label'] as String, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(service['subtitle'] as String, style: const TextStyle(fontSize: 13, color: AppTheme.textGrey)),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
              ],
            ),
            const SizedBox(height: 16),
            ...features.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, size: 16, color: AppTheme.primaryBlue),
                      const SizedBox(width: 8),
                      Text(f, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

