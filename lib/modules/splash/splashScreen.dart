import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/utils/localfiles.dart';
import 'package:hostel_finder/utils/text_styles.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/routes/route_names.dart';
import 'package:hostel_finder/widgets/common_button.dart';
import 'package:provider/provider.dart';

import '../bottom_tab/bottom_tab_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoadText = false;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) =>
        _loadAppLocalizations()); // call after first frame receiver so we have context
    super.initState();

    bool isChecking = true;

    Center(child: Visibility(visible: isChecking,
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
      ),));

    User? user = FirebaseAuth.instance.currentUser;
    if(user != null){
      Future.delayed(Duration.zero, (){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (c) => BottomTabScreen(),
            ),
            result: (Route<dynamic> route ) => false
        );
      });

    }

    setState((){
      isChecking = false;
    });

  }

  Future<void> _loadAppLocalizations() async {
    try {
      //load all text json file to allLanguageTextData(in common file)
      //   await AppLocalizations.init(context);
      setState(() {
        isLoadText = true;
      });
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = Provider.of<ThemeProvider>(context);
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(
              foregroundDecoration: !appTheme.isLightMode
                  ? BoxDecoration(
                      color: Theme.of(context).backgroundColor.withOpacity(0.4))
                  : null,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.asset(Localfiles.introduction, fit: BoxFit.cover),
            ),
            Column(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
                Center(
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: Theme.of(context).dividerColor,
                            offset: Offset(1.1, 1.1),
                            blurRadius: 10.0),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      child: Image.asset(Localfiles.appIcon),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Hostel Finder",
                  textAlign: TextAlign.left,
                  style: TextStyles(context).getBoldStyle().copyWith(
                        fontSize: 24,
                      ),
                ),
                SizedBox(
                  height: 8,
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 420),
                  child: Text(
                    AppLocalizations(context).of("best_hotel_deals"),
                    textAlign: TextAlign.left,
                    style: TextStyles(context).getRegularStyle().copyWith(),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: SizedBox(),
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 680),
                  child: CommonButton(
                    padding: const EdgeInsets.only(
                        left: 48, right: 48, bottom: 8, top: 8),
                    buttonText: AppLocalizations(context).of("get_started"),
                    onTap: () {
                      NavigationServices(context).gotoIntroductionScreen();
                    },
                  ),
                ),
                AnimatedOpacity(
                  opacity: isLoadText ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 1200),
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: 24.0 + MediaQuery.of(context).padding.bottom,
                        top: 16),
                    child: Text(
                      AppLocalizations(context).of("already_have_account"),
                      textAlign: TextAlign.left,
                      style: TextStyles(context).getDescriptionStyle().copyWith(
                            color: AppTheme.whiteColor,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
