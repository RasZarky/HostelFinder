import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel_finder/modules/chat/widgets/category_selector.dart';
import 'package:hostel_finder/modules/chat/widgets/favorite_contacts.dart';
import 'package:hostel_finder/modules/chat/widgets/recent_chats.dart';

class ChatListScreen extends StatefulWidget {
  final AnimationController animationController;

  const ChatListScreen({Key? key, required this.animationController}) : super(key: key);

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        //leading: IconButton(icon: Icon(Icons.menu,), iconSize: 30.0,color: Colors.white, onPressed: (){}),
        automaticallyImplyLeading: false,
        title: Text("Chats",style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold),),
        elevation: 0.0,
        // actions: <Widget>[
        //   IconButton(icon: Icon(Icons.search,), iconSize: 30.0,color: Colors.white, onPressed: (){})
        // ],
      ),

      body: Column(
        children: <Widget>[
          //CategorySelector(),
          Expanded(child: Container(
            decoration: BoxDecoration(
                color: Color(0xFF262626),
                //borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30))
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  //FavoriteContacts(),
                  RecentChats(),
                ],
              ),
            ),
          ))
        ],
      ),
    );
  }
}
