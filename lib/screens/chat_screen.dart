import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/utilities/constants.dart';
import 'package:pick_flick/utilities/widgets.dart';
import 'package:pick_flick/screens/unique_chat_screen.dart';
import 'package:pick_flick/networks/firebase.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  List<dynamic> friendsNames;
  List<dynamic> ids;

  // Get current users fire store information
  _getFriendsData() async {
    await firestoreInstance
        .collection("users")
        .doc(firebaseUser.uid)
        .get()
        .then((snap) => {
              ids = snap["friends"],
            });
  }

  void initState() {
    _getFriendsData();
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Color(BACKGROUND_COLOR_1),
            Color(BACKGROUND_COLOR_2),
            Color(BACKGROUND_COLOR_3),
          ])),
      child: FutureBuilder(
        future: _getFriendsData(),
        builder: (context, snap) {
          switch (snap.connectionState) {
            case ConnectionState.active:
            case ConnectionState.waiting:
              return Loading();
            case ConnectionState.done:
              return Conversations(friends: ids);
            default:
              return Loading();
          }
        },
      ),
    );
  }
}

class Conversations extends StatelessWidget {
  final List<dynamic> friends;
  const Conversations({Key key, this.friends}) : super(key: key);

  _getName(String id) async {
    var name;
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection("users").doc(id).get().then(
            (snap) => {
          name = snap["name"],
        }
    );
    return name;
  }
  static const message = ['Where are you??', 'Spider man?', 'Send first message', 'what time did we say again?', 'Hello!', 'I LOVED that move!'];
  static const times = ['Yesterday', '1:30pm', 'May 18th', 'May 13th', '10:22am'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: friends.length,
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 16),
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, index) {
        return FutureBuilder(
          future: _getName(friends[index].toString()),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
              case ConnectionState.waiting:
                return Loading();
              case ConnectionState.done:
                return ConversationList(
                  id: friends[index],
                  name: snapshot.data.toString(),
                  messageText: message[index],
                  imageUrl: "hello",
                  time: times[index],
                  isMessageRead: (index == 0 || index == 3) ? true : false,
                );
              default:
                return Loading();
            }
          },
        );
      },
    );
  }
}

class ConversationList extends StatefulWidget {
  String id;
  String name;
  String messageText;
  String imageUrl;
  String time;
  bool isMessageRead;

  ConversationList(
      {@required this.id,
        @required this.name,
      @required this.messageText,
      @required this.imageUrl,
      @required this.time,
      @required this.isMessageRead});

  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  bool chatCheck = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        chatCreation(widget.id);
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return new UniqueChat(friendId: widget.id);
        }));
      },
      child: Container(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 20),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.black,
                    //backgroundImage: NetworkImage(widget.imageUrl),
                    maxRadius: 30,
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(widget.name, style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                          Text(
                            widget.messageText,
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey.shade400,
                                fontWeight: widget.isMessageRead
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(widget.time,
                style: TextStyle(fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }
}
