class I18nText {
  final String? ar;
  final String? en;

  const I18nText({this.ar, this.en});

  factory I18nText.fromAny(dynamic v) {
    if (v == null) return const I18nText();
    if (v is I18nText) return v;
    if (v is String) return I18nText(ar: v, en: v);
    if (v is Map) {
      final ar = v['ar'];
      final en = v['en'];
      return I18nText(
        ar: ar is String ? ar : null,
        en: en is String ? en : null,
      );
    }
    // دعم لكلاسات عندها خصائص ar/en
    try {
      final ar = (v as dynamic).ar as String?;
      final en = (v as dynamic).en as String?;
      return I18nText(ar: ar, en: en);
    } catch (_) {
      return const I18nText();
    }
  }

  String localized({required bool isAr, String fallback = ''}) {
    final primary = isAr ? ar : en;
    final other = isAr ? en : ar;
    return (primary ?? other ?? fallback).trim();
  }

  Map<String, dynamic> toJson() => {'ar': ar, 'en': en};

  I18nText copyWith({String? ar, String? en}) =>
      I18nText(ar: ar ?? this.ar, en: en ?? this.en);
}
