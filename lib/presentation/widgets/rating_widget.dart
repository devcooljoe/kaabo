import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../core/utils/localization_service.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int reviewCount;
  final bool showText;
  final double size;

  const RatingWidget({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.showText = true,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        RatingBarIndicator(
          rating: rating,
          itemBuilder: (context, index) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          itemCount: 5,
          itemSize: size,
          direction: Axis.horizontal,
        ),
        if (showText) ...[
          const SizedBox(width: 4),
          Text(
            '${rating.toStringAsFixed(1)} ($reviewCount ${'reviews'.tr})',
            style: TextStyle(
              fontSize: size * 0.8,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ],
    );
  }
}

class RatingInput extends StatefulWidget {
  final Function(double) onRatingChanged;
  final double initialRating;

  const RatingInput({
    super.key,
    required this.onRatingChanged,
    this.initialRating = 0,
  });

  @override
  State<RatingInput> createState() => _RatingInputState();
}

class _RatingInputState extends State<RatingInput> {
  late double _rating;

  @override
  void initState() {
    super.initState();
    _rating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'rating'.tr,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        RatingBar.builder(
          initialRating: _rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            setState(() => _rating = rating);
            widget.onRatingChanged(rating);
          },
        ),
        const SizedBox(height: 4),
        Text(
          _getRatingText(_rating),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 4.5) return 'Excellent';
    if (rating >= 3.5) return 'Very Good';
    if (rating >= 2.5) return 'Good';
    if (rating >= 1.5) return 'Fair';
    return 'Poor';
  }
}