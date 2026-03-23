import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/core/theme/app_colors.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/core/widgets/custom_text_field.dart';
import 'package:mine_wadhwani/core/widgets/primary_button.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';

@RoutePage()
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _usernameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _obscurePassword = true;
  String? _usernameError;
  String? _passwordError;

  @override
  void initState() {
    super.initState();
    _usernameFocus.addListener(() {
      if (!_usernameFocus.hasFocus && _usernameError != null) {
        setState(() => _usernameError = null);
      }
    });
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus && _passwordError != null) {
        setState(() => _passwordError = null);
      }
    });
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _usernameFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  void _onAdminLogin() {
    setState(() {
      _usernameError = null;
      _passwordError = null;
    });
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
            AdminLoginRequested(
              username: _usernameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            _passwordController.clear();
            final msg = state.message.toLowerCase();
            if (msg.contains('not exist') || msg.contains('not found')) {
              setState(() => _usernameError = state.message);
            } else if (msg.contains('invalid password')) {
              setState(() => _passwordError = state.message);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
          } else if (state is AdminAuthenticated) {
            context.router.replaceAll([const AdminDashboardRoute()]);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Row(
            children: [
              // Left branding panel
              Expanded(
                flex: 3,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Icon(
                            Icons.admin_panel_settings,
                            size: 80,
                            color:
                                AppColors.onPrimary.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Wadhwani Admin',
                          style: AppTextStyles.headlineLarge.copyWith(
                            color: AppColors.onPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Mining Management System',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.onPrimary
                                .withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Right form panel
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(48),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                const Icon(
                                  Icons.shield_outlined,
                                  size: 48,
                                  color: Color(0xFF1A1A2E),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Admin Portal',
                                  style: AppTextStyles.headlineLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Sign in with your admin credentials',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 40),
                                CustomTextField(
                                  label: 'Username',
                                  hint: 'Enter your email',
                                  controller: _usernameController,
                                  focusNode: _usernameFocus,
                                  keyboardType: TextInputType.emailAddress,
                                  prefixIcon:
                                      const Icon(Icons.person_outlined),
                                  errorText: _usernameError,
                                  validator: (value) {
                                    if (value == null ||
                                        value.trim().isEmpty) {
                                      return 'Username is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 24),
                                CustomTextField(
                                  label: 'Password',
                                  hint: 'Enter your password',
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  obscureText: _obscurePassword,
                                  prefixIcon:
                                      const Icon(Icons.lock_outlined),
                                  errorText: _passwordError,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _obscurePassword =
                                            !_obscurePassword;
                                      });
                                    },
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Password is required';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 32),
                                Center(
                                  child: PrimaryButton(
                                    label: 'Sign In as Admin',
                                    isLoading: isLoading,
                                    onPressed: _onAdminLogin,
                                    minWidth: double.infinity,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Not an admin? ',
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.router
                                            .push(const LoginRoute());
                                      },
                                      child: Text(
                                        'User Login',
                                        style: AppTextStyles.labelLarge
                                            .copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
