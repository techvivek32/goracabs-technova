import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'taxi_booking_screen.dart';
import 'outstation_screen.dart';
import 'rental_screen.dart';
import 'hire_driver_screen.dart';

class ServiceSelectionScreen extends StatelessWidget {
  const ServiceSelectionScreen({super.key});

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
        children: [
          _buildServiceCard(
            context,
            'Taxi',
            'Quick rides within the city',
            Icons.local_taxi,
            AppTheme.primaryBlue,
            ['Point to point', 'Multiple stops', 'Instant booking'],
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TaxiBookingScreen())),
          ),
          const SizedBox(height: 16),
          _buildServiceCard(
            context,
            'Outstation Trip',
            'Long distance travel',
            Icons.route,
            AppTheme.primaryBlue,
            ['One-way & Round trip', 'Multiple cities', 'Flexible timing'],
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OutstationScreen())),
          ),
          const SizedBox(height: 16),
          _buildServiceCard(
            context,
            'Rental Package',
            'Hourly car rental',
            Icons.schedule,
            AppTheme.primaryBlue,
            ['4hr, 8hr, 12hr packages', 'Unlimited stops', 'Fixed pricing'],
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RentalScreen())),
          ),
          const SizedBox(height: 16),
          _buildServiceCard(
            context,
            'Hire Driver',
            'Get a professional driver',
            Icons.person_pin,
            AppTheme.primaryBlue,
            ['Use your own car', 'Experienced drivers', 'Hourly/Daily basis'],
            () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HireDriverScreen())),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, String title, String subtitle, IconData icon, Color color, List<String> features, VoidCallback onTap) {
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
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: color.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(fontSize: 13, color: AppTheme.textGrey)),
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
                      Icon(Icons.check_circle, size: 16, color: color),
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

