dynamic getField(dynamic obj, String key) {
  if (obj == null) return null;


  if (obj is Map) return obj[key];


  try {
    final toJson = (obj as dynamic).toJson;
    if (toJson is Function) {
      final map = toJson();
      if (map is Map) return map[key];
    }
  } catch (_) {}

  return null;
}