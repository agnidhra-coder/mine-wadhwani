import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/core/theme/app_text_styles.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';

@RoutePage()
class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final user =
            state is AdminAuthenticated ? state.user : null;

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text('Admin Dashboard'),
            actions: [
              if (user != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      user.role.replaceAll('_', ' '),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Logout',
                onPressed: () {
                  context.read<AuthBloc>().add(const AuthLogoutRequested());
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome, ${user?.name ?? 'Admin'}!',
                  style: AppTextStyles.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Manage your mining operations from here.',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 48),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 24,
                    crossAxisSpacing: 24,
                    childAspectRatio: 1.6,
                    children: [
                      _DashboardCard(
                        icon: Icons.people_outlined,
                        title: 'Users',
                        subtitle: 'Manage user accounts',
                        onTap: () => context.router
                            .push(const AdminUsersRoute()),
                      ),
                      const _DashboardCard(
                        icon: Icons.checklist,
                        title: 'Checklists',
                        subtitle: 'View compliance reports',
                      ),
                      _DashboardCard(
                        icon: Icons.warning_amber,
                        title: 'Hazards',
                        subtitle: 'Manage hazard database',
                      ),
                      _DashboardCard(
                        icon: Icons.terrain_rounded,
                        title: 'Mines',
                        subtitle: 'Manage mine sites',
                      ),
                      _DashboardCard(
                        icon: Icons.analytics_outlined,
                        title: 'Reports',
                        subtitle: 'View analytics & reports',
                        onTap: () => context.router
                            .push(const AdminReportsRoute()),
                      ),
                      _DashboardCard(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        subtitle: 'System configuration',
                      ),
                    ],
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

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap ?? () {},
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 16),
              Text(title, style: AppTextStyles.titleLarge),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
