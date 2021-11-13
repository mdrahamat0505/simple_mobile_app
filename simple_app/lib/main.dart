import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/drawer/left_drawer.dart';
import 'package:simple_app/log_in/bloc/login_bloc.dart';
import 'package:simple_app/log_in/ui/login.dart';
import 'package:simple_app/sign_up/bloc/sign_up_bloc.dart';
import 'package:simple_app/update_profile/bloc/user_profile_update_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SignUpBloc()),
        BlocProvider(create: (context) => LoginBloc()),
        BlocProvider(create: (context) => UserProfileUpdateBloc()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
        routes: <String, WidgetBuilder>{
          // Set routes for using the Navigator.
          '/home': (BuildContext context) => const MyHomePage(),
          '/login': (BuildContext context) => Login(),
        },
      ),
    );
  }
}
