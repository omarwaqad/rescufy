// lib/injection_container.dart
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/data/datasources/auth_remote_datasource.dart';
import 'package:rescufy/data/repositories/auth_remote_impl.dart';
import 'package:rescufy/domain/repositories/auth_repository.dart';
import 'package:rescufy/domain/usecases/login_usecase.dart';
import 'package:rescufy/domain/usecases/register_usecase.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => DioClient(sl()));

  // UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));

  // Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  // DataSources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
}
