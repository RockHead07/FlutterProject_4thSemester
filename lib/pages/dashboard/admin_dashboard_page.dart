import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import 'widgets/sidebar_widget.dart';
import 'widgets/stat_card_widget.dart';
import 'widgets/chart_widgets.dart';

class AdminDashboardPage extends StatefulWidget {
  final UserModel user;

  const AdminDashboardPage({super.key, required this.user});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

  // Static/dummy data — will be replaced by REST API calls later
  static const _totalUsers = '75,782';
  static const _activeUsers = '25,782';
  static const _newClients = '6,782';
  static const _activeSubs = '2,986';

  final _userGrowthData = const [
    210, 280, 260, 340, 300, 380, 420, 390, 450, 410, 490, 470,
    530, 500, 580, 560, 620, 600, 670, 650, 710, 690, 750, 730,
  ].map((e) => e.toDouble()).toList();

  final _newClientsData = const [
    120, 90, 150, 110, 170, 140, 200, 160, 230, 180, 260, 210,
    290, 240, 320, 270, 350, 300, 380, 330, 410, 360, 440, 390,
  ].map((e) => e.toDouble()).toList();

  final _subsData = const [
    180, 220, 160, 280, 200, 310, 260, 340, 290, 370, 310, 400,
  ].map((e) => e.toDouble()).toList();

  // Page titles for sidebar navigation
  static const _pageTitles = [
    'Dashboard',
    'Users',
    'Projects',
    'Materials',
    'Pricing Plans',
    'Partners',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: Row(
        children: [
          SidebarWidget(
            selectedIndex: _selectedIndex,
            onItemSelected: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: _selectedIndex == 0
                      ? _buildDashboardBody()
                      : _buildPlaceholderPage(_pageTitles[_selectedIndex]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.darkGreen.withOpacity(0.12),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Flexible(
            child: Text(
              _pageTitles[_selectedIndex],
              style: const TextStyle(
                color: AppColors.darkBg,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const Spacer(),
          // Bell icon
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.lightBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.darkGreen.withOpacity(0.12),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_outlined,
                  color: AppColors.darkGreen.withOpacity(0.6),
                  size: 18,
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Avatar + name
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.mediumGreen],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  widget.user.email.isNotEmpty
                      ? widget.user.email[0].toUpperCase()
                      : 'A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.email,
                      style: const TextStyle(
                        color: AppColors.darkBg,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'Administrator',
                      style: TextStyle(
                        color: AppColors.darkGreen.withOpacity(0.5),
                        fontSize: 11,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Welcome back',
                        style: TextStyle(
                          color: AppColors.darkBg,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('👋', style: TextStyle(fontSize: 24)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _todayString(),
                    style: TextStyle(
                      color: AppColors.darkGreen.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 28),

          // Top row: Total Users + Active Users
          Row(
            children: [
              // Total Users card
              Expanded(
                child: StatCardWidget(
                  title: 'Total Users',
                  value: _totalUsers,
                  subtitle: '+24.635 users from last month',
                  changePercent: 2,
                  isPositive: true,
                  extraContent: Row(
                    children: [
                      _buildMiniStat('THIS MONTH', '+24.635'),
                      const SizedBox(width: 24),
                      _buildMiniStat('LAST MONTH', '51.147'),
                    ],
                  ),
                  chart: MiniLineChart(data: _userGrowthData),
                ),
              ),
              const SizedBox(width: 20),
              // Active Users card
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.darkGreen.withOpacity(0.1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ACTIVE USERS',
                        style: TextStyle(
                          color: AppColors.darkGreen.withOpacity(0.5),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Flexible(
                            child: const Text(
                              _activeUsers,
                              style: TextStyle(
                                color: AppColors.darkBg,
                                fontSize: 34,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -1,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 10),
                          _buildChangeBadge(-1, false),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: DonutChart(
                          activeRate: 78,
                          activeCount: 25782,
                          inactiveCount: 7259,
                          total: 33041,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bottom row: New Clients + Active Subscriptions
          Row(
            children: [
              // New Clients
              Expanded(
                child: StatCardWidget(
                  title: 'New Clients',
                  value: _newClients,
                  subtitle: 'Compared to last 7 days',
                  changePercent: 0,
                  isPositive: true,
                  chart: MiniLineChart(
                    data: _newClientsData,
                    color: AppColors.mediumGreen,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              // Active Subscriptions
              Expanded(
                child: StatCardWidget(
                  title: 'Active Subscriptions',
                  value: _activeSubs,
                  subtitle: 'Compared to last 7 days',
                  changePercent: 4,
                  isPositive: true,
                  chart: VerticalBarChart(
                    data: _subsData,
                    labels: const ['M', 'T', 'W', 'T', 'F', 'S', 'S', 'M', 'T', 'W', 'T', 'F'],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderPage(String title) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.lightGreen.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.construction_rounded,
              color: AppColors.primary,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Halaman $title',
            style: const TextStyle(
              color: AppColors.darkBg,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Halaman ini sedang dalam pengembangan',
            style: TextStyle(
              color: AppColors.darkGreen.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.darkGreen.withOpacity(0.4),
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.darkBg,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildChangeBadge(double percent, bool isPositive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: isPositive
            ? AppColors.primary.withOpacity(0.12)
            : AppColors.error.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
            color: isPositive ? AppColors.primary : AppColors.error,
            size: 11,
          ),
          const SizedBox(width: 2),
          Text(
            '${percent.abs().toStringAsFixed(0)}%',
            style: TextStyle(
              color: isPositive ? AppColors.primary : AppColors.error,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _todayString() {
    final now = DateTime.now();
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    const months = ['January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}, ${now.year}';
  }
}