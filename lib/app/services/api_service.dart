import 'package:dio/dio.dart';
import '../models/pokemon_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://pokeapi.co/api/v2',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // Add interceptors for logging (optional)
    _dio.interceptors.add(
      LogInterceptor(requestBody: true, responseBody: true, error: true),
    );
  }

  // Get Pokemon list with pagination
  Future<PokemonList> getPokemonList({int offset = 0, int limit = 20}) async {
    try {
      final response = await _dio.get(
        '/pokemon',
        queryParameters: {'offset': offset, 'limit': limit},
      );

      return PokemonList.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // Get Pokemon detail by ID or name
  Future<PokemonDetail> getPokemonDetail(dynamic idOrName) async {
    try {
      final response = await _dio.get('/pokemon/$idOrName');
      return PokemonDetail.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timeout. Please check your internet connection.';
      case DioExceptionType.badResponse:
        return 'Server error: ${error.response?.statusCode}';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Network error. Please try again.';
    }
  }

  Future<PokemonSpecies> getPokemonSpecies(int id) async {
    try {
      final response = await _dio.get('/pokemon-species/$id');
      return PokemonSpecies.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<EvolutionChain> getEvolutionChain(int id) async {
    try {
      final response = await _dio.get('/evolution-chain/$id');
      return EvolutionChain.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getMove(dynamic idOrName) async {
    try {
      final response = await _dio.get('/move/$idOrName');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}
