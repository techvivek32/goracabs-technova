import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'invoice_screen.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final rides = [
      {
        'date': 'Today, 10:30 AM',
        'from': 'MG Road, Delhi',
        'to': 'Cyber City, Gurugram',
        'driver': 'Rajesh Kumar',
        'fare': '₹120',
        'status': 'Completed',
        'rating': 4.5,
        'vehicle': 'Gora Go',
      },
      {
        'date': 'Yesterday, 5:45 PM',
        'from': 'Connaught Place',
        'to': 'Dwarka Sector 21',
        'driver': 'Amit Singh',
        'fare': '₹180',
        'status': 'Completed',
        'rating': 5.0,
        'vehicle': 'Gora Sedan',
      },
      {
        'date': '15 Jan, 2:20 PM',
        'from': 'Nehru Place',
        'to': 'Saket Mall',
        'driver': 'Suresh Patel',
        'fare': '₹95',
        'status': 'Completed',
        'rating': 4.0,
        'vehicle': 'Gora Go',
      },
      {
        'date': '14 Jan, 11:00 AM',
        'from': 'IGI Airport',
        'to': 'Vasant Kunj',
        'driver': 'Vikram Sharma',
        'fare': '₹250',
        'status': 'Cancelled',
        'rating': 0.0,
        'vehicle': 'Gora SUV',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: rides.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (_, i) {
          final ride = rides[i];
          final isCancelled = ride['status'] == 'Cancelled';
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: isCancelled ? Colors.red[50] : Colors.green[50],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        ride['status'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isCancelled ? Colors.red : Colors.green,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(ride['date'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                        ),
                        Container(
                          width: 2,
                          height: 30,
                          color: Colors.grey[300],
                        ),
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.red, width: 2),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(ride['from'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 24),
                          Text(ride['to'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                Row(
                  children: [
                    const Icon(Icons.person_outline, size: 18, color: AppTheme.textGrey),
                    const SizedBox(width: 6),
                    Text(ride['driver'] as String, style: const TextStyle(fontSize: 13)),
                    const SizedBox(width: 16),
                    const Icon(Icons.directions_car, size: 18, color: AppTheme.textGrey),
                    const SizedBox(width: 6),
                    Text(ride['vehicle'] as String == 'Gora Go' ? 'Bike' : 
                         ride['vehicle'] as String == 'Gora Sedan' ? 'Cab Economy' : 
                         ride['vehicle'] as String == 'Gora SUV' ? 'SUV' : 'Premium', 
                         style: const TextStyle(fontSize: 13)),
                    const Spacer(),
                    Text(ride['fare'] as String, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.primaryBlue)),
                  ],
                ),
                if (!isCancelled) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      if ((ride['rating'] as double) > 0) ...[
                        const Icon(Icons.star, color: Colors.amber, size: 18),
                        const SizedBox(width: 4),
                        Text('${ride['rating']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      ] else
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => RatingDialog(driver: ride['driver'] as String),
                            );
                          },
                          child: const Text('Rate this ride', style: TextStyle(color: AppTheme.primaryBlue)),
                        ),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () {
                          final String originalVehicle = ride['vehicle'] as String;
                          final String mappedVehicle = originalVehicle == 'Gora Go' ? 'Bike' : 
                                                     originalVehicle == 'Gora Sedan' ? 'Cab Economy' : 
                                                     originalVehicle == 'Gora SUV' ? 'SUV' : 'Premium';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => InvoiceScreen(
                                vehicleName: mappedVehicle,
                                selectedTip: 0,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.receipt_long, size: 16),
                        label: const Text('Invoice'),
                        style: TextButton.styleFrom(foregroundColor: AppTheme.primaryBlue),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class RatingDialog extends StatefulWidget {
  final String driver;
  const RatingDialog({super.key, required this.driver});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _rating = 0;
  final _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Rate ${widget.driver}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return IconButton(
                onPressed: () => setState(() => _rating = i + 1),
                icon: Icon(
                  i < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 36,
                ),
              );
            }),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _feedbackController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Share your feedback (optional)',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _rating == 0
              ? null
              : () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your feedback!')),
                  );
                },
          style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryBlue),
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
