import 'package:flutter/material.dart';
import 'package:movie_app/repo/movie_repo.dart';
import 'package:movie_app/screens/movie_details_screen.dart';
import '../models/movie_model.dart';


class MoviesListScreen extends StatefulWidget {
  const MoviesListScreen({Key? key}) : super(key: key);

  @override
  State<MoviesListScreen> createState() => _MoviesListScreenState();
}

class _MoviesListScreenState extends State<MoviesListScreen> {
  final MovieService _movieService = MovieService();
  final List<Movie> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadMovies();
  }

  Future<void> _loadMovies() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final movies = await _movieService.getPopularMovies(_currentPage);
      setState(() {
        _movies.addAll(movies);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _loadNextPage() {
    _currentPage++;
    _loadMovies();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.movie, size: 28),
            SizedBox(width: 8),
            Text('Movies'),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              // هنضيف الـ Theme Toggle لاحقاً
            },
          ),
        ],
      ),
      body: _movies.isEmpty && _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      final movie = _movies[index];
                      return _buildMovieCard(movie);
                    },
                  ),
                ),
                _buildLoadMoreButton(),
              ],
            ),
    );
  }

  Widget _buildMovieCard(Movie movie) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MovieDetailsScreen(movie: movie),
              ),
            );
          },
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                // صورة الفيلم
                _buildMoviePoster(movie),
                SizedBox(width: 12),
                // معلومات الفيلم
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // اسم الفيلم
                      Text(
                        movie.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      // التقييم
                      _buildRating(movie.voteAverage),
                      SizedBox(height: 8),
                      // النوع (Genre) - هنستخدم Release Date كبديل
                      _buildGenreChip(movie.releaseDate),
                    ],
                  ),
                ),
                // السهم
                Icon(
                  Icons.arrow_forward_ios,
                  color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMoviePoster(Movie movie) {
    return Container(
      width: 100,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: movie.posterUrl.isNotEmpty
            ? Image.network(
                movie.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildImagePlaceholder();
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                },
              )
            : _buildImagePlaceholder(),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Icon(
        Icons.movie,
        size: 50,
        color: Colors.grey[600],
      ),
    );
  }

  Widget _buildRating(double rating) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Color(0xFFFFB300),
          size: 20,
        ),
        SizedBox(width: 4),
        Text(
          '${rating.toStringAsFixed(1)}/10',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
        ),
      ],
    );
  }

  Widget _buildGenreChip(String releaseDate) {
    // استخراج السنة من تاريخ الإصدار
    String year = releaseDate.isNotEmpty && releaseDate.length >= 4 
        ? releaseDate.substring(0, 4) 
        : 'Unknown';
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).dividerColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        year,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 13,
            ),
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: _isLoading
          ? Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(),
              ),
            )
          : ElevatedButton(
              onPressed: _loadNextPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).cardTheme.color,
                foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 2,
              ),
              child: Text(
                'Load More Movies',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
    );
  }
}