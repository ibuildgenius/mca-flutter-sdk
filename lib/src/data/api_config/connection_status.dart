import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class ConnectionStatus {
  static Future<bool> isConnected() async {
    var connectionResult = await (Connectivity().checkConnectivity());

    if (!connectionResult.contains(ConnectivityResult.none)) {
      return await InternetConnectionChecker().hasConnection;
    } else {
      return false;
    }
  }
}
