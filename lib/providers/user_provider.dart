import 'package:flutter/cupertino.dart';
import 'package:instagram_clone/resources/auth_method.dart';
import '../models/user.dart';

class UserProvider with ChangeNotifier{

  User? _user;
final AuthMethods authMethods=AuthMethods();
  User? get getUser => _user!;

  Future<void> refreshUser()async {
    User? user=await authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
}