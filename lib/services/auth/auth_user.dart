import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/cupertino.dart';

@immutable
class AuthUser {
  const AuthUser(this.isEmailVerified);
  final bool isEmailVerified;

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);
}
