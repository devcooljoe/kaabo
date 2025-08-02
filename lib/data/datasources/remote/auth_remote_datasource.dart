import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../../domain/entities/user_entity.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn(String email, String password);
  Future<UserModel> signUp(UserModel user, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Stream<User?> authStateChanges();
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Wait a moment for Firebase to settle
      await Future.delayed(const Duration(milliseconds: 100));

      final doc =
          await _firestore.collection('users').doc(credential.user!.uid).get();
      if (!doc.exists) {
        throw Exception('User data not found');
      }

      final data = doc.data();
      if (data == null) {
        throw Exception('User data is null');
      }

      return UserModel.fromJson(Map<String, dynamic>.from(data));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp(UserModel user, String password) async {
    print('SignUp - Creating Firebase Auth user for: ${user.email}');
    
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: user.email,
      password: password,
    );
    
    print('SignUp - Firebase Auth user created: ${credential.user!.uid}');
    
    final newUser = user.copyWith(id: credential.user!.uid);
    print('SignUp - Saving user to Firestore: ${newUser.toJson()}');
    
    await _firestore.collection('users').doc(newUser.id).set(newUser.toJson());
    print('SignUp - User saved successfully to Firestore');
    
    return newUser;
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists || doc.data() == null) return null;

    final data = doc.data()!;
    if (data is! Map<String, dynamic>) return null;

    return UserModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}
