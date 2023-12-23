import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_finder/modules/hotel_detailes/transactions.dart';
import 'package:hostel_finder/modules/profile/widgets/profile_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../login/login_screen.dart';
import 'constants.dart';

class ProfileScreen extends StatefulWidget {
   final AnimationController animationController;

  const ProfileScreen({super.key, required this.animationController});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);

    var profileInfo = Expanded(
      child: Column(
        children: <Widget>[
          Container(
            height: kSpacingUnit.w * 10,
            width: kSpacingUnit.w * 10,
            margin: EdgeInsets.only(top: kSpacingUnit.w * 3),
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  radius: kSpacingUnit.w * 5,
                  backgroundImage: const AssetImage('assets/images/profile_pic.png'),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: kSpacingUnit.w * 2.5,
                    width: kSpacingUnit.w * 2.5,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      heightFactor: kSpacingUnit.w * 1.5,
                      widthFactor: kSpacingUnit.w * 1.5,
                      child: Icon(
                        Icons.edit,
                        color: kDarkPrimaryColor,
                        size: ScreenUtil().setSp(kSpacingUnit.w * 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Text(
            'Name here',
            style: kTitleTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 0.5),
          Text(
            'ntohhh@gmail.com',
            style: kCaptionTextStyle,
          ),
          SizedBox(height: kSpacingUnit.w * 2),
          Container(
            height: kSpacingUnit.w * 4,
            width: kSpacingUnit.w * 20,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kSpacingUnit.w * 3),
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Center(
              child: Text(
                '',
                style: kButtonTextStyle,
              ),
            ),
          ),
        ],
      ),
    );


    var header = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(width: kSpacingUnit.w * 3),

        profileInfo,
        //themeSwitcher,
        SizedBox(width: kSpacingUnit.w * 3),
      ],
    );


    return Scaffold(
      body: Column(
        children: <Widget>[
          SizedBox(height: kSpacingUnit.w * 5),
          header,
          Expanded(
            child: ListView(
              children: <Widget>[

                GestureDetector(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const Transactions(),
                        ),
                    );
                  },
                  child: ProfileListItem(
                    icon: Icons.history,
                    text: 'Booking History',
                  ),
                ),
                ProfileListItem(
                  icon: Icons.question_mark_rounded,
                  text: 'Help & Support',
                ),
                ProfileListItem(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
                ProfileListItem(
                  icon: Icons.supervised_user_circle,
                  text: 'Invite a Friend',
                ),
                GestureDetector(
                  onTap: (){
                    FirebaseAuth.instance.signOut();
                    FirebaseAuth.instance.authStateChanges()
                        .listen((User? user) {
                      if(user == null){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (c) => LoginScreen(),
                            ),
                            result: (Route<dynamic> route ) => false
                        );
                      }
                    });
                  },
                  child: ProfileListItem(
                    icon: Icons.logout_rounded,
                    text: 'Logout',
                    hasNavigation: false,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );

  }
}
