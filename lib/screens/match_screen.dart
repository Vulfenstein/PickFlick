import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pick_flick/utilities/widgets.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  final firestoreInstance = FirebaseFirestore.instance;
  var firebaseUser =  FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: firestoreInstance.collection('users').doc(firebaseUser.uid).collection('Movie Details').snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData == null){
          return Loading();
        }
        return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
            itemBuilder: (BuildContext context, int index) {
              return Container(child: Text(snapshot.data, style: TextStyle(color: Colors.black),),);
            },
          itemCount: snapshot.data.docs.length,
        );
      },
    );
  }
}
