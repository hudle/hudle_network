import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hudle_network/src/models/base_response.dart';
import 'package:hudle_network/src/vo/error_codes.dart';
import 'package:hudle_network/src/vo/generic_parser.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class DioNetwork {

  late Dio _dio;

  DioNetwork() {
     _dio = Dio(BaseOptions(baseUrl: injectBaseUrl() , headers: injectHeaders()))
      ..interceptors.add(
        PrettyDioLogger(
            requestBody: showRequestBody, requestHeader: showRequestHeader, responseBody: showResponseBody),
      );
  }

  Dio get dio => _dio;

  String injectBaseUrl();

  Map<String, dynamic>? injectHeaders();

  GenericParser<T> provideParser<T>();

  BaseResponse<T> handleResponse<T>(Response response, {bool skipMetaParsing = false,}) {
    try {
      if (response.isSuccessful) {

        if (response.statusCode == 204) {
          return BaseResponse(success: true, message: '', data: null, code: 204);
        }
        
        final json = jsonDecode(response.data);
      

        return response.getBaseResponse<T>(skipMetaParsing: skipMetaParsing, genericParser: provideParser<T>());
      } else {
        return BaseResponse.fromError(response.errorMessage);
      }
    } catch (e) {
      return BaseResponse.fromError(e.toString());
    }
  }

  bool get showRequestBody => kDebugMode;
  bool get showRequestHeader => kDebugMode;
  bool get showResponseBody => kDebugMode;
}

extension FutureResponse on Future<Response> {
  Future<BaseResponse<T>> safeApiCall<T>(DioNetwork dioNetwork, {bool skipMetaParsing = false}) async {
    try {
      final Response response = await this;
      return dioNetwork.handleResponse<T>(response, skipMetaParsing: skipMetaParsing);
    } catch (e) {
      if (e is DioError) {
        return _handleDioError<T>(e);
      }
      return BaseResponse.fromError(e.toString());
    }
  }
}

BaseResponse<T> _handleDioError<T>(DioError e) {
  switch (e.type) {
    case DioErrorType.connectTimeout:
      return BaseResponse.fromError("Connection timeout");

    case DioErrorType.sendTimeout:
      return BaseResponse.fromError("Send timeout");

    case DioErrorType.receiveTimeout:
      return BaseResponse.fromError("Receive timeout", errorCode: -1);

    case DioErrorType.response:
      switch (e.response?.statusCode) {
        case 401:
          return  BaseResponse.fromError(
            "onUnauthorizedAccess",
            errorCode: e.response?.statusCode ?? -1, );
        case 422:

          final validationError = e.response?.data['errors'];

         return  BaseResponse.fromError(
           "",
           errorCode: e.response?.statusCode ?? -1, error: validationError );
        case 403:
          return  BaseResponse.fromError(
            e.response?.errorMessage ?? "onForbiddenError",
            errorCode: e.response?.statusCode ?? -1, );
        case 404:
          return  BaseResponse.fromError(
            e.response?.errorMessage ?? "onNotFound",
            errorCode: e.response?.statusCode ?? -1, );
        case 500:
          return  BaseResponse.fromError(
            e.response?.errorMessage ?? "Internal Server Error",
            errorCode: e.response?.statusCode ?? 500, );
      }

      return BaseResponse.fromError(e.response?.errorMessage ?? "Something unknown error", errorCode: e.response?.statusCode ?? -1);

    case DioErrorType.cancel:
      return BaseResponse.fromError("Request has been cancelled");

    case DioErrorType.other:
      return BaseResponse.fromError("Could not connect",errorCode: ErrorCode.COULD_NOT_CONNECT);
  }
}

extension Base on Response {
  bool get isSuccessful => statusCode == HttpStatus.ok || statusCode == HttpStatus.created ||  statusCode == HttpStatus.noContent || statusCode == HttpStatus.accepted;

  BaseResponse<T> getBaseResponse<T>({bool skipMetaParsing = false, required GenericParser genericParser}) {
    try {
      // debugPrint("--------RESPONSE---------");
      // debugPrint("$data");
      // debugPrint("--------RESPONSE END---------");
      if (data is String) {
        return BaseResponse(success: true, message: 'Success', data:null, code: 200);
      }
      BaseResponse<T> baseResponse = BaseResponse.fromJson(data, skipMetaParsing: skipMetaParsing, genericParser: genericParser);
      return baseResponse;
    } catch (e, stacktrace) {
      BaseResponse<T> baseResponse = BaseResponse.fromError("Unable to parse base response $e $stacktrace");
      return baseResponse;
    }
  }

  String get errorMessage {
    try {
      if (data is Map) {
        final Map<String, dynamic> resp = data;
        return resp.containsKey("message")
            ? resp['message']
            : "Something went wrong";
      }
      else if (data is String) {
        return data.isEmpty ? statusMessage : data;
      }
      else return "Unknown Error Response";
    }
    catch (e) {
      return "$e";
    }
  }

}
