import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class HireDriverScreen extends StatefulWidget {
  const HireDriverScreen({super.key});

  @override
  State<HireDriverScreen> createState() => _HireDriverScreenState();
}

class _HireDriverScreenState extends State<HireDriverScreen> {
  String _hireDuration = 'Hourly';
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<Map<String, dynamic>> _hourlyOptions = [
    {'duration': '4 Hours', 'price': '₹600'},
    {'duration': '8 Hours', 'price': '₹1,100'},
    {'duration': '12 Hours', 'price': '₹1,600'},
  ];

  final List<Map<String, dynamic>> _dailyOptions = [
    {'duration': '1 Day', 'price': '₹2,000'},
    {'duration': '3 Days', 'price': '₹5,500'},
    {'duration': '7 Days', 'price': '₹12,000'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hire Driver'),
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: AppTheme.primaryBlue),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Use your own car with our professional drivers',
                            style: TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
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
                  const Text('Hire Duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildDurationTypeButton('Hourly')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildDurationTypeButton('Daily')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...(_hireDuration == 'Hourly' ? _hourlyOptions : _dailyOptions).map((o) => _buildOptionCard(o)),
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
                            Text('What\'s Included', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text('• Verified & experienced drivers', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        Text('• Background checked', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        Text('• Professional driving', style: TextStyle(fontSize: 13)),
                        SizedBox(height: 6),
                        Text('• Flexible timing', style: TextStyle(fontSize: 13)),
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
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Hire Driver', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationTypeButton(String type) {
    final isSelected = _hireDuration == type;
    return GestureDetector(
      onTap: () => setState(() => _hireDuration = type),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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

  Widget _buildOptionCard(Map<String, dynamic> option) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withAlpha(30),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.person_pin, color: AppTheme.primaryBlue, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(option['duration'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          Text(option['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppTheme.primaryBlue)),
        ],
      ),
    );
  }
}
