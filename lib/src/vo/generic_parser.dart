abstract class GenericParser<T> {


  T? parse(Map<dynamic, dynamic> json, {String key = "data"});

  bool isSubtype<T1, T2>() => <T1>[] is List<T2>;
}