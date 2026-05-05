import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../constants/app_colors.dart';
import '../../models/api_user.dart';
import '../../blocs/users/users_bloc.dart';

class UsersPage extends StatefulWidget {
  final String token;
  const UsersPage({super.key, required this.token});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _roleFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ApiUser> _filterUsers(List<ApiUser> users) {
    return users.where((user) {
      final q = _searchQuery.toLowerCase();
      final matchesSearch = q.isEmpty ||
          user.username.toLowerCase().contains(q) ||
          user.email.toLowerCase().contains(q) ||
          (user.firstName ?? '').toLowerCase().contains(q) ||
          (user.lastName ?? '').toLowerCase().contains(q);
      final matchesRole =
          _roleFilter == 'All' || user.role?.toLowerCase() == _roleFilter.toLowerCase();
      return matchesSearch && matchesRole;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 14),
          _buildSearchAndFilter(),
          const SizedBox(height: 14),
          Expanded(child: _buildUsersContent()),
        ],
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Manage Users',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkBg),
              ),
              const SizedBox(height: 2),
              Text(
                'Kelola akun pengguna',
                style: TextStyle(fontSize: 12, color: AppColors.darkGreen.withOpacity(0.5)),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 38,
          child: ElevatedButton.icon(
            onPressed: () => _showUserFormDialog(null),
            icon: const Icon(Icons.add_rounded, size: 16),
            label: const Text('Tambah', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  // ── Search & Filter ─────────────────────────────────────────────────────────
  Widget _buildSearchAndFilter() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              controller: _searchController,
              onChanged: (v) => setState(() => _searchQuery = v),
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Cari user...',
                hintStyle: TextStyle(color: AppColors.darkGreen.withOpacity(0.35), fontSize: 13),
                prefixIcon: Icon(Icons.search_rounded, color: AppColors.darkGreen.withOpacity(0.4), size: 18),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.darkGreen.withOpacity(0.12)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.darkGreen.withOpacity(0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkGreen.withOpacity(0.12)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _roleFilter,
              isDense: true,
              icon: Icon(Icons.expand_more_rounded, color: AppColors.darkGreen.withOpacity(0.4), size: 18),
              style: const TextStyle(color: AppColors.darkBg, fontSize: 13),
              items: ['All', 'Admin', 'User']
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (v) => setState(() => _roleFilter = v ?? 'All'),
            ),
          ),
        ),
      ],
    );
  }

  // ── Users Content (BlocBuilder) ─────────────────────────────────────────────
  Widget _buildUsersContent() {
    return BlocBuilder<UsersBloc, UsersState>(
      builder: (context, state) {
        if (state.status == UsersStatus.loading && state.users.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        if (state.status == UsersStatus.failure && state.users.isEmpty) {
          return _buildErrorState(state.errorMessage ?? 'Terjadi kesalahan');
        }

        final filtered = _filterUsers(state.users);
        if (filtered.isEmpty) return _buildEmptyState();

        return Stack(
          children: [
            ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) => _buildUserCard(filtered[i]),
            ),
            if (state.status == UsersStatus.loading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.lightGreen.withOpacity(0.3),
                  minHeight: 2,
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline_rounded, size: 40, color: AppColors.error.withOpacity(0.6)),
          const SizedBox(height: 10),
          Text(message, style: TextStyle(color: AppColors.darkGreen.withOpacity(0.6), fontSize: 13)),
          const SizedBox(height: 14),
          OutlinedButton.icon(
            onPressed: () => context.read<UsersBloc>().add(UsersLoad(token: widget.token)),
            icon: const Icon(Icons.refresh_rounded, size: 16),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline_rounded, size: 40, color: AppColors.darkGreen.withOpacity(0.25)),
          const SizedBox(height: 10),
          Text(
            _searchQuery.isNotEmpty ? 'Tidak ditemukan' : 'Belum ada user',
            style: TextStyle(color: AppColors.darkGreen.withOpacity(0.5), fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── User Card (mobile-friendly) ─────────────────────────────────────────────
  Widget _buildUserCard(ApiUser user) {
    final initials = _getInitials(user);
    final displayName = _getDisplayName(user);
    final isActive = user.accountStatus?.toLowerCase() == 'active';
    final isAdmin = user.role?.toLowerCase() == 'admin';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.darkGreen.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () => _showUserFormDialog(user),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: avatar + name + actions
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.primary.withOpacity(0.12),
                      child: Text(
                        initials,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 13,
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
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user.email,
                            style: TextStyle(
                              color: AppColors.darkGreen.withOpacity(0.45),
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _actionButton(Icons.edit_outlined, AppColors.primary, () => _showUserFormDialog(user)),
                    const SizedBox(width: 6),
                    _actionButton(Icons.delete_outline_rounded, AppColors.error, () => _showDeleteDialog(user)),
                  ],
                ),
                const SizedBox(height: 10),
                // Bottom row: badges
                Row(
                  children: [
                    _badge(
                      isAdmin ? 'Admin' : 'User',
                      isAdmin ? AppColors.darkGreen : AppColors.primary,
                      isAdmin ? AppColors.darkGreen.withOpacity(0.1) : AppColors.primary.withOpacity(0.1),
                    ),
                    const SizedBox(width: 8),
                    _badge(
                      isActive ? 'Active' : 'Inactive',
                      isActive ? AppColors.darkGreen : AppColors.error,
                      isActive ? AppColors.success.withOpacity(0.4) : AppColors.error.withOpacity(0.1),
                      dotColor: isActive ? AppColors.primary : AppColors.error,
                    ),
                    if (user.plan != null && user.plan!.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      _badge(
                        user.plan!,
                        AppColors.darkGreen.withOpacity(0.6),
                        AppColors.lightBg,
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _actionButton(IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }

  Widget _badge(String text, Color textColor, Color bgColor, {Color? dotColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(width: 6, height: 6, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
            const SizedBox(width: 5),
          ],
          Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textColor)),
        ],
      ),
    );
  }

  // ── Form Dialog ─────────────────────────────────────────────────────────────
  void _showUserFormDialog(ApiUser? user) {
    final isEdit = user != null;
    final usernameCtrl = TextEditingController(text: user?.username ?? '');
    final emailCtrl = TextEditingController(text: user?.email ?? '');
    final passwordCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    final firstNameCtrl = TextEditingController(text: user?.firstName ?? '');
    final lastNameCtrl = TextEditingController(text: user?.lastName ?? '');
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final jobTitleCtrl = TextEditingController(text: user?.jobTitle ?? '');
    String selectedRole = user?.role ?? 'user';
    String selectedStatus = user?.accountStatus ?? 'active';
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.88,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.darkGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          isEdit ? Icons.edit_rounded : Icons.person_add_rounded,
                          color: AppColors.primary, size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEdit ? 'Edit User' : 'Tambah User',
                        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.darkBg),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () => Navigator.pop(ctx),
                        borderRadius: BorderRadius.circular(8),
                        child: Icon(Icons.close_rounded, color: AppColors.darkGreen.withOpacity(0.4)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Form fields
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Column(
                      children: [
                        _formField('Username', usernameCtrl, required: true),
                        const SizedBox(height: 12),
                        _formField('Email', emailCtrl, required: true, isEmail: true),
                        const SizedBox(height: 12),
                        _formField('Password', passwordCtrl, required: !isEdit, obscure: true),
                        const SizedBox(height: 12),
                        _formField('Konfirmasi Password', confirmCtrl, required: !isEdit, obscure: true, matchCtrl: passwordCtrl),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _formField('Nama Depan', firstNameCtrl)),
                            const SizedBox(width: 10),
                            Expanded(child: _formField('Nama Belakang', lastNameCtrl)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(child: _formField('Telepon', phoneCtrl)),
                            const SizedBox(width: 10),
                            Expanded(child: _formField('Jabatan', jobTitleCtrl)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _dropdownField('Role', selectedRole, ['admin', 'user'], (v) {
                                setSheetState(() => selectedRole = v!);
                              }),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _dropdownField('Status', selectedStatus, ['active', 'inactive'], (v) {
                                setSheetState(() => selectedStatus = v!);
                              }),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(ctx),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  side: BorderSide(color: AppColors.darkGreen.withOpacity(0.2)),
                                ),
                                child: const Text('Batal', style: TextStyle(color: AppColors.darkBg)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (!formKey.currentState!.validate()) return;
                                  final body = <String, dynamic>{
                                    'username': usernameCtrl.text.trim(),
                                    'email': emailCtrl.text.trim(),
                                    'role': selectedRole,
                                    'account_status': selectedStatus,
                                    'first_name': firstNameCtrl.text.trim(),
                                    'last_name': lastNameCtrl.text.trim(),
                                    'phone': phoneCtrl.text.trim(),
                                    'job_title': jobTitleCtrl.text.trim(),
                                  };
                                  if (passwordCtrl.text.isNotEmpty) {
                                    body['password'] = passwordCtrl.text;
                                    body['password_confirmation'] = confirmCtrl.text;
                                  }
                                  final bloc = context.read<UsersBloc>();
                                  if (isEdit) {
                                    bloc.add(UserUpdate(token: widget.token, id: user.id, body: body));
                                  } else {
                                    bloc.add(UserCreate(token: widget.token, body: body));
                                  }
                                  Navigator.pop(ctx);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  elevation: 0,
                                ),
                                child: Text(isEdit ? 'Simpan' : 'Buat User'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDeleteDialog(ApiUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 18),
            ),
            const SizedBox(width: 10),
            const Text('Hapus User', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          'Yakin ingin menghapus "${_getDisplayName(user)}"?',
          style: TextStyle(color: AppColors.darkGreen.withOpacity(0.6), fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: AppColors.darkBg)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<UsersBloc>().add(UserDelete(token: widget.token, id: user.id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // ── Form Helpers ────────────────────────────────────────────────────────────
  Widget _formField(
    String label,
    TextEditingController ctrl, {
    bool required = false,
    bool isEmail = false,
    bool obscure = false,
    TextEditingController? matchCtrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkGreen.withOpacity(0.7))),
        const SizedBox(height: 5),
        TextFormField(
          controller: ctrl,
          obscureText: obscure,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: TextStyle(color: AppColors.darkGreen.withOpacity(0.25), fontSize: 13),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.darkGreen.withOpacity(0.15)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.darkGreen.withOpacity(0.15)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            filled: true,
            fillColor: AppColors.lightBg,
          ),
          validator: (v) {
            if (required && (v == null || v.isEmpty)) return '$label wajib diisi';
            if (isEmail && v != null && v.isNotEmpty && !v.contains('@')) return 'Email tidak valid';
            if (matchCtrl != null && v != matchCtrl.text) return 'Password tidak cocok';
            return null;
          },
        ),
      ],
    );
  }

  Widget _dropdownField(String label, String value, List<String> items, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.darkGreen.withOpacity(0.7))),
        const SizedBox(height: 5),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: AppColors.lightBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.darkGreen.withOpacity(0.15)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: Icon(Icons.expand_more_rounded, color: AppColors.darkGreen.withOpacity(0.4), size: 18),
              style: const TextStyle(color: AppColors.darkBg, fontSize: 13),
              items: items.map((e) => DropdownMenuItem(
                value: e,
                child: Text(e[0].toUpperCase() + e.substring(1)),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  // ── Utils ───────────────────────────────────────────────────────────────────
  String _getInitials(ApiUser user) {
    if (user.firstName != null && user.lastName != null &&
        user.firstName!.isNotEmpty && user.lastName!.isNotEmpty) {
      return '${user.firstName![0]}${user.lastName![0]}'.toUpperCase();
    }
    return user.username.isNotEmpty ? user.username[0].toUpperCase() : '?';
  }

  String _getDisplayName(ApiUser user) {
    if (user.firstName != null && user.firstName!.isNotEmpty) {
      return '${user.firstName} ${user.lastName ?? ''}'.trim();
    }
    return user.username;
  }
}
