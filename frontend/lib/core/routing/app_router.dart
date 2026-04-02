import 'package:auto_route/auto_route.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/core/routing/auth_guard.dart';
import '../../presentation/screens/datacollection/Mine_selection.dart';
import '../../presentation/screens/datacollection/Shift_selection.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  final AuthGuard authGuard;

  AppRouter({required this.authGuard});

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: LoginRoute.page, path: '/login'),
    AutoRoute(page: SignupRoute.page, path: '/signup'),
    AutoRoute(
      page: HomeRoute.page,
      path: '/',
      initial: true,
      guards: [authGuard],
    ),
    AutoRoute(
      page: MineSelectionRoute.page,
      path: '/mine-selection',
    ),
    AutoRoute(
      page: ShiftSelectionRoute.page,
      path: '/shift-selection',
    ),
  ];

  @override
  List<AutoRouteGuard> get guards => [];
}
