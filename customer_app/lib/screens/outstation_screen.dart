import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import 'booking_screen.dart';

class OutstationScreen extends StatefulWidget {
  const OutstationScreen({super.key});

  @override
  State<OutstationScreen> createState() => _OutstationScreenState();
}

class _OutstationScreenState extends State<OutstationScreen> {
  String? _selectedVehicle;
  final _fromController = TextEditingController();
  final _toController = TextEditingController();
  final _departureDateController = TextEditingController();
  final _departureTimeController = TextEditingController();
  final _returnDateController = TextEditingController();
  final _returnTimeController = TextEditingController();
  bool _showLocationInputs = true;
  String _tripType = 'One Way';
  bool _showTripDetails = true;
  bool _showVehicleSelection = false;

  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Sedan', 'type': 'Comfortable', 'price': '₹12/km', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF2196F3), 'image': 'https://cdn-icons-png.flaticon.com/512/3202/3202926.png'},
    {'name': 'SUV', 'type': 'Spacious', 'price': '₹15/km', 'capacity': '6', 'icon': Icons.airport_shuttle, 'color': Color(0xFF9C27B0), 'image': 'https://cdn-icons-png.flaticon.com/512/3097/3097132.png'},
    {'name': 'Hatchback', 'type': 'Economy', 'price': '₹10/km', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF4CAF50), 'image': 'https://cdn-icons-png.flaticon.com/512/3202/3202003.png'},
    {'name': 'Premium SUV', 'type': 'Luxury', 'price': '₹20/km', 'capacity': '6', 'icon': Icons.car_rental, 'color': Color(0xFF795548), 'image': 'https://cdn-icons-png.flaticon.com/512/3097/3097150.png'},
    {'name': 'Tempo Traveller', 'type': 'Group Travel', 'price': '₹25/km', 'capacity': '12', 'icon': Icons.bus_alert, 'color': Color(0xFFFF9800), 'image': 'https://cdn-icons-png.flaticon.com/512/2972/2972185.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.arrow_back, size: 20),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (_showLocationInputs)
                          const Text('Outstation Booking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
                        else
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _showLocationInputs = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _toController.text.isEmpty ? 'Select destination' : '${_fromController.text} → ${_toController.text}',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Icon(Icons.edit, size: 16, color: Colors.grey[600]),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (_showLocationInputs)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: [
                          _buildLocationInput(Icons.radio_button_checked, _fromController, Color(0xFF4CAF50), 'From (Pickup Location)'),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Row(
                              children: [
                                Column(
                                  children: List.generate(2, (index) => Container(
                                    margin: const EdgeInsets.symmetric(vertical: 1),
                                    width: 2,
                                    height: 3,
                                    color: Colors.grey[400],
                                  )),
                                ),
                              ],
                            ),
                          ),
                          _buildLocationInput(Icons.location_on, _toController, Color(0xFFFF5252), 'To (Destination)'),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_toController.text.isNotEmpty && _fromController.text.isNotEmpty) {
                                  setState(() => _showLocationInputs = false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2196F3),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Search Cabs', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(28.6139, 77.2090),
                    initialZoom: 13.0,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.goracabs.customer',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(28.6139, 77.2090),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_on, color: Color(0xFF4CAF50), size: 40),
                        ),
                        Marker(
                          point: LatLng(28.7041, 77.1025),
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.location_on, color: Color(0xFFFF5252), size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.4,
                  minChildSize: 0.4,
                  maxChildSize: 0.85,
                  builder: (context, scrollController) {
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, -2),
                          ),
                        ],
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
                              controller: scrollController,
                              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                              children: [
                                GestureDetector(
                                  onTap: () => setState(() => _showTripDetails = !_showTripDetails),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      children: [
                                        const Text('Trip Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Icon(
                                          _showTripDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_showTripDetails)
                                  const SizedBox(height: 8),
                                if (_showTripDetails)
                                  Row(
                                    children: [
                                      Expanded(child: _buildTripTypeButton('One Way')),
                                      const SizedBox(width: 12),
                                      Expanded(child: _buildTripTypeButton('Round Trip')),
                                    ],
                                  ),
                                if (_showTripDetails)
                                  const SizedBox(height: 16),
                                if (_showTripDetails)
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDateInput(_departureDateController, 'Departure Date', Icons.calendar_today),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildTimeInput(_departureTimeController, 'Time', Icons.access_time),
                                      ),
                                    ],
                                  ),
                                if (_showTripDetails && _tripType == 'Round Trip')
                                  const SizedBox(height: 12),
                                if (_showTripDetails && _tripType == 'Round Trip')
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDateInput(_returnDateController, 'Return Date', Icons.calendar_today),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: _buildTimeInput(_returnTimeController, 'Time', Icons.access_time),
                                      ),
                                    ],
                                  ),
                                if (_showTripDetails)
                                  const SizedBox(height: 16),
                                GestureDetector(
                                  onTap: () => setState(() => _showVehicleSelection = !_showVehicleSelection),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    child: Row(
                                      children: [
                                        const Text('Select Vehicle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                        const Spacer(),
                                        Icon(
                                          _showVehicleSelection ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (_showVehicleSelection)
                                  const SizedBox(height: 8),
                                if (_showVehicleSelection)
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[50],
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.blue[200]!),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.info_outline, color: Colors.blue[600], size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            'Estimated distance: 45 km • Duration: 1h 30m',
                                            style: TextStyle(fontSize: 12, color: Colors.blue[700]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                if (_showVehicleSelection)
                                  const SizedBox(height: 16),
                                if (_showVehicleSelection)
                                  ..._vehicles.map((v) => _buildVehicleCard(v)),
                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedVehicle == null ? null : () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverBiddingScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF2196F3),
                        disabledBackgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _selectedVehicle == null ? 'Select a vehicle' : 'Book Outstation',
                        style: TextStyle(
                          fontSize: 16,
                          color: _selectedVehicle == null ? Colors.grey[600] : Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverBiddingScreen()));
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF2196F3), width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Get Quotes', style: TextStyle(fontSize: 16, color: Color(0xFF2196F3), fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeButton(String type) {
    final isSelected = _tripType == type;
    return GestureDetector(
      onTap: () => setState(() {
        _tripType = type;
        if (type == 'One Way') {
          _returnDateController.clear();
          _returnTimeController.clear();
        }
        // Auto-expand vehicle selection after trip details are set
        if (!_showVehicleSelection && (_departureDateController.text.isNotEmpty || type == 'One Way')) {
          _showVehicleSelection = true;
        }
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2196F3) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Color(0xFF2196F3) : Colors.grey[300]!),
        ),
        child: Center(
          child: Text(
            type,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationInput(IconData icon, TextEditingController controller, Color iconColor, String hint) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateInput(TextEditingController controller, String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (date != null) {
                  controller.text = '${date.day}/${date.month}/${date.year}';
                }
              },
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInput(TextEditingController controller, String hint, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              readOnly: true,
              onTap: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  controller.text = time.format(context);
                }
              },
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
              ),
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> v) {
    final isSelected = _selectedVehicle == v['name'];
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = v['name']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? (v['color'] as Color).withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? (v['color'] as Color) : Colors.grey[300]!, 
            width: isSelected ? 2 : 1
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: (v['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.network(
                v['image'],
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(v['icon'], color: v['color'] as Color, size: 24);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${v['type']} • ${v['capacity']} seats', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(v['price'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: v['color'] as Color)),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text('Available', style: const TextStyle(fontSize: 10, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
