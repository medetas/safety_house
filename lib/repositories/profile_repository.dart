import 'dart:async';

import 'package:safety_house/api/api.dart';
import 'package:safety_house/models/profile.dart';

class ProfileRepository {
  Future<ProfileModel> fetchProfile() async {
    try {
      final result = await APIRepository().fetchProfile();

      if (result.statusCode == 200) {
        return ProfileModel.fromMap(result.data['data']);
      } else {
        throw Exception('Error on fetchProfile: ${result.statusCode}');
      }
    } on Exception catch (e) {
      throw Exception('Error: $e');
    }
  }
}
