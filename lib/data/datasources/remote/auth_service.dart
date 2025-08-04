import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:kaabo/domain/entities/user_entity.dart';

import '../../../data/models/user_model.dart';

@injectable
class AuthService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AuthService(this._auth, this._firestore);

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signUp({
    required String email,
    required String password,
    required String name,
    required String phone,
    required UserType type,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        final user = UserModel(
          id: credential.user!.uid,
          email: email,
          name: name,
          phone: phone,
          type: type,
          createdAt: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(credential.user!.uid)
            .set(user.toJson());

        return user;
      }
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
    return null;
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Authentication successful
      return await getCurrentUserData();
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<UserModel?> getCurrentUserData() async {
    if (currentUser == null) return null;

    try {
      final doc =
          await _firestore.collection('users').doc(currentUser!.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return UserModel.fromJson(data);
      }
    } catch (e) {
      throw Exception('Failed to get user data: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
