import 'package:flutter/foundation.dart';
import '../vo/error_codes.dart';
import '../vo/generic_parser.dart';
import 'pagination_model.dart';

class BaseResponse<Data> {
  late bool success;
  late String message;
  Meta? meta;
  Data? data;
  int code = -1;
  Map<String, dynamic>? errors;
  //GenericParser genericParser;

  BaseResponse({required this.success, required this.message, required this.data, required this.code, this.errors, this.meta});

  BaseResponse.fromJson(Map<String, dynamic> json, {required GenericParser genericParser, bool skipMetaParsing = false}) {
    success = json.containsKey("success") ? json['success'] : true;
    message = json.containsKey("message") ? json['message'] : "Success";
   // debugPrint("TO PARSE THE GIVEN JSON: ${json}" );
   // debugPrint("SKIP META PARSING CONFIG: $skipMetaParsing" );
    //
    if (skipMetaParsing == false && json.containsKey('meta') && json['meta'] != null) {
      debugPrint("TO PARSE THE GIVEN META: ${json['meta']}" );
      // //----------------Meta--------------------//
        meta = Meta.fromJson(json['meta']);
        print("IS META PARSED  ${[meta?.toJson(), meta?.pagination?.toJson()]}");
    }
    else {
      debugPrint("META PARSING SKIPPED" );
    }

    if (json.containsKey('data') && json['data'] != null) {
      try {
        //CHECK FOR GENERIC DATA TYPE
        //---------------------------
        data = genericParser.parse(json);

        print("==========");
        if (kDebugMode) print(Data);
        print("==========");

        if (kDebugMode && data == null) {
          throw Exception("Data is not parsed it is null");
        }

      } catch (e, stacktrace) {
        success = false;
        message = e.toString();
        data = null;
        debugPrint("EXCEPTION: PARSING BASE RESPONSE DATA KEY, ERROR: $e $stacktrace");
      }
    }
    else {
      success = false;
      message = "No data key found";
      data = null;
    }
  }

  BaseResponse.fromError(String errorMessage, {int errorCode = ErrorCode.UNKNOWN_ERROR, Map<String, dynamic>? error}) {
    success = false;
    message = errorMessage;
    data = null;
    code = errorCode;
    errors = error;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;

    return data;
  }
}