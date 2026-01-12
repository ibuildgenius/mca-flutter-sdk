import 'package:get_it/get_it.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/claim_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/init_config_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/inspection_repo.dart';
import 'package:mca_official_flutter_sdk/src/utils/string_utils.dart';
import 'package:mca_official_flutter_sdk/src/data/api_config/local_cache.dart';
import 'package:mca_official_flutter_sdk/src/data/api_config/local_cache_impl.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/form_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/init_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/payment_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/product_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/user_repo.dart';
import 'package:mca_official_flutter_sdk/src/utils/secure_storage.dart';
import 'package:mca_official_flutter_sdk/src/utils/secure_storage_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

GetIt locator = GetIt.instance;

///Registers dependencies
Future<void> setupLocator() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  // locator.registerSingleton(sharedPreferences);
  if (!locator.isRegistered<SharedPreferences>()) {
    locator.registerSingleton(sharedPreferences);
  }

  // Local storage
  if (!locator.isRegistered<SecureStorage>()) {
    locator.registerLazySingleton<SecureStorage>(
      () => SecureStorageImpl(),
    );
  }

  // Navigation handler
  // if (!locator.isRegistered<NavigationHandler>()) {
  //   locator.registerLazySingleton<NavigationHandler>(
  //     () => NavigationHandlerImpl(),
  //   );
  // }

  // Init repository
  if (!locator.isRegistered<CustomerInitUIConfig>()) {
    locator.registerLazySingleton<CustomerInitUIConfig>(
          () => CustomerInitUIConfigImpl(),
    );
  }

  if (!locator.isRegistered<InitRepository>()) {
    locator.registerLazySingleton<InitRepository>(
          () => InitRepositoryImpl(
        cache: locator(),
        baseUrl: StringUtils.getBaseUrl(useV2Url: true),
      ),
    );
  }

  // User repository
  if (!locator.isRegistered<UserRepository>()) {
    locator.registerLazySingleton<UserRepository>(
      ({String? baseUrl}) => UserRepositoryImpl(
        cache: locator(),
        baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
      ),
    );
  }

  // Payment repository
  if (!locator.isRegistered<PaymentRepository>()) {
    locator.registerLazySingleton<PaymentRepository>(
      ({String? baseUrl}) => PaymentRepositoryImpl(
        cache: locator(),
        baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
      ),
    );
  }

  // Inspection repository
  if (!locator.isRegistered<InspectionRepository>()) {
    locator.registerLazySingleton<InspectionRepository>(
      ({String? baseUrl}) => InspectionRepositoryImpl(
        cache: locator(),
        baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
      ),
    );
  }

  // Claim repository
  if (!locator.isRegistered<ClaimRepository>()) {
    locator.registerLazySingleton<ClaimRepository>(
      ({String? baseUrl}) => ClaimRepositoryImpl(
        cache: locator(),
        baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
      ),
    );
  }

  // Form repository
  if (!locator.isRegistered<FormRepository>()) {
    locator.registerLazySingleton<FormRepository>(
      ({String? baseUrl}) => FormRepositoryImpl(
        cache: locator(),
        baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
      ),
    );
  }

  // Product repository
  if (!locator.isRegistered<ProductRepository>()) {
    locator.registerLazySingleton<ProductRepository>(
      ({String? baseUrl}) => ProductRepositoryImpl(
        cache: locator(),
        baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
      ),
    );
  }

  // Local cache
  if (!locator.isRegistered<LocalCache>()) {
    locator.registerLazySingleton<LocalCache>(
      () => LocalCacheImpl(
        sharedPreferences: locator(),
        storage: locator(),
      ),
    );
  }

  // //Local storage
  // locator.registerLazySingleton<SecureStorage>(
  //   () => SecureStorageImpl(),
  // );

  // // //Local storage
  // locator.registerLazySingleton<NavigationHandler>(
  //   () => NavigationHandlerImpl(),
  // );
  // locator.registerLazySingleton<InitRepository>(
  //   () => InitRepositoryImpl(
  //     cache: locator(),
  //     baseUrl: StringUtils.getBaseUrl(useV2Url: true),
  //   ),
  // );

  // locator.registerLazySingleton<UserRepository>(
  //   ({String? baseUrl}) => UserRepositoryImpl(
  //     cache: locator(),
  //     baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
  //   ),
  // );

  // locator.registerLazySingleton<PaymentRepository>(
  //   ({String? baseUrl}) => PaymentRepositoryImpl(
  //     cache: locator(),
  //     baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
  //   ),
  // );

  // locator.registerLazySingleton<FormRepository>(
  //   ({String? baseUrl}) => FormRepositoryImpl(
  //     cache: locator(),
  //     baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
  //   ),
  // );

  // locator.registerLazySingleton<ProductRepository>(
  //   ({String? baseUrl}) => ProductRepositoryImpl(
  //     cache: locator(),
  //     baseUrl: baseUrl ?? StringUtils.getBaseUrl(),
  //   ),
  // );

  // locator.registerLazySingleton<LocalCache>(
  //   () => LocalCacheImpl(
  //     sharedPreferences: locator(),
  //     storage: locator(),
  //   ),
  // );
}
