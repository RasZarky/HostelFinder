import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/utils/text_styles.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/modules/login/facebook_twitter_button_view.dart';
import 'package:hostel_finder/routes/route_names.dart';
import 'package:hostel_finder/utils/validator.dart';
import 'package:hostel_finder/widgets/common_appbar_view.dart';
import 'package:hostel_finder/widgets/common_button.dart';
import 'package:hostel_finder/widgets/common_text_field_view.dart';
import 'package:hostel_finder/widgets/remove_focuse.dart';

import '../../providers/fire_auth.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();
  String _errorFName = '';
  TextEditingController _fnameController = TextEditingController();
  String _errorLName = '';
  TextEditingController _lnameController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: RemoveFocuse(
          onClick: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _appBar(),
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
                      CommonTextFieldView(
                        controller: _fnameController,
                        errorText: _errorFName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: AppLocalizations(context).of("first_name"),
                        hintText:
                            AppLocalizations(context).of("enter_first_name"),
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _lnameController,
                        errorText: _errorLName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: AppLocalizations(context).of("last_name"),
                        hintText:
                            AppLocalizations(context).of("enter_last_name"),
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
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
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 24),
                        hintText:
                            AppLocalizations(context).of('enter_password'),
                        isObscureText: true,
                        onChanged: (String txt) {},
                        errorText: _errorPassword,
                        controller: _passwordController,
                      ),

                      const SizedBox(height: 15),

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

                      const SizedBox(height: 15),

                      CommonButton(
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 8),
                        buttonText: AppLocalizations(context).of("sign_up"),
                        onTap: () {
                          if (_allValidation()) {

                            setState(() {
                              isLoading = true;
                            });

                            try {
                              FireAuth.registerUsingEmailPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                                name: '$_fnameController + $_lnameController',

                              );

                              FirebaseAuth.instance.authStateChanges()
                                  .listen((User? user) {
                                if(user != null){
                                  databaseRef.child("users").child(_emailController
                                      .text.trim().replaceAll(RegExp('[^A-Za-z]'), '')).set({
                                    'first name': _fnameController.text.trim(),
                                    'last name': _lnameController.text.trim(),
                                    'email': _emailController.text.trim(),
                                  });
                                }
                              });

                              setState(() {
                                isLoading = false;
                              });

                              var snackBar = const SnackBar(
                                content: Text( "Account created successfully",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              NavigationServices(context).gotoTabScreen();
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "weak-password") {
                                print('The password provided is too weak.');
                                var snackBar = const SnackBar(
                                  content: Text( "The password provided is too weak",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              } else if (e.code == "email-already-in-use") {
                                print('An account already exists for that email.');
                                var snackBar = const SnackBar(
                                  content: Text( "An account already exist for that email",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              }
                            } catch (e) {
                              print(e);
                            }

                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          AppLocalizations(context).of("terms_agreed"),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            AppLocalizations(context)
                                .of("already_have_account"),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {
                              NavigationServices(context).gotoLoginScreen();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                AppLocalizations(context).of("login"),
                                style: TextStyles(context)
                                    .getRegularStyle()
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 24,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return CommonAppbarView(
      iconData: Icons.arrow_back,
      titleText: AppLocalizations(context).of("sign_up"),
      onBackClick: () {
        Navigator.pop(context);
      },
    );
  }

  bool _allValidation() {
    bool isValid = true;

    if (_fnameController.text.trim().isEmpty) {
      _errorFName = AppLocalizations(context).of('first_name_cannot_empty');
      isValid = false;
    } else {
      _errorFName = '';
    }

    if (_lnameController.text.trim().isEmpty) {
      _errorLName = AppLocalizations(context).of('last_name_cannot_empty');
      isValid = false;
    } else {
      _errorLName = '';
    }

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
