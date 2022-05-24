// import '../../hudle_network.dart';
//
// class Resource<T> {
//   Status status;
//   T? data;
//   ErrorResource? onError;
//
//   Resource._(this.status, this.data, this.onError);
//
//   static Resource<T> error<T>(ErrorResource onError) {
//     return Resource._(Status.ERROR, null, onError);
//   }
//
//   static Resource<T> success<T>(T data) {
//     return Resource._(Status.SUCCESS, data, null);
//   }
//
//   static Resource<T> loading<T>() {
//     return Resource._(Status.LOADING, null, null);
//   }
// }
//
// enum Status { SUCCESS, ERROR, LOADING }
//
