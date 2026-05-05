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
        color: Colors.white,
        border: Border(
          right: BorderSide(
            color: AppColors.darkGreen.withOpacity(0.1),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo area
          Container(
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.darkGreen.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: _isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, AppColors.mediumGreen],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.architecture_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                if (!_isCollapsed) ...[
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      'RenovaSim',
                      style: const TextStyle(
                        color: AppColors.darkBg,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  InkWell(
                    onTap: () => setState(() => _isCollapsed = true),
                    borderRadius: BorderRadius.circular(6),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: Icon(
                        Icons.chevron_left_rounded,
                        color: AppColors.darkGreen.withOpacity(0.4),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (_isCollapsed)
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 4),
              child: InkWell(
                onTap: () => setState(() => _isCollapsed = false),
                borderRadius: BorderRadius.circular(6),
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.darkGreen.withOpacity(0.4),
                    size: 20,
                  ),
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
                        color: AppColors.darkGreen.withOpacity(0.4),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ));
                }

                result.add(
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => widget.onItemSelected(index),
                      borderRadius: BorderRadius.circular(10),
                      hoverColor: AppColors.lightGreen.withOpacity(0.15),
                      splashColor: AppColors.primary.withOpacity(0.1),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        clipBehavior: Clip.hardEdge,
                        margin: const EdgeInsets.symmetric(vertical: 2),
                        padding: EdgeInsets.symmetric(
                          horizontal: _isCollapsed ? 0 : 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
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
                                  : AppColors.darkGreen.withOpacity(0.45),
                              size: 20,
                            ),
                            if (!_isCollapsed) ...[
                              const SizedBox(width: 10),
                              Flexible(
                                child: Text(
                                  item.label,
                                  style: TextStyle(
                                    color: isSelected
                                        ? AppColors.darkBg
                                        : AppColors.darkGreen.withOpacity(0.7),
                                    fontSize: 13.5,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ],
                        ),
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
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.darkGreen.withOpacity(0.08),
                  width: 1,
                ),
              ),
            ),
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        hoverColor: isDestructive
            ? AppColors.error.withOpacity(0.08)
            : AppColors.lightGreen.withOpacity(0.15),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: _isCollapsed ? 0 : 12,
            vertical: 10,
          ),
          child: Row(
            mainAxisAlignment:
                _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: isDestructive
                    ? AppColors.error.withOpacity(0.7)
                    : AppColors.darkGreen.withOpacity(0.4),
                size: 18,
              ),
              if (!_isCollapsed) ...[
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: isDestructive
                          ? AppColors.error.withOpacity(0.7)
                          : AppColors.darkGreen.withOpacity(0.5),
                      fontSize: 13,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
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