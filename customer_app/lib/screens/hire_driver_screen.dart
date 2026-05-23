import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'hire_driver_booking_details_screen.dart';

class HireDriverScreen extends StatefulWidget {
  const HireDriverScreen({super.key});

  @override
  State<HireDriverScreen> createState() => _HireDriverScreenState();
}

class _HireDriverScreenState extends State<HireDriverScreen> {
  String _hireDuration = 'Hourly';
  String? _selectedPackage;
  String? _selectedVehicle;
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final List<Map<String, dynamic>> _hourlyOptions = [
    {'duration': '4 Hours', 'price': '₹600', 'icon': Icons.schedule, 'color': Color(0xFF2196F3)},
    {'duration': '8 Hours', 'price': '₹1,100', 'icon': Icons.schedule, 'color': Color(0xFF4CAF50)},
    {'duration': '12 Hours', 'price': '₹1,600', 'icon': Icons.schedule, 'color': Color(0xFFFF9800)},
  ];

  final List<Map<String, dynamic>> _dailyOptions = [
    {'duration': '1 Day', 'price': '₹2,000', 'icon': Icons.calendar_today, 'color': Color(0xFF2196F3)},
    {'duration': '3 Days', 'price': '₹5,500', 'icon': Icons.calendar_today, 'color': Color(0xFF4CAF50)},
    {'duration': '7 Days', 'price': '₹12,000', 'icon': Icons.calendar_today, 'color': Color(0xFFFF9800)},
  ];

  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Economy', 'type': 'Comfortable', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF2196F3), 'image': 'assets/images/economy.png'},
    {'name': 'SUV', 'type': 'Premium', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF4CAF50), 'image': 'assets/images/texi.png'},
    {'name': 'Sedan', 'type': 'Spacious', 'capacity': '6', 'icon': Icons.airport_shuttle, 'color': Color(0xFF9C27B0), 'image': 'assets/images/texi2.png'},
    {'name': 'Premium', 'type': 'Luxury', 'capacity': '4', 'icon': Icons.car_rental, 'color': Color(0xFF795548), 'image': 'assets/images/texi3.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Hire Driver'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.radio_button_checked, color: Color(0xFF4CAF50), size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _pickupController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter pickup location',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 9, top: 8, bottom: 8),
                          child: Row(
                            children: [
                              Column(
                                children: List.generate(3, (index) => Container(
                                  margin: const EdgeInsets.symmetric(vertical: 1),
                                  width: 2,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[400],
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                )),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Color(0xFFFF5252), size: 18),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 40,
                                child: TextField(
                                  controller: _dropController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter drop location',
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 14),
                                  ),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  const Text('Hire Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildHireModeButton('Hourly')),
                      const SizedBox(width: 12),
                      Expanded(child: _buildHireModeButton('Daily')),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Select ${_hireDuration == 'Hourly' ? 'Hours' : 'Days'}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: (_hireDuration == 'Hourly' ? _hourlyOptions : _dailyOptions).map((opt) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: _buildPackageBox(opt['duration']),
                        ),
                      );
                    }).toList(),
                  ),
                  if (_selectedPackage != null) ...[
                    const SizedBox(height: 16),
                    _buildPackageDetailsCard(),
                  ],
                  const SizedBox(height: 20),
                  const Text('Select Your Vehicle Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.5,
                    ),
                    itemCount: _vehicles.length,
                    itemBuilder: (context, index) => _buildVehicleCard(_vehicles[index]),
                  ),
                  const SizedBox(height: 20),
                  const Text('Trip Conditions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      children: [
                        _buildConditionItem(Icons.person, 'Verified professional driver'),
                        const SizedBox(height: 8),
                        _buildConditionItem(Icons.toll, 'Tolls & parking extra (pay directly)'),
                        const SizedBox(height: 8),
                        _buildConditionItem(Icons.schedule, 'Overtime: ₹150/hour extra'),
                        const SizedBox(height: 8),
                        _buildConditionItem(Icons.info_outline, 'Driver will drive your own car'),
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
              onPressed: _selectedPackage == null || _selectedVehicle == null ? null : () {
                _showBookingConfirmationDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2196F3),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(
                _selectedPackage == null || _selectedVehicle == null 
                    ? 'Complete Selection' 
                    : 'Confirm Hire Driver',
                style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHireModeButton(String mode) {
    final isSelected = _hireDuration == mode;
    return GestureDetector(
      onTap: () => setState(() {
        _hireDuration = mode;
        _selectedPackage = null;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            mode,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageBox(String duration) {
    final isSelected = _selectedPackage == duration;
    return GestureDetector(
      onTap: () => setState(() => _selectedPackage = duration),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? const Color(0xFF2196F3) : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Center(
          child: Text(
            duration,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPackageDetailsCard() {
    final options = _hireDuration == 'Hourly' ? _hourlyOptions : _dailyOptions;
    final packageData = options.firstWhere((p) => p['duration'] == _selectedPackage);
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2196F3), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2196F3).withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: (packageData['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: (packageData['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Icon(packageData['icon'], color: packageData['color'] as Color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(packageData['duration'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 2),
                Text(_hireDuration, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
          Text(packageData['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2196F3))),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> v) {
    final isSelected = _selectedVehicle == v['name'];
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = v['name']),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? (v['color'] as Color) : Colors.grey[300]!, 
            width: isSelected ? 2 : 1
          ),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 80,
              height: 55,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  v['image'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(v['icon'], color: v['color'] as Color, size: 36),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                v['name'], 
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
      ],
    );
  }

  void _showBookingConfirmationDialog() {
    final options = _hireDuration == 'Hourly' ? _hourlyOptions : _dailyOptions;
    final packageData = options.firstWhere((p) => p['duration'] == _selectedPackage);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Confirm Hire Driver', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              _buildConfirmRow('Pickup', _pickupController.text.isEmpty ? 'Not set' : _pickupController.text),
              _buildConfirmRow('Drop', _dropController.text.isEmpty ? 'Not set' : _dropController.text),
              _buildConfirmRow('Date', _selectedDate == null ? 'Today' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
              _buildConfirmRow('Time', _selectedTime == null ? 'Now' : _selectedTime!.format(context)),
              _buildConfirmRow('Duration', packageData['duration']),
              _buildConfirmRow('Car Type', _selectedVehicle!),
              _buildConfirmRow('Price', packageData['price']),
              const SizedBox(height: 16),
              const Text('Conditions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              _buildPopupConditionItem(Icons.check_circle_outline, 'Verified professional driver'),
              _buildPopupConditionItem(Icons.toll, 'Tolls & parking extra'),
              _buildPopupConditionItem(Icons.schedule, '₹150/hr extra after package'),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HireDriverBookingDetailsScreen(
                          inquiryId: 'HD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                          pickupLocation: _pickupController.text.isEmpty ? 'Current Location' : _pickupController.text,
                          dropLocation: _dropController.text.isEmpty ? 'Not Specified' : _dropController.text,
                          carType: _selectedVehicle!,
                          hireDuration: _hireDuration,
                          package: packageData['duration'],
                          price: packageData['price'],
                          tripStartDate: _selectedDate == null ? 'Today' : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          tripTime: _selectedTime == null ? 'Now' : _selectedTime!.format(context),
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm & Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 80, child: Text('$label:', style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _buildPopupConditionItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
        ],
      ),
    );
  }
}
