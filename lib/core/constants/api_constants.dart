class ApiConstants {
  static const String baseUrl = 'https://api.themoviedb.org/3';
  static const String apiKey = 'bd54d7a0a150e06281d0039c67374c79'; 
  static const String imageBaseUrl = 'https://image.tmdb.org/t/p/w500';

  // Endpoints
  static const String popularMoviesEndpoint = '/movie/popular';
  
  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}