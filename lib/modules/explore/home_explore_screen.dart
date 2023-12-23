import 'package:flutter/material.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/models/hotel_list_data.dart';
import 'package:hostel_finder/modules/explore/home_explore_slider_view.dart';
import 'package:hostel_finder/modules/explore/hotel_list_view_page.dart';
import 'package:hostel_finder/modules/explore/popular_list_view.dart';
import 'package:hostel_finder/modules/explore/title_view.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/routes/route_names.dart';
import 'package:hostel_finder/utils/enum.dart';
import 'package:hostel_finder/utils/text_styles.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/widgets/bottom_top_move_animation_view.dart';
import 'package:hostel_finder/widgets/common_button.dart';
import 'package:hostel_finder/widgets/common_card.dart';
import 'package:hostel_finder/widgets/common_search_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import '../../utils/helper.dart';
import '../../widgets/list_cell_animation_view.dart';
import '../hotel_detailes/hotel_detailes.dart';
import '../myTrips/my_trips_screen.dart';

class HomeExploreScreen extends StatefulWidget {
  final AnimationController animationController;

  const HomeExploreScreen({Key? key, required this.animationController})
      : super(key: key);
  @override
  _HomeExploreScreenState createState() => _HomeExploreScreenState();
}

class _HomeExploreScreenState extends State<HomeExploreScreen>
    with TickerProviderStateMixin {
  var hotelList = HotelListData.hotelList;
  late ScrollController controller;
  late AnimationController _animationController;
  var sliderImageHieght = 0.0;

  Query dbRef = FirebaseDatabase.instance.ref().child('hotels');

  Widget listItem( {required Map users}){
    var animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    return ListCellAnimationView(
      animation: animation,
      animationController: widget.animationController,
      child: Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: CommonCard(
          color: AppTheme.backgroundColor,
          child: ClipRRect(
            //   borderRadius: BorderRadius.all(Radius.circular(0.0)),
            child: AspectRatio(
              aspectRatio: 2.7,
              child: Stack(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      AspectRatio(
                        aspectRatio: 0.90,
                        child: Image.network(
                          users['image'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(
                              MediaQuery.of(context).size.width >= 360
                                  ? 12
                                  : 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                users['name'],
                                maxLines: 2,
                                textAlign: TextAlign.left,
                                style:
                                TextStyles(context).getBoldStyle().copyWith(
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                users['location'],
                                style: TextStyles(context)
                                    .getDescriptionStyle()
                                    .copyWith(
                                  fontSize: 14,
                                ),
                              ),
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.mapMarkerAlt,
                                                size: 12,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                              Text(
                                                " ${users['price']} ",
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyles(context)
                                                    .getDescriptionStyle()
                                                    .copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Expanded(
                                                child: Text(
                                                  AppLocalizations(context)
                                                      .of("km_to_city"),
                                                  overflow:
                                                  TextOverflow.ellipsis,
                                                  style: TextStyles(context)
                                                      .getDescriptionStyle()
                                                      .copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          //Helper.ratingStar(),
                                        ],
                                      ),
                                    ),
                                    FittedBox(
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.only(right: 8),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              "GHC ${users['price']}",
                                              textAlign: TextAlign.left,
                                              style: TextStyles(context)
                                                  .getBoldStyle()
                                                  .copyWith(fontSize: 18),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: context
                                                      .read<
                                                      ThemeProvider>()
                                                      .languageType ==
                                                      LanguageType.ar
                                                      ? 2.0
                                                      : 0.0),
                                              child: Text(
                                                AppLocalizations(context)
                                                    .of("per_night"),
                                                style: TextStyles(context)
                                                    .getDescriptionStyle()
                                                    .copyWith(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      highlightColor: Colors.transparent,
                      splashColor:
                      Theme.of(context).primaryColor.withOpacity(0.1),
                      onTap: () {
                        try {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HotelDetailes(hostelData: users,)),
                          );
                        } catch (e) {}
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    widget.animationController.forward();
    controller = ScrollController(initialScrollOffset: 0.0);
    controller
      ..addListener(() {
        if (mounted) {
          if (controller.offset < 0) {
            // we static set the just below half scrolling values
            _animationController.animateTo(0.0);
          } else if (controller.offset > 0.0 &&
              controller.offset < sliderImageHieght) {
            // we need around half scrolling values
            if (controller.offset < ((sliderImageHieght / 1.5))) {
              _animationController
                  .animateTo((controller.offset / sliderImageHieght));
            } else {
              // we static set the just above half scrolling values "around == 0.64"
              _animationController
                  .animateTo((sliderImageHieght / 1.5) / sliderImageHieght);
            }
          }
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    sliderImageHieght = MediaQuery.of(context).size.width * 1.3;
    return BottomTopMoveAnimationView(
      animationController: widget.animationController,
      child: Consumer<ThemeProvider>(
        builder: (context, provider, child) => Stack(
          children: <Widget>[
            Container(
              color: AppTheme.scaffoldBackgroundColor,
              child: ListView.builder(
                controller: controller,
                itemCount: 4,
                // padding on top is only for we need spec for sider
                padding:
                    EdgeInsets.only(top: sliderImageHieght + 32, bottom: 16),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  // some list UI
                  var count = 4;
                  var animation = Tween(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: widget.animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  if (index == 0) {
                    return TitleView(
                      titleTxt: '',
                      subTxt: '',
                      animation: animation,
                      animationController: widget.animationController,
                      click: () {},
                    );
                  } else if (index == 1) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      //Popular Destinations animation view
                      // child: PopularListView(
                      //   animationController: widget.animationController,
                      //   callBack: (index) {},
                      // ),
                    );
                  } else if (index == 2) {
                    return TitleView(
                      titleTxt: AppLocalizations(context).of("best_deal"),
                      subTxt: AppLocalizations(context).of("view_all"),
                      animation: animation,
                      isLeftButton: true,
                      animationController: widget.animationController,
                      click: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyTripsScreen(animationController: _animationController,)),
                        );
                        //NavigationServices(context).gotoHotelHomeScreen();
                      },
                    );
                  } else {
                    return getDealListView(index);
                  }
                },
              ),
            ),
            // sliderUI with 3 images are moving
            _sliderUI(),

            // viewHotels Button UI for click event
            _viewHotelsButton(_animationController),

            //just gradient for see the time and battry Icon on "TopBar"
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  colors: [
                    Theme.of(context).backgroundColor.withOpacity(0.4),
                    Theme.of(context).backgroundColor.withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
              ),
            ),
            //   serachUI on Top  Positioned
            // Positioned(
            //   top: MediaQuery.of(context).padding.top,
            //   left: 0,
            //   right: 0,
            //   child: serachUI(),
            // )
          ],
        ),
      ),
    );
  }

  Widget _viewHotelsButton(AnimationController _animationController) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (BuildContext context, Widget? child) {
        var opecity = 1.0 -
            (_animationController.value > 0.64
                ? 1.0
                : _animationController.value);
        return Positioned(
          left: 0,
          right: 0,
          top: 0,
          height: sliderImageHieght * (1.0 - _animationController.value),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 32,
                left: context.read<ThemeProvider>().languageType ==
                        LanguageType.ar
                    ? null
                    : 24,
                right: context.read<ThemeProvider>().languageType ==
                        LanguageType.ar
                    ? 24
                    : null,
                child: Opacity(
                  opacity: opecity,
                  child: CommonButton(
                    onTap: () {
                      if (opecity != 0) {
                        NavigationServices(context).gotoHotelHomeScreen();
                      }
                    },
                    buttonTextWidget: Padding(
                      padding: const EdgeInsets.only(
                          left: 24, right: 24, top: 8, bottom: 8),
                      child: Text(
                        AppLocalizations(context).of("view_hotel"),
                        style: TextStyles(context)
                            .getRegularStyle()
                            .copyWith(color: AppTheme.whiteColor),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sliderUI() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          // we calculate the opecity between 0.64 to 1.0
          var opecity = 1.0 -
              (_animationController.value > 0.64
                  ? 1.0
                  : _animationController.value);
          return SizedBox(
            height: sliderImageHieght * (1.0 - _animationController.value),
            child: HomeExploreSliderView(
              opValue: opecity,
              click: () {},
            ),
          );
        },
      ),
    );
  }

  Widget getDealListView(int index) {
    return SizedBox(
        width: double.infinity,
        child: Container(
          height: 500,
          child: FirebaseAnimatedList(
            query: dbRef,
            itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

              Map users = snapshot.value as Map;
              users['key'] = snapshot.key;

              return  listItem(users: users);
            },

          ),
        )
    );
    // return Padding(
    //   padding: const EdgeInsets.only(top: 8),
    //   child: Column(
    //     children: list,
    //   ),
    // );
  }

  Widget serachUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 16),
      child: CommonCard(
        radius: 36,
        child: InkWell(
          borderRadius: BorderRadius.all(Radius.circular(38)),
          onTap: () {
            NavigationServices(context).gotoSearchScreen();
          },
          child: CommonSearchBar(
            iconData: FontAwesomeIcons.search,
            enabled: false,
            text: AppLocalizations(context).of("where_are_you_going"),
          ),
        ),
      ),
    );
  }
}
