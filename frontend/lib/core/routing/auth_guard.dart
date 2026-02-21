import 'package:auto_route/auto_route.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/data/datasources/auth/auth_local_datasource.dart';

class AuthGuard extends AutoRouteGuard {
  final AuthLocalDataSource localDataSource;

  AuthGuard({required this.localDataSource});

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final hasToken = await localDataSource.hasToken();
    if (hasToken) {
      resolver.next(true);
    } else {
      resolver.redirect(const LoginRoute());
    }
  }
}
