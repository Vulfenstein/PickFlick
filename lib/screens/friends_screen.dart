import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pick_flick/networks/firebase.dart';
import 'package:pick_flick/utilities/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendsScreen extends StatefulWidget {
  @override
  _FriendsScreenState createState() => _FriendsScreenState();
}
final firestoreInstance = FirebaseFirestore.instance;
var firebaseUser =  FirebaseAuth.instance.currentUser;
DocumentSnapshot ds;

// ----------------------------------------------------------------------------//
// Add Friends list
// ----------------------------------------------------------------------------//
_newFriendsList(context){
  return StreamBuilder<QuerySnapshot>(stream: firestoreInstance.collection("users").snapshots(),
    builder: (context, snapshot) {
      if(snapshot.hasData){
        return new ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            ds = snapshot.data.docs[index];
            return OutlinedButton(
                child: new Container(
                  height: 50,
                  color: Colors.transparent,
                  child: Center(child: Text(ds["Name"], style: TextStyle(color: Colors.white))),
                ),
                onPressed: () {
                  pendingFriendAdd(ds["id"]);
                }
            );
          },
        );
      }
      return Loading();
    },
  );
}

// ----------------------------------------------------------------------------//
// Get firebase pending/friends list
// ----------------------------------------------------------------------------//
Future<List<dynamic>> getList(String val) async{
  DocumentReference docRef = firestoreInstance.collection("users").doc(firebaseUser.uid);
  print(firebaseUser.uid);

  return docRef.get().then((datasnapshot) {
    print(datasnapshot);
    if(datasnapshot.exists){
      List<dynamic> info = datasnapshot[val].toList();
      return info;
    }
    return null;
  });
}

// ----------------------------------------------------------------------------//
// Create pending/friends list view builder
// ----------------------------------------------------------------------------//
_fpList(context, String friendType){
  return FutureBuilder(
    future: getList(friendType),
    builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
      if(snapshot.hasData){
        return new ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data.length,
          itemBuilder: (context, index){
            return new Container(
              height: 50,
              color: Colors.transparent,
              child: OutlinedButton(
                  child: Center(
                    child: Text(snapshot.data[index], style: TextStyle(color: Colors.white))),
                  onPressed: (){
                    if(friendType == "Pending Friends"){
                      friendAdd(snapshot.data[index]);
                    }
                  },
              ),
            );
          },
        );
      }
      return Loading();
    },
  );
}

// ----------------------------------------------------------------------------//
// Build
// ----------------------------------------------------------------------------//
class _FriendsScreenState extends State<FriendsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFF14575d),
        title: Text("Friends"),
      ),
      body: Stack(
        children: <Widget>[
          BackgroundBuilder(),
          Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15,),
                  SizedBox(child: Text("Add Friends", style: TextStyle(fontSize: 26, color: Colors.white))),
                  SizedBox(height: 10,),
                  _newFriendsList(context),
                  SizedBox(height: 30,),
                  SizedBox(child: Text("My Friends", style: TextStyle(fontSize: 26, color: Colors.white))),
                  SizedBox(height: 10,),
                  _fpList(context, "Friends"),
                  SizedBox(height: 30,),
                  SizedBox(child: Text("Pending", style: TextStyle(fontSize: 26, color: Colors.white))),
                  SizedBox(height: 10,),
                  _fpList(context, "Pending Friends"),
                ],
              ),
            ),
          )],
      ),
    );
  }
}
