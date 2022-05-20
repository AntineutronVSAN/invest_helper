

extension MapGeneration on Map {
  Map<K, V> generate<K, V>(List<K> keys, List<V> values) {
    assert(keys.length == values.length);
    final res = <K, V>{};
    for(var i=0; i<keys.length; i++) {
      res[keys[i]] = values[i];
    }
    return res;
  }
}