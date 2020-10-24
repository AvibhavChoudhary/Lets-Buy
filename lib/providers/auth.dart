import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:myshop/models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer _authtimer;

  FirebaseAuth auth = FirebaseAuth.instance;

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_expiryDate != null &&
        _expiryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> signUp(String email, String password) async {
    try {
      var user = await auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await user.user.getIdTokenResult().then((token) {
        _token = token.token;
        _expiryDate = token.expirationTime;
      });
      _userId = user.user.uid;
      print("$_token  x-x-x--x-x");
      print("$_expiryDate x--x-xx--x");
      print("$_userId x-x-x-x-x-");
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });
      prefs.setString("userData", userData);
    } on FirebaseAuthException catch (error) {
      print(error);
      if (error.code == "email-already-in-use") {
        throw HttpException(error.message.toString());
      }
      if (error.code == "invalid-email") {
        throw HttpException(error.message.toString());
      }
      if (error.code == "weak-password") {
        throw HttpException(error.message.toString());
      }
      if (error.code == "operation-not-allowed") {
        throw HttpException(error.message.toString());
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<void> logIn(String email, String password) async {
    try {
      var user = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      await user.user.getIdTokenResult().then((token) {
        _token = token.token;
        _expiryDate = token.expirationTime;
      });
      _userId = user.user.uid;
      print("$_token  x-x-x--x-x");
      print("$_expiryDate x--x-xx--x");
      print("$_userId x-x-x-x-x-");
      _autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDate.toIso8601String()
      });
      prefs.setString("userData", userData);
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        throw HttpException("Invalid email, Please enter a valid email");
      }
      if (error.code == "user-disabled") {
        throw HttpException("This account is disabled");
      }
      if (error.code == "user-not-found") {
        throw HttpException("User not found, Please enter valid credetials");
      }
      if (error.code == "wrong-password") {
        throw HttpException("Incorrect password");
      }
    } catch (error) {
      throw HttpException(error.toString());
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final data =
        json.decode(prefs.getString("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(data["expiryDate"]);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = data["token"];
    _userId = data["userId"];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoLogout();
    return true;
  }

  Future<void> logout() async {
    if (auth.currentUser != null) {
      if (_token != null || _userId != null) {
        _token = null;
        _userId = null;
        _expiryDate = null;
      }
      if (_authtimer != null) {
        _authtimer.cancel();
        _authtimer = null;
      }
      auth.signOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.clear();
    }
  }

  void _autoLogout() {
    if (_authtimer != null) {
      _authtimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authtimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}

//   Future<void> signUp(String email, String password) async {
//     try {
//       await auth
//           .createUserWithEmailAndPassword(email: email, password: password)
//           .catchError((error) {
//         print("noooo");
//         throw HttpException("Could not sign in");
//       }).then((user) {
//         print(user);
//       });
//     } catch (error) {
//       print("$error xxxx");
//       throw HttpException(error.toString());
//     }
//   }

//   Future<void> logIn(String email, String password) async {
//     try {
//       await auth
//           .signInWithEmailAndPassword(email: email, password: password)
//           .catchError((error) {
//         throw HttpException("Could not Log in");
//       }).then((user) {
//         print(user);
//       });
//     } catch (error) {
//       throw HttpException(error.toString());
//     }
//   }
// }
