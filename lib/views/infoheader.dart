import 'package:flutter/material.dart';
import '../model/userdata.dart';

class Infoheader extends StatelessWidget {
  Infoheader({super.key, required this.userdata});
  final Userdata userdata;

  final followTxtStyle = const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [Text('Followers'), Text('Following'), Text('Posts')],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(userdata.myUserAccount.numFollowers, style: followTxtStyle),
            Text(userdata.myUserAccount.numFollowing, style: followTxtStyle),
            Text(userdata.myUserAccount.numPosts, style: followTxtStyle),
          ],
        ),
        const SizedBox(height: 10),
        const Divider(color: Colors.grey),
      ],
    );
  }
}