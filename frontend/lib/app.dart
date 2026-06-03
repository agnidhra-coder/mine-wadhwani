// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mine_wadhwani/core/constants/app_constants.dart';
// import 'package:mine_wadhwani/core/di/injection_container.dart';
// import 'package:mine_wadhwani/core/routing/app_router.dart';
// import 'package:mine_wadhwani/core/routing/auth_guard.dart';
// import 'package:mine_wadhwani/core/theme/app_theme.dart';
// import 'package:mine_wadhwani/data/datasources/auth/auth_local_datasource.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_event.dart';
// import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';
// import 'package:mine_wadhwani/core/routing/app_router.gr.dart';

// class App extends StatefulWidget {
//   const App({super.key});

//   @override
//   State<App> createState() => _AppState();
// }

// class _AppState extends State<App> {
//   late final AppRouter _appRouter;

//   @override
//   void initState() {
//     super.initState();
//     _appRouter = AppRouter(
//       authGuard: AuthGuard(localDataSource: sl<AuthLocalDataSource>()),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
//       child: BlocListener<AuthBloc, AuthState>(
//         listener: (context, state) {
//           if (state is Unauthenticated) {
//             _appRouter.replaceAll([const LoginRoute()]);
//           }
//         },
//         child: MaterialApp.router(
//           title: AppConstants.appName,
//           theme: AppTheme.lightTheme,
//           debugShowCheckedModeBanner: false,
//           routerConfig: _appRouter.config(),
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mine_wadhwani/core/constants/app_constants.dart';
import 'package:mine_wadhwani/core/di/injection_container.dart';
import 'package:mine_wadhwani/core/routing/app_router.dart';
import 'package:mine_wadhwani/core/routing/auth_guard.dart';
import 'package:mine_wadhwani/core/theme/app_theme.dart';
import 'package:mine_wadhwani/data/datasources/auth/auth_local_datasource.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_event.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_state.dart';
import 'package:mine_wadhwani/presentation/bloc/draft_bloc/draft_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/draft_bloc/draft_event.dart';
import 'package:mine_wadhwani/core/routing/app_router.gr.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _appRouter = AppRouter(
      authGuard: AuthGuard(localDataSource: sl<AuthLocalDataSource>()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthBloc>()..add(const AuthCheckRequested()),
        ),
        // DraftBloc is provided at the root so it's accessible from
        // HomePage, StockpileOverviewPage, and PendingInspectionsScreen
        // without needing to pass it down manually.
        BlocProvider(
          create: (_) => sl<DraftBloc>()..add(const LoadDrafts()),
        ),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Unauthenticated) {
            _appRouter.replaceAll([const LoginRoute()]);
          }
        },
        child: MaterialApp.router(
          title: AppConstants.appName,
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }
}