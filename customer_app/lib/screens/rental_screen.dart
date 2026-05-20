import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RentalScreen extends StatefulWidget {
  const RentalScreen({super.key});

  @override
  State<RentalScreen> createState() => _RentalScreenState();
}

class _RentalScreenState extends State<RentalScreen> {
  String? _selectedPackage;
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<Map<String, dynamic>> _packages = [
    {'duration': '4 Hours', 'distance': '40 km', 'price': '₹800', 'icon': Icons.schedule},
    {'duration': '8 Hours', 'distance': '80 km', 'price': '₹1,500', 'icon': Icons.schedule},
    {'duration': '12 Hours', 'distance': '120 km', 'price': '₹2,200', 'icon': Icons.schedule},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rental Package'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pickup Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildLocationField(Icons.radio_button_checked, 'Enter pickup location', _pickupController),
                  const SizedBox(height: 16),
                  const Text('Drop Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildLocationField(Icons.location_on, 'Enter drop location', _dropController),
                  const SizedBox(height: 24),
                  const Text('Select Date & Time', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() => _selectedDate = date);
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: Text(_selectedDate == null 
                            ? 'Select Date' 
                            : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (time != null) {
                              setState(() => _selectedTime = time);
                            }
                          },
                          icon: const Icon(Icons.access_time, size: 18),
                          label: Text(_selectedTime == null 
                            ? 'Select Time' 
                            : _selectedTime!.format(context)),
                          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Select Package', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ..._packages.map((p) => _buildPackageCard(p)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: AppTheme.primaryBlue, size: 20),
                            SizedBox(width: 8),
                            Text('Package Benefits', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text('• Unlimited stops within package', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        Text('• Fixed pricing, no surge', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        Text('• Extra km charged at ₹12/km', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        Text('• Extra hour charged at ₹150/hr', style: TextStyle(fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: ElevatedButton(
              onPressed: _selectedPackage == null ? null : () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Book Package', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField(IconData icon, String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackageCard(Map<String, dynamic> p) {
    final isSelected = _selectedPackage == p['duration'];
    return GestureDetector(
      onTap: () => setState(() => _selectedPackage = p['duration']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue.withAlpha(30) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryBlue : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(p['icon'], color: isSelected ? Colors.white : AppTheme.textGrey, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(p['duration'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('Up to ${p['distance']}', style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                ],
              ),
            ),
            Text(p['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryBlue)),
          ],
        ),
      ),
    );
  }
}
