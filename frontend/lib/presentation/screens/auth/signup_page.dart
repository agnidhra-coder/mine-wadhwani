// import 'package:auto_route/auto_route.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mine_wadhwani/core/constants/app_constants.dart';
// import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
// import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
// import 'package:mine_wadhwani/core/widgets/custom_text_field.dart';
// import 'package:mine_wadhwani/core/widgets/primary_button.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_event.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';
// import 'package:mine_wadhwani/presentation/common/auth_form_card.dart';
// import 'package:mine_wadhwani/presentation/common/auth_header.dart';

// @RoutePage()
// class SignupPage extends StatefulWidget {
//   const SignupPage({super.key});

//   @override
//   State<SignupPage> createState() => _SignupPageState();
// }

// class _SignupPageState extends State<SignupPage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _mobileController = TextEditingController();
//   final _passwordController = TextEditingController();
//   final _confirmPasswordController = TextEditingController();
//   bool _obscurePassword = true;
//   bool _obscureConfirmPassword = true;
//   String? _selectedRole;

//   final List<String> _roles = [
//     'Mine Manager',
//     'Assistant Mine Manager',
//     'Project Officer',
//     'Mine Foreman',
//     'Overman',
//     'Mining Sirdar',
//     'Other',
//   ];

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _mobileController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     super.dispose();
//   }

//   void _onRegister() {
//     if (_formKey.currentState?.validate() ?? false) {
//       if (_selectedRole == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: const Text('Please select a role'),
//             backgroundColor: Theme.of(context).colorScheme.error,
//           ),
//         );
//         return;
//       }
//       context.read<AuthBloc>().add(
//             AuthRegisterRequested(
//               name: _nameController.text.trim(),
//               email: _emailController.text.trim(),
//               password: _passwordController.text,
//               mobilenumber: _mobileController.text.trim(),
//               mine_role: _selectedRole!,
//             ),
//           );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: BlocConsumer<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is AuthError) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 content: Text(state.message),
//                 backgroundColor: Theme.of(context).colorScheme.error,
//               ),
//             );
//           } else if (state is Authenticated) {
//             context.router.replaceAll([const HomeRoute()]);
//           }
//         },
//         builder: (context, state) {
//           final isLoading = state is AuthLoading;

//           return Row(
//             children: [
//               // Left branding panel
//               const Expanded(flex: 3, child: AuthHeader()),

//               // Right form panel
//               Expanded(
//                 flex: 2,
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(vertical: 48),
//                   child: AuthFormCard(
//                     child: Form(
//                       key: _formKey,
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Text(
//                             'Create Account',
//                             style: AppTextStyles.headlineLarge,
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Fill in your details to get started',
//                             style: AppTextStyles.bodyMedium.copyWith(
//                               color: Colors.grey[600],
//                             ),
//                             textAlign: TextAlign.center,
//                           ),
//                           const SizedBox(height: 40),
//                           CustomTextField(
//                             label: 'Full Name',
//                             hint: 'Enter your full name',
//                             controller: _nameController,
//                             prefixIcon: const Icon(Icons.person_outlined),
//                             validator: (value) {
//                               if (value == null || value.trim().isEmpty) {
//                                 return 'Name is required';
//                               }
//                               if (value.trim().length < 2) {
//                                 return 'Name must be at least 2 characters';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           CustomTextField(
//                             label: 'Email',
//                             hint: 'Enter your email',
//                             controller: _emailController,
//                             keyboardType: TextInputType.emailAddress,
//                             prefixIcon: const Icon(Icons.email_outlined),
//                             validator: (value) {
//                               if (value == null || value.trim().isEmpty) {
//                                 return 'Email is required';
//                               }
//                               if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
//                                   .hasMatch(value.trim())) {
//                                 return 'Enter a valid email';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           CustomTextField(
//                             label: 'Mobile Number',
//                             hint: 'Enter your mobile number',
//                             controller: _mobileController,
//                             keyboardType: TextInputType.phone,
//                             prefixIcon: const Icon(Icons.phone_outlined),
//                             validator: (value) {
//                               if (value == null || value.trim().isEmpty) {
//                                 return 'Mobile number is required';
//                               }
//                               if (value.trim().length < 10) {
//                                 return 'Enter a valid mobile number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           DropdownButtonFormField<String>(
//                             decoration: InputDecoration(
//                               labelText: 'Role',
//                               hintText: 'Select your role',
//                               prefixIcon: const Icon(Icons.assignment_ind_outlined),
//                               border: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               enabledBorder: OutlineInputBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                                 borderSide: BorderSide(
//                                   color: Colors.grey[300]!,
//                                 ),
//                               ),
//                             ),
//                             value: _selectedRole,
//                             items: _roles.map((role) {
//                               return DropdownMenuItem<String>(
//                                 value: role,
//                                 child: Text(role),
//                               );
//                             }).toList(),
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedRole = value;
//                               });
//                             },
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please select a role';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           CustomTextField(
//                             label: 'Password',
//                             hint: 'Create a password',
//                             controller: _passwordController,
//                             obscureText: _obscurePassword,
//                             prefixIcon: const Icon(Icons.lock_outlined),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscurePassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.visibility_outlined,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscurePassword = !_obscurePassword;
//                                 });
//                               },
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Password is required';
//                               }
//                               if (value.length <
//                                   AppConstants.minPasswordLength) {
//                                 return 'Password must be at least ${AppConstants.minPasswordLength} characters';
//                               }
//                               if (!RegExp(r'[A-Z]').hasMatch(value)) {
//                                 return 'Password must contain at least one uppercase letter';
//                               }
//                               if (!RegExp(r'[0-9]').hasMatch(value)) {
//                                 return 'Password must contain at least one number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                           CustomTextField(
//                             label: 'Confirm Password',
//                             hint: 'Re-enter your password',
//                             controller: _confirmPasswordController,
//                             obscureText: _obscureConfirmPassword,
//                             prefixIcon: const Icon(Icons.lock_outlined),
//                             suffixIcon: IconButton(
//                               icon: Icon(
//                                 _obscureConfirmPassword
//                                     ? Icons.visibility_off_outlined
//                                     : Icons.visibility_outlined,
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _obscureConfirmPassword =
//                                       !_obscureConfirmPassword;
//                                 });
//                               },
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please confirm your password';
//                               }
//                               if (value != _passwordController.text) {
//                                 return 'Passwords do not match';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 32),
//                           Center(
//                             child: PrimaryButton(
//                               label: 'Create Account',
//                               isLoading: isLoading,
//                               onPressed: _onRegister,
//                               minWidth: double.infinity,
//                             ),
//                           ),
//                           const SizedBox(height: 24),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 'Already have an account? ',
//                                 style: AppTextStyles.bodyMedium,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   context.router.maybePop();
//                                 },
//                                 child: Text(
//                                   'Log In',
//                                   style: AppTextStyles.labelLarge.copyWith(
//                                     color:
//                                         Theme.of(context).colorScheme.primary,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/constants/app_constants.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';

@RoutePage()
class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _selectedRole;

  final List<String> _roles = [
    'Mine Manager',
    'Assistant Mine Manager',
    'Project Officer',
    'Mine Foreman',
    'Overman',
    'Mining Sirdar',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedRole == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please select a role'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(
            AuthRegisterRequested(
              name: _nameController.text.trim(),
              email: _emailController.text.trim(),
              password: _passwordController.text,
              mobilenumber: _mobileController.text.trim(),
              mine_role: _selectedRole!,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          } else if (state is Authenticated) {
            context.router.replaceAll([const HomeRoute()]);
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return isWide
              ? _buildWideLayout(isLoading)
              : _buildNarrowLayout(isLoading);
        },
      ),
    );
  }

  // ── Wide layout (tablet/desktop): left panel + right form ──
  Widget _buildWideLayout(bool isLoading) {
    return Row(
      children: [
        // Left branding panel
        Expanded(
          flex: 5,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A4A8A),
                  Color(0xFF2563A8),
                  Color(0xFF1E7BC4),
                ],
              ),
            ),
            child: Stack(
              children: [
                Positioned.fill(child: CustomPaint(painter: _GridPainter())),
                Padding(
                  padding: const EdgeInsets.all(48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/app_trans_icon.png',
                            width: 48,
                            height: 48,
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'AIMSURE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 4,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Text(
                        'Join the Future\nof Mine Safety.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Create your account and start monitoring\nyour mine sites with AI-powered insights.',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48),
                      Row(
                        children: [
                          _buildStat('99.9%', 'Uptime'),
                          const SizedBox(width: 40),
                          _buildStat('500+', 'Mine Sites'),
                          const SizedBox(width: 40),
                          _buildStat('24/7', 'Monitoring'),
                        ],
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Right form panel
        Expanded(
          flex: 4,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: _buildForm(isLoading),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Narrow layout (mobile): top banner + form ──
  Widget _buildNarrowLayout(bool isLoading) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 40),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1A4A8A), Color(0xFF2563A8)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Image.asset(
                      'assets/images/app_icon.png',
                      width: 40,
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'AIMSURE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 4,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Text(
                  'Join the Future\nof Mine Safety.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildForm(isLoading),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(bool isLoading) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF0F1F3D),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Fill in your details to get started',
            style: TextStyle(fontSize: 14, color: Color(0xFF6B7A99)),
          ),
          const SizedBox(height: 32),

          // Full Name
          _buildLabel('Full Name'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _nameController,
            hint: 'John Doe',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Name is required';
              }
              if (value.trim().length < 2) {
                return 'Name must be at least 2 characters';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Email
          _buildLabel('Email Address'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _emailController,
            hint: 'you@company.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
                return 'Enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Mobile
          _buildLabel('Mobile Number'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _mobileController,
            hint: '+91 00000 00000',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Mobile number is required';
              }
              if (value.trim().length < 10) {
                return 'Enter a valid mobile number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Role dropdown
          _buildLabel('Role'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _selectedRole,
            decoration: InputDecoration(
              hintText: 'Select your role',
              hintStyle:
                  const TextStyle(color: Color(0xFFB0BAD0), fontSize: 14),
              prefixIcon: const Icon(
                Icons.assignment_ind_outlined,
                color: Color(0xFF6B7A99),
                size: 20,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFDDE3EF)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFDDE3EF)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide:
                    const BorderSide(color: Color(0xFF2563A8), width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            style: const TextStyle(fontSize: 14, color: Color(0xFF0F1F3D)),
            items: _roles.map((role) {
              return DropdownMenuItem<String>(
                value: role,
                child: Text(role),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedRole = value),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a role';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Password
          _buildLabel('Password'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _passwordController,
            hint: '••••••••',
            icon: Icons.lock_outline,
            obscure: _obscurePassword,
            suffix: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF6B7A99),
                size: 20,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < AppConstants.minPasswordLength) {
                return 'Password must be at least ${AppConstants.minPasswordLength} characters';
              }
              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                return 'Password must contain at least one uppercase letter';
              }
              if (!RegExp(r'[0-9]').hasMatch(value)) {
                return 'Password must contain at least one number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // Confirm Password
          _buildLabel('Confirm Password'),
          const SizedBox(height: 8),
          _buildTextField(
            controller: _confirmPasswordController,
            hint: '••••••••',
            icon: Icons.lock_outline,
            obscure: _obscureConfirmPassword,
            suffix: IconButton(
              icon: Icon(
                _obscureConfirmPassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF6B7A99),
                size: 20,
              ),
              onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Create Account button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: isLoading ? null : _onRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563A8),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Divider
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFDDE3EF))),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  'or',
                  style: TextStyle(color: Colors.grey[400], fontSize: 13),
                ),
              ),
              const Expanded(child: Divider(color: Color(0xFFDDE3EF))),
            ],
          ),
          const SizedBox(height: 24),

          // Back to Sign In button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () => context.router.maybePop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2563A8),
                side: const BorderSide(color: Color(0xFF2563A8), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Back to Sign In',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 32),

          Center(
            child: Text(
              '© 2026 AIMSURE. All rights reserved.',
              style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Color(0xFF0F1F3D),
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(fontSize: 14, color: Color(0xFF0F1F3D)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFFB0BAD0), fontSize: 14),
        prefixIcon: Icon(icon, color: const Color(0xFF6B7A99), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE3EF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFDDE3EF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF2563A8), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white60, fontSize: 12),
        ),
      ],
    );
  }
}

// Subtle grid background painter for left panel
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 1;

    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}