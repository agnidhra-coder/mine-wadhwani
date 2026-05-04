import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mine_wadhwani/core/network/api_client.dart';
import 'package:mine_wadhwani/data/datasources/auth/auth_local_datasource.dart';
import 'package:mine_wadhwani/data/datasources/auth/auth_remote_datasource.dart';
import 'package:mine_wadhwani/data/datasources/checklist/checklist_remote_datasource.dart';
import 'package:mine_wadhwani/data/repositories/auth_repository_impl.dart';
import 'package:mine_wadhwani/data/repositories/checklist_repository_impl.dart';
import 'package:mine_wadhwani/domain/repositories/auth_repository.dart';
import 'package:mine_wadhwani/domain/repositories/checklist_repository.dart';
import 'package:mine_wadhwani/domain/usecases/auth_usecases.dart';
import 'package:mine_wadhwani/domain/usecases/checklist_usecases.dart';
import 'package:mine_wadhwani/presentation/bloc/auth_bloc/auth_bloc.dart';
import 'package:mine_wadhwani/presentation/bloc/checklist_bloc/checklist_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ── External ───────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ── Core ───────────────────────────────────────────────
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sharedPreferences: sl()),
  );

  // ── Data Sources ───────────────────────────────────────
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ChecklistRemoteDataSource>(
    () => ChecklistRemoteDataSourceImpl(apiClient: sl()),
  );

  // ── Repositories ───────────────────────────────────────
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<ChecklistRepository>(
    () => ChecklistRepositoryImpl(remoteDataSource: sl()),
  );

  // ── Use Cases ──────────────────────────────────────────
  // Auth
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));

  // Checklist
  sl.registerLazySingleton(() => GetChecklistUseCase(sl()));
  sl.registerLazySingleton(() => SubmitChecklistUseCase(sl()));
  sl.registerLazySingleton(() => UploadMediaUseCase(sl()));
  sl.registerLazySingleton(() => GetSavedDataUseCase(sl()));

  // ── BLoC ───────────────────────────────────────────────
  sl.registerFactory(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      checkAuthUseCase: sl(),
      logoutUseCase: sl(),
      getCachedUserUseCase: sl(),
    ),
  );
  sl.registerFactory(
    () => ChecklistBloc(
      getChecklistUseCase: sl(),
      submitChecklistUseCase: sl(),
      uploadMediaUseCase: sl(),
      getSavedDataUseCase: sl(),
      sharedPreferences: sl(),
    ),
  );
}
