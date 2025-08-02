import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    final tUserEntity = UserEntity(
      id: '1',
      email: 'test@test.com',
      name: 'Test User',
      phone: '1234567890',
      type: UserType.tenant,
      createdAt: DateTime(2024, 1, 1),
      averageRating: 4.5,
      reviewCount: 10,
    );

    test('should be a subclass of Equatable', () {
      expect(tUserEntity, isA<UserEntity>());
    });

    test('should return correct props', () {
      expect(tUserEntity.props, [
        '1',
        'test@test.com',
        'Test User',
        '1234567890',
        UserType.tenant,
        DateTime(2024, 1, 1),
        4.5,
        10,
      ]);
    });

    test('should support equality comparison', () {
      final tUserEntity2 = UserEntity(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
        phone: '1234567890',
        type: UserType.tenant,
        createdAt: DateTime(2024, 1, 1),
        averageRating: 4.5,
        reviewCount: 10,
      );

      expect(tUserEntity, equals(tUserEntity2));
    });

    test('should have default values for optional parameters', () {
      final tUserEntityDefault = UserEntity(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
        phone: '1234567890',
        type: UserType.tenant,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(tUserEntityDefault.averageRating, equals(0.0));
      expect(tUserEntityDefault.reviewCount, equals(0));
    });
  });
}
