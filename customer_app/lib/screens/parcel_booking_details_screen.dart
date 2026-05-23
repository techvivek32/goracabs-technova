import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ParcelBookingDetailsScreen extends StatelessWidget {
  final String inquiryId;
  final String pickupLocation;
  final String dropLocation;
  final String itemType;
  final String weight;
  final String vehicle;
  final String receiverName;
  final String receiverPhone;
  final List<String> imagePaths;

  const ParcelBookingDetailsScreen({
    Key? key,
    required this.inquiryId,
    required this.pickupLocation,
    required this.dropLocation,
    required this.itemType,
    required this.weight,
    required this.vehicle,
    required this.receiverName,
    required this.receiverPhone,
    required this.imagePaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Custom Minimal App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                    ),
                    const Text(
                      'Booking Confirmed',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Success Header
                      Center(
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 64),
                            const SizedBox(height: 16),
                            const Text(
                              'Your parcel is ready for pickup!',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Inquiry ID: $inquiryId',
                              style: const TextStyle(color: Colors.grey, fontSize: 14),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Parcel PIN: ', style: TextStyle(fontSize: 14, color: Colors.grey)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: const Text(
                                    '5294',
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Delivery Route
                      const Text('Delivery Route', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            _buildRouteRow(Icons.radio_button_checked, Colors.green, 'Pickup', pickupLocation),
                            const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: Align(alignment: Alignment.centerLeft, child: SizedBox(height: 12, child: VerticalDivider(width: 2))),
                            ),
                            _buildRouteRow(Icons.location_on, Colors.red, 'Drop', dropLocation),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Parcel Details Grid
                      const Text('Parcel Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('Type', itemType, Icons.inventory_2_outlined)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('Weight', '$weight kg', Icons.fitness_center_outlined)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(child: _buildInfoCard('Vehicle', vehicle, Icons.local_shipping_outlined)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildInfoCard('Receiver', receiverName, Icons.person_outline)),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Parcel Images
                      if (imagePaths.isNotEmpty) ...[
                        const Text('Parcel Images', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 100,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: imagePaths.length,
                            itemBuilder: (context, index) {
                              return Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey[200]!),
                                  image: DecorationImage(
                                    image: FileImage(File(imagePaths[index])),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      // Conditions
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50]?.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue[100]!),
                        ),
                        child: Column(
                          children: [
                            _buildConditionItem(Icons.security_outlined, 'Parcel contents must be legal and safe'),
                            const SizedBox(height: 8),
                            _buildConditionItem(Icons.timer_outlined, 'Standard delivery time: 1-2 hours'),
                            const SizedBox(height: 8),
                            _buildConditionItem(Icons.payment_outlined, 'Tolls/Parking extra (if applicable)'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              // Bottom Action
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, -5))],
                ),
                child: SafeArea(
                  top: false,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text(
                        'Done',
                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRouteRow(IconData icon, Color color, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue[400]),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.blue[400]),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[800]))),
      ],
    );
  }
}
