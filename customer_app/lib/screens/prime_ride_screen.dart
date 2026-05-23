import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PrimeRideScreen extends StatefulWidget {
  const PrimeRideScreen({super.key});

  @override
  State<PrimeRideScreen> createState() => _PrimeRideScreenState();
}

class _PrimeRideScreenState extends State<PrimeRideScreen> {
  final _pickupController = TextEditingController(text: 'Current Location');
  final _dropController = TextEditingController(text: 'Oriental Bank of Commerce');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Oriental Bank of Com...', style: TextStyle(color: Colors.black, fontSize: 16)),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Prime Sedan', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              Text(
                                'Add the comfort of a high-rated sedan to your daily commute. Enjoy extra legroom, ample boot space',
                                style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.4),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Image(
                          image: AssetImage('assets/images/texi2.png'),
                          width: 100,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Icon(Icons.directions_car, color: Colors.grey, size: 28),
                            SizedBox(height: 4),
                            Text('Spacious\nSedans', style: TextStyle(fontSize: 12, color: Colors.grey), textAlign: TextAlign.center),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.verified_user, color: Colors.grey, size: 28),
                            SizedBox(height: 4),
                            Text('Top Partners', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                        Column(
                          children: [
                            Icon(Icons.flash_on, color: Colors.grey, size: 28),
                            SizedBox(height: 4),
                            Text('Cashless Rides', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total fare', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            const Text('₹223', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('Includes taxes', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const Divider(height: 24),
                        _buildFareRow('Your Trip', '₹173'),
                        const SizedBox(height: 8),
                        _buildFareRow('Airport parking charge', '₹50'),
                        const SizedBox(height: 12),
                        Text(
                          'Total fare may change if toll, route or destination changes or if your ride takes longer due to traffic or other factors.\n\nYou may be charged a Cancellation fee of ₹75, if a trip is cancelled after 3 (three) minutes or later from the time of acceptance of booking by the Driver or if the driver cancels after reaching your location and waiting for 5 minutes.',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600], height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Our fleet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Image.asset('assets/images/texi2.png', width: 60, height: 45, fit: BoxFit.contain),
                            const SizedBox(width: 8),
                            Image.asset('assets/images/texi.png', width: 60, height: 45, fit: BoxFit.contain),
                            const SizedBox(width: 8),
                            Image.asset('assets/images/economy.png', width: 60, height: 45, fit: BoxFit.contain),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Maruti Suzuki Dzire, Toyota Etios, Honda Amaze',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 10, offset: const Offset(0, -2))],
        ),
        child: SafeArea(
          top: false,
          child: ElevatedButton(
            onPressed: () => _showConfirmationDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Done', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }

  Widget _buildFareRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        Text(amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
      ],
    );
  }

  void _showConfirmationDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.directions_car, color: Color(0xFF9C27B0)),
                    const SizedBox(width: 8),
                    const Text('Prime Sedan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 20),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(color: Color(0xFF4CAF50), shape: BoxShape.circle),
                              ),
                              Container(width: 2, height: 40, color: Colors.grey[300]),
                              Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(color: Color(0xFFFF5252), shape: BoxShape.circle),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_pickupController.text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 40),
                                Text(_dropController.text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text('Vehicle Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            Image.asset('assets/images/texi2.png', width: 80, height: 60, fit: BoxFit.contain),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Prime Sedan', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                  SizedBox(height: 4),
                                  Text('Spacious • Top Partners • 4 seats', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Fare Breakdown', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Column(
                          children: [
                            _buildFareRow('Your Trip', '₹173'),
                            const SizedBox(height: 8),
                            _buildFareRow('Airport parking charge', '₹50'),
                            const Divider(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Total (incl. taxes)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const Text('₹223', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4CAF50))),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Important Notes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.purple[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.purple[200]!),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('• Fare may change due to traffic/route', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            const SizedBox(height: 4),
                            Text('• Cancellation fee: ₹75 (after 3 mins)', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                            const SizedBox(height: 4),
                            Text('• Top-rated drivers & clean vehicles', style: TextStyle(fontSize: 12, color: Colors.grey[700])),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text('Payment Method', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_wallet, color: Color(0xFF2196F3)),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text('Cash / Wallet / UPI', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            ),
                            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
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
                child: SafeArea(
                  top: false,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Prime Sedan booking confirmed!'), backgroundColor: Colors.green),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Confirm Booking', style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
