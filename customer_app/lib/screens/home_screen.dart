import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasOngoingRide = true;

  final List<Map<String, dynamic>> _services = [
    {'icon': Icons.local_taxi, 'label': 'Taxi', 'color': Color(0xFF0052CC)},
    {'icon': Icons.route, 'label': 'Outstation', 'color': Color(0xFF0052CC)},
    {'icon': Icons.schedule, 'label': 'Rental', 'color': Color(0xFF0052CC)},
    {'icon': Icons.person_pin, 'label': 'Hire Driver', 'color': Color(0xFF0052CC)},
  ];

  final List<Map<String, String>> _recentPlaces = [
    {'name': 'Home', 'address': '12, MG Road, Delhi', 'icon': 'home'},
    {'name': 'Office', 'address': 'Cyber City, Gurugram', 'icon': 'work'},
    {'name': 'Phoenix Mall', 'address': 'Nagar Road, Pune', 'icon': 'place'},
  ];

  final List<Map<String, String>> _promos = [
    {'title': '50% OFF your first ride!', 'sub': 'Use code: GORA50', 'color': '0xFF0052CC'},
    {'title': 'Free Delivery today', 'sub': 'On orders above ₹200', 'color': '0xFFE65100'},
    {'title': 'Refer & Earn ₹100', 'sub': 'Invite friends to Gora Cabs', 'color': '0xFF2E7D32'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Stack(
        children: [
          // Map Placeholder
          Container(
            color: Colors.grey[300],
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text('Map View', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
                ],
              ),
            ),
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
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.search, color: AppTheme.primaryBlue, size: 20),
                            const SizedBox(width: 10),
                            Text('Where are you going?',
                                style: TextStyle(color: Colors.grey[500], fontSize: 15)),
                          ],
                        ),
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
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 16, spreadRadius: 2)
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
                          color: Colors.grey[300],
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
                    const Text('Our Services',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
        child: Icon(icon, color: AppTheme.primaryBlue, size: 22),
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
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: (s['color'] as Color).withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(s['icon'] as IconData, color: s['color'] as Color, size: 30),
          ),
          const SizedBox(height: 6),
          Text(s['label'] as String,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOngoingRide() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withAlpha(15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withAlpha(60)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.directions_car, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ongoing Ride',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 2),
                Text('Driver is 2 min away • Gora Go',
                    style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Track', style: TextStyle(fontSize: 13)),
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
        gradient: LinearGradient(
          colors: [color, color.withAlpha(180)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
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
              style: TextStyle(color: Colors.white.withAlpha(200), fontSize: 12)),
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
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(iconMap[place['icon']] ?? Icons.place_outlined,
            color: AppTheme.primaryBlue, size: 22),
      ),
      title: Text(place['name']!,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
      subtitle: Text(place['address']!,
          style: const TextStyle(fontSize: 12, color: AppTheme.textGrey)),
      trailing: const Icon(Icons.north_west, size: 16, color: AppTheme.textGrey),
      onTap: () {},
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 56, 20, 24),
            color: AppTheme.primaryBlue,
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
                        radius: 32,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, size: 36, color: AppTheme.primaryBlue),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('John Doe',
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            SizedBox(height: 2),
                            Text('john.doe@goracabs.com',
                                style: TextStyle(color: Colors.white70, fontSize: 13)),
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
      leading: Icon(icon, color: color ?? AppTheme.textGrey, size: 22),
      title: Text(title, style: TextStyle(fontSize: 15, color: color ?? Colors.black87)),
      onTap: onTap ?? () => Navigator.pop(context),
    );
  }
}
