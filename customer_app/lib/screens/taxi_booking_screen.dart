import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Gora Go', 'type': 'Mini', 'price': '₹120', 'eta': '2 min', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF2196F3)},
    {'name': 'Gora Sedan', 'type': 'Premium', 'price': '₹180', 'eta': '3 min', 'capacity': '4', 'icon': Icons.directions_car, 'color': Color(0xFF4CAF50)},
    {'name': 'Gora SUV', 'type': 'SUV', 'price': '₹250', 'eta': '5 min', 'capacity': '6', 'icon': Icons.airport_shuttle, 'color': Color(0xFFFF9800)},
    {'name': 'Gora Luxury', 'type': 'Luxury', 'price': '₹400', 'eta': '8 min', 'capacity': '4', 'icon': Icons.car_rental, 'color': Color(0xFF9C27B0)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book a Taxi'),
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLocationInput(Icons.radio_button_checked, 'Pickup Location', _pickupController),
                  const SizedBox(height: 16),
                  _buildLocationInput(Icons.location_on, 'Drop Location', _dropController),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text('Estimated Fare:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Color(0xFF2196F3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text('₹120 - ₹400', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.route, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 8),
                      Text('Distance: 8.5 km', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                      const Spacer(),
                      Icon(Icons.access_time, color: Colors.grey[600], size: 16),
                      const SizedBox(width: 8),
                      Text('ETA: 15-20 min', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Select Vehicle', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ..._vehicles.map((v) => _buildVehicleCard(v)),
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
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _selectedVehicle == null ? null : () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverBiddingScreen()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF2196F3),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text('Book Now', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
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
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInput(IconData icon, String hint, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF2196F3), size: 20),
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

  Widget _buildVehicleCard(Map<String, dynamic> v) {
    final isSelected = _selectedVehicle == v['name'];
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = v['name']),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Color(0xFF2196F3) : Colors.grey[300]!, 
            width: isSelected ? 2 : 1
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected 
                ? Color(0xFF2196F3).withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
              blurRadius: isSelected ? 8 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (v['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: (v['color'] as Color).withOpacity(0.3),
                ),
              ),
              child: Icon(v['icon'], color: v['color'] as Color, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  const SizedBox(height: 2),
                  Text('${v['type']} • ${v['capacity']} seats', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(v['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2196F3))),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(v['eta'], style: const TextStyle(fontSize: 11, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
