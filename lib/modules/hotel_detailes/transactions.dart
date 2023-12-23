import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../payment/checkout.dart';



class Transactions extends StatefulWidget {
  const Transactions({super.key});

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {

  Query dbRef1 = FirebaseDatabase.instance.ref().child('bookings').orderByChild('status').equalTo('pending');
  Query dbRef2 = FirebaseDatabase.instance.ref().child('bookings').orderByChild('status').equalTo('processing');
  Query dbRef3 = FirebaseDatabase.instance.ref().child('bookings').orderByChild('status').equalTo('completed');

  User? user = FirebaseAuth.instance.currentUser;

  Widget listItem( {required Map pending}){
    return pending['user email'] == user?.email ? Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            pending['hostel'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const SizedBox(height: 2,),
          Text(
            pending['room'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            pending['duration']+' semester(s)',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            '${'GHC '+pending['price']} per semester',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            pending['user email'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
           Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){

                  FirebaseDatabase.instance.ref().child('bookings').child(pending['key']).remove();
                  var snackBar = const SnackBar(
                    content: Text( "Order Cancelled",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text(
                  'Cancel Order',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25,
                      backgroundColor: Colors.red),
                ),
              )
            ],
          )
        ],
      ),
    ) : Container() ;
  }

  Widget listItem2( {required Map processing}){
    return processing['user email'] == user?.email ? Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),


      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            processing['hostel'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const SizedBox(height: 2,),
          Text(
            processing['room'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            processing['duration']+' semester(s)',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            '${'GHC '+processing['price']} per semester',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            processing['user email'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: (){

                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => CheckoutPage()));

                },
                child: Text(
                  'Make Payment',
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 25,
                      backgroundColor: Colors.red),
                ),
              )
            ],
          )
        ],
      ),
    ) : Container();
  }

  Widget listItem3( {required Map completed}){
    return completed['user email'] == user?.email ? Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),


      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            completed['hostel'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          const SizedBox(height: 2,),
          Text(
            completed['room'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            completed['duration']+' semester(s)',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            '${'GHC '+completed['price']} per semester',
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),
          Text(
            completed['user email'],
            style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
          ),

        ],
      ),
    ) : Container();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(

          bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.pending_actions),
                  text: 'Pending',
                ),
                Tab(icon: Icon(Icons.update),
                  text: 'Processing',
                ),
                Tab(icon: Icon(Icons.done_all),
                  text: 'Completed',
                ),
              ]
          ),
          title: const Text('Bookings'),
        ),

        body: TabBarView(
          children: [
            Container(
              child: FirebaseAnimatedList(
                query: dbRef1,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

                  Map pending = snapshot.value as Map;
                  pending['key'] = snapshot.key;

                  return  listItem(pending: pending);
                },

              ),
            ),
            Container(
              child: FirebaseAnimatedList(
                query: dbRef2,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

                  Map processing = snapshot.value as Map;
                  processing['key'] = snapshot.key;

                  return  listItem2(processing: processing);
                },

              ),
            ),
            Container(
              child: FirebaseAnimatedList(
                query: dbRef3,
                itemBuilder: (BuildContext context, DataSnapshot snapshot, Animation<double> animation, int index) {

                  Map completed = snapshot.value as Map;
                  completed['key'] = snapshot.key;

                  return  listItem3(completed: completed);
                },

              ),
            ),
          ],
        ),
      ),
    );
  }
}
