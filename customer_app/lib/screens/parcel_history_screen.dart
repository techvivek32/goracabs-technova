import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ParcelHistoryScreen extends StatefulWidget {
  const ParcelHistoryScreen({super.key});

  @override
  State<ParcelHistoryScreen> createState() => _ParcelHistoryScreenState();
}

class _ParcelHistoryScreenState extends State<ParcelHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> _sendHistory = [
    {
      'id': 'PRC9284',
      'date': '24 May 2026, 10:30 AM',
      'pickup': 'Arvind Nagar, Jodhpur',
      'drop': 'Clock Tower, Jodhpur',
      'item': 'Electronics',
      'price': '₹80',
      'status': 'Delivered',
      'statusColor': Colors.green,
    },
    {
      'id': 'PRC5291',
      'date': '20 May 2026, 02:15 PM',
      'pickup': 'Sardarpura, Jodhpur',
      'drop': 'Paota, Jodhpur',
      'item': 'Documents',
      'price': '₹50',
      'status': 'Cancelled',
      'statusColor': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _receiveHistory = [
    {
      'id': 'PRC1048',
      'date': '26 May 2026, 09:45 AM',
      'pickup': 'Ratanada, Jodhpur',
      'drop': 'Airforce Area, Jodhpur',
      'item': 'Food Items',
      'price': '₹60',
      'status': 'On the way',
      'statusColor': AppTheme.primaryBlue,
    },
    {
      'id': 'PRC3829',
      'date': '22 May 2026, 11:00 AM',
      'pickup': 'Basni, Jodhpur',
      'drop': 'Shastri Nagar, Jodhpur',
      'item': 'Clothing',
      'price': '₹55',
      'status': 'Delivered',
      'statusColor': Colors.green,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Parcel History', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryBlue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryBlue,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Sent Parcels'),
            Tab(text: 'Received Parcels'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildHistoryList(_sendHistory),
          _buildHistoryList(_receiveHistory),
        ],
      ),
    );
  }

  Widget _buildHistoryList(List<Map<String, dynamic>> history) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.history_outlined, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text('No history found', style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: history.length,
      itemBuilder: (context, index) {
        final item = history[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ID: ${item['id']}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primaryBlue),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (item['statusColor'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item['status'],
                      style: TextStyle(
                        color: item['statusColor'],
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(item['date'], style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const Divider(height: 24),
              _buildLocationRow(Icons.radio_button_checked, Colors.green, item['pickup']),
              const Padding(
                padding: EdgeInsets.only(left: 11),
                child: SizedBox(height: 8, child: VerticalDivider(width: 2)),
              ),
              _buildLocationRow(Icons.location_on, Colors.red, item['drop']),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.inventory_2_outlined, size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(item['item'], style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    ],
                  ),
                  Text(
                    item['price'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLocationRow(IconData icon, Color color, String location) {
    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            location,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
