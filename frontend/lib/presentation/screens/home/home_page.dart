import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
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
            automaticallyImplyLeading: false,
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
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () {
                    context.router.push(const ChecklistRoute());
                  },
                  icon: const Icon(Icons.checklist),
                  label: const Text('Start Compliance Checklist'),
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {
                    context.router.push(const HazardDatabaseRoute());
                  },
                  icon: const Icon(Icons.warning_amber),
                  label: const Text('Hazard Database'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
