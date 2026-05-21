import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import 'booking_screen.dart';

class TaxiBookingScreen extends StatefulWidget {
  final String? fromLocation;
  final String? toLocation;
  final bool hideLocationInputs;
  
  const TaxiBookingScreen({
    super.key,
    this.fromLocation,
    this.toLocation,
    this.hideLocationInputs = false,
  });

  @override
  State<TaxiBookingScreen> createState() => _TaxiBookingScreenState();
}

class _TaxiBookingScreenState extends State<TaxiBookingScreen> {
  String? _selectedVehicle;
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  bool _showLocationInputs = true;

  @override
  void initState() {
    super.initState();
    // Set initial values and visibility based on parameters
    if (widget.fromLocation != null) {
      _pickupController.text = widget.fromLocation!;
    }
    if (widget.toLocation != null) {
      _dropController.text = widget.toLocation!;
    }
    if (widget.hideLocationInputs) {
      _showLocationInputs = false;
    }
  }

  // Bike locations near user
  final List<LatLng> _bikeLocations = [
    LatLng(28.6139, 77.2090),
    LatLng(28.6150, 77.2100),
    LatLng(28.6120, 77.2080),
    LatLng(28.6160, 77.2110),
    LatLng(28.6130, 77.2070),
    LatLng(28.6170, 77.2120),
  ];

  // Auto locations near user
  final List<LatLng> _autoLocations = [
    LatLng(28.6145, 77.2095),
    LatLng(28.6155, 77.2085),
    LatLng(28.6125, 77.2105),
    LatLng(28.6165, 77.2075),
    LatLng(28.6135, 77.2115),
  ];

  // Economy car locations (4 cars)
  final List<LatLng> _economyLocations = [
    LatLng(28.6140, 77.2095),
    LatLng(28.6158, 77.2088),
    LatLng(28.6122, 77.2102),
    LatLng(28.6162, 77.2078),
  ];

  // SUV locations (2 cars)
  final List<LatLng> _suvLocations = [
    LatLng(28.6148, 77.2092),
    LatLng(28.6152, 77.2098),
  ];

  // Premium car locations (1 car)
  final List<LatLng> _premiumLocations = [
    LatLng(28.6145, 77.2090),
  ];

  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Bike', 'type': 'Quick Rides', 'price': '₹49', 'eta': '2 min', 'capacity': '1', 'icon': Icons.two_wheeler, 'color': Color(0xFF2196F3), 'image': 'assets/images/bike.png'},
    {'name': 'Auto', 'type': 'Affordable', 'price': '₹76', 'eta': '3 min', 'capacity': '3', 'icon': Icons.electric_rickshaw, 'color': Color(0xFF2196F3), 'image': 'assets/images/auto.jpg'},
    {'name': 'Cab Economy', 'type': 'Comfortable', 'price': '₹144', 'eta': '4 min', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF2196F3), 'image': 'assets/images/economy.png'},
    {'name': 'SUV', 'type': 'Spacious', 'price': '₹250', 'eta': '5 min', 'capacity': '6', 'icon': Icons.airport_shuttle, 'color': Color(0xFF2196F3), 'image': 'assets/images/texi.png'},
    {'name': 'Premium', 'type': 'Luxury Sedan', 'price': '₹320', 'eta': '6 min', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF2196F3), 'image': 'assets/images/texi2.png'},
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
                                        _dropController.text.isEmpty 
                                            ? 'Select destination' 
                                            : '${_pickupController.text.isEmpty ? "Current Location" : _pickupController.text} → ${_dropController.text}',
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
                        // Show bike markers when bike is selected
                        if (_selectedVehicle == 'Bike')
                          ..._bikeLocations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final location = entry.value;
                            // Different rotation angles for each bike
                            final rotationAngle = (index * 60.0) * (3.14159 / 180); // Convert degrees to radians
                            
                            return Marker(
                              point: location,
                              width: 50,
                              height: 50,
                              child: Transform.rotate(
                                angle: rotationAngle,
                                child: Image.asset(
                                  'assets/images/topview/bike-top.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    print('Error loading bike image: $error');
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF9800),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(
                                        Icons.two_wheeler,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        // Show auto markers when auto is selected
                        if (_selectedVehicle == 'Auto')
                          ..._autoLocations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final location = entry.value;
                            final rotationAngle = (index * 72.0) * (3.14159 / 180);
                            
                            return Marker(
                              point: location,
                              width: 50,
                              height: 50,
                              child: Transform.rotate(
                                angle: rotationAngle,
                                child: Image.asset(
                                  'assets/images/topview/auto-top.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2196F3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(
                                        Icons.electric_rickshaw,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        // Show economy car markers when Cab Economy is selected
                        if (_selectedVehicle == 'Cab Economy')
                          ..._economyLocations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final location = entry.value;
                            final rotationAngle = (index * 90.0) * (3.14159 / 180);
                            
                            return Marker(
                              point: location,
                              width: 50,
                              height: 50,
                              child: Transform.rotate(
                                angle: rotationAngle,
                                child: Image.asset(
                                  'assets/images/topview/economy-top.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2196F3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(
                                        Icons.directions_car,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        // Show SUV markers when SUV is selected
                        if (_selectedVehicle == 'SUV')
                          ..._suvLocations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final location = entry.value;
                            final rotationAngle = (index * 180.0) * (3.14159 / 180);
                            
                            return Marker(
                              point: location,
                              width: 50,
                              height: 50,
                              child: Transform.rotate(
                                angle: rotationAngle,
                                child: Image.asset(
                                  'assets/images/topview/suv-top.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2196F3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(
                                        Icons.airport_shuttle,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        // Show premium car markers when Premium is selected
                        if (_selectedVehicle == 'Premium')
                          ..._premiumLocations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final location = entry.value;
                            final rotationAngle = (index * 45.0) * (3.14159 / 180);
                            
                            return Marker(
                              point: location,
                              width: 50,
                              height: 50,
                              child: Transform.rotate(
                                angle: rotationAngle,
                                child: Image.asset(
                                  'assets/images/topview/primium-top.png',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF2196F3),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(
                                        Icons.directions_car,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
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
              child: SizedBox(
                width: double.infinity,
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
              decoration: BoxDecoration(
                color: (v['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  v['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(v['icon'], color: v['color'] as Color, size: 24);
                  },
                ),
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
                Text(v['price'], style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF4CAF50))),
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