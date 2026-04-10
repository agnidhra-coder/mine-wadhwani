import 'package:auto_route/auto_route.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';
import 'package:mine_wadhwani/core/routing/auth_guard.dart';

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
          guards: [authGuard],
        ),
        AutoRoute(
          page: ShiftSelectionRoute.page,
          path: '/shift-selection',
          guards: [authGuard],
        ),
        AutoRoute(
          page: ChecklistOverviewRoute.page,
          path: '/checklist-overview',
          guards: [authGuard],
        ),
        AutoRoute(
          page: ChecklistRoute.page,
          path: '/checklist',
          guards: [authGuard],
        ),
        AutoRoute(
          page: StockpileOverviewRoute.page,
          path: '/stockpile-overview',
          guards: [authGuard],
        ),
        AutoRoute(
          page: HazardDatabaseRoute.page,
          path: '/hazard-database',
          guards: [authGuard],
        ),
      ];

  @override
  List<AutoRouteGuard> get guards => [];
}
