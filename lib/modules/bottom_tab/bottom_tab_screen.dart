import 'package:flutter/material.dart';
import 'package:hostel_finder/modules/explore/home_explore_screen.dart';
import 'package:hostel_finder/modules/myTrips/my_trips_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/modules/bottom_tab/components/tab_button_UI.dart';
import 'package:hostel_finder/widgets/common_card.dart';
import 'package:provider/provider.dart';

import '../chat/chat_list_screen.dart';
import '../map_view/pages/home_page.dart';
import '../profile/profile.dart';

class BottomTabScreen extends StatefulWidget {
  @override
  _BottomTabScreenState createState() => _BottomTabScreenState();
}

class _BottomTabScreenState extends State<BottomTabScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isFirstTime = true;
  Widget _indexView = Container();
  BottomBarType bottomBarType = BottomBarType.Explore;

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 400), vsync: this);
    _indexView = Container();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _startLoadScreen());
    super.initState();
  }

  Future _startLoadScreen() async {
    await Future.delayed(const Duration(milliseconds: 480));
    setState(() {
      _isFirstTime = false;
      _indexView = HomeExploreScreen(
        animationController: _animationController,
      );
    });
    _animationController..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (_, provider, child) => Container(
        child: Scaffold(
          bottomNavigationBar: Container(
              height: 60 + MediaQuery.of(context).padding.bottom,
              child: getBottomBarUI(bottomBarType)),
          body: _isFirstTime
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                )
              : _indexView,
        ),
      ),
    );
  }

  void tabClick(BottomBarType tabType) {
    if (tabType != bottomBarType) {
      bottomBarType = tabType;
      _animationController.reverse().then((f) {
        if (tabType == BottomBarType.Explore) {
          setState(() {
            _indexView = HomeExploreScreen(
              animationController: _animationController,
            );
          });
        }  else if (tabType == BottomBarType.Map) {
          setState(() {
            _indexView = const HomePage(

            );
          });
        }else if (tabType == BottomBarType.Trips) {
          setState(() {
            _indexView = MyTripsScreen(
              animationController: _animationController,
            );
          });
        }
        // else if (tabType == BottomBarType.Chats) {
        //   setState(() {
        //     _indexView = ChatListScreen(
        //       animationController: _animationController,
        //     );
        //   });
        // }
        else if (tabType == BottomBarType.Profile) {
          setState(() {
            _indexView = ProfileScreen(
              animationController: _animationController,
            );
          });
        }
      });
    }
  }

  Widget getBottomBarUI(BottomBarType tabType) {
    return CommonCard(
      color: AppTheme.backgroundColor,
      radius: 0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              TabButtonUI(
                icon: Icons.search,
                isSelected: tabType == BottomBarType.Explore,
                text: AppLocalizations(context).of("explore"),
                onTap: () {
                  tabClick(BottomBarType.Explore);
                },
              ),
              TabButtonUI(
                icon: Icons.map,
                isSelected: tabType == BottomBarType.Map,
                text: 'Map',
                onTap: () {
                  tabClick(BottomBarType.Map);
                },
              ),
              TabButtonUI(
                icon: FontAwesomeIcons.heart,
                isSelected: tabType == BottomBarType.Trips,
                text: AppLocalizations(context).of("trips"),
                onTap: () {
                  tabClick(BottomBarType.Trips);
                },
              ),
              // TabButtonUI(
              //   icon: FontAwesomeIcons.facebookMessenger,
              //   isSelected: tabType == BottomBarType.Chats,
              //   text: "Chats",
              //   onTap: () {
              //     tabClick(BottomBarType.Chats);
              //   },
              // ),
              TabButtonUI(
                icon: FontAwesomeIcons.user,
                isSelected: tabType == BottomBarType.Profile,
                text: AppLocalizations(context).of("profile"),
                onTap: () {
                  tabClick(BottomBarType.Profile);
                },
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).padding.bottom,
          )
        ],
      ),
    );
  }
}

enum BottomBarType { Explore, Trips, Profile, Map }
