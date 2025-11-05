import 'package:flutter/material.dart';
import '../models/movie_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final Movie movie;

  const MovieDetailsScreen({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة الفيلم الكبيرة
            _buildBackdropImage(),
            
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // اسم الفيلم
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 16),
                  
                  // التقييم وتاريخ الإصدار
                  Row(
                    children: [
                      _buildRating(context),
                      SizedBox(width: 24),
                      _buildReleaseDate(context),
                    ],
                  ),
                  SizedBox(height: 24),
                  
                  // Overview
                  Text(
                    'Overview',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    movie.overview,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.5,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackdropImage() {
    return Container(
      width: double.infinity,
      height: 250,
      color: Colors.grey[300],
      child: movie.backdropUrl.isNotEmpty
          ? Image.network(
              movie.backdropUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return _buildImagePlaceholder();
              },
            )
          : _buildImagePlaceholder(),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: Colors.grey[300],
      child: Center(
        child: Icon(
          Icons.movie,
          size: 80,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _buildRating(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.star,
          color: Color(0xFFFFB300),
          size: 24,
        ),
        SizedBox(width: 6),
        Text(
          '${movie.voteAverage.toStringAsFixed(1)}/10',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
        ),
      ],
    );
  }

  Widget _buildReleaseDate(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.calendar_today,
          size: 20,
          color: Theme.of(context).iconTheme.color?.withOpacity(0.7),
        ),
        SizedBox(width: 6),
        Text(
          movie.releaseDate,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 16,
              ),
        ),
      ],
    );
  }
}
