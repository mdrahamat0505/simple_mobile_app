import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/log_in/ui/login.dart';
import 'package:simple_app/model/user_model.dart';
import 'package:simple_app/sign_up/bloc/sign_up_bloc.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  UserModel userModel;
  SharedPreferences _prefer;
  @override
  void initState() {
    super.initState();
    userModel = UserModel();
    context.read<SignUpBloc>().emit(const SignUpState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: BlocListener<SignUpBloc, SignUpState>(
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
                MaterialPageRoute(builder: (context) => Login()),
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
            if (mounted) {
              Navigator.pop(
                context,
                MaterialPageRoute(builder: (context) => Login()),
              );
            }
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
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.username != current.username,
      builder: (BuildContext context, state) {
        return Focus(
          onFocusChange: (isFocus) => context
              .read<SignUpBloc>()
              .add(usernameChanged(usernameController.text)),
          child: TextField(
            controller: usernameController,
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
  final TextEditingController firstNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.firstName != current.firstName,
      builder: (BuildContext context, state) {
        return Focus(
          onFocusChange: (isFocus) => context
              .read<SignUpBloc>()
              .add(firstNameChanged(firstNameController.text)),
          child: TextField(
            controller: firstNameController,
            key: const Key('firstNameInput_textField'),
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
  final TextEditingController lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.lastName != current.lastName,
      builder: (BuildContext context, state) {
        return Focus(
          onFocusChange: (isFocus) => context
              .read<SignUpBloc>()
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
  final TextEditingController controllerEmail = TextEditingController();

  Email({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (BuildContext context, state) {
        return Focus(
          onFocusChange: (b) => context
              .read<SignUpBloc>()
              .add(emailChanged(controllerEmail.text)),
          child: TextField(
            controller: controllerEmail,
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
  final TextEditingController controllerPassword = TextEditingController();

  Pssword({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (BuildContext context, state) {
        return Focus(
          child: TextField(
            onChanged: (value) => context
                .read<SignUpBloc>()
                .add(passwordChanged(controllerPassword.text)),
            controller: controllerPassword,
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
  SharedPreferences _prefer;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => (previous.username != current.username),
      builder: (BuildContext context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            minimumSize: const Size(double.infinity, 45),
          ),
          onPressed: () async {
            final userName = state.username;
            final email = state.email;
            try {
              _prefer.setString('USERNAME', state.username) as String;
              _prefer.setString('email', state.email) as String;
            } catch (e) {}
            if (userName != null || email != null) {
              BlocProvider.of<SignUpBloc>(context).add(Submitted());
            } else {
              Fluttertoast.showToast(
                  msg: 'Required fields(*) must be filled with valid data',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.CENTER,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
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

// class _UsernameInput extends StatelessWidget {
//   final TextEditingController usernameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SignupBloc, SignupState>(
//       buildWhen: (previous, current) => previous.username != current.username,
//       builder: (BuildContext context, state) {
//         return Focus(
//           onFocusChange: (isFocus) => context.read<SignupBloc>().add(SignupUsernameChanged(usernameController.text)),
//           child: TextField(
//             controller: usernameController,
//             key: const Key('signupForm_usernameInput_textField'),
//             decoration: InputDecoration(
//               labelText: 'Username *',
//               errorText: state.username.invalid ? "Username can't be empty" : null,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// class _SubmitButton extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<SignupBloc, SignupState>(
//       buildWhen: (previous, current) =>
//       (previous.status != current.status) || (previous.checkTermsAndConditions != current.checkTermsAndConditions),
//       builder: (BuildContext context, state) {
//         return ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             primary: AppColors.appBarColor,
//             minimumSize: const Size(double.infinity, 45),
//           ),
//           onPressed: () async {
//             final bool isValid = context.read<SignupBloc>().validate();
//             if (isValid && state.status.isValidated) {
//               if (state.checkTermsAndConditions && state.status.isValid) {
//                 final fullName = state.fullName.value;
//                 final userName = state.username.value;
//                 final mobile = state.mobile.value;
//                 final email = state.email.value;
//                 if (fullName != '' && userName != '' && mobile != '' && email != '') {
//                   BlocProvider.of<SignupBloc>(context).add(RequestForOtp());
//                   SignupProcessDialogManage(context);
//                 } else {
//                   PopMessage(message: 'Required fields(*) must be filled with valid data', context: context);
//                 }
//               } else {
//                 PopMessage(message: 'Terms & conditions is required.', context: context);
//               }
//             } else {
//               PopMessage(message: 'Required fields(*) must be filled with valid data', context: context);
//             }
//           },
//           child: const Text(
//             'Submit',
//             style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18.0),
//           ),
//         );
//       },
//     );
//   }
// }
//

/*
import 'package:flutter/material.dart';
import 'package:simple_app/model/user_model.dart';
import 'package:simple_app/service/api_service.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';
import 'package:snippet_coder_utils/hex_color.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  static final GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  bool isApiCallProcess = false;
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  UserModel userModel;

  @override
  void initState() {
    super.initState();
    userModel = new UserModel();
  }

  @override
  Widget build(BuildContext context) {
    return new SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[200],
        key: _scaffoldKey,
        body: ProgressHUD(
          child: loginUISetup(),
          inAsyncCall: isApiCallProcess,
          opacity: 0.3,
        ),
      ),
    );
  }

  Widget loginUISetup() {
    return new SingleChildScrollView(
      child: new Container(
        child: new Form(
          key: globalFormKey,
          child: _loginUI(context),
        ),
      ),
    );
  }

  Widget _loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height / 3.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [HexColor("#3f517e"), HexColor("#182545")],
              ),
              borderRadius: BorderRadius.only(
                // topLeft: Radius.circular(500),
                //topRight: Radius.circular(150),
                bottomRight: Radius.circular(150),
                //bottomLeft: Radius.circular(150),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Align(
                  alignment: Alignment.center,
                  child: Image.network(
                    "https://avatars.githubusercontent.com/u/64971583?s=460&u=ccc349dd8eaafbfa73533c3316d7d729ec223e9b&v=4",
                    fit: BoxFit.contain,
                    width: 140,
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20, top: 40),
              child: Text(
                "User Signup",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
          ),
          FormHelper.inputFieldWidget(
            context,
            const Icon(Icons.verified_user),
            "name",
            "Username",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Username can\'t be empty.';
              }

              return null;
            },
            (onSavedVal) => {
              this.userModel.userName = onSavedVal.toString().trim(),
            },
            initialValue: "",
            paddingBottom: 20,
            onChange: (val) {},
          ),
          FormHelper.inputFieldWidget(
            context,
            Icon(Icons.email),
            "name",
            "Email Id",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Email can\'t be empty.';
              }

              bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(onValidateVal);

              if (!emailValid) {
                return 'Email Invalid!';
              }

              return null;
            },
            (onSavedVal) => {
              this.userModel.email = onSavedVal.toString().trim(),
            },
            initialValue: "",
            paddingBottom: 20,
          ),
          FormHelper.inputFieldWidget(
            context,
            Icon(Icons.lock),
            "password",
            "Password",
            (onValidateVal) {
              if (onValidateVal.isEmpty) {
                return 'Password can\'t be empty.';
              }

              return null;
            },
            (onSavedVal) => {
              this.userModel.password = onSavedVal.toString().trim(),
            },
            initialValue: "",
            obscureText: hidePassword,
            suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  hidePassword = !hidePassword;
                });
              },
              color: Colors.redAccent.withOpacity(0.4),
              icon: Icon(
                hidePassword ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            paddingBottom: 20,
            onChange: (val) {
              this.userModel.password = val;
            },
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: FormHelper.inputFieldWidget(
              context,
              Icon(Icons.lock),
              "confirmpassword",
              "Confirm Password",
              (onValidateVal) {
                if (onValidateVal.isEmpty) {
                  return 'Confirm Password can\'t be empty.';
                }

                if (this.userModel.password != this.userModel.confirmPassword) {
                  return 'Password Mismatched!';
                }

                return null;
              },
              (onSavedVal) => {
                this.userModel.confirmPassword = onSavedVal.toString().trim(),
              },
              initialValue: "",
              obscureText: hideConfirmPassword,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    hideConfirmPassword = !hideConfirmPassword;
                  });
                },
                color: Colors.redAccent.withOpacity(0.4),
                icon: Icon(
                  hideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                ),
              ),
              onChange: (val) {
                this.userModel.confirmPassword = val;
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          new Center(
            child: FormHelper.submitButton(
              "Register",
              () {
                if (validateAndSave()) {
                  setState(() {
                    this.isApiCallProcess = true;
                  });

                  APIServices.registerUser(this.userModel)
                      .then((UserResponseModel response) {
                    setState(() {
                      this.isApiCallProcess = false;
                    });
                    if (response.code == 200) {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "Wordpress Register",
                        response.message,
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    } else {
                      FormHelper.showSimpleAlertDialog(
                        context,
                        "Wordpress Register",
                        response.message,
                        "Ok",
                        () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  });
                }
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
*/
