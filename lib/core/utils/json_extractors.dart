import '../models/i18n_text.dart' show I18nText;

/// دوال مساعدة لاستخراج قيم شائعة من خرائط/أوبجكتات ديناميكية
String extractId(dynamic raw, [Map<String, dynamic>? map, Map<String, dynamic>? attrs]) {
  final m = map ?? _toMap(raw);
  final a = attrs ?? _innerAttrs(m);
  dynamic v = m['id'] ?? a['id'];
  if (v == null) {
    try { v = (raw as dynamic).id; } catch (_) {}
  }
  return '${v ?? ''}';
}

I18nText extractI18n(dynamic raw, List<String> keys) {
  final m = _toMap(raw);
  final a = _innerAttrs(m);
  for (final k in keys) {
    if (m.containsKey(k)) return I18nText.fromAny(m[k]);
    if (a.containsKey(k)) return I18nText.fromAny(a[k]);
    try {
      final v = (raw as dynamic).toJson()[k];
      if (v != null) return I18nText.fromAny(v);
    } catch (_) {}
    try {
      final v = (raw as dynamic).$k; // سيُتجاهَل من الدارت أنالايزر، مجرد محاولة
    } catch (_) {}
    try {
      final v = (raw as dynamic).__proto__; // للتخطّي
    } catch (_) {}
    // محاولات getters مباشرة
    try {
      final v = (raw as dynamic).title;
      if (k == 'title') return I18nText.fromAny(v);
    } catch (_) {}
    try {
      final v = (raw as dynamic).name;
      if (k == 'title') return I18nText.fromAny(v);
    } catch (_) {}
    try {
      final v = (raw as dynamic).message;
      if (k == 'title' || k == 'description') return I18nText.fromAny(v);
    } catch (_) {}
  }
  return const I18nText();
}

String extractImageUrl(dynamic raw) {
  String fromMap(Map mm) {
    for (final k in ['image','imageUrl','cover','coverUrl','thumbnail','thumb','banner']) {
      if (mm.containsKey(k)) {
        final v = mm[k];
        if (v is String) return v;
        if (v is Map && v['url'] is String) return v['url'] as String;
      }
    }
    return '';
  }

  final m = _toMap(raw);
  final a = _innerAttrs(m);

  var direct = fromMap(m);
  if (direct.isNotEmpty) return direct;

  direct = fromMap(a);
  if (direct.isNotEmpty) return direct;

  try {
    final v = (raw as dynamic).image;
    if (v is String) return v;
    try { final u = (v as dynamic).url as String?; if (u != null) return u; } catch (_) {}
  } catch (_) {}

  try {
    final v = (raw as dynamic).coverUrl ?? (raw as dynamic).thumbnail;
    if (v is String) return v;
  } catch (_) {}

  try {
    final j = (raw as dynamic).toJson() as Map<String, dynamic>;
    final jj = fromMap(j);
    if (jj.isNotEmpty) return jj;
    final attrs = j['attributes'];
    if (attrs is Map) {
      final aa = fromMap(attrs);
      if (aa.isNotEmpty) return aa;
    }
  } catch (_) {}

  return '';
}

Map<String, dynamic> _toMap(dynamic raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  try { return Map<String, dynamic>.from((raw as dynamic).toJson()); } catch (_) {}
  return <String, dynamic>{};
}

Map<String, dynamic> _innerAttrs(Map<String, dynamic> m) {
  final n = m['attributes'] ?? m['data'];
  if (n is Map) return Map<String, dynamic>.from(n);
  return <String, dynamic>{};
}
