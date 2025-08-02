import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:kaabo/presentation/providers/review_provider.dart';

import '../../domain/entities/review_entity.dart';
import 'rating_widget.dart';

class ReviewsListWidget extends ConsumerWidget {
  final String propertyId;
  final String? landlordId;
  final ReviewType reviewType;

  const ReviewsListWidget({
    super.key,
    required this.propertyId,
    this.landlordId,
    required this.reviewType,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reviewsAsync =
        reviewType == ReviewType.property
            ? ref.watch(propertyReviewsProvider(propertyId))
            : landlordId != null
            ? ref.watch(landlordReviewsProvider(landlordId!))
            : const AsyncValue.data(<ReviewEntity>[]);

    return reviewsAsync.when(
      data:
          (reviews) =>
              reviews.isEmpty
                  ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text('No reviews yet'),
                    ),
                  )
                  : ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: reviews.length,
                    separatorBuilder: (context, index) => const Divider(),
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return ReviewCard(review: review);
                    },
                  ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error: $error')),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final ReviewEntity review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text(
                  review.reviewerName.substring(0, 1).toUpperCase(),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('MMM dd, yyyy').format(review.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              RatingWidget(
                rating: review.rating,
                reviewCount: 0,
                showText: false,
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(fontSize: 14, height: 1.4),
          ),
        ],
      ),
    );
  }
}
