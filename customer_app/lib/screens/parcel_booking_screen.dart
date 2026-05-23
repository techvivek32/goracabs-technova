import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import 'parcel_booking_details_screen.dart';

class ParcelBookingScreen extends StatefulWidget {
  const ParcelBookingScreen({super.key});

  @override
  State<ParcelBookingScreen> createState() => _ParcelBookingScreenState();
}

class _ParcelBookingScreenState extends State<ParcelBookingScreen> {
  final _pickupController = TextEditingController();
  final _dropController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _senderPhoneController = TextEditingController();
  final _receiverNameController = TextEditingController();
  final _receiverPhoneController = TextEditingController();
  final _weightController = TextEditingController();
  
  final List<XFile> _parcelImages = [];
  final ImagePicker _picker = ImagePicker();
  
  String _selectedItemType = 'Documents';
  String _selectedVehicle = 'Bike';
  
  final List<String> _itemTypes = ['Documents', 'Electronics', 'Clothing', 'Food', 'Fragile', 'Other'];
  
  final List<Map<String, dynamic>> _parcelVehicles = [
    {'name': 'Bike', 'capacity': 'Up to 5 kg', 'image': 'assets/images/bike.png', 'price': '₹50'},
    {'name': 'Scooter', 'capacity': 'Up to 10 kg', 'image': 'assets/images/scooter.png', 'price': '₹80'},
    {'name': 'Mini Truck', 'capacity': 'Up to 500 kg', 'image': 'assets/images/mini-truck.png', 'price': '₹450'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Send Parcel'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        centerTitle: false,
      ),
      body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Locations Card
              _buildSectionTitle('Delivery Route'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildLocationRow(Icons.radio_button_checked, Color(0xFF4CAF50), 'Pickup Location', _pickupController),
                    _buildVerticalDivider(),
                    _buildLocationRow(Icons.location_on, Color(0xFFFF5252), 'Drop Location', _dropController),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Parcel Details
              _buildSectionTitle('Parcel Details'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Item Type', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _itemTypes.map((type) => _buildChoiceChip(type)).toList(),
                    ),
                    const SizedBox(height: 20),
                    _buildInputField('Weight (approx. kg)', _weightController, Icons.fitness_center, keyboardType: TextInputType.number),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Parcel Images
              _buildSectionTitle('Parcel Images'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Take multiple live images of the parcel', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _parcelImages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == _parcelImages.length) {
                            return GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: const Icon(Icons.add_a_photo, color: AppTheme.primaryBlue, size: 30),
                              ),
                            );
                          }
                          return Stack(
                            children: [
                              Container(
                                width: 100,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: FileImage(File(_parcelImages[index].path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 16,
                                child: GestureDetector(
                                  onTap: () => setState(() => _parcelImages.removeAt(index)),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.close, color: Colors.white, size: 14),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Contact Details
              _buildSectionTitle('Contact Information'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildInputField('Sender Name', _senderNameController, Icons.person_outline),
                    const SizedBox(height: 16),
                    _buildInputField('Sender Phone', _senderPhoneController, Icons.phone_android, keyboardType: TextInputType.phone),
                    const Divider(height: 32),
                    _buildInputField('Receiver Name', _receiverNameController, Icons.person),
                    const SizedBox(height: 16),
                    _buildInputField('Receiver Phone', _receiverPhoneController, Icons.phone, keyboardType: TextInputType.phone),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Vehicle Selection
              _buildSectionTitle('Choose Vehicle'),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _parcelVehicles.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => _buildVehicleCard(_parcelVehicles[index]),
              ),
              const SizedBox(height: 24),

              // Conditions
              _buildSectionTitle('Booking Conditions'),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  children: [
                    _buildConditionItem(Icons.security, 'Parcel contents must be legal and safe'),
                    const SizedBox(height: 8),
                    _buildConditionItem(Icons.timer, 'Standard delivery time: 1-2 hours'),
                    const SizedBox(height: 8),
                    _buildConditionItem(Icons.payment, 'Tolls/Parking extra (if applicable)'),
                    const SizedBox(height: 8),
                    _buildConditionItem(Icons.verified_user, 'Contactless delivery available'),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, -5))],
        ),
        child: ElevatedButton(
          onPressed: () => _showConfirmationPopup(),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Proceed to Book', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildLocationRow(IconData icon, Color color, String hint, TextEditingController controller) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 9),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          children: List.generate(3, (index) => Container(
            margin: const EdgeInsets.symmetric(vertical: 2),
            width: 2,
            height: 4,
            color: Colors.grey[300],
          )),
        ),
      ),
    );
  }

  Widget _buildChoiceChip(String label) {
    final isSelected = _selectedItemType == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedItemType = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey[300]!),
        ),
        child: Text(label, style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildVehicleCard(Map<String, dynamic> vehicle) {
    final isSelected = _selectedVehicle == vehicle['name'];
    return GestureDetector(
      onTap: () => setState(() => _selectedVehicle = vehicle['name'] as String),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? AppTheme.primaryBlue : Colors.grey[200]!, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 90,
              height: 65,
              child: Image.asset(
                vehicle['image'] as String,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.directions_car, color: AppTheme.primaryBlue, size: 28),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(vehicle['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(vehicle['capacity'] as String, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                ],
              ),
            ),
            Text(vehicle['price'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppTheme.primaryBlue)),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _parcelImages.add(image);
      });
    }
  }

  void _showConfirmationPopup() {
    final selectedVehicleData = _parcelVehicles.firstWhere((v) => v['name'] == _selectedVehicle);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
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
                            Text('Confirm Parcel', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text(
                              'Safe and secure delivery for your valuable items with real-time tracking',
                              style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Image.asset(
                        selectedVehicleData['image'] as String,
                        width: 100,
                        height: 80,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.inventory_2, size: 60, color: AppTheme.primaryBlue),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.security, color: Colors.grey, size: 28),
                          SizedBox(height: 4),
                          Text('Safe Delivery', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.track_changes, color: Colors.grey, size: 28),
                          SizedBox(height: 4),
                          Text('Live Tracking', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.verified_user_outlined, color: Colors.grey, size: 28),
                          SizedBox(height: 4),
                          Text('Verified Partner', style: TextStyle(fontSize: 12, color: Colors.grey)),
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
                        _buildMinimalConfirmRow(Icons.radio_button_checked, Color(0xFF4CAF50), 'Pickup', _pickupController.text),
                        const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Align(alignment: Alignment.centerLeft, child: SizedBox(height: 10, child: VerticalDivider(width: 2))),
                        ),
                        _buildMinimalConfirmRow(Icons.location_on, Color(0xFFFF5252), 'Drop', _dropController.text),
                        const Divider(height: 32),
                        _buildMinimalConfirmRow(Icons.inventory_2_outlined, Colors.grey, 'Item', '$_selectedItemType (${_weightController.text} kg)'),
                        const SizedBox(height: 12),
                        _buildMinimalConfirmRow(Icons.person_outline, Colors.grey, 'Receiver', _receiverNameController.text),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppTheme.primaryBlue.withOpacity(0.1)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Estimated Fare', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text(selectedVehicleData['price'] as String, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                          ],
                        ),
                        const Divider(height: 32),
                        _buildFareRow('Base Delivery Fare', selectedVehicleData['price'] as String),
                        const SizedBox(height: 8),
                        _buildFareRow('Handling Charges', '₹0'),
                        const SizedBox(height: 8),
                        _buildFareRow('Taxes & Fees', '₹0'),
                        const SizedBox(height: 16),
                        const Text(
                          'Includes basic insurance for your parcel. Additional charges may apply for waiting time exceeding 15 minutes at pickup/drop.',
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ParcelBookingDetailsScreen(
                            inquiryId: 'PRC${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                            pickupLocation: _pickupController.text,
                            dropLocation: _dropController.text,
                            itemType: _selectedItemType,
                            weight: _weightController.text,
                            vehicle: _selectedVehicle,
                            receiverName: _receiverNameController.text,
                            receiverPhone: _receiverPhoneController.text,
                            imagePaths: _parcelImages.map((e) => e.path).toList(),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
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
      ),
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
            Text(value.isEmpty ? 'Not set' : value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
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
