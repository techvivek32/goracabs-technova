import 'package:flutter/material.dart';
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
  
  String _selectedItemType = 'Documents';
  String _selectedVehicle = 'Bike';
  
  final List<String> _itemTypes = ['Documents', 'Electronics', 'Clothing', 'Food', 'Fragile', 'Other'];
  
  final List<Map<String, dynamic>> _parcelVehicles = [
    {'name': 'Bike', 'capacity': 'Up to 5 kg', 'image': 'assets/images/bike.png', 'price': '₹50'},
    {'name': 'Scooter', 'capacity': 'Up to 10 kg', 'image': 'assets/images/topview/bike-top.png', 'price': '₹80'},
    {'name': 'Mini Truck', 'capacity': 'Up to 500 kg', 'image': 'assets/images/texi3.png', 'price': '₹450'},
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

  void _showConfirmationPopup() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Confirm Parcel Booking', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const Divider(),
            const SizedBox(height: 10),
            _buildConfirmRow('Pickup', _pickupController.text.isEmpty ? 'Not set' : _pickupController.text),
            _buildConfirmRow('Drop', _dropController.text.isEmpty ? 'Not set' : _dropController.text),
            _buildConfirmRow('Sender', _senderNameController.text.isEmpty ? 'Not set' : '${_senderNameController.text} (${_senderPhoneController.text})'),
            _buildConfirmRow('Receiver', _receiverNameController.text.isEmpty ? 'Not set' : '${_receiverNameController.text} (${_receiverPhoneController.text})'),
            _buildConfirmRow('Item', '$_selectedItemType (${_weightController.text} kg)'),
            _buildConfirmRow('Vehicle', _selectedVehicle),
            const SizedBox(height: 16),
            const Text('Conditions:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(height: 8),
            _buildPopupConditionItem(Icons.security, 'Safe & legal contents only'),
            _buildPopupConditionItem(Icons.timer, '1-2 hours delivery time'),
            _buildPopupConditionItem(Icons.payment, 'Tolls/Parking extra'),
            const SizedBox(height: 20),
            SizedBox(
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
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Confirm & Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
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

  Widget _buildConfirmRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text('$label:', style: const TextStyle(color: Colors.grey))),
          Expanded(child: Text(value, style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }
}
