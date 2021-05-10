import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_flick/utilities/widgets.dart';
import 'package:pick_flick/networks/firebase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UniqueChat extends StatefulWidget {
  final String friendId;

  const UniqueChat({Key key, this.friendId,}) : super(key: key);

  @override
  _UniqueChatState createState() => _UniqueChatState();
}

class _UniqueChatState extends State<UniqueChat> {

  bool friendsChat = false;
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser = FirebaseAuth.instance.currentUser;
  TextEditingController controller = new TextEditingController();
  List<dynamic> messages;
  ScrollController _scrollController = ScrollController();

  void initState(){
    super.initState();
    _check();
  }

  void dispose(){
    controller.dispose();
    super.dispose();
  }

  _check() async{
    DocumentSnapshot ds = await firestoreInstance.collection("ChatRoom").doc(widget.friendId + "_" + firebaseUser.uid).get();
    this.setState(() {
      friendsChat = ds.exists;
    });
  }
  _getMessages() async {
    if(friendsChat == false) {
      await firestoreInstance
          .collection("ChatRoom")
          .doc(firebaseUser.uid + "_" + widget.friendId)
          .get()
          .then((snap) =>
      {
        messages = snap["messages"],
      });
    }else{
      await firestoreInstance
          .collection("ChatRoom")
          .doc(widget.friendId + "_" + firebaseUser.uid)
          .get()
          .then((snap) =>
      {
        messages = snap["messages"],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Color(0xFF14575d),
        title: Text("Chat Screen"),
      ),
      body: Stack(
        children: <Widget>[
          BackgroundBuilder(),
          FutureBuilder(
            future: _getMessages(),
            builder: (context, snap){
              switch(snap.connectionState){
                case ConnectionState.active:
                case ConnectionState.waiting:
                  return Loading();
                case ConnectionState.done:
                  return ListView.builder(
                    itemCount: messages.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context, index){
                      return Container(
                        padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
                        child: Align(
                          alignment: (messages[index]['sender'] != firebaseUser.uid?Alignment.topLeft:Alignment.topRight),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: (messages[index]['sender'] != firebaseUser.uid?Colors.grey.shade200:Colors.blue[200]),
                            ),
                            padding: EdgeInsets.all(16),
                            child: Text(messages[index]["messageContent"], style: TextStyle(fontSize: 15),),
                          ),
                        ),
                      );
                    },
                  );
                default:
                  return Loading();
              }
            }),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
        height: 60,
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: <Widget>[
            GestureDetector(
              onTap: (){
              },
              child: Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  color: Color(0xFF14575d),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
            SizedBox(width: 15),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                    hintText: "Write message...",
                    hintStyle: TextStyle(color: Colors.black54),
                    border: InputBorder.none
                ),
                controller: controller,
              ),
            ),
            SizedBox(width: 15,),
            FloatingActionButton(
              onPressed: (){
                sendMessage(widget.friendId, controller.text);
                FocusScopeNode currentFocus = FocusScope.of(context);
                setState(() { });
              },
              child: Icon(Icons.send, color: Colors.white, size: 18),
              backgroundColor: Color(0xFF14575d),
              elevation: 0,
            )
          ],
        ),
      ),
    );
  }
}
