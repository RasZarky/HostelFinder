import 'package:hostel_finder/modules/chat/models/user_model.dart';

class Message{
  final User sender;
  final String time;
  final String text;
  final bool isLiked;
  final bool unread;

  Message({required this.sender,required this.time,required this.text,
    required this.isLiked,required this.unread});
}

//You Current User
final User currentUser=User(
  id:0,
  name: 'Current User',
  imageUrl: 'assets/images/user0.png'
);

final User user1=User(id:1,name:'Blck Window',imageUrl: 'assets/black.jpg');

final User user2=User(id:2,name:'Hulk',imageUrl: 'assets/hulk.jpg');
final User user3=User(id:3,name:'Captain America',imageUrl: 'assets/captain.jpg');
final User user4=User(id:4,name:'Iron Man',imageUrl: 'assets/ironman.jpg');
final User user5=User(id:5,name:'Thor',imageUrl: 'assets/thor.jpg');

List<User>favorite=[user1,user2,user3,user4,user5];

List<Message>chats=[
  Message(sender:user1,time:'5:30 PM',text: 'Hey, how\'s it going? What did you do today?',isLiked:false,unread:true),
  Message(sender:user2,time:'3:30 PM',text: 'Hey, how\'s it going? What did you do today?',isLiked:false,unread:false),
  Message(sender:user3,time:'1:30 PM',text: 'Hey, how\'s it going? What did you do today?',isLiked:true,unread:true),
  Message(sender:user1,time:'2:30 AM',text: 'Hey, how\'s it going? What did you do today?',isLiked:false,unread:true),
  Message(sender:user1,time:'2:00 PM',text: 'Hey, how\'s it going? What did you do today?',isLiked:false,unread:true),
];

//Example Messages
List<Message>messages=[
  Message(sender:user1,time:'5:30 PM',text: 'Hey, how\'s it going? What did you do today?',isLiked:true,unread:true),
  Message(sender:currentUser,time:'4:30 PM',text: 'Just walked my doge. She was super duper',isLiked:false,unread:true),
  Message(sender:user1,time:'1:30 PM',text: 'How is the doggo?',isLiked:true,unread:true),
  Message(sender:currentUser,time:'2:30 AM',text: 'All the food',isLiked:false,unread:true),
  Message(sender:user1,time:'2:30 PM',text:'Nice, What kind of food you eat?',isLiked:false,unread:true),
  Message(sender:currentUser,time:'2:00 AM',text:'I ate so much of food today',isLiked:false,unread:true),
];

