import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:invests_helper/data/providers/secure_storage_provider.dart';
import 'package:invests_helper/utils/json_utils.dart';


class BaseBackendClient {
  Future<void> Function()? onAccessTokenExpired;
  Function()? onRefreshTokenExpired;

  static const String binanceApiUrl = 'api.binance.com';
  static const String googleSheetApi = 'script.google.com';

  String getApiUrl({required CryptoMarketType type}) {
    switch (type) {
      case CryptoMarketType.binance:
        return binanceApiUrl;
      case CryptoMarketType.byBit:
        throw Exception('Btbit api не поддерживается');
      case CryptoMarketType.googleSheets:
        return googleSheetApi;
    }
  }

  Future<Map> makeDeleteResponse(String method, {
    Map<String, dynamic>? query,
    required CryptoMarketType type,
    Map<String, String>? additionalParams,
  }) async {
    final headers = await getHeaders(isDelete: true, additionalParams: additionalParams);
    final uri = Uri.https(getApiUrl(type: type), method, query);
    var response = await delete(uri, headers: headers);
    final message = utf8.decode(response.bodyBytes);
    print('DELETE Request -- address: $uri with code: ' +
        response.statusCode.toString());
    if (response != null && response.statusCode == 200) {
      return json.decode(response.body);
    }
    if (response.statusCode == 403) {
      throw RefreshTokenExpiredException(data: response, message: message);
    }
    if (response.statusCode == 401) {
      print('Access token expired');
      await onAccessTokenExpired?.call();
      var response = await delete(uri, headers: headers);
      final message = utf8.decode(response.bodyBytes);
      if (response != null && response.statusCode == 200) {
        return json.decode(response.body);
      }
      if (response.statusCode == 403) {
        throw RefreshTokenExpiredException(data: response, message: message);
      }
    }
    throw UnknownServerException(data: response, message: message);
  }

  Future<Map<String, dynamic>> makeGetResponse(String method, {
    Map<String, dynamic>? queryParam,
    required CryptoMarketType type,
    Map<String, String>? additionalParams,
  }) async {
    print('GET Request address: ${getApiUrl(type: type) + method}');
    print('GET Request query: $queryParam');
    queryParam?.removeWhere((key, value) => value == null);
    final headers = await getHeaders(additionalParams: additionalParams);
    final cuApiUrl = getApiUrl(type: type);
    final uri = Uri.https(cuApiUrl, method, queryParam);
    var response = await get(uri, headers: headers);
    final message = utf8.decode(response.bodyBytes);
    print('GET Request code: ' +
        response.statusCode.toString() +
        ' For uri: $uri');

    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      if (decoded is List<dynamic>) {
        return <String, dynamic>{
          'result': decoded
        };
      }
      return decoded;
    }

    if (response.statusCode == 403) {
      throw RefreshTokenExpiredException(data: response, message: message);
    }
    if (response.statusCode == 401) {
      print('Access token expired');
      await onAccessTokenExpired?.call();
      var response = await get(uri, headers: headers);
      final message = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      if (response.statusCode == 403) {
        throw RefreshTokenExpiredException(data: response, message: message);
      }
    }
    throw UnknownServerException(data: response, message: message);
  }

  Future<Map<String, dynamic>> makePostResponse(String method, {
    Map<String, String>? queryParameters,
    Map<String, dynamic> body = const {},
    required CryptoMarketType type,
    Map<String, String>? additionalParams,
  }) async {
    final headers = await getHeaders(isPost: true, additionalParams: additionalParams);
    print('POST Request -- body: ${jsonEncode(body)} API - $method');
    final uri = Uri.https(getApiUrl(type: type), method, queryParameters);
    final response = await post(uri, body: jsonEncode(body), headers: headers);
    print('POST Request address: $uri with code: ' +
        response.statusCode.toString());
    final message = utf8.decode(response.bodyBytes);
    if (response.statusCode == 200) {
      final result = jsonTryDecode(response.body);
      return result;
    }

    if (response.statusCode == 403 ||
        message == '{"status":"error","message":"Token is expired"}') {
      throw RefreshTokenExpiredException(data: response, message: message);
    }
    if (response.statusCode == 401) {
      print('Access token expired');
      await onAccessTokenExpired?.call();
      final response =
          await post(uri, body: jsonEncode(body), headers: headers);
      final message = utf8.decode(response.bodyBytes);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      if (response.statusCode == 403 ||
          message == '{"status":"error","message":"Token is expired"}') {
        throw RefreshTokenExpiredException(data: response, message: message);
      }
    }
    throw UnknownServerException(data: response, message: message);
  }

  /*Future<Map<String, dynamic>> makeMultipartResponse(String method, List<MultipartFile> files) async {
    final uri = Uri.httpss(getApiUrl(), method);
    final headers = await getHeaders(isPost: true);
    final request = MultipartRequest('POST', uri);
    request.headers.addAll(headers);
    request.files.addAll(files);
    final response = await request.send();
    print('Multipart Request address: ${getApiUrl() + method} with code: ' + response.statusCode.toString());

    if (response != null && response.statusCode == 200) {
      final result = await response.stream.transform(utf8.decoder).single;
      return json.decode(result);
    } else {
      final body = await response.stream.bytesToString();
      throw await _handleServerError(body);
    }
  }*/

  /// Получить хедеры для запроса.
  /// [additionalParams] используется для доп-параметров, таких как
  /// ключ api
  Future<Map<String, String>> getHeaders({
    Map<String, String>? additionalParams,
    bool isPost = false,
    bool isDelete = false,
  }) async {

    final token = await SecureStorageProvider().getAccessToken();
    final headers = <String, String>{
      'x-client-info': await generateClientInfo()
    };
    if (!isDelete) {
      headers[HttpHeaders.contentTypeHeader] = 'application/json';
      headers[HttpHeaders.acceptHeader] = 'application/json';
    }
    if (token != null) {
      headers[HttpHeaders.authorizationHeader] =
          'Bearer %s'.replaceAll('%s', token);
      //print(HttpHeaders.authorizationHeader + ': ' + Constants.TOKEN_HEADER.replaceAll('%s', token));
    } else {
      //assert(false, 'Token is null');
      print('Token is null');
    }

    if (additionalParams != null) {
      for(var i in additionalParams.entries) {
        headers[i.key] = i.value;
      }
    }

    print('Headers: $headers');
    return headers;
  }

  /// В некоторых проектах есть специфичные коды ошибок, как например 429
  /// метод поможет выловить и обработать эти ошибки
  void _responseCodesHandler(Response response) {

  }

  Future<String> generateClientInfo() async {
    /*final packageInfo = await PackageInfo.fromPlatform();
    final appName = packageInfo.appName;
    final packageName = packageInfo.packageName;
    final version = packageInfo.version;
    final buildNumber = packageInfo.buildNumber;
    final platform = Platform.isAndroid ? 'Android' : 'iOS';
    final time = DateTime.now().toIso8601String();

    return '$appName/$version (bundle: $packageName; build: $buildNumber; '
        'ocName: $platform; '
        'ocVersion: ${Platform.operatingSystemVersion}; time: $time)';*/
    return '';
  }
}

class RefreshTokenExpiredException implements Exception {
  final dynamic data;
  final String message;

  RefreshTokenExpiredException({required this.data, required this.message});
}

class UnknownServerException implements Exception {
  final dynamic data;
  final String message;

  UnknownServerException({required this.data, required this.message});
}

enum CryptoMarketType {
  binance,
  byBit,
  googleSheets,
}
