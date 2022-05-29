

class IHMemoryCacheSingleData<T> {
  final Map<String, T> data = {};

  IHMemoryCacheSingleData();

  T? get({required String key}) {
    final hasKey = data.containsKey(key);
    if (!hasKey) return null;
    return data[key]!;
  }

  void add({
    required String key,
    required T value,
  }) {
    data[key] = value;
  }

  void clear() {
    data.clear();
  }
}