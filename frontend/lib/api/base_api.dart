import 'package:finsplore/common/consts.dart';
import 'package:finsplore/model/model.dart';
import 'package:finsplore/model/pager.dart';
import 'package:finsplore/model/result.dart';
import 'package:finsplore/net/http_api.dart';

// Type alias for converter function
typedef Converter<T> = T Function(Map<String, dynamic>);

/// Base API class for CRUD operations on models of type M.
/// It uses HttpApi for actual HTTP interactions and provides
/// standard endpoints based on naming conventions.
/// 
/// Updated to work with the unified Finsplore backend API structure.
class BaseApi<M extends Model<M>> {
  final HttpApi<M> api;
  final Converter<M> converter;
  late final String prefix; // URL prefix for the model module
  bool useAuth = true; // Flag to use authentication

  /// Constructor initializes the HttpApi and sets the URL prefix.
  /// If no prefix is provided, it defaults to the lowercase model name.
  BaseApi(this.converter, {bool? useAuth, String? prefix})
      : api = HttpApi(converter) {
    this.prefix = prefix ?? "/${M.toString().toLowerCase()}";
    this.useAuth = useAuth ?? true;
  }

  // Generic get method to fetch a endpoint
  Future<Result<Map<String, dynamic>>> get({Map<String, dynamic>? queryParams}) =>
      api.get(prefix, query: queryParams, useAuth: useAuth);

  /// Retrieve a single item by its primary ID.
  Future<Result<Map<String, dynamic>>> selectById(String id) =>
      api.get("$prefix/$id", useAuth: useAuth);

  /// Retrieve a complete list of items under this module.
  Future<List<M>> selectList() => api.getList("$prefix/all", useAuth: useAuth);

  /// Retrieve a paginated list of items with optional query parameters.
  Future<Pager<M>> selectPageList({
    required int page,
    int? size,
    Map<String, dynamic>? query,
  }) {
    query = query ?? <String, dynamic>{};
    query["page"] = page;
    query["size"] = size ?? Consts.request.pageSize;
    return api.getPageList("$prefix/list", query: query, useAuth: useAuth);
  }

  /// Create a new model entry by sending a POST request.
  Future<Result<Map<String, dynamic>>> create(M model) =>
      api.post(prefix, data: model, useAuth: useAuth);

  Future<Result<Map<String, dynamic>>> put(M model) {
    return api.put(prefix, data: model, useAuth: useAuth);
  }

  /// Update an existing model by ID using PUT request.
  Future<Result<Map<String, dynamic>>> updateById(M model) =>
      api.put(prefix, data: model, useAuth: useAuth);

  /// Delete a model entry by its ID.
  Future<bool> deleteById(String id) =>
      api.delete("$prefix/$id", useAuth: useAuth);
}
