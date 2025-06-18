import 'dart:convert';

typedef Converter<T> = T Function(Map<String, dynamic>);

/// Base abstract class for all data models in the Finsplore application.
/// 
/// Provides common functionality for JSON serialization and string representation.
/// Updated for the unified Finsplore architecture.
abstract class Model<T extends Model<T>> {
  const Model();

  /// Unique identifier for the model instance.
  /// This is a placeholder and should be overridden in subclasses.
  String get id => "0";

  /// Convert the model instance to a JSON-serializable map.
  /// Must be implemented by all subclasses.
  Map<String, dynamic> toJson();

  /// Create a copy of this model with optional field updates.
  /// Should be implemented by subclasses for immutable updates.
  T copyWith();

  /// String representation using JSON encoding for debugging.
  @override
  String toString() => json.encode(this);

  /// Equality comparison based on the model's ID.
  /// Can be overridden for more complex equality logic.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Model<T> && other.id == id;
  }

  /// Hash code based on the model's ID.
  @override
  int get hashCode => id.hashCode;
}
