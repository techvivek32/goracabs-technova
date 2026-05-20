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
    {'icon': Icons.local_taxi, 'label': 'Taxi', 'color': AppTheme.primaryPurple, 'gradient': AppTheme.primaryGradient},
    {'icon': Icons.route, 'label': 'Outstation', 'color': AppTheme.secondaryBlue, 'gradient': AppTheme.primaryGradient},
    {'icon': Icons.schedule, 'label': 'Rental', 'color': AppTheme.accentGreen, 'gradient': AppTheme.successGradient},
    {'icon': Icons.person_pin, 'label': 'Hire Driver', 'color': AppTheme.accentOrange, 'gradient': AppTheme.accentGradient},
  ];

  final List<Map<String, String>> _recentPlaces = [
    {'name': 'Home', 'address': '12, MG Road, Delhi', 'icon': 'home'},
    {'name': 'Office', 'address': 'Cyber City, Gurugram', 'icon': 'work'},
    {'name': 'Phoenix Mall', 'address': 'Nagar Road, Pune', 'icon': 'place'},
  ];

  final List<Map<String, String>> _promos = [
    {'title': '50% OFF your first ride!', 'sub': 'Use code: GORA50', 'color': '0xFF6C5CE7'},
    {'title': 'Free Delivery today', 'sub': 'On orders above ₹200', 'color': '0xFFFF7675'},
    {'title': 'Refer & Earn ₹100', 'sub': 'Invite friends to Gora Cabs', 'color': '0xFF00B894'},
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
                      color: AppTheme.primaryPurple,
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
                        prefixIcon: const Icon(Icons.search, color: AppTheme.primaryPurple, size: 20),
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12, 
                      blurRadius: 24, 
                      spreadRadius: 4,
                      offset: Offset(0, -4),
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
                        width: 50,
                        height: 6,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(3),
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
                              style: TextStyle(fontSize: 14, color: AppTheme.primaryPurple, fontWeight: FontWeight.w600)),
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
        child: Icon(icon, color: AppTheme.primaryPurple, size: 22),
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
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              gradient: s['gradient'] as LinearGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (s['color'] as Color).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(s['icon'] as IconData, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 8),
          Text(s['label'] as String,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppTheme.textDark)),
        ],
      ),
    );
  }

  Widget _buildOngoingRide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryPurple.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
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
      width: 240,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(promo['title']!,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 6),
          Text(promo['sub']!,
              style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13)),
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(iconMap[place['icon']] ?? Icons.place_outlined,
            color: Colors.white, size: 20),
      ),
      title: Text(place['name']!,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppTheme.textDark)),
      subtitle: Text(place['address']!,
          style: const TextStyle(fontSize: 13, color: AppTheme.textMedium)),
      trailing: const Icon(Icons.north_west, size: 18, color: AppTheme.textLight),
      onTap: () {},
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 28),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
            ),
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
      leading: Icon(icon, color: color ?? AppTheme.textMedium, size: 24),
      title: Text(title, style: TextStyle(fontSize: 16, color: color ?? AppTheme.textDark, fontWeight: FontWeight.w500)),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}
