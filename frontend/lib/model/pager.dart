import 'package:json_annotation/json_annotation.dart';

part 'pager.g.dart';

/// Pagination wrapper for API responses with page information.
/// Updated to match the unified Finsplore backend pagination structure.
@JsonSerializable(genericArgumentFactories: true)
class Pager<T> {
  final List<T> content;
  final int page;
  final int size;
  final int totalElements;
  final int totalPages;
  final bool first;
  final bool last;
  final bool empty;

  Pager({
    required this.content,
    required this.page,
    required this.size,
    required this.totalElements,
    required this.totalPages,
    required this.first,
    required this.last,
    required this.empty,
  });

  factory Pager.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$PagerFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object Function(T value) toJsonT) =>
      _$PagerToJson(this, toJsonT);

  /// Create an empty pager
  factory Pager.empty() {
    return Pager<T>(
      content: [],
      page: 0,
      size: 0,
      totalElements: 0,
      totalPages: 0,
      first: true,
      last: true,
      empty: true,
    );
  }

  /// Create a pager from a simple list (for local data)
  factory Pager.fromList(List<T> items, {int page = 0, int size = 20}) {
    final startIndex = page * size;
    final endIndex = (startIndex + size).clamp(0, items.length);
    final pageContent = items.sublist(startIndex, endIndex);
    final totalPages = (items.length / size).ceil();

    return Pager<T>(
      content: pageContent,
      page: page,
      size: size,
      totalElements: items.length,
      totalPages: totalPages,
      first: page == 0,
      last: page >= totalPages - 1,
      empty: items.isEmpty,
    );
  }

  /// Check if there are more pages available
  bool get hasNext => !last;

  /// Check if there are previous pages available
  bool get hasPrevious => !first;

  /// Get the next page number (or null if no next page)
  int? get nextPage => hasNext ? page + 1 : null;

  /// Get the previous page number (or null if no previous page)
  int? get previousPage => hasPrevious ? page - 1 : null;

  /// Get the number of items in current page
  int get numberOfElements => content.length;

  @override
  String toString() {
    return 'Pager(page: $page, size: $size, totalElements: $totalElements, content: ${content.length} items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Pager<T> &&
        other.page == page &&
        other.size == size &&
        other.totalElements == totalElements;
  }

  @override
  int get hashCode => page.hashCode ^ size.hashCode ^ totalElements.hashCode;
}
