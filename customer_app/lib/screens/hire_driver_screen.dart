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
  String? _selectedVehicle;
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _selectedHours = 4;
  int _selectedDays = 1;

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
                        _buildDurationSelector(),
                        const SizedBox(height: 12),
                        _buildPriceDisplay(),
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
                    onPressed: _selectedVehicle == null ? null : () {
                      _showBookingConfirmationDialog();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _selectedVehicle == null 
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

  Widget _buildDurationSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$_hireDuration Selection',
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Row(
            children: [
              _buildRoundButton(Icons.remove, () {
                setState(() {
                  if (_hireDuration == 'Hourly') {
                    if (_selectedHours > 1) _selectedHours--;
                  } else {
                    if (_selectedDays > 1) _selectedDays--;
                  }
                });
              }),
              const SizedBox(width: 20),
              Text(
                _hireDuration == 'Hourly' ? '$_selectedHours hr' : '$_selectedDays day',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 20),
              _buildRoundButton(Icons.add, () {
                setState(() {
                  if (_hireDuration == 'Hourly') {
                    if (_selectedHours < 24) _selectedHours++;
                  } else {
                    if (_selectedDays < 30) _selectedDays++;
                  }
                });
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceDisplay() {
    final price = _hireDuration == 'Hourly' ? _selectedHours * 150 : _selectedDays * 1500;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Estimated Price',
                style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 4),
              Text(
                _hireDuration == 'Hourly' ? '₹150/hour' : '₹1500/day',
                style: TextStyle(fontSize: 12, color: Colors.blue[700], fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Text(
            '₹$price',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2196F3)),
          ),
        ],
      ),
    );
  }

  Widget _buildRoundButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 4, offset: const Offset(0, 2)),
          ],
        ),
        child: Icon(icon, size: 20, color: const Color(0xFF2196F3)),
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
              width: 60,
              height: 45,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  v['image'],
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(v['icon'], color: v['color'] as Color, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                v['name'], 
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
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
    final selectedVehicleData = _vehicles.firstWhere((v) => v['name'] == _selectedVehicle);
    final duration = _hireDuration == 'Hourly' ? '$_selectedHours Hours' : '$_selectedDays Day(s)';
    final basePrice = _hireDuration == 'Hourly' ? _selectedHours * 150 : _selectedDays * 1500;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Confirm Hire', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(
                                'Professional verified drivers for your personal vehicle',
                                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.asset(
                          selectedVehicleData['image'],
                          width: 100,
                          height: 80,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 60, color: Color(0xFF2196F3)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.verified_user, color: Colors.grey, size: 28),
                            SizedBox(height: 4),
                            Text('Verified Pro', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.security, color: Colors.grey, size: 28),
                            SizedBox(height: 4),
                            Text('Safe Ride', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.timer, color: Colors.grey, size: 28),
                            SizedBox(height: 4),
                            Text('Punctual', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Text('Booking Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          _buildMinimalConfirmRow(Icons.radio_button_checked, Color(0xFF4CAF50), 'Pickup', _pickupController.text.isEmpty ? 'Current Location' : _pickupController.text),
                          const Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Align(alignment: Alignment.centerLeft, child: SizedBox(height: 10, child: VerticalDivider(width: 2))),
                          ),
                          _buildMinimalConfirmRow(Icons.calendar_today, Color(0xFF2196F3), 'Schedule', '${_selectedDate == null ? 'Today' : '${_selectedDate!.day}/${_selectedDate!.month}'} at ${_selectedTime == null ? 'Now' : _selectedTime!.format(context)}'),
                          const Divider(height: 32),
                          _buildMinimalConfirmRow(Icons.timer_outlined, Colors.grey, 'Duration', duration),
                          const SizedBox(height: 12),
                          _buildMinimalConfirmRow(Icons.directions_car_outlined, Colors.grey, 'Car Type', _selectedVehicle!),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3).withOpacity(0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.1)),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Estimated Fare', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('₹$basePrice', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2196F3))),
                            ],
                          ),
                          const Divider(height: 32),
                          _buildFareRow('Base Driver Fee', '₹$basePrice'),
                          const SizedBox(height: 8),
                          _buildFareRow('Convenience Fee', '₹0'),
                          const SizedBox(height: 16),
                          const Text(
                            'Tolls, parking and fuel are to be provided by the customer. Overtime charges of ₹150/hr apply after the package duration.',
                            style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                    onPressed: () {
                        Navigator.pop(context);
                        final duration = _hireDuration == 'Hourly' ? '$_selectedHours Hours' : '$_selectedDays Day(s)';
                        final basePrice = _hireDuration == 'Hourly' ? _selectedHours * 150 : _selectedDays * 1500;
                        
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HireDriverBookingDetailsScreen(
                              inquiryId: 'HD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                              pickupLocation: _pickupController.text.isEmpty ? 'Current Location' : _pickupController.text,
                              dropLocation: _dropController.text.isEmpty ? 'Not Specified' : _dropController.text,
                              carType: _selectedVehicle!,
                              hireDuration: _hireDuration,
                              package: duration,
                              price: '₹$basePrice',
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
                      child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMinimalConfirmRow(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildFareRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
