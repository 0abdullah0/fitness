import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String message_text;
  Timestamp timestamp;
  String sender_id;

  Message(this.message_text, this.timestamp, this.sender_id);
}