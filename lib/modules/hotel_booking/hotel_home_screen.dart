import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/modules/hotel_booking/components/filter_bar_UI.dart';
import 'package:hostel_finder/modules/hotel_booking/components/map_and_list_view.dart';
import 'package:hostel_finder/modules/hotel_booking/components/time_date_view.dart';
import 'package:hostel_finder/modules/myTrips/hotel_list_view.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/routes/route_names.dart';
import 'package:hostel_finder/utils/enum.dart';
import 'package:hostel_finder/utils/text_styles.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/widgets/common_card.dart';
import 'package:hostel_finder/widgets/common_search_bar.dart';
import 'package:hostel_finder/widgets/remove_focuse.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../models/hotel_list_data.dart';
import 'package:provider/provider.dart';

import '../../utils/helper.dart';
import '../../widgets/list_cell_animation_view.dart';

class HotelHomeScreen extends StatefulWidget {
  @override
  _HotelHomeScreenState createState() => _HotelHomeScreenState();
}

class _HotelHomeScreenState extends State<HotelHomeScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController _animationController;
  var hotelList = HotelListData.hotelList;
  ScrollController scrollController = new ScrollController();
  int room = 1;
  int ad = 2;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(Duration(days: 5));
  bool _isShowMap = false;

  final searchBarHieght = 158.0;
  final filterBarHieght = 52.0;

  Query dbRef = FirebaseDatabase.instance.ref().child('hotels');

  Widget listItem( {required Map users}){
    var animation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    bool isShowDate = false;

    return ListCellAnimationView(
      animation: animation,
      animationController: animationController,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: Column(
          children: <Widget>[
            isShowDate
                ? Padding(
              padding: const EdgeInsets.only(top: 12, bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    users['date'] + ', ',
                    style: TextStyles(context)
                        .getRegularStyle()
                        .copyWith(fontSize: 14),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 2.0),
                  //   child: Text(
                  //     Helper.getRoomText(hotelData.roomData!),
                  //     style: TextStyles(context)
                  //         .getRegularStyle()
                  //         .copyWith(fontSize: 14),
                  //   ),
                  // ),
                ],
              ),
            )
                : SizedBox(),
            CommonCard(
              color: AppTheme.backgroundColor,
              radius: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16.0)),
                child: Stack(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        AspectRatio(
                          aspectRatio: 2,
                          child: Image.network(
                            users['image'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, top: 8, bottom: 8, right: 8),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        users['name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyles(context)
                                            .getBoldStyle()
                                            .copyWith(fontSize: 22),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            users['location'],
                                            style: TextStyles(context)
                                                .getDescriptionStyle(),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(
                                            FontAwesomeIcons.mapMarkerAlt,
                                            size: 12,
                                            color:
                                            Theme.of(context).primaryColor,
                                          ),
                                          Text(
                                            "${users['price']}",
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyles(context)
                                                .getDescriptionStyle(),
                                          ),
                                          Expanded(
                                            child: Text(
                                              AppLocalizations(context)
                                                  .of("km_to_city"),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyles(context)
                                                  .getDescriptionStyle(),
                                            ),
                                          ),
                                        ],
                                      ),
                                      // Padding(
                                      //   padding: const EdgeInsets.only(top: 4),
                                      //   child: Row(
                                      //     children: <Widget>[
                                      //       Helper.ratingStar(),
                                      //       Text(
                                      //         users['review'],
                                      //         style: TextStyles(context)
                                      //             .getDescriptionStyle(),
                                      //       ),
                                      //       Text(
                                      //         AppLocalizations(context)
                                      //             .of("reviews"),
                                      //         style: TextStyles(context)
                                      //             .getDescriptionStyle(),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: 16, top: 8, left: 16),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    "GHC ${users['price']}",
                                    textAlign: TextAlign.left,
                                    style: TextStyles(context)
                                        .getBoldStyle()
                                        .copyWith(fontSize: 22),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: context
                                            .read<ThemeProvider>()
                                            .languageType ==
                                            LanguageType.ar
                                            ? 2.0
                                            : 0.0),
                                    child: Text(
                                      AppLocalizations(context).of("per_night"),
                                      style: TextStyles(context)
                                          .getDescriptionStyle(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      bottom: 0,
                      left: 0,
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor:
                          Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.all(
                            Radius.circular(16.0),
                          ),
                          onTap: () {
                            try {
                              NavigationServices(context)
                                           .gotoRoomBookingScreen(
                                               users['name']);
                            } catch (e) {}
                          },
                        ),
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).backgroundColor,
                            shape: BoxShape.circle),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(
                              Radius.circular(32.0),
                            ),
                            onTap: () {},
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.favorite_border,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    animationController = AnimationController(
        duration: Duration(milliseconds: 1000), vsync: this);
    _animationController =
        AnimationController(duration: Duration(milliseconds: 0), vsync: this);
    scrollController.addListener(() {
      if (scrollController.offset <= 0) {
        _animationController.animateTo(0.0);
      } else if (scrollController.offset > 0.0 &&
          scrollController.offset < searchBarHieght) {
        // we need around searchBarHieght scrolling values in 0.0 to 1.0
        _animationController
            .animateTo((scrollController.offset / searchBarHieght));
      } else {
        _animationController.animateTo(1.0);
      }
    });
    super.initState();
  }

  Future<bool> getData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          RemoveFocuse(
            onClick: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: <Widget>[
                _getAppBarUI(),
                _isShowMap
                    ? MapAndListView(
                        hotelList: hotelList,
                        searchBarUI: _getSearchBarUI(),
                      )
                    : Expanded(
                        child: Stack(
                          children: <Widget>[
                            // Container(
                            //   color: AppTheme.scaffoldBackgroundColor,
                            //     child:
                            //     // Container(
                            //     //   //height: 500,
                            //     //   child: FirebaseAnimatedList(
                            //     //     query: dbRef,
                            //     //     itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {
                            //     //
                            //     //       Map users = snapshot.value as Map;
                            //     //       users['key'] = snapshot.key;
                            //     //
                            //     //       return  listItem(users: users);
                            //     //     },
                            //     //
                            //     //   ),
                            //     // ),
                            //   ListView.builder(
                            //     controller: scrollController,
                            //     itemCount: hotelList.length,
                            //     padding: EdgeInsets.only(
                            //       top: 20 + 52.0,
                            //     ),
                            //     scrollDirection: Axis.vertical,
                            //     itemBuilder: (context, index) {
                            //       var count = hotelList.length > 10
                            //           ? 10
                            //           : hotelList.length;
                            //       var animation = Tween(begin: 0.0, end: 1.0)
                            //           .animate(CurvedAnimation(
                            //               parent: animationController,
                            //               curve: Interval(
                            //                   (1 / count) * index, 1.0,
                            //                   curve: Curves.fastOutSlowIn)));
                            //       animationController.forward();
                            //       return HotelListView(
                            //         callback: () {
                            //           NavigationServices(context)
                            //               .gotoRoomBookingScreen(
                            //                   hotelList[index].titleTxt);
                            //         },
                            //         hotelData: hotelList[index],
                            //         animation: animation,
                            //         animationController: animationController,
                            //       );
                            //     },
                            //   ),
                            // ),
                            AnimatedBuilder(
                              animation: _animationController,
                              builder: (BuildContext context, Widget? child) {
                                return Positioned(
                                  top: -searchBarHieght *
                                      (_animationController.value),
                                  left: 0,
                                  right: 0,
                                  child: Column(
                                    children: <Widget>[
                                      Container(
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        child: Column(
                                          children: <Widget>[
                                            //hotel search view
                                            _getSearchBarUI(),
                                            // time date and number of rooms view
                                            //TimeDateView(),
                                          ],
                                        ),
                                      ),
                                      //hotel price & facilitate  & distance
                                      //FilterBarUI(),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.only(right: 8, top: 8, bottom: 8, left: 8),
              child: CommonCard(
                color: AppTheme.backgroundColor,
                radius: 36,
                child: CommonSearchBar(
                  enabled: true,
                  ishsow: false,
                  text: "Hostel name...",
                ),
              ),
            ),
          ),
          CommonCard(
            color: AppTheme.primaryColor,
            radius: 36,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  NavigationServices(context).gotoSearchScreen();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 20, color: AppTheme.backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAppBarUI() {
    return Padding(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top, left: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            alignment:
                context.read<ThemeProvider>().languageType == LanguageType.ar
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                AppLocalizations(context).of("explore"),
                style: TextStyles(context).getTitleStyle(),
              ),
            ),
          ),
          Container(
            width: AppBar().preferredSize.height + 40,
            height: AppBar().preferredSize.height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                // Material(
                //   color: Colors.transparent,
                //   child: InkWell(
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(32.0),
                //     ),
                //     onTap: () {},
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Icon(Icons.favorite_border),
                //     ),
                //   ),
                // ),
                // Material(
                //   color: Colors.transparent,
                //   child: InkWell(
                //     borderRadius: BorderRadius.all(
                //       Radius.circular(32.0),
                //     ),
                //     onTap: () {
                //       setState(() {
                //         _isShowMap = !_isShowMap;
                //       });
                //     },
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: Icon(_isShowMap
                //           ? Icons.sort
                //           : FontAwesomeIcons.mapMarkedAlt),
                //     ),
                //   ),
                // ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
