import 'package:flutter/foundation.dart';
import 'package:mca_official_flutter_sdk/locator.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/claim_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/form_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/init_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/inspection_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/payment_repo.dart';
import 'package:mca_official_flutter_sdk/src/data/repositories/product_repo.dart';

import '../api_config/app_logger.dart';
import '../api_config/local_cache.dart';
import '../repositories/init_config_repo.dart';
import '../repositories/user_repo.dart';

class BaseChangeNotifier extends ChangeNotifier {
  BaseChangeNotifier({
    UserRepository? userRepository,
    ProductRepository? productRepository,
    FormRepository? formRepository,
    PaymentRepository? paymentRepository,
    InspectionRepository? inspectionRepository,
    ClaimRepository? claimRepository,
    LocalCache? localCache,
    //  NavigationHandler? navigationHandler,
    InitRepository? initRepository,
    CustomerInitUIConfig? customerInitUIConfig,
  }) {
    this.userRepository = userRepository ?? locator();
    this.productRepository = productRepository ?? locator();
    this.formRepository = formRepository ?? locator();
    this.paymentRepository = paymentRepository ?? locator();
    this.inspectionRepository = inspectionRepository ?? locator();
    this.claimRepository = claimRepository ?? locator();
    this.localCache = localCache ?? locator();
    // this.navigationHandler = navigationHandler ?? locator();
    this.initRepository = initRepository ?? locator();
    this.customerInitUIConfig = customerInitUIConfig ?? locator();
  }

  late UserRepository userRepository;
  late ProductRepository productRepository;
  late FormRepository formRepository;
  late InitRepository initRepository;
  late CustomerInitUIConfig customerInitUIConfig;
  late InitRepository initRepositoryV2;
  late PaymentRepository paymentRepository;
  late InspectionRepository inspectionRepository;
  late ClaimRepository claimRepository;
  late LocalCache localCache;

  // late NavigationHandler navigationHandler;

  // ignore: prefer_final_fields
  bool _loading = false;

  bool get loading => _loading;

  void log(Object? e) {
    AppLogger.log("$e");
  }
}
