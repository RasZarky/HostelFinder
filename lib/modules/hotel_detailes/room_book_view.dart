import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/language/appLocalizations.dart';
import 'package:hostel_finder/models/hotel_list_data.dart';
import 'package:hostel_finder/utils/helper.dart';
import 'package:hostel_finder/utils/text_styles.dart';
import 'package:hostel_finder/widgets/common_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class RoomeBookView extends StatefulWidget {
  final Map roomData;
  final AnimationController animationController;
  final Animation<double> animation;

  const RoomeBookView(
      {Key? key,
      required this.roomData,
      required this.animationController,
      required this.animation})
      : super(key: key);

  @override
  _RoomeBookViewState createState() => _RoomeBookViewState(roomData: roomData);
}

class _RoomeBookViewState extends State<RoomeBookView> {

  final Map roomData;
  _RoomeBookViewState( {required this.roomData});

  var pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    //List<String> images = widget.roomData['image1'];
    return AnimatedBuilder(
      animation: widget.animationController,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.animation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 40 * (1.0 - widget.animation.value), 0.0),
            child: Column(
              children: <Widget>[
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1.5,
                      child: PageView(
                        controller: pageController,
                        pageSnapping: true,
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          // for (var image in images)
                            Image.network(
                              roomData['image1'],
                              fit: BoxFit.cover,
                            ),
                          Image.network(
                            roomData['image2'],
                            fit: BoxFit.cover,
                          ),
                          Image.network(
                            roomData['image3'],
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SmoothPageIndicator(
                        controller: pageController, // PageController
                        count: 3,
                        effect: WormEffect(
                            activeDotColor: Theme.of(context).primaryColor,
                            dotColor: Theme.of(context).backgroundColor,
                            dotHeight: 10.0,
                            dotWidth: 10.0,
                            spacing: 5.0), // your preferred effect
                        onDotClicked: (index) {},
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 16, top: 16),
                  child: Column(
                    children: <Widget>[
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            roomData['name'],
                            maxLines: 2,
                            textAlign: TextAlign.left,
                            style: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 24),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Expanded(child: SizedBox()),
                          SizedBox(
                            height: 38,
                            child: CommonButton(
                              onTap: (){

                                final databaseRef = FirebaseDatabase.instance.ref();
                                User? user = FirebaseAuth.instance.currentUser;
                                String? userEmail = user?.email;
                                showDialog(context: context, builder: (BuildContext context){
                                  return SimpleDialog(
                                    title: const Text('Select booking period'),
                                    children: [
                                      SimpleDialogOption(
                                        onPressed: (){
                                          databaseRef.child("bookings").child(userEmail!.replaceAll(RegExp('[^A-Za-z]'), '')+
                                          roomData['name']).set({
                                            'user email': user?.email,
                                            'room': roomData['name'],
                                            'price': roomData['price'],
                                            'duration': '1',
                                            'status': 'pending',
                                            'manager': roomData['managerId'],
                                            'hostel': roomData['hostel']
                                          });

                                          var snackBar = const SnackBar(
                                            content: Text( "Booking successful",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Text('One Semester'),
                                        ),
                                      ),
                                      SimpleDialogOption(
                                        onPressed: (){
                                          databaseRef.child("bookings").child(userEmail!.replaceAll(RegExp('[^A-Za-z]'), '')+
                                              roomData['name']).set({
                                            'user email': user?.email,
                                            'room': roomData['name'],
                                            'price': roomData['price'],
                                            'duration': '2',
                                            'status': 'pending',
                                            'manager': roomData['managerId'],
                                            'hostel': roomData['hostel']
                                          });

                                          var snackBar = const SnackBar(
                                            content: Text( "Booking successful",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Text('Two semesters'),
                                        ),
                                      ),
                                      SimpleDialogOption(
                                        onPressed: (){
                                          databaseRef.child("bookings").child(userEmail!.replaceAll(RegExp('[^A-Za-z]'), '')+
                                              roomData['name']).set({
                                            'user email': user?.email,
                                            'room': roomData['name'],
                                            'price': roomData['price'],
                                            'duration': '3',
                                            'status': 'pending',
                                            'manager': roomData['managerId'],
                                            'hostel': roomData['hostel']
                                          });

                                          var snackBar = const SnackBar(
                                            content: Text( "Booking successful",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Text('Three semesters'),
                                        ),
                                      ),
                                      SimpleDialogOption(
                                        onPressed: (){
                                          databaseRef.child("bookings").child(userEmail!.replaceAll(RegExp('[^A-Za-z]'), '')+
                                              roomData['name']).set({
                                            'user email': user?.email,
                                            'room': roomData['name'],
                                            'price': roomData['price'],
                                            'duration': '4',
                                            'status': 'pending',
                                            'manager': roomData['managerId'],
                                            'hostel': roomData['hostel']
                                          });

                                          var snackBar = const SnackBar(
                                            content: Text( "Booking successful",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          );
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(18.0),
                                          child: Text('Four semesters'),
                                        ),
                                      ),
                                    ],
                                  );
                                });

                              },
                              buttonTextWidget: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0, top: 4, bottom: 4),
                                child: Text(
                                  AppLocalizations(context).of("book_now"),
                                  textAlign: TextAlign.center,
                                  style: TextStyles(context).getRegularStyle(),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "GHC "+roomData['price'],
                            textAlign: TextAlign.left,
                            style: TextStyles(context)
                                .getBoldStyle()
                                .copyWith(fontSize: 22),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 0),
                            child: Text(
                              AppLocalizations(context).of("per_night"),
                              style: TextStyles(context)
                                  .getRegularStyle()
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            roomData['people']+' in a room',
                            // "${widget.roomData.dateTxt}",
                            textAlign: TextAlign.left,
                            style: TextStyles(context).getDescriptionStyle(),
                          ),
                          // InkWell(
                          //   borderRadius:
                          //       BorderRadius.all(Radius.circular(4.0)),
                          //   onTap: () {},
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(left: 8, right: 4),
                          //     child: Row(
                          //       mainAxisSize: MainAxisSize.min,
                          //       mainAxisAlignment: MainAxisAlignment.center,
                          //       crossAxisAlignment: CrossAxisAlignment.center,
                          //       children: <Widget>[
                          //         GestureDetector(
                          //           onTap: (){
                          //
                          //           },
                          //           child: Text(
                          //             AppLocalizations(context)
                          //                 .of("more_details"),
                          //             style: TextStyles(context).getBoldStyle(),
                          //           ),
                          //         ),
                          //         Padding(
                          //           padding: const EdgeInsets.only(top: 2),
                          //           child: Icon(
                          //             Icons.keyboard_arrow_down,
                          //             // color: Theme.of(context).backgroundColor,
                          //             size: 24,
                          //           ),
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  height: 1,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
