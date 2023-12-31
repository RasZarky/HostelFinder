import 'package:flutter/material.dart';
import 'package:hostel_finder/modules/chat/models/message_model.dart';
import 'package:hostel_finder/modules/chat/models/user_model.dart';

class ChatScreen extends StatefulWidget{
  ChatScreen({required this.user});
  User user;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ChatScreenState();
  }

}
class _ChatScreenState extends State<ChatScreen>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Color(0xFF262626),
appBar: AppBar(
  title: Text(widget.user.name,style: TextStyle(fontSize: 28.0,fontWeight: FontWeight.bold),),
  // actions: <Widget>[
  //   IconButton(icon: Icon(Icons.more_horiz,), iconSize: 30.0,color: Colors.white, onPressed: (){})
  // ],
  elevation: 0.0,
),
      body: GestureDetector(
        onTap: (){FocusScope.of(context).unfocus();},
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Color(0xFF262626),borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30))),
             child: ClipRRect(
               borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30),),
               child: Padding(
                 padding: const EdgeInsets.only(top: 20),
                 child: ListView.builder(
                   reverse: true,
                     itemCount: messages.length,
                     itemBuilder: (contx,index){
                   Message message=messages[index];
                   bool isMe=message.sender.id==currentUser.id;
                   return _buildMessages(message,isMe);
                 }),
               ),
             ),
              ),
            ),
            _buildComposer(),
          ],
        ),
      ),
    );
  }


   _buildMessages(Message message,isMe) {
     msg()
     {
       return Container(
         width: MediaQuery.of(context).size.width*.75,
         decoration: BoxDecoration(
             color: isMe?Color(0XFFF7F9F9):Color(0XFFFFEFEE),
             borderRadius: isMe? BorderRadius.only(topLeft: Radius.circular(15),bottomLeft: Radius.circular(15)): BorderRadius.only(topRight: Radius.circular(15),bottomRight: Radius.circular(15))
         ),
         margin: isMe?EdgeInsets.only(top: 8.0,bottom: 8.0,left: 80):EdgeInsets.only(top: 8.0,bottom: 8.0),
         padding:  const EdgeInsets.symmetric(horizontal: 25,vertical: 15),
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: <Widget>[
             Text(message.time,style: TextStyle(color: Colors.blueGrey,fontWeight: FontWeight.bold,fontSize: 10),),
             SizedBox(height: 10.0,),
             Text(message.text,style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold,fontSize: 12),),
           ],
         ),
       );
     }
     if(isMe)
       {
         return msg();
       }
    return Row(
      children: <Widget>[
        msg(),
       message.isLiked? IconButton(icon: Icon(Icons.favorite),color:Theme.of(context).primaryColor, onPressed: (){}):IconButton(icon: Icon(Icons.favorite_border,color: Colors.blueGrey,), onPressed: (){})
      ],
    );
   }

  _buildComposer() {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF262626),
       border: Border.all(color: Colors.grey,width: 1)
      ),

      height: 70,
      child: Row(
        children: <Widget>[
          IconButton(icon: Icon(Icons.camera_alt,color:Theme.of(context).primaryColor,size: 35,), onPressed: null),
          Expanded(child: TextField(

            decoration: InputDecoration.collapsed(hintText: "Write your message"),
          ),),
          IconButton(icon: Icon(Icons.send,color:Theme.of(context).primaryColor,size: 35), onPressed: null),
        ],
      ),
    );
  }

}