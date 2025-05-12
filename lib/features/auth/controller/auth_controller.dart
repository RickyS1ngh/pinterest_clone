import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/core/providers/firebase_providers.dart';
import 'package:pinterest_clone/core/utils.dart';
import 'package:pinterest_clone/features/auth/repository/auth_repository.dart';
import 'package:pinterest_clone/models/user.dart';

final currentUserProvider = StateProvider<UserModel?>(
    (ref) => null); //sets current state of user to null

final authControllerProvider = StateNotifierProvider<AuthController, UserModel>(
    (ref) => AuthController(ref.read(authRepositoryProvider), ref));

class AuthController extends StateNotifier<UserModel> {
  AuthController(AuthRepository authRepository, Ref ref)
      : _authRepository = authRepository,
        _ref = ref,
        super(UserModel(email: '', uid: ''));
  final AuthRepository _authRepository;
  final Ref _ref;

  Future<bool> googleSignIn(BuildContext context) async {
    final user = await _authRepository.googleSignIn();
    return user.fold((l) {
      showSnackBar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<bool> signUpWithEmail(
      BuildContext context, String email, String password) async {
    final user = await _authRepository.signUpWithEmail(email, password);
    return user.fold((l) {
      showSnackBar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  Future<void> facebookSignIn(BuildContext context) async {}
  Future<void> appleSignIn(BuildContext context) async {}
  Future<bool> loginWithEmail(
      BuildContext context, String email, String password) async {
    final user = await _authRepository.loginWithEmail(email, password);
    return user.fold((l) {
      showSnackBar(context, l.errorMessage);
      return false;
    }, (user) {
      _ref.read(currentUserProvider.notifier).state = user;
      return true;
    });
  }

  void loadCachedUser() {
    if (_ref.read(currentUserProvider.notifier).state == null) {
      _ref.read(currentUserProvider.notifier).state =
          _authRepository.loadCachedUser();
    }
  }

  bool isCachedUser() {
    return _authRepository.isCachedUser();
  }
}
