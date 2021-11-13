import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/drawer/left_drawer.dart';
import 'package:simple_app/log_in/ui/login.dart';
import 'package:simple_app/model/user_model.dart';
import 'package:simple_app/update_profile/bloc/user_profile_update_bloc.dart';

class UserProfilUpdate extends StatefulWidget {
  const UserProfilUpdate({Key key}) : super(key: key);

  @override
  _UserProfilUpdateState createState() => _UserProfilUpdateState();
}

class _UserProfilUpdateState extends State<UserProfilUpdate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: BlocListener<UserProfileUpdateBloc, UserProfileUpdateState>(
        listener: (context, state) async {
          if (state.status.isSubmissionInProgress) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Submitting...'),
              ),
            );
          }
          if (state.status.isSubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('isSubmissionSuccess.'),
              ),
            );

            //if (mounted) Navigator.of(context).pop();

            if (mounted) {
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => const MyHomePage()),
              );
            }
          }
          if (state.status.isSubmissionFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('isSubmissionFailure.'),
              ),
            );

            // if (mounted) Navigator.of(context).pop();
            // if (mounted) {
            //   Navigator.pop(
            //     context,
            //     MaterialPageRoute(builder: (context) => Login()),
            //   );
            // }
          }
          if (state.status.isSubmissionCanceled) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('SubmissionCanceled.'),
              ),
            );
            // if (mounted) Navigator.of(context).pop();

            if (mounted) {
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            }
          }
        },
        child: Center(
          child: ListView(
            children: [
              _firstName(),
              _lastName(),
              _UserName(),
              Email(),
              Pssword(),
              const SaveButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserName extends StatelessWidget {
  SharedPreferences _prefer;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileUpdateBloc, UserProfileUpdateState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (BuildContext context, state) {
        var userNameController =
            TextEditingController(text: state.username ?? '');
        return Focus(
          onFocusChange: (isFocus) => context
              .read<UserProfileUpdateBloc>()
              .add(usernameChanged(userNameController.text)),
          child: TextField(
            controller: userNameController,
            key: const Key('signupForm_usernameInput_textField'),
            decoration: const InputDecoration(
              labelText: 'Username *',
            ),
          ),
        );
      },
    );
  }
}

class _firstName extends StatelessWidget {
  SharedPreferences _prefer;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileUpdateBloc, UserProfileUpdateState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (BuildContext context, state) {
        var firstNameController =
            TextEditingController(text: state.firstName ?? '');
        return Focus(
          onFocusChange: (isFocus) => context
              .read<UserProfileUpdateBloc>()
              .add(firstNameChanged(firstNameController.text)),
          child: TextField(
            controller: firstNameController,
            key: const Key('_firstNameInput_textField'),
            decoration: const InputDecoration(
              labelText: 'FirstName *',
            ),
          ),
        );
      },
    );
  }
}

class _lastName extends StatelessWidget {
  SharedPreferences _prefer;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileUpdateBloc, UserProfileUpdateState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (BuildContext context, state) {
        var lastNameController =
            TextEditingController(text: state.lastName ?? '');
        return Focus(
          onFocusChange: (isFocus) => context
              .read<UserProfileUpdateBloc>()
              .add(lastNameChanged(lastNameController.text)),
          child: TextField(
            controller: lastNameController,
            key: const Key('LastNameInput_textField'),
            decoration: const InputDecoration(
              labelText: 'LastName *',
            ),
          ),
        );
      },
    );
  }
}

class Email extends StatelessWidget {
  //final TextEditingController controllerEmail = TextEditingController();
  SharedPreferences _prefer;
  Email({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileUpdateBloc, UserProfileUpdateState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (BuildContext context, state) {
        var emailController = TextEditingController(text: state.email ?? '');
        return Focus(
          onFocusChange: (b) => context
              .read<UserProfileUpdateBloc>()
              .add(emailChanged(emailController.text)),
          child: TextField(
            controller: emailController,
            key: const Key('signupForm_emailAddressInput_textField'),
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email address *',
            ),
          ),
        );
      },
    );
  }
}

class Pssword extends StatelessWidget {
  SharedPreferences _prefer;
  Pssword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileUpdateBloc, UserProfileUpdateState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (BuildContext context, state) {
        var passwordController =
            TextEditingController(text: state.password ?? '');
        return Focus(
          child: TextField(
            onChanged: (value) => context
                .read<UserProfileUpdateBloc>()
                .add(passwordChanged(passwordController.text)),
            controller: passwordController,
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            key: const Key('signupForm_passwordInput_textField'),
            decoration: const InputDecoration(
              labelText: 'Password *',
            ),
          ),
        );
      },
    );
  }
}

class SaveButton extends StatefulWidget {
  const SaveButton({Key key}) : super(key: key);

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  UserModel userModel;
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserProfileUpdateBloc, UserProfileUpdateState>(
      buildWhen: (previous, current) => (previous.username != current.username),
      builder: (BuildContext context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            minimumSize: const Size(double.infinity, 45),
          ),
          onPressed: () {
            BlocProvider.of<UserProfileUpdateBloc>(context)
                .add(ProfileUpdateSubmitted());
          },
          child: const Text(
            'Submit',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 18.0),
          ),
        );
      },
    );
  }
}
