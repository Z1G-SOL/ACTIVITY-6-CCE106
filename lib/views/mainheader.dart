import 'package:flutter/material.dart';

import '../model/userdata.dart';

class Mainheader extends StatelessWidget {
  const Mainheader({super.key, required this.userdata});

  final Userdata userdata;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage(userdata.myUserAccount.img),
          radius: 40,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            userdata.myUserAccount.name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ),
        Text(userdata.myUserAccount.email),
        const SizedBox(height: 20),
      ],
    );
  }
}