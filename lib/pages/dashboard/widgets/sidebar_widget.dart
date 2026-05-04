import 'package:flutter/material.dart';
import '../../../constants/app_colors.dart';

class SidebarWidget extends StatefulWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const SidebarWidget({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  State<SidebarWidget> createState() => _SidebarWidgetState();
}

class _SidebarWidgetState extends State<SidebarWidget> {
  bool _isCollapsed = false;

  final List<_SidebarItem> _items = [
    _SidebarItem(icon: Icons.dashboard_rounded, label: 'Dashboard', section: 'OVERVIEW'),
    _SidebarItem(icon: Icons.people_rounded, label: 'Users', section: 'MANAGE'),
    _SidebarItem(icon: Icons.folder_rounded, label: 'Projects', section: null),
    _SidebarItem(icon: Icons.inventory_2_rounded, label: 'Materials', section: null),
    _SidebarItem(icon: Icons.card_membership_rounded, label: 'Pricing Plans', section: null),
    _SidebarItem(icon: Icons.handshake_rounded, label: 'Partners', section: null),
  ];

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      width: _isCollapsed ? 72 : 220,
      decoration: BoxDecoration(
        color: const Color(0xFF161E1D),
        border: Border(
          right: BorderSide(
            color: AppColors.darkGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // Logo area
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.architecture_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (!_isCollapsed) ...[
                  const SizedBox(width: 10),
                  const Text(
                    'RenovaSim',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
                const Spacer(),
                if (!_isCollapsed)
                  GestureDetector(
                    onTap: () => setState(() => _isCollapsed = true),
                    child: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white.withOpacity(0.5),
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),

          if (_isCollapsed)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: GestureDetector(
                onTap: () => setState(() => _isCollapsed = false),
                child: Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white.withOpacity(0.5),
                  size: 20,
                ),
              ),
            ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: _items.length,
              itemBuilder: (context, index) {
                final item = _items[index];
                final isSelected = widget.selectedIndex == index;

                List<Widget> result = [];

                if (item.section != null && !_isCollapsed) {
                  result.add(Padding(
                    padding: const EdgeInsets.fromLTRB(8, 16, 8, 6),
                    child: Text(
                      item.section!,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ));
                }

                result.add(
                  GestureDetector(
                    onTap: () => widget.onItemSelected(index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      padding: EdgeInsets.symmetric(
                        horizontal: _isCollapsed ? 0 : 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.15)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: isSelected
                            ? Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1,
                              )
                            : null,
                      ),
                      child: Row(
                        mainAxisAlignment: _isCollapsed
                            ? MainAxisAlignment.center
                            : MainAxisAlignment.start,
                        children: [
                          Icon(
                            item.icon,
                            color: isSelected
                                ? AppColors.primary
                                : Colors.white.withOpacity(0.5),
                            size: 20,
                          ),
                          if (!_isCollapsed) ...[
                            const SizedBox(width: 10),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.6),
                                fontSize: 13.5,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: result,
                );
              },
            ),
          ),

          // Bottom actions
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: [
                _buildBottomItem(
                  icon: Icons.settings_rounded,
                  label: 'Settings',
                  onTap: () {},
                ),
                const SizedBox(height: 4),
                _buildBottomItem(
                  icon: Icons.logout_rounded,
                  label: 'Logout',
                  onTap: () => Navigator.of(context).pushReplacementNamed('/login'),
                  isDestructive: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: _isCollapsed ? 0 : 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment:
              _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: isDestructive
                  ? AppColors.error.withOpacity(0.8)
                  : Colors.white.withOpacity(0.4),
              size: 18,
            ),
            if (!_isCollapsed) ...[
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  color: isDestructive
                      ? AppColors.error.withOpacity(0.8)
                      : Colors.white.withOpacity(0.4),
                  fontSize: 13,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;
  final String? section;

  _SidebarItem({
    required this.icon,
    required this.label,
    this.section,
  });
}