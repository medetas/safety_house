import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:safety_house/api/api.dart';

class AuthRepository {
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> attemptAutoLogin() async {
    try {
      final token = await storage.read(key: 'accessToken');
      return token;
    } catch (e) {
      throw e;
    }
  }

  Future login({
    required String username,
    required String password,
  }) async {
    try {
      final result = await APIRepository().logIn(
        username: username.trim(),
        password: password.trim(),
      );
      // final result = await Amplify.Auth.signIn(
      //   username: username.trim(),
      //   password: password.trim(),
      // );
      if (result.statusCode == 200) {
        await storage.write(
            key: 'accessToken', value: result.data['data']['token']);
        return result.data['data']['token'];
      } else {
        return null;
      }
      // return result.isSignedIn ? (await _getUserIdFromAttributes()) : null;
    } catch (e) {
      throw e;
    }
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String surname,
    required String name,
    required String username,
  }) async {
    // final options =
    //     CognitoSignUpOptions(userAttributes: {'email': email.trim()});
    try {
      // final result = await Amplify.Auth.signUp(
      //   username: username.trim(),
      //   password: password.trim(),
      //   options: options,
      // );
      final result = await APIRepository().signUp(
        email: email.trim(),
        password: password.trim(),
        name: name.trim(),
        surname: surname.trim(),
        username: username.trim(),
      );

      if (result.statusCode == 200) {
        // await storage.write(
        //     key: 'accessToken', value: result.data['data']['token']);
        // return result.data['data']['token'];
        return true;
      } else {
        return false;
      }
      // return result.isSignUpComplete;
    } catch (e) {
      throw e;
    }
  }

  // Future<bool> signUp({
  //   @required String username,
  //   @required String email,
  //   @required String password,
  // }) async {
  //   final options =
  //       CognitoSignUpOptions(userAttributes: {'email': email.trim()});
  //   try {
  //     final result = await Amplify.Auth.signUp(
  //       username: username.trim(),
  //       password: password.trim(),
  //       options: options,
  //     );
  //     return result.isSignUpComplete;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  // Future<bool> confirmSignUp({
  //   @required String username,
  //   @required String confirmationCode,
  // }) async {
  //   try {
  //     final result = await Amplify.Auth.confirmSignUp(
  //       username: username.trim(),
  //       confirmationCode: confirmationCode.trim(),
  //     );
  //     return result.isSignUpComplete;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<void> signOut() async {
    await storage.deleteAll();
    // await Amplify.Auth.signOut();
  }
}
