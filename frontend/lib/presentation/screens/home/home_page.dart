import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final userName =
            state is Authenticated ? state.user.name : 'User';

        return Scaffold(
          appBar: AppBar(
            title: const Text('Wadhwani'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome, $userName!',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  'You are logged in successfully.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
