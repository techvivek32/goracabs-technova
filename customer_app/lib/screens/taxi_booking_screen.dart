import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import 'booking_screen.dart';

class TaxiBookingScreen extends StatefulWidget {
  const TaxiBookingScreen({super.key});

  @override
  State<TaxiBookingScreen> createState() => _TaxiBookingScreenState();
}

class _TaxiBookingScreenState extends State<TaxiBookingScreen> {
  String? _selectedVehicle;
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  bool _showLocationInputs = true;

  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Bike', 'type': 'Quick Rides', 'price': '₹49', 'eta': '2 min', 'capacity': '1', 'icon': Icons.two_wheeler, 'color': Color(0xFFFF9800), 'image': 'https://cdn-icons-png.flaticon.com/512/2972/2972185.png'},
    {'name': 'Auto', 'type': 'Affordable', 'price': '₹76', 'eta': '3 min', 'capacity': '3', 'icon': Icons.electric_rickshaw, 'color': Color(0xFF4CAF50), 'image': 'https://cdn-icons-png.flaticon.com/512/3097/3097136.png'},
    {'name': 'Cab Economy', 'type': 'Comfortable', 'price': '₹144', 'eta': '4 min', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF2196F3), 'image': 'https://cdn-icons-png.flaticon.com/512/3202/3202926.png'},
    {'name': 'SUV', 'type': 'Spacious', 'price': '₹250', 'eta': '5 min', 'capacity': '6', 'icon': Icons.airport_shuttle, 'color': Color(0xFF9C27B0), 'image': 'https://cdn-icons-png.flaticon.com/512/3097/3097132.png'},
    {'name': 'Premium', 'type': 'Luxury Sedan', 'price': '₹320', 'eta': '6 min', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF795548), 'image': 'https://cdn-icons-png.flaticon.com/512/3202/3202003.png'},
    {'name': 'Luxury', 'type': 'Premium Experience', 'price': '₹500', 'eta': '8 min', 'capacity': '4', 'icon': Icons.car_rental, 'color': Color(0xFF000000), 'image': 'https://cdn-icons-png.flaticon.com/512/3097/3097150.png'},
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
                          const Text('Book a Taxi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))
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
                                        _dropController.text.isEmpty ? 'Select destination' : _dropController.text,
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
                          _buildLocationInput(Icons.radio_button_checked, _pickupController, Color(0xFF4CAF50), 'Current Location'),
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
                          _buildLocationInput(Icons.location_on, _dropController, Color(0xFFFF5252), 'Select destination'),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_dropController.text.isNotEmpty) {
                                  setState(() => _showLocationInputs = false);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2196F3),
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                              child: const Text('Confirm Location', style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600)),
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
                                const Text('Select Vehicle', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 16),
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
                        _selectedVehicle == null ? 'Select a vehicle' : 'Book Now',
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
                      child: const Text('Get Bids', style: TextStyle(fontSize: 16, color: Color(0xFF2196F3), fontWeight: FontWeight.w600)),
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
                  child: Text(v['eta'], style: const TextStyle(fontSize: 10, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}