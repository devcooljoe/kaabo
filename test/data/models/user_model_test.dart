import 'package:flutter_test/flutter_test.dart';
import 'package:kaabo/data/models/user_model.dart';
import 'package:kaabo/domain/entities/user_entity.dart';

void main() {
  final tUserModel = UserModel(
    id: '1',
    email: 'test@test.com',
    name: 'Test User',
    phone: '1234567890',
    type: UserType.tenant,
    createdAt: DateTime(2024, 1, 1),
    averageRating: 4.5,
    reviewCount: 10,
  );

  group('UserModel', () {
    test('should convert to entity correctly', () {
      final entity = tUserModel.toEntity();

      expect(entity.id, equals('1'));
      expect(entity.email, equals('test@test.com'));
      expect(entity.name, equals('Test User'));
      expect(entity.phone, equals('1234567890'));
      expect(entity.type, equals(UserType.tenant));
      expect(entity.createdAt, equals(DateTime(2024, 1, 1)));
      expect(entity.averageRating, equals(4.5));
      expect(entity.reviewCount, equals(10));
    });

    test('should return a valid model from JSON', () {
      final Map<String, dynamic> jsonMap = {
        'id': '1',
        'email': 'test@test.com',
        'name': 'Test User',
        'phone': '1234567890',
        'type': 'tenant',
        'createdAt': '2024-01-01T00:00:00.000',
        'averageRating': 4.5,
        'reviewCount': 10,
      };

      final result = UserModel.fromJson(jsonMap);

      expect(result.id, equals('1'));
      expect(result.email, equals('test@test.com'));
      expect(result.name, equals('Test User'));
    });

    test('should return a JSON map containing proper data', () {
      final result = tUserModel.toJson();

      expect(result['id'], equals('1'));
      expect(result['email'], equals('test@test.com'));
      expect(result['name'], equals('Test User'));
      expect(result['type'], equals('tenant'));
      expect(result['averageRating'], equals(4.5));
      expect(result['reviewCount'], equals(10));
    });

    test('should handle default values', () {
      final userModelDefault = UserModel(
        id: '1',
        email: 'test@test.com',
        name: 'Test User',
        phone: '1234567890',
        type: UserType.tenant,
        createdAt: DateTime(2024, 1, 1),
      );

      expect(userModelDefault.averageRating, equals(0.0));
      expect(userModelDefault.reviewCount, equals(0));
    });

    test('should support copyWith', () {
      final updatedModel = tUserModel.copyWith(name: 'Updated Name');

      expect(updatedModel.name, equals('Updated Name'));
      expect(updatedModel.id, equals('1'));
      expect(updatedModel.email, equals('test@test.com'));
    });
  });
}
