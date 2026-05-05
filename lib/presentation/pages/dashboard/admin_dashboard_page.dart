import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_colors.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';
import '../../blocs/users/users_bloc.dart';
import 'widgets/sidebar_widget.dart';
import 'widgets/stat_card_widget.dart';
import 'widgets/chart_widgets.dart';
import 'users_page.dart';

class AdminDashboardPage extends StatefulWidget {
  final UserModel user;

  const AdminDashboardPage({super.key, required this.user});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _selectedIndex = 0;

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
    return BlocProvider(
      create: (context) => UsersBloc(
        userRepository: context.read<UserRepository>(),
      )..add(UsersLoad(token: widget.user.token)),
      child: Scaffold(
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
                    child: _buildPageContent(),
                  ),
                ],
              ),
            ),
          ],
        ),
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
          Text(
            _pageTitles[_selectedIndex],
            style: const TextStyle(
              color: AppColors.darkBg,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.2,
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

        ],
      ),
    );
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardOverview();
      case 1:
        return UsersPage(token: widget.user.token);
      default:
        return _buildPlaceholder(_pageTitles[_selectedIndex]);
    }
  }

  // ── Dashboard Overview ────────────────────────────────────────────────────
  Widget _buildDashboardOverview() {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        final users = state.users;
        final totalUsers = users.length;
        final activeUsers = users.where((u) => u.accountStatus?.toLowerCase() == 'active').length;
        final adminCount = users.where((u) => u.role?.toLowerCase() == 'admin').length;
        final inactiveUsers = totalUsers - activeUsers;
        final activeRate = totalUsers > 0 ? (activeUsers / totalUsers * 100) : 0.0;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome banner
              _buildWelcomeBanner(),
              const SizedBox(height: 16),

              // Stat cards - responsive grid
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 600;
                  final cardWidth = isWide
                      ? (constraints.maxWidth - 48) / 4
                      : (constraints.maxWidth - 16) / 2;
                  return Wrap(
                    spacing: isWide ? 16 : 10,
                    runSpacing: isWide ? 16 : 10,
                    children: [
                      SizedBox(
                        width: cardWidth.clamp(140.0, 400.0),
                        child: StatCardWidget(
                          title: 'Total Users',
                          value: totalUsers.toString(),
                          subtitle: 'Semua akun',
                          changePercent: 12,
                          isPositive: true,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth.clamp(140.0, 400.0),
                        child: StatCardWidget(
                          title: 'Active',
                          value: activeUsers.toString(),
                          subtitle: 'Akun aktif',
                          changePercent: 8,
                          isPositive: true,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth.clamp(140.0, 400.0),
                        child: StatCardWidget(
                          title: 'Admins',
                          value: adminCount.toString(),
                          subtitle: 'Role admin',
                          changePercent: 0,
                          isPositive: true,
                        ),
                      ),
                      SizedBox(
                        width: cardWidth.clamp(140.0, 400.0),
                        child: StatCardWidget(
                          title: 'Inactive',
                          value: inactiveUsers.toString(),
                          subtitle: 'Nonaktif',
                          changePercent: inactiveUsers > 0 ? 5 : 0,
                          isPositive: false,
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),

              // Charts - stack vertically on mobile
              _buildChartCard(
                title: 'Distribusi Status User',
                subtitle: 'Aktif vs nonaktif',
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: DonutChart(
                    activeRate: activeRate,
                    activeCount: activeUsers,
                    inactiveCount: inactiveUsers,
                    total: totalUsers,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildChartCard(
                title: 'Registrasi Bulanan',
                subtitle: 'User baru per bulan',
                child: const SizedBox(
                  height: 160,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: VerticalBarChart(
                      data: [4, 7, 5, 9, 6, 12, 8],
                      labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Recent users
              _buildRecentUsersCard(users),
            ],
          ),
        );
      },
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.darkGreen, AppColors.mediumGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: AppColors.darkGreen.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, ${widget.user.email.split('@').first}!',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Here\'s an overview of your application data.',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.insights_rounded, color: Colors.white, size: 28),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkGreen.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.darkBg,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: AppColors.darkGreen.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          child,
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildRecentUsersCard(List users) {
    final recent = users.take(5).toList();
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkGreen.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                const Text(
                  'Recent Users',
                  style: TextStyle(
                    color: AppColors.darkBg,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => setState(() => _selectedIndex = 1),
                  child: const Text(
                    'View All →',
                    style: TextStyle(color: AppColors.primary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.darkGreen.withOpacity(0.06)),
          if (recent.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Center(
                child: Text(
                  'No users yet',
                  style: TextStyle(color: AppColors.darkGreen.withOpacity(0.4)),
                ),
              ),
            )
          else
            ...recent.map((user) => _buildRecentUserRow(user)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildRecentUserRow(dynamic user) {
    final initials = user.username.isNotEmpty ? user.username[0].toUpperCase() : '?';
    final displayName = (user.firstName != null && user.firstName.isNotEmpty)
        ? '${user.firstName} ${user.lastName ?? ''}'.trim()
        : user.username;
    final isActive = user.accountStatus?.toLowerCase() == 'active';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withOpacity(0.12),
            child: Text(
              initials,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: const TextStyle(
                    color: AppColors.darkBg,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  user.email,
                  style: TextStyle(
                    color: AppColors.darkGreen.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.success.withOpacity(0.4)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isActive ? 'Active' : 'Inactive',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: isActive ? AppColors.darkGreen : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Placeholder ───────────────────────────────────────────────────────────
  Widget _buildPlaceholder(String title) {
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
            child: const Icon(
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
            'Fitur ini akan segera tersedia',
            style: TextStyle(
              color: AppColors.darkGreen.withOpacity(0.5),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}