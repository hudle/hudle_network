// import '../../hudle_network.dart';
// import '../models/base_response.dart';
// import '../vo/resource.dart';
//
// extension DataResponse<T> on Future<BaseResponse> {
//
//   Future<Resource<T>> toResource<T>() async {
//     try {
//       final response = await this;
//       if (response.success) {
//         return Resource.success(response.data);
//       } else {
//         return Resource.error(ErrorResource(response.message,
//             errorCode: response.code, validationError: response.errors));
//       }
//     } catch (e) {
//       return Resource.error(ErrorResource('$e'));
//     }
//   }
//
//   @Deprecated("Use toResourcePaginate instead")
//   Future<Resource<PaginationDataWrapper<T>>> resourcePaginateAsync<T>() async {
//     final response = await this;
//     if (response.success) {
//       return Resource.success(PaginationDataWrapper<T>(response.data, response.meta));
//     } else {
//       return Resource.error(ErrorResource(response.message, errorCode: response.code, validationError: response.errors));
//     }
//   }
//
//   Future<Resource<PaginationWrapper<T>>> toResourcePaginate<T>() async {
//     final response = await this;
//     if (response.success) {
//       return Resource.success(PaginationWrapper<T>(response.data, response.meta));
//     } else {
//       return Resource.error(ErrorResource(response.message, errorCode: response.code, validationError: response.errors));
//     }
//   }
//
//   @Deprecated("Use toResource instead")
//   Future<Resource<T>> resourceAsync<T>() async {
//     try {
//       final response = await this;
//       if (response.success) {
//         return Resource.success(response.data);
//       } else {
//         return Resource.error(ErrorResource(response.message,
//             errorCode: response.code, validationError: response.errors));
//       }
//     } catch (e) {
//       return Resource.error(ErrorResource('$e'));
//     }
//   }
// }