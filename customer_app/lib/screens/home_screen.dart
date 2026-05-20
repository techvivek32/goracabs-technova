import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_theme.dart';
import 'taxi_booking_screen.dart';
import 'outstation_screen.dart';
import 'rental_screen.dart';
import 'hire_driver_screen.dart';
import 'wallet_screen.dart';
import 'ride_history_screen.dart';
import 'support_screen.dart';
import 'settings_screen.dart';
import 'profile_screen.dart';
import 'offers_screen.dart';
import 'service_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasOngoingRide = true;
  final MapController _mapController = MapController();

  final List<Map<String, dynamic>> _services = [
    {'icon': Icons.local_taxi, 'label': 'Taxi', 'color': Color(0xFF2196F3)},
    {'icon': Icons.route, 'label': 'Outstation', 'color': Color(0xFF4CAF50)},
    {'icon': Icons.schedule, 'label': 'Rental', 'color': Color(0xFFFF9800)},
    {'icon': Icons.person_pin, 'label': 'Hire Driver', 'color': Color(0xFF9C27B0)},
  ];

  final List<Map<String, String>> _recentPlaces = [
    {'name': 'Home', 'address': '12, MG Road, Delhi', 'icon': 'home'},
    {'name': 'Office', 'address': 'Cyber City, Gurugram', 'icon': 'work'},
    {'name': 'Phoenix Mall', 'address': 'Nagar Road, Pune', 'icon': 'place'},
  ];

  final List<Map<String, String>> _promos = [
    {'title': '50% OFF your first ride!', 'sub': 'Use code: GORA50', 'color': '0xFF2196F3'},
    {'title': 'Free Delivery today', 'sub': 'On orders above ₹200', 'color': '0xFF4CAF50'},
    {'title': 'Refer & Earn ₹100', 'sub': 'Invite friends to Gora Cabs', 'color': '0xFFFF9800'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // OpenStreetMap using flutter_map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: LatLng(28.6139, 77.2090),
              initialZoom: 14.0,
              minZoom: 5.0,
              maxZoom: 18.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.goracabs.customer_app',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(28.6139, 77.2090),
                    width: 40,
                    height: 40,
                    child: Icon(
                      Icons.location_on,
                      color: Color(0xFF2196F3),
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => _circleButton(Icons.menu, () => Scaffold.of(ctx).openDrawer()),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Where are you going?',
                        hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF2196F3), size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  _circleButton(Icons.my_location, () {}),
                ],
              ),
            ),
          ),

          // Bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.42,
            minChildSize: 0.15,
            maxChildSize: 0.88,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, 
                      blurRadius: 10, 
                      spreadRadius: 1,
                      offset: Offset(0, -2),
                    )
                  ],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  children: [
                    // Drag handle
                    Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),

                    // Ongoing ride
                    if (_hasOngoingRide) ...[
                      _buildOngoingRide(),
                      const SizedBox(height: 20),
                    ],

                    // Services grid
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Our Services',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const ServiceSelectionScreen()));
                          },
                          child: Text('View All',
                              style: TextStyle(fontSize: 14, color: Color(0xFF2196F3), fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _services.map((s) => _buildServiceItem(s)).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Promo banners
                    const Text('Offers for you',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 100,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _promos.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => _buildPromoBanner(_promos[i]),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Recent places
                    const Text('Recent Places',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ..._recentPlaces.map((p) => _buildRecentPlace(p)),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _circleButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(30),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Icon(icon, color: Color(0xFF2196F3), size: 22),
      ),
    );
  }

  Widget _buildServiceItem(Map<String, dynamic> s) {
    return GestureDetector(
      onTap: () {
        if (s['label'] == 'Taxi') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TaxiBookingScreen()));
        } else if (s['label'] == 'Outstation') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const OutstationScreen()));
        } else if (s['label'] == 'Rental') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const RentalScreen()));
        } else if (s['label'] == 'Hire Driver') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const HireDriverScreen()));
        }
      },
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: (s['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (s['color'] as Color).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(s['label'] as String,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildOngoingRide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF2196F3).withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.directions_car, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ongoing Ride',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white)),
                SizedBox(height: 4),
                Text('Driver is 2 min away • Gora Go',
                    style: TextStyle(fontSize: 13, color: Colors.white70)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.primaryPurple,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Track', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner(Map<String, String> promo) {
    final color = Color(int.parse(promo['color']!));
    return Container(
      width: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(promo['title']!,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 4),
          Text(promo['sub']!,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildRecentPlace(Map<String, String> place) {
    final iconMap = {
      'home': Icons.home_outlined,
      'work': Icons.work_outline,
      'place': Icons.place_outlined
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(iconMap[place['icon']] ?? Icons.place_outlined,
            color: Color(0xFF2196F3), size: 20),
      ),
      title: Text(place['name']!,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
      subtitle: Text(place['address']!,
          style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      trailing: Icon(Icons.north_west, size: 16, color: Colors.grey[500]),
      onTap: () {},
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            color: Color(0xFF2196F3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                  },
                  child: const Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.white24,
                        child: Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('John Doe',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)),
                            SizedBox(height: 4),
                            Text('john.doe@goracabs.com',
                                style: TextStyle(color: Colors.white70, fontSize: 14)),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _drawerItem(Icons.person_outline, 'My Profile', onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
          }),
          _drawerItem(Icons.account_balance_wallet_outlined, 'Wallet', onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
          }),
          _drawerItem(Icons.history, 'Ride History', onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const RideHistoryScreen()));
          }),
          _drawerItem(Icons.card_giftcard_outlined, 'Offers & Promos', onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen()));
          }),
          _drawerItem(Icons.help_outline, 'Help & Support', onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()));
          }),
          const Spacer(),
          const Divider(),
          _drawerItem(Icons.settings_outlined, 'Settings', onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
          }),
          _drawerItem(Icons.logout, 'Logout', color: Colors.red),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _drawerItem(IconData icon, String title, {Color? color, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[600], size: 22),
      title: Text(title, style: TextStyle(fontSize: 15, color: color ?? Colors.black87, fontWeight: FontWeight.w500)),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}
