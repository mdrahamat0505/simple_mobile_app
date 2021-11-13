import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/update_profile/ui/user_profile_update.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key key, this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    Future<void> logoutUser() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      //prefs?.clear();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => Login()),
      // );
      Navigator.of(context).pushReplacementNamed('/login');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
        ),
      ),
      body: const Center(
        child: Text(
          'A drawer is an invisible side screen.',
          style: TextStyle(fontSize: 20.0),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text("Rahamat Ullah"),
              accountEmail: Text("mdrahamat0505@gmail.com"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.orange,
                child: Text(
                  "R",
                  style: TextStyle(fontSize: 40.0),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.update),
              title: const Text("Update Profile "),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserProfilUpdate()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Settings"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text("Contact Us"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onTap: () {
                logoutUser();
              },
            ),
          ],
        ),
      ),
    );
  }
}
