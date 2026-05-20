import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class OutstationScreen extends StatefulWidget {
  const OutstationScreen({super.key});

  @override
  State<OutstationScreen> createState() => _OutstationScreenState();
}

class _OutstationScreenState extends State<OutstationScreen> {
  String _tripType = 'One Way';
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Outstation Trip'),
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
                  const Text('Trip Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildTripTypeButton('One Way')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildTripTypeButton('Round Trip')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Pickup Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildLocationField(Icons.radio_button_checked, 'Enter pickup city', _pickupController),
                  const SizedBox(height: 16),
                  const Text('Drop Location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  _buildLocationField(Icons.location_on, 'Enter drop city', _dropController),
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withAlpha(30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Estimated Fare', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Text('₹2,500 - ₹4,000', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                        SizedBox(height: 8),
                        Text('For approx. 250 km', style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
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
              child: const Text('Search Cabs', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeButton(String type) {
    final isSelected = _tripType == type;
    return GestureDetector(
      onTap: () => setState(() => _tripType = type),
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
}
