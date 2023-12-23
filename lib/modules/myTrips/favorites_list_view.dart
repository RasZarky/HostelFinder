import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/modules/explore/hotel_list_view_page.dart';
import 'package:hostel_finder/routes/route_names.dart';
import '../../models/hotel_list_data.dart';

class FavoritesListView extends StatefulWidget {
  final AnimationController animationController;

  const FavoritesListView({Key? key, required this.animationController})
      : super(key: key);
  @override
  _FavoritesListViewState createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  var hotelList = HotelListData.hotelList;

  @override
  void initState() {
    widget.animationController.forward();
    super.initState();
  }
  
  //User? user = FirebaseAuth.instance.currentUser;
  
  Query dbRef = FirebaseDatabase.instance.ref().child('users').child(FirebaseAuth.instance.currentUser!.email.toString()
  .replaceAll(RegExp('[^A-Za-z]'), '')).child('favorite');

  Widget listItem( {required Map rooms}){

    var animation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 1.0, curve: Curves.fastOutSlowIn)));
    widget.animationController.forward();

    return HotelListViewPage(
                callback: () {
                  NavigationServices(context)
                      .gotoRoomBookingScreen(rooms['name']);
                },
                hotelData: rooms,
                animation: animation,
                animationController: widget.animationController,
              );

  }
  
  @override
  Widget build(BuildContext context) {
    return FirebaseAnimatedList(
        query: dbRef,
        itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

      Map rooms = snapshot.value as Map;
      rooms['key'] = snapshot.key;

      return  listItem(rooms: rooms);
    });
    //   Container(
    //   child: ListView.builder(
    //     itemCount: hotelList.length,
    //     padding: EdgeInsets.only(top: 8, bottom: 8),
    //     scrollDirection: Axis.vertical,
    //     itemBuilder: (context, index) {
    //       var count = hotelList.length > 10 ? 10 : hotelList.length;
    //       var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //           parent: widget.animationController,
    //           curve: Interval((1 / count) * index, 1.0,
    //               curve: Curves.fastOutSlowIn)));
    //       widget.animationController.forward();
    //       //Favorites hotel data list and UI View
    //       return HotelListViewPage(
    //         callback: () {
    //           NavigationServices(context)
    //               .gotoRoomBookingScreen(hotelList[index].titleTxt);
    //         },
    //         hotelData: hotelList[index],
    //         animation: animation,
    //         animationController: widget.animationController,
    //       );
    //     },
    //   ),
    // );
  }
}
