// lib/core/di/injection_container.dart
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rescufy/core/network/endpoints/api_endpoints.dart';
import 'package:rescufy/core/services/location_service.dart';
import 'package:rescufy/core/services/signalr/ambulance_signalr_service.dart';
import 'package:rescufy/core/services/signalr/notification_signalr_service.dart';
import 'package:rescufy/core/services/signalr/signalr_hub_connection_factory.dart';
import 'package:rescufy/data/datasources/local/medical_local_data_source.dart';
import 'package:rescufy/data/datasources/local/profile_local_datasource.dart';
import 'package:rescufy/data/datasources/remote/medical_remote_data_source.dart';
import 'package:rescufy/data/datasources/remote/paramedic_emergency_remote_datasource.dart';
import 'package:rescufy/data/datasources/remote/paramedic_profile_remote_datasource.dart';
import 'package:rescufy/data/datasources/remote/profile_remote_datasource.dart';
import 'package:rescufy/data/datasources/remote/hospital_remote_datasource.dart';
import 'package:rescufy/data/datasources/remote/request_history_remote_datasource.dart';
import 'package:rescufy/data/models/medical_profile/allergy_model.dart';
import 'package:rescufy/data/models/medical_profile/chronic_disease_model.dart';
import 'package:rescufy/data/models/medical_profile/emergency_contact_model.dart';
import 'package:rescufy/data/models/medical_profile/medication_model.dart';
import 'package:rescufy/data/models/medical_profile/past_surgery_model.dart';
import 'package:rescufy/data/models/medical_profile/profile_model.dart';
import 'package:rescufy/data/repositories/hospital_repository_impl.dart';
import 'package:rescufy/data/repositories/medical_repository.dart';
import 'package:rescufy/data/repositories/paramedic_emergency_repository_impl.dart';
import 'package:rescufy/data/repositories/paramedic_profile_repository_impl.dart';
import 'package:rescufy/data/repositories/profile_repository_impl.dart';
import 'package:rescufy/data/repositories/request_history_repository_impl.dart';
import 'package:rescufy/domain/repositories/hospital_repository.dart';
import 'package:rescufy/domain/repositories/paramedic_emergency_repository.dart';
import 'package:rescufy/domain/repositories/paramedic_profile_repository.dart';
import 'package:rescufy/domain/usecases/get_nearby_hospitals_usecase.dart';
import 'package:rescufy/domain/repositories/profile_repository.dart';
import 'package:rescufy/domain/repositories/request_history_repository.dart';
import 'package:rescufy/presentation/paramedic/active_case/cubit/active_case_cubit.dart';
import 'package:rescufy/presentation/paramedic/dashboard/cubit/dashboard_cubit.dart';
import 'package:rescufy/presentation/paramedic/incoming_request/cubit/incoming_request_cubit.dart';
import 'package:rescufy/presentation/paramedic/profile/cubit/paramedic_profile_cubit.dart';
import 'package:rescufy/presentation/user/history/cubit/request_history_cubit.dart';
import 'package:rescufy/presentation/user/hospitals/cubit/hospitals_cubit.dart';
import 'package:rescufy/presentation/user/profile/cubit/profile_cubit.dart';
import 'package:rescufy/presentation/user/request/cubit/emergency_request_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Core
import 'package:rescufy/core/network/dio_client.dart';
import 'package:rescufy/core/network/auth_interceptor.dart';

// Data
import 'package:rescufy/data/datasources/remote/auth_remote_datasource.dart';
import 'package:rescufy/data/datasources/local/auth_local_datasource.dart';
import 'package:rescufy/data/repositories/auth_repository_impl.dart';
import 'package:rescufy/data/datasources/remote/emergency_remote_datasource.dart'
    as user_ds;

// Domain
import 'package:rescufy/domain/repositories/auth_repository.dart';
import 'package:rescufy/domain/entities/incoming_request.dart';

// Presentation (Cubits)
import 'package:rescufy/presentation/auth/cubit/auth/auth_cubit.dart';
import 'package:rescufy/presentation/auth/cubit/login/login_cubit.dart';
import 'package:rescufy/presentation/auth/cubit/register/register_cubit.dart';
import 'package:rescufy/presentation/auth/cubit/forgot_password/forgot_password_cubit.dart';
import 'package:rescufy/presentation/auth/cubit/reset_password/reset_password_cubit.dart';
import 'package:rescufy/core/cubit/theme/theme_cubit.dart';
import 'package:rescufy/core/cubit/locale/locale_cubit.dart';

import '../../presentation/auth/cubit/verify_reset_otp/verify_reset_otp_cubit.dart';

import 'package:rescufy/data/repositories/emergency_repository_impl.dart';
import 'package:rescufy/domain/repositories/emergency_repository.dart';

final sl = GetIt.instance;
Future<void>? _initFuture;
bool _initialized = false;

Future<void> init() {
  if (_initialized) {
    return Future.value();
  }

  return _initFuture ??= _init().catchError((
    Object error,
    StackTrace stackTrace,
  ) async {
    _initFuture = null;
    if (!_initialized) {
      await sl.reset();
    }
    Error.throwWithStackTrace(error, stackTrace);
  });
}

Future<void> _init() async {
  // =============================
  // External
  // =============================
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(ProfileModelAdapter().typeId)) {
    Hive.registerAdapter(ProfileModelAdapter());
  }
  if (!Hive.isAdapterRegistered(MedicationModelAdapter().typeId)) {
    Hive.registerAdapter(MedicationModelAdapter());
  }
  if (!Hive.isAdapterRegistered(AllergyModelAdapter().typeId)) {
    Hive.registerAdapter(AllergyModelAdapter());
  }
  if (!Hive.isAdapterRegistered(ChronicDiseaseModelAdapter().typeId)) {
    Hive.registerAdapter(ChronicDiseaseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(EmergencyContactModelAdapter().typeId)) {
    Hive.registerAdapter(EmergencyContactModelAdapter());
  }
  if (!Hive.isAdapterRegistered(PastSurgeryModelAdapter().typeId)) {
    Hive.registerAdapter(PastSurgeryModelAdapter());
  }
  final userBox = await Hive.openBox<ProfileModel>('user_box');
  final medicationsBox = await Hive.openBox<MedicationModel>('medications');
  final allergiesBox = await Hive.openBox<AllergyModel>('allergies');
  final chronicDiseasesBox = await Hive.openBox<ChronicDiseaseModel>(
    'chronicDiseases',
  );
  final emergencyContactsBox = await Hive.openBox<EmergencyContactModel>(
    'emergencyContacts',
  );
  final pastSurgeriesBox = await Hive.openBox<PastSurgeryModel>(
    'pastSurgeries',
  );
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<Box<ProfileModel>>(() => userBox);
  sl.registerLazySingleton<Box<MedicationModel>>(() => medicationsBox);
  sl.registerLazySingleton<Box<AllergyModel>>(() => allergiesBox);
  sl.registerLazySingleton<Box<ChronicDiseaseModel>>(() => chronicDiseasesBox);
  sl.registerLazySingleton<Box<EmergencyContactModel>>(
    () => emergencyContactsBox,
  );
  sl.registerLazySingleton<Box<PastSurgeryModel>>(() => pastSurgeriesBox);
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => const FlutterSecureStorage());
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => AuthInterceptor(sl()));
  sl.registerLazySingleton(() => DioClient(sl(), sl()));
  sl.registerLazySingleton(() => LocationService());

  // =============================
  // SignalR
  // =============================
  sl.registerLazySingleton(() => SignalRHubConnectionFactory(sl()));
  sl.registerLazySingleton(
    () => NotificationSignalRService(
      connectionFactory: sl(),
      hubUrl: ApiEndpoints.notificationHubUrl,
    ),
  );
  sl.registerLazySingleton(
    () => AmbulanceSignalRService(
      connectionFactory: sl(),
      hubUrl: ApiEndpoints.ambulanceHubUrl,
    ),
  );

  // =============================
  // Data sources
  // =============================
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileLocalDataSource>(
    () => ProfileLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(
    () => MedicalLocalDataSource(
      medicationsBox: sl(),
      allergiesBox: sl(),
      chronicDiseasesBox: sl(),
      emergencyContactsBox: sl(),
      pastSurgeriesBox: sl(),
    ),
  );
  sl.registerLazySingleton<user_ds.EmergencyRemoteDataSource>(
    () => user_ds.EmergencyRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton(() => MedicalRemoteDataSource(sl()));
  sl.registerLazySingleton<HospitalRemoteDataSource>(
    () => HospitalRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<RequestHistoryRemoteDataSource>(
    () => RequestHistoryRemoteDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<ParamedicProfileRemoteDataSource>(
    () => ParamedicProfileRemoteDataSourceImpl(sl()),
  );

  sl.registerLazySingleton<ParamedicEmergencyRemoteDataSource>(
    () => EmergencyRemoteDataSourceImpl(sl()),
  );

  // =============================
  // Repository
  // =============================
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(sl(), sl()),
  );
  sl.registerLazySingleton(() => MedicalRepository(sl(), sl()));
  sl.registerLazySingleton<EmergencyRepository>(
    () => EmergencyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<HospitalRepository>(
    () => HospitalRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<RequestHistoryRepository>(
    () => RequestHistoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ParamedicProfileRepository>(
    () => ParamedicProfileRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ParamedicEmergencyRepository>(
    () => ParamedicEmergencyRepositoryImpl(remoteDataSource: sl()),
  );

  // =============================
  // Global Cubits (Singleton)
  // =============================
  sl.registerLazySingleton(() => ThemeCubit());
  sl.registerLazySingleton(() => LocaleCubit(sl()));
  sl.registerLazySingleton(() => AuthCubit(authRepository: sl()));
  sl.registerLazySingleton(() => GetNearbyHospitalsUseCase(sl()));

  // =============================
  // Cubits (FACTORY — one per route)
  // =============================
  sl.registerFactory(() => LoginCubit());
  sl.registerFactory(() => RegisterCubit(sl()));
  sl.registerFactory(() => ForgotPasswordCubit(sl<AuthRepository>()));
  sl.registerFactory(() => VerifyResetOtpCubit(sl<AuthRepository>()));
  sl.registerFactory(() => ResetPasswordCubit(sl<AuthRepository>()));
  sl.registerFactory(() => ProfileCubit(sl(), sl(), sl(), sl(), sl()));
  sl.registerFactory(() => EmergencyRequestCubit(sl(), sl()));
  sl.registerFactory(() => HospitalsCubit(sl(), sl()));
  sl.registerFactory(() => RequestHistoryCubit(sl()));

  // Paramedic Cubits
  sl.registerFactory(
    () => DashboardCubit(
      notificationSignalRService: sl(),
      paramedicEmergencyRepository: sl(),
    ),
  );
  sl.registerFactory(() => ParamedicProfileCubit(sl(), sl()));
  sl.registerFactoryParam<IncomingRequestCubit, IncomingRequest, void>(
    (request, _) => IncomingRequestCubit(
      request: request,
      ambulanceSignalRService: sl(),
      notificationSignalRService: sl(),
    ),
  );
  sl.registerFactoryParam<ActiveCaseCubit, IncomingRequest, void>(
    (request, _) => ActiveCaseCubit(
      request: request,
      notificationSignalRService: sl(),
      ambulanceSignalRService: sl(),
      locationService: sl(),
    ),
  );

  _initialized = true;
}
