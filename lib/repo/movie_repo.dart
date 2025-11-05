import 'package:dio/dio.dart';
import 'package:movie_app/models/movie_model.dart';
import '../core/constants/api_constants.dart';

class MovieService {
  late final Dio _dio;

  MovieService() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: ApiConstants.connectionTimeout,
        receiveTimeout: ApiConstants.receiveTimeout,
      ),
    );
  }

  // جلب الأفلام الشائعة
  Future<List<Movie>> getPopularMovies(int page) async {
    try {
      print('🌐 Fetching movies from API - Page $page');
      
      final response = await _dio.get(
        ApiConstants.popularMoviesEndpoint,
        queryParameters: {
          'api_key': ApiConstants.apiKey,
          'page': page,
          'language': 'en-US',
        },
      );

      if (response.statusCode == 200) {
        List moviesJson = response.data['results'] ?? [];
        
        List<Movie> movies = moviesJson
            .map((json) => Movie.fromJson(json))
            .toList();
        
        print('✅ Successfully fetched ${movies.length} movies');
        return movies;
      } else {
        throw Exception('Failed to load movies: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('❌ Dio Error: ${e.message}');
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout - Check your internet');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Receive timeout - Server is slow');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error - Check your internet');
      }
    } catch (e) {
      print('❌ Unexpected Error: $e');
      throw Exception('Something went wrong: $e');
    }
  }
}