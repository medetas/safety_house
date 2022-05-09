import 'package:flutter/material.dart';
import 'package:safety_house/models/profile.dart';
import 'package:safety_house/repositories/profile_repository.dart';
import 'package:safety_house/widgets/loading_view.dart';
import 'package:safety_house/widgets/page_error.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileModel userInfo;
  const ProfileScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(30),
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.person,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                '${userInfo.surname} ${userInfo.name} ${userInfo.patronymic}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.email,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                '${userInfo.email}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.edit_notifications,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                userInfo.notification == '2'
                    ? 'Уведомления включены'
                    : 'Уведомления выключены',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
