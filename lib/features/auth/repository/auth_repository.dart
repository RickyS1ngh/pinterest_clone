import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';
import 'package:pinterest_clone/core/failure.dart';
import 'package:pinterest_clone/core/providers/firebase_providers.dart';
import 'package:pinterest_clone/core/typedef.dart';
import 'package:pinterest_clone/models/user.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
    ref.read(authProvider),
    ref.read(fireStoreProvider),
    ref.read(googleSignInProvider)));

class AuthRepository {
  const AuthRepository(FirebaseAuth auth, FirebaseFirestore firestore,
      GoogleSignIn google_sign_in)
      : _auth = auth,
        _firestore = firestore,
        _google_sign_in = google_sign_in;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _google_sign_in;

  EitherUser<UserModel> googleSignIn() async {
    try {
      final userBox = Hive.box('user');
      final GoogleSignInAccount? googleUser = await _google_sign_in.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser!.authentication;

      final credential = GoogleAuthProvider.credential(
          idToken: googleAuth!.idToken, accessToken: googleAuth.accessToken);

      final userCredential = await _auth.signInWithCredential(credential);
      UserModel user;

      if (userCredential.additionalUserInfo!.isNewUser) {
        user = UserModel(
            email: userCredential.user!.email ?? '',
            uid: userCredential.user!.uid);
        await _firestore
            .collection('Users')
            .doc(userCredential.user!.uid)
            .set(user.toMap());
      } else {
        user = await getUser(userCredential.user!.uid);
      }
      userBox.put('user', user);
      return right(userBox.get('user'));
    } on FirebaseAuthException catch (error) {
      return left(Failure(error.message!));
    }
  }

  EitherUser<UserModel> loginWithEmail(String email, String password) async {
    try {
      final userBox = Hive.box('user');
      final userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      UserModel user = await getUser(userCredential.user!.uid);
      userBox.put('user', user);
      return right(userBox.get('user'));
    } on FirebaseAuthException catch (error) {
      return left(Failure(error.message!));
    }
  }

  UserModel loadCachedUser() {
    final userBox = Hive.box('user');
    return userBox.get('user');
  }

  Future<UserModel> getUser(String id) {
    return _firestore
        .collection('Users')
        .doc(id)
        .snapshots()
        .map((user) => UserModel.fromMap(user.data() as Map<String, dynamic>))
        .first;
  }
}
