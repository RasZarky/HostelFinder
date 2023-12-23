import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/models/hotel_list_data.dart';
import 'package:hostel_finder/providers/theme_provider.dart';
import 'package:hostel_finder/utils/enum.dart';
import 'package:hostel_finder/utils/helper.dart';
import 'package:hostel_finder/utils/text_styles.dart';
import 'package:hostel_finder/utils/themes.dart';
import 'package:hostel_finder/widgets/common_card.dart';
import 'package:hostel_finder/widgets/list_cell_animation_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HotelListView extends StatelessWidget {
  final bool isShowDate;
  final VoidCallback callback;
  final Map hotelData;
  final AnimationController animationController;
  final Animation<double> animation;

  const HotelListView(
      {Key? key,
      required this.hotelData,
      required this.animationController,
      required this.animation,
      required this.callback,
      this.isShowDate = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListCellAnimationView(
      animation: animation,
      animationController: animationController,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
        child: Column(
          children: <Widget>[
            isShowDate
                ? const Padding(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text(
                        //   Helper.getDateText(hotelData.date!) + ', ',
                        //   style: TextStyles(context)
                        //       .getRegularStyle()
                        //       .copyWith(fontSize: 14),
                        // ),
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
                            hotelData['image'],
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
                                        hotelData['name'],
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
                                            hotelData['location'],
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
                                            hotelData['price'],
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
                                      const Padding(
                                        padding: EdgeInsets.only(top: 4),
                                      ),
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
                                    "GHC ${hotelData['price']}",
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
                              callback();
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
                            onTap: () {

                              final databaseRef = FirebaseDatabase.instance.ref();
                              User? user = FirebaseAuth.instance.currentUser;
                              String? userEmail = user?.email;

                              databaseRef.child("users").child(userEmail!.replaceAll(RegExp('[^A-Za-z]'), ''))
                                  .child('favorite').child(hotelData['key']).update({
                                'coordinates': hotelData['coordinates'],
                                'date': hotelData['date'],
                                'description': hotelData['description'],
                                'image': hotelData['image'],
                                'location': hotelData['location'],
                                'managerId': hotelData['managerId'],
                                'name': hotelData['name'],
                                'price': hotelData['price'],
                              });

                              var snackBar = const SnackBar(
                                content: Text( "Added to favourites",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 15),
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);

                            },
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
}
