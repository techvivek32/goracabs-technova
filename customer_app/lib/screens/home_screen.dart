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
import 'service_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasOngoingRide = true;
  int _currentIndex = 0;
  bool _showRecentLocations = false;
  final FocusNode _searchFocusNode = FocusNode();

  final List<Map<String, dynamic>> _services = [
    {'icon': 'assets/images/texi.png', 'label': 'Taxi', 'color': Color(0xFF2196F3), 'bgColor': Color(0xFFE3F2FD)},
    {'icon': 'assets/images/outstation.png', 'label': 'Outstation', 'color': Color(0xFF4CAF50), 'bgColor': Color(0xFFE8F5E9)},
    {'icon': 'assets/images/rental.png', 'label': 'Rental', 'color': Color(0xFFFF9800), 'bgColor': Color(0xFFFFF3E0)},
    {'icon': 'assets/images/hiredriver.png', 'label': 'Hire Driver', 'color': Color(0xFF9C27B0), 'bgColor': Color(0xFFF3E5F5)},
  ];

  final List<Map<String, String>> _recentLocations = [
    {'name': 'Home', 'address': '12, MG Road, Delhi'},
    {'name': 'Office', 'address': 'Cyber City, Gurugram'},
  ];

  final List<Map<String, String>> _popularLocations = [
    {'name': 'Phoenix Mall', 'address': 'Nagar Road, Pune', 'image': 'https://images.unsplash.com/photo-1519567241046-7f570eee3ce6?w=400'},
    {'name': 'Airport Terminal 3', 'address': 'IGI Airport, Delhi', 'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=400'},
    {'name': 'Railway Station', 'address': 'New Delhi Railway Station', 'image': 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=400'},
  ];

  final List<Map<String, String>> _promos = [
    {'title': '50% OFF your first ride!', 'sub': 'Use code: GORA50', 'color': '0xFF0052CC'},
    {'title': 'Free Delivery today', 'sub': 'On orders above ₹200', 'color': '0xFFE65100'},
    {'title': 'Refer & Earn ₹100', 'sub': 'Invite friends to Gora Cabs', 'color': '0xFF2E7D32'},
  ];

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() {
      setState(() {
        _showRecentLocations = _searchFocusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getSelectedPage(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _getSelectedPage() {
    switch (_currentIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return const ServiceSelectionScreen();
      case 2:
        return const RideHistoryScreen();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryBlue,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            activeIcon: Icon(Icons.history),
            label: 'Recent Rides',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomePage() {
    return Scaffold(
      backgroundColor: Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: AppTheme.primaryBlue,
                    child: Icon(Icons.person, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hello,', style: TextStyle(fontSize: 13, color: AppTheme.textGrey)),
                        SizedBox(height: 2),
                        Text('John Doe', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.notifications_outlined, size: 26),
                  ),
                ],
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(20),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: TextField(
                  focusNode: _searchFocusNode,
                  onTap: () {
                    setState(() {
                      _showRecentLocations = true;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Where are you going?',
                    hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.primaryBlue, size: 22),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_showRecentLocations) ...[
                      Container(
                        color: Color(0xFFF8F8F8),
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                        child: Column(
                          children: _recentLocations.asMap().entries.map((entry) {
                            final index = entry.key;
                            final loc = entry.value;
                            return Column(
                              children: [
                                _buildRecentItem(loc),
                                if (index < _recentLocations.length - 1)
                                  Container(
                                    margin: const EdgeInsets.symmetric(vertical: 8),
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 32),
                                        Expanded(
                                          child: CustomPaint(
                                            size: const Size(double.infinity, 1),
                                            painter: DottedLinePainter(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                    
                    const Text('Popular Places', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 140,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _popularLocations.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => _buildPopularCard(_popularLocations[i]),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    if (_hasOngoingRide) ...[ 
                      _buildOngoingRide(),
                      const SizedBox(height: 24),
                    ],

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Our Services', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        GestureDetector(
                          onTap: () => setState(() => _currentIndex = 1),
                          child: const Text('View All', style: TextStyle(fontSize: 14, color: AppTheme.primaryBlue, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _services.map((s) => _buildServiceItem(s)).toList(),
                    ),

                    const SizedBox(height: 24),

                    const Text('Offers for you', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItem(Map<String, String> location) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.access_time, color: Colors.grey[600], size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  location['name']!,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  location['address']!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border, color: Colors.grey[600], size: 20),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  Widget _buildPopularCard(Map<String, String> location) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            Image.network(
              location['image']!,
              width: 200,
              height: 140,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 200,
                  height: 140,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                );
              },
            ),
            Container(
              width: 200,
              height: 140,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned(
              bottom: 12,
              left: 12,
              right: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location['name']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location['address']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
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
              color: s['bgColor'] as Color,
              borderRadius: BorderRadius.circular(20),
            ),
            child: s['icon'] is String
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset(
                      s['icon'] as String,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(s['icon'] as IconData, color: s['color'] as Color, size: 32),
          ),
          const SizedBox(height: 8),
          Text(s['label'] as String, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildOngoingRide() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/images/texi2.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Ongoing Ride', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 4),
                Text('Driver is 2 min away • Gora Go', style: TextStyle(fontSize: 12, color: AppTheme.textGrey)),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              foregroundColor: Colors.white,
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.local_offer,
              color: AppTheme.primaryBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  promo['title']!,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  promo['sub']!,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfilePage() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryBlue, AppTheme.primaryBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: AppTheme.primaryBlue),
                    ),
                    const SizedBox(height: 16),
                    const Text('John Doe', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
                    const SizedBox(height: 4),
                    const Text('john.doe@goracabs.com', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileScreen()));
                      },
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Edit Profile'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primaryBlue,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _buildProfileMenuItem(Icons.account_balance_wallet_outlined, 'Wallet', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const WalletScreen()));
              }),
              _buildProfileMenuItem(Icons.history, 'Ride History', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RideHistoryScreen()));
              }),
              _buildProfileMenuItem(Icons.card_giftcard_outlined, 'Offers & Promos', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersScreen()));
              }),
              _buildProfileMenuItem(Icons.help_outline, 'Help & Support', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SupportScreen()));
              }),
              _buildProfileMenuItem(Icons.settings_outlined, 'Settings', () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
              }),
              _buildProfileMenuItem(Icons.logout, 'Logout', () {}, color: Colors.red),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: (color ?? AppTheme.primaryBlue).withAlpha(20),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color ?? AppTheme.primaryBlue, size: 22),
        ),
        title: Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: color ?? Colors.black87)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}

class DottedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 4.0;
    const dashSpace = 4.0;
    double startX = 0;

    while (startX < size.width) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
