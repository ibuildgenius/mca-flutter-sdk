// ignore_for_file: prefer_typing_uninitialized_variables, unused_local_variable

import 'package:mca_official_flutter_sdk/src/constants/api_endpoints.dart';
import 'package:mca_official_flutter_sdk/src/globals.dart';

import '../api/generic_response.dart';
import '../api_config/api_service.dart';
import '../api_config/local_cache.dart';

abstract class ProductRepository {
  Future<GenericResponse> getAllInsuranceProviders();
  Future<GenericResponse> getInsuranceProviders(
    String categoryid, {
    List<String>? providerIds,
  });
  Future<GenericResponse> getProductDetails({
    required String categoryId,
    List<String>? providerIds,
    String? search,
    String? priceStaticFrom,
    String? priceStaticTo,
    String? priceDynamicFrom,
    String? priceDynamicTo,

    // bool useProductIds = false,
  });
  Future<GenericResponse> getProductDetailsById({
    required String productId,
  });
}

class ProductRepositoryImpl extends ApiService implements ProductRepository {
  late LocalCache cache;
  ProductRepositoryImpl({
    required this.cache,
    required String baseUrl,
  }) : super(baseUrl: baseUrl);

  @override
  Future<GenericResponse> getAllInsuranceProviders() async {
    var res = await get(ApiEndpoints.getInsuranceProviders, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getInsuranceProviders(
    String categoryid, {
    List<String>? providerIds,
  }) async {
    // String query = "?pageNumber=$pageNumber&pageSize=$pageSize";
    String query = "?category_id=$categoryid";

    if (Global.productId.isNotEmpty) {
      final productIdsQuery = Global.productId.map((productId) {
        return 'product_ids=${Uri.encodeComponent(productId)}';
      }).join('&');
      query += "&$productIdsQuery";
    }

    if (providerIds != null && providerIds.isNotEmpty) {
      final providerIdQuery = providerIds.map((providerId) {
        return 'provider_ids=${Uri.encodeComponent(providerId)}';
      }).join('&');
      query += "&$providerIdQuery";
    }

    var res =
        await get(ApiEndpoints.getInsuranceProviders + query, useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getProductDetails({
    required String categoryId,
    List<String>? providerIds,
    String? search,
    String? priceStaticFrom,
    String? priceStaticTo,
    String? priceDynamicFrom,
    String? priceDynamicTo,
  }) async {
    // Construct the query string dynamically
    final queryParameters = <String, String>{};

    queryParameters['category_id'] = categoryId;

    // if (providerId != null) queryParameters['provider_id'] = providerId;

    if (search != null) queryParameters['search'] = search;
    if (priceStaticFrom != null) {
      queryParameters['price_static_from'] = priceStaticFrom;
    }
    if (priceStaticTo != null) {
      queryParameters['price_static_to'] = priceStaticTo;
    }
    if (priceDynamicFrom != null) {
      queryParameters['price_dynamic_from'] = priceDynamicFrom;
    }
    if (priceDynamicTo != null) {
      queryParameters['price_dynamic_to'] = priceDynamicTo;
    }

    // if (providerIds != null && providerIds.isNotEmpty) {
    //   for (var providerId in providerIds) {
    //     if (providerId.isNotEmpty) {
    //       queryParameters['provider_ids'] = providerId;
    //     }
    //   }
    // }

    // Append productIds to the query string if not empty
    if (Global.productId.isNotEmpty) {
      for (var productId in Global.productId) {
        queryParameters['product_ids'] = productId;
      }
    }

    // Build the query string
    var query = Uri(queryParameters: queryParameters).query;

    if (providerIds != null && providerIds.isNotEmpty) {
      final providerIdsQuery = providerIds.map((providerId) {
        return 'provider_id=${Uri.encodeComponent(providerId)}';
      }).join('&');
      query += "&$providerIdsQuery";
    }

    if (Global.productId.isNotEmpty) {
      final productIdsQuery = Global.productId.map((productId) {
        return 'product_ids=${Uri.encodeComponent(productId)}';
      }).join('&');
      query += "&$productIdsQuery";
    }

    // Make the API call with the constructed URL
    var res =
        await get('${ApiEndpoints.getProductDetails}?$query', useToken: true);
    return GenericResponse.fromJson(res);
  }

  @override
  Future<GenericResponse> getProductDetailsById({
    required String productId,
  }) async {
    // Make the API call with the constructed URL
    String query = "?product_ids=$productId";
    var res = await get(ApiEndpoints.getProductDetails + query, useToken: true);
    return GenericResponse.fromJson(res);
  }
}
