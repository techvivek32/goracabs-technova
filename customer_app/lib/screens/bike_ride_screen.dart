import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';
import 'rating_screen.dart';

class BikeRideScreen extends StatefulWidget {
  final String? fromLocation;
  final String? toLocation;
  final bool hideLocationInputs;
  
  const BikeRideScreen({
    super.key,
    this.fromLocation,
    this.toLocation,
    this.hideLocationInputs = false,
  });

  @override
  State<BikeRideScreen> createState() => _BikeRideScreenState();
}

class _BikeRideScreenState extends State<BikeRideScreen> {
  String? _selectedVehicle;
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  bool _showLocationInputs = false;
  bool _showPickupConfirmation = false;
  int? _selectedTip;
  bool _isTaxiComing = false;
  LatLng? _comingTaxiLocation;
  bool _locationConfirmed = false;
  bool _showFullTripMap = false;
  bool _showArrivingButtons = false;
  
  final List<int> _tipAmounts = [10, 20, 50, 100];

  @override
  void initState() {
    super.initState();
    _pickupController.text = widget.fromLocation ?? 'Current Location';
    _dropController.text = widget.toLocation ?? 'Select Destination';
    if (widget.fromLocation != null && widget.toLocation != null) {
      _locationConfirmed = true;
    }
  }

  final List<LatLng> _bikeLocations = [
    LatLng(28.6139, 77.2090),
    LatLng(28.6150, 77.2100),
    LatLng(28.6120, 77.2080),
    LatLng(28.6160, 77.2110),
    LatLng(28.6130, 77.2070),
    LatLng(28.6170, 77.2120),
  ];

  final List<Map<String, dynamic>> _vehicles = [
    {'name': 'Bike', 'type': 'Quick Rides', 'price': '₹49', 'eta': '2 min', 'capacity': '1', 'icon': Icons.two_wheeler, 'color': Color(0xFF2196F3), 'image': 'assets/images/bike.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          if (!_locationConfirmed)
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
                                        '${_pickupController.text} → ${_dropController.text}',
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
                                  if (_dropController.text.isNotEmpty && _dropController.text != 'Select Destination') {
                                    setState(() {
                                      _showLocationInputs = false;
                                      _locationConfirmed = true;
                                    });
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
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.goracabs.customer',
                    ),
                    if (_isTaxiComing)
                      PolylineLayer(
                        polylines: [
                          if (!_showFullTripMap)
                            Polyline(
                              points: [
                                LatLng(28.6220, 77.2150),
                                LatLng(28.6139, 77.2090),
                              ],
                              color: const Color(0xFF2196F3),
                              strokeWidth: 4,
                            ),
                          if (_showFullTripMap)
                            Polyline(
                              points: [
                                LatLng(28.6139, 77.2090),
                                LatLng(28.6200, 77.2300),
                              ],
                              color: const Color(0xFF4CAF50),
                              strokeWidth: 4,
                            ),
                        ],
                      ),
                    MarkerLayer(
                      markers: [
                        if (!_showFullTripMap)
                          Marker(
                            point: LatLng(28.6139, 77.2090),
                            width: 40,
                            height: 40,
                            child: const Icon(Icons.location_on, color: Color(0xFFFF5252), size: 40),
                          ),
                        if (_showFullTripMap)
                          Marker(
                            point: LatLng(28.6200, 77.2300),
                            width: 45,
                            height: 45,
                            child: const Icon(Icons.location_on, color: Colors.green, size: 45),
                          ),
                        if (!_isTaxiComing && _selectedVehicle != null)
                          ..._bikeLocations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final location = entry.value;
                            final rotationAngle = (index * 60.0) * (3.14159 / 180);
                            
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
                                    return Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: Color(0xFFFF9800),
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: const Icon(Icons.two_wheeler, color: Colors.white, size: 24),
                                    );
                                  },
                                ),
                              ),
                            );
                          }).toList(),
                        if (_isTaxiComing && _comingTaxiLocation != null && !_showFullTripMap)
                          Marker(
                            point: _comingTaxiLocation!,
                            width: 60,
                            height: 60,
                            child: Image.asset(
                              'assets/images/topview/bike-top.png',
                              width: 60,
                              height: 60,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFF2196F3),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.two_wheeler, color: Colors.white, size: 30),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
                if (_showFullTripMap)
                  Positioned(
                    top: 16,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.black87, size: 24),
                      ),
                    ),
                  ),
                if (!_showFullTripMap)
                  DraggableScrollableSheet(
                    initialChildSize: _showPickupConfirmation ? 0.18 : 0.4,
                    minChildSize: _showPickupConfirmation ? 0.18 : 0.4,
                    maxChildSize: _showPickupConfirmation ? 0.18 : 0.4,
                    builder: (context, scrollController) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))],
                        ),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 12),
                              width: 40,
                              height: 4,
                              decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
                            ),
                            Expanded(
                              child: ListView(
                                controller: scrollController,
                                physics: _showPickupConfirmation ? const NeverScrollableScrollPhysics() : null,
                                padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                                children: [
                                  if (_showPickupConfirmation) ...[
                                    const Text('Double Check Pickup Point', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(color: Colors.blue[200]!),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.location_on, color: Colors.green[600], size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(child: Text(_pickupController.text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                                        ],
                                      ),
                                    ),
                                  ] else ...[
                                    const Text('Bike Ride', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                  ],
                                  const SizedBox(height: 16),
                                  if (!_showPickupConfirmation) ...[
                                    ..._vehicles.map((v) => _buildVehicleCard(v)),
                                    const SizedBox(height: 80),
                                  ],
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
          if (!_showFullTripMap)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, -2))]),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() => _locationConfirmed = true);
                      if (_showPickupConfirmation) {
                        _showWaitingDialog();
                      } else {
                        setState(() => _showPickupConfirmation = true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2196F3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text(
                      _showPickupConfirmation ? 'Confirm Pickup' : 'Book Bike Ride',
                      style: const TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
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
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: hint, border: InputBorder.none, isDense: true, contentPadding: const EdgeInsets.symmetric(vertical: 10), hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15)),
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
          border: Border.all(color: isSelected ? (v['color'] as Color) : Colors.grey[300]!, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(color: (v['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(v['image'], width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => Icon(v['icon'], color: v['color'] as Color, size: 24)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(v['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('${v['type']} • ${v['capacity']} seat', style: TextStyle(fontSize: 11, color: Colors.grey[600])),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(v['price'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF4CAF50))),
                const SizedBox(height: 2),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: Color(0xFF4CAF50).withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                  child: Text(v['eta'], style: const TextStyle(fontSize: 10, color: Color(0xFF4CAF50), fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showWaitingDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Add Tip', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Support your pilot by adding a tip', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Fare: ₹49', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(_selectedTip != null ? '(₹$_selectedTip tip added)' : '(No tip added)', style: TextStyle(fontSize: 12, color: _selectedTip != null ? Colors.green : Colors.grey[600])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    children: _tipAmounts.map((amount) {
                      final isSelected = _selectedTip == amount;
                      return GestureDetector(
                        onTap: () => setDialogState(() => _selectedTip = isSelected ? null : amount),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(color: isSelected ? Color(0xFF2196F3) : Colors.grey[100], borderRadius: BorderRadius.circular(20), border: Border.all(color: isSelected ? Color(0xFF2196F3) : Colors.grey[300]!)),
                          child: Text('₹$amount', style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600)),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(side: const BorderSide(color: Colors.grey), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: const Text('Back', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _showFinalWaitingDialog();
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2196F3), padding: const EdgeInsets.symmetric(vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                          child: Text(_selectedTip != null ? 'Confirm with ₹$_selectedTip Tip' : 'Confirm Ride', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showFinalWaitingDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 3), () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
            _showDriverArrivingDialog();
          }
        });

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3))),
              SizedBox(height: 16),
              Text('Finding your Bike', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Please wait while we connect you with a nearby pilot.', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showDriverArrivingDialog() {
    setState(() {
      _isTaxiComing = true;
      _showArrivingButtons = true;
      _comingTaxiLocation = LatLng(28.6220, 77.2150);
    });
    
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 5), () {
          if (Navigator.canPop(context)) {
            Navigator.of(context).pop();
            setState(() {
              _showFullTripMap = true;
              _showArrivingButtons = false;
            });
            Future.delayed(const Duration(seconds: 5), () {
              _showRideCompletedDialog();
            });
          }
        });

        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24)), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, -2))]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
              const Text('Your bike pilot on the way', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Ride PIN: ', style: TextStyle(fontSize: 16, color: Colors.grey)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[300]!)),
                    child: const Text('4829', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.black)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Row(
                children: [
                  Icon(Icons.access_time_filled, color: Color(0xFF2196F3), size: 18),
                  SizedBox(width: 8),
                  Text('Arriving in 2 mins', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                  SizedBox(width: 12),
                  Icon(Icons.location_on, color: Colors.green, size: 18),
                  SizedBox(width: 8),
                  Text('0.8 km away', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
                child: Row(
                  children: [
                    Container(width: 55, height: 55, decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.grey[200]!, width: 2), image: const DecorationImage(image: NetworkImage('https://i.pravatar.cc/150?u=bikepilot'), fit: BoxFit.cover))),
                    const SizedBox(width: 12),
                    const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Arjun Singh', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)), SizedBox(height: 4), Row(children: [Icon(Icons.star, color: Colors.amber, size: 16), SizedBox(width: 4), Text('4.8 (800+ rides)', style: TextStyle(fontSize: 13, color: Colors.grey))]), SizedBox(height: 4), Text('Hero Splendor • RJ 14 AB 5678', style: TextStyle(fontSize: 11, color: Colors.grey))])),
                    SizedBox(width: 70, height: 50, child: Image.asset('assets/images/bike.png', fit: BoxFit.contain)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.call, color: Colors.green), label: const Text('Call', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)), elevation: 2))),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton.icon(onPressed: () {}, icon: const Icon(Icons.message, color: Color(0xFF2196F3)), label: const Text('Message', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[200]!)), elevation: 2))),
                ],
              ),
              const SizedBox(height: 12),
              Center(child: TextButton(onPressed: () => _showCancelReasonDialog(), child: const Text('Cancel Ride', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 15)))),
            ],
          ),
        );
      },
    );
  }

  void _showCancelReasonDialog() {
    final List<String> reasons = ['Plan changed', 'Pilot is too far', 'Found another ride', 'Wait time is too long', 'Wrong location selected', 'Other'];
    String? selectedReason;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 20), decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)))),
                  const Text('Cancel Ride', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Please select a reason for cancellation', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  const SizedBox(height: 20),
                  ...reasons.map((reason) => RadioListTile<String>(title: Text(reason, style: const TextStyle(fontSize: 15)), value: reason, groupValue: selectedReason, activeColor: const Color(0xFF2196F3), contentPadding: EdgeInsets.zero, onChanged: (value) => setDialogState(() => selectedReason = value))),
                  const SizedBox(height: 24),
                  SizedBox(width: double.infinity, child: ElevatedButton(onPressed: selectedReason == null ? null : () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false), style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2196F3), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Confirm Cancellation', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
                  const SizedBox(height: 12),
                  Center(child: TextButton(onPressed: () => Navigator.pop(context), child: const Text('Back', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600)))),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showRideCompletedDialog() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 64),
              const SizedBox(height: 16),
              const Text('Ride Completed!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('You have reached your destination safely.', style: TextStyle(fontSize: 14, color: Colors.grey), textAlign: TextAlign.center),
              const SizedBox(height: 24),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () { Navigator.pop(context); Navigator.push(context, MaterialPageRoute(builder: (context) => RatingScreen(driverName: 'Arjun Singh', vehicleName: 'Bike', selectedTip: _selectedTip))); }, style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2196F3), padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), child: const Text('Rate Your Ride', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)))),
            ],
          ),
        );
      },
    );
  }
}
