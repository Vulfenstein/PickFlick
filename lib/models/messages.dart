import 'package:flutter/material.dart';

class Messages{
  String name;
  String messageText;
  String imageURL;
  String time;

  Messages({this.name, this.messageText, this.imageURL, this.time});
}

class ChatMessages{
  String messageContent;
  String messageType;
  ChatMessages({@required this.messageContent, @required this.messageType});
}

class UniqueMessage{
  String messageContent;
  String sender;
  UniqueMessage({this.messageContent, this.sender});
}