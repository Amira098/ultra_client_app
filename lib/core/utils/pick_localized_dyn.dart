String? pickLocalizedDyn(dynamic messageLike, bool isAr) {
  if (messageLike == null) return null;
  try {

    final ar = (messageLike as dynamic).ar as String?;
    final en = (messageLike as dynamic).en as String?;
    final primary = isAr ? ar : en;
    final fallback = isAr ? en : ar;
    return (primary != null && primary.trim().isNotEmpty)
        ? primary
        : (fallback ?? '');
  } catch (_) {

    try {
      final ar = (messageLike as Map)['ar'] as String?;
      final en = (messageLike as Map)['en'] as String?;
      final primary = isAr ? ar : en;
      final fallback = isAr ? en : ar;
      return (primary != null && primary.trim().isNotEmpty)
          ? primary
          : (fallback ?? '');
    } catch (_) {
      return messageLike.toString();
    }
  }
}