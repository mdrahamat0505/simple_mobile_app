import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/drawer/left_drawer.dart';
import 'package:simple_app/log_in/bloc/login_bloc.dart';
import 'package:simple_app/sign_up/ui/sign_up.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();

    context.read<LoginBloc>().emit(const LoginState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log In'),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Login successful'),
              ),
            );
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          }
          if (state.status.isSubmissionInProgress) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Submitting...'),
              ),
            );
            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          }
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('isSubmissionFailure.'),
              ),
            );

            Navigator.pop(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePage()),
            );
          } else {
            Fluttertoast.showToast(
              msg: 'Username or password is invalid',
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red,
              textColor: Colors.white,
            );
            // Navigator.pop(
            //   context,
            //   MaterialPageRoute(builder: (context) => const MyHomePage()),
            // );
          }
        },
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              _userName(),
              const SizedBox(
                height: 10,
              ),
              _password(),
              const SizedBox(
                height: 10,
              ),
              _loginButton(),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Don"t have an account? '),
                        const SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp()),
                            );
                          },
                          child: Row(
                            children: const [
                              Text(
                                'Sign Up',
                                style: TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: Colors.blue,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _userName extends StatelessWidget {
  SharedPreferences _prefer;
  String oldUsername;

  @override
  Widget build(BuildContext context) {
    try {
      oldUsername = _prefer.getString('USERNAME') ?? '';
      context.read<LoginBloc>().add(LoginUsernameChanged(oldUsername ?? ''));
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Not found old username',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (context, state) {
        return TextFormField(
          // initialValue: oldUsername,
          key: const Key('usernameInput_textField'),
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Username',
          ),
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(value)),
        );
      },
    );
  }
}

class _password extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      key: const Key('passwordInput_textField'),
      decoration: const InputDecoration(
        labelText: 'Password',
      ),
      onChanged: (value) =>
          context.read<LoginBloc>().add(LoginPasswordChanged(value)),
    );
  }
}

class _loginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(45),
                  primary: Colors.blue,
                ),
                key: const Key('loginForm_button'),
                onPressed: () {
                  if (state.status.isSubmissionSuccess) {
                    context.read<LoginBloc>().add(const submitted());
                  } else {
                    Fluttertoast.showToast(
                      msg: 'Username or password is invalid',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                child: const Text(
                  'Log In',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
