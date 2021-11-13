import 'package:flutter/material.dart';
import 'package:simple_app/model/user_model.dart';

class Welcome extends StatelessWidget {
  final UserModel user;

  Welcome({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile Update')),
      body: const Center(
        child: Text("WELCOME PAGE"),
      ),
    );
  }
}
