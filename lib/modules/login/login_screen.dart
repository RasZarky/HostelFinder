import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/modules/bottom_tab/bottom_tab_screen.dart';
import 'package:hostel_finder/modules/login/facebook_twitter_button_view.dart';
import 'package:hostel_finder/routes/route_names.dart';
import 'package:hostel_finder/utils/validator.dart';
import 'package:hostel_finder/widgets/common_appbar_view.dart';
import 'package:hostel_finder/widgets/common_button.dart';
import 'package:hostel_finder/widgets/common_text_field_view.dart';
import 'package:hostel_finder/widgets/remove_focuse.dart';

import '../../providers/fire_auth.dart';
import '../../utils/themes.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RemoveFocuse(
        onClick: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CommonAppbarView(
              iconData: Icons.arrow_back,
              titleText: AppLocalizations(context).of("login"),
              onBackClick: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 32),
                    //   child: FacebookTwitterButtonView(),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.all(16.0),
                    //   child: Text(
                    //     AppLocalizations(context).of("log_with mail"),
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       fontWeight: FontWeight.w500,
                    //       color: Theme.of(context).disabledColor,
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 50,),

                    CommonTextFieldView(
                      controller: _emailController,
                      errorText: _errorEmail,
                      titleText: AppLocalizations(context).of("your_mail"),
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, bottom: 16),
                      hintText:
                          AppLocalizations(context).of("enter_your_email"),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String txt) {},
                    ),
                    CommonTextFieldView(
                      titleText: AppLocalizations(context).of("password"),
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      hintText: AppLocalizations(context).of("enter_password"),
                      isObscureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorPassword,
                      controller: _passwordController,
                    ),

                    Center(child: Visibility(visible: isLoading,
                      child: Stack(
                        children: [
                          Container(
                            alignment: AlignmentDirectional.center,
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppTheme.backgroundColor,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              width: 300.0,
                              height: 200.0,
                              alignment: AlignmentDirectional.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: SizedBox(
                                      height: 50.0,
                                      width: 50.0,
                                      child: CircularProgressIndicator(
                                        value: null,
                                        strokeWidth: 7.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 25),
                                    child: Center(
                                      child: Text(
                                        "Please wait ...",
                                        style: TextStyle(
                                            color: Colors.white
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),)),

                    _forgotYourPasswordUI(),
                    CommonButton(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      buttonText: AppLocalizations(context).of("login"),
                      onTap: () async {
                        if (_allValidation()) {

                          setState(() {
                            isLoading = true;
                          });

                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();

                          FirebaseAuth auth = FirebaseAuth.instance;
                          User? user;

                          try {
                            UserCredential userCredential = await auth.signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );
                            user = userCredential.user;
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              var snackBar = const SnackBar(
                                content: Text( "User not found",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided.');
                              var snackBar = const SnackBar(
                                content: Text( "Wrong password provided",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            }

                          }
                              // User? user = await FireAuth.signInUsingEmailPassword(
                              //     email: _emailController.text,
                              //     password: _passwordController.text,
                              //     context: context,
                              //   );
                          setState(() {
                            isLoading = false;
                          });
                              if (user != null) {
                                Navigator.of(context)
                                    .pushReplacement(
                                  MaterialPageRoute(builder: (context) => BottomTabScreen(
                                    // user: user
                                  )),
                                );
                              }

                        }

                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _forgotYourPasswordUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            onTap: () {
              NavigationServices(context).gotoForgotPassword();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                AppLocalizations(context).of("forgot_your_Password"),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty) {
      _errorEmail = AppLocalizations(context).of('email_cannot_empty');
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = AppLocalizations(context).of('enter_valid_email');
      isValid = false;
    } else {
      _errorEmail = '';
    }

    if (_passwordController.text.trim().isEmpty) {
      _errorPassword = AppLocalizations(context).of('password_cannot_empty');
      isValid = false;
    } else if (_passwordController.text.trim().length < 6) {
      _errorPassword = AppLocalizations(context).of('valid_password');
      isValid = false;
    } else {
      _errorPassword = '';
    }
    setState(() {});
    return isValid;
  }
}
