import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kaabo/presentation/providers/auth_provider.dart';
import 'package:kaabo/presentation/providers/review_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/review_model.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/localization_service.dart';
import '../../domain/entities/review_entity.dart';
import '../widgets/rating_widget.dart';

class ReviewPage extends ConsumerStatefulWidget {
  final String propertyId;
  final String? landlordId;
  final ReviewType reviewType;

  const ReviewPage({
    super.key,
    required this.propertyId,
    this.landlordId,
    required this.reviewType,
  });

  @override
  ConsumerState<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends ConsumerState<ReviewPage> {
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  double _rating = 0;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Text('write_review'.tr),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body:
          user == null
              ? const Center(child: Text('Please login to write a review'))
              : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.reviewType == ReviewType.property
                            ? 'Rate this property'
                            : 'Rate this landlord',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      RatingInput(
                        onRatingChanged: (rating) => _rating = rating,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _commentController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          labelText: 'Your Review',
                          hintText: 'Share your experience...',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Please write a review';
                          }
                          if (value!.length < AppConstants.minReviewLength) {
                            return 'Review must be at least ${AppConstants.minReviewLength} characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitReview,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Submit Review',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  void _submitReview() async {
    if (_formKey.currentState!.validate() && _rating > 0) {
      final user = ref.read(authStateProvider).value!;

      final review = ReviewModel(
        id: const Uuid().v4(),
        propertyId: widget.propertyId,
        landlordId: widget.landlordId,
        reviewerId: user.id,
        reviewerName: user.name,
        rating: _rating,
        comment: _commentController.text.trim(),
        createdAt: DateTime.now(),
        type: widget.reviewType,
      );

      await ref
          .read(reviewControllerProvider.notifier)
          .addReview(review.toEntity());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } else if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide a rating'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }
}
