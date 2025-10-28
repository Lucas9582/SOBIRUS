abstract class ModelFactory<T> {
  T createFromMap(String id, Map<String, dynamic> map);
  T createEmpty();
}
