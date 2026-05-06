import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../users/presentation/pages/dashboard/admin_dashboard_page.dart';
import '../blocs/auth_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginSubmitted(
              username: _usernameController.text.trim(),
              password: _passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBg,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // ← Arahkan ke AdminDashboardPage, bukan HomePage
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AdminDashboardPage(user: state.user),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildLoginCard(state),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.mediumGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.lock_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 20),
        const Text(
          'Selamat Datang!',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkBg),
        ),
        const SizedBox(height: 8),
        const Text(
          'Masuk untuk melanjutkan',
          style: TextStyle(fontSize: 15, color: Color(0xFF64748B)),
        ),
      ],
    );
  }

  Widget _buildLoginCard(AuthState state) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Username'),
            const SizedBox(height: 8),
            _buildUsernameField(),
            const SizedBox(height: 20),
            _buildLabel('Password'),
            const SizedBox(height: 8),
            _buildPasswordField(),
            const SizedBox(height: 28),
            _buildLoginButton(state),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.darkGreen,
      ),
    );
  }

  Widget _buildUsernameField() {
    return TextFormField(
      controller: _usernameController,
      decoration: InputDecoration(
        hintText: 'nama pengguna',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: const Icon(Icons.person_outlined, color: AppColors.primary),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Username tidak boleh kosong';
        if (value.length < 3) return 'Username minimal 3 karakter';
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        hintText: '••••••••',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
            color: Colors.grey.shade500,
          ),
          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Password tidak boleh kosong';
        if (value.length < 6) return 'Password minimal 6 karakter';
        return null;
      },
    );
  }

  Widget _buildLoginButton(AuthState state) {
    final isLoading = state is AuthLoading;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : _onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppStyles.borderRadius),
          ),
          elevation: isLoading ? 0 : 4,
          shadowColor: AppColors.primary.withOpacity(0.4),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
              )
            : const Text(
                'Masuk',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5),
              ),
      ),
    );
  }
}
