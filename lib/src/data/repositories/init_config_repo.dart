import 'package:mca_official_flutter_sdk/src/constants/api_endpoints.dart';
import 'package:mca_official_flutter_sdk/src/data/api/generic_response.dart';
import 'package:mca_official_flutter_sdk/src/data/api_config/api_service.dart';


abstract class CustomerInitUIConfig {
  Future<GenericResponse> fallbackConfig();
}

class CustomerInitUIConfigImpl extends ApiService
    implements CustomerInitUIConfig {
  CustomerInitUIConfigImpl() : super();

//////////////////////
  @override
  Future<GenericResponse> fallbackConfig() async {
    // var res = await get('${ApiEndpoints.getProductDetails}?$query', useToken: true);


    const String baseUrl = ApiEndpoints.initialiseSdkFallBack;
    final response = await get(baseUrl, useToken: true);
    //return GenericResponse.fromJson(response);
    final parsedResponse = GenericResponse.fromJson(response);
    return parsedResponse;
  }
}

