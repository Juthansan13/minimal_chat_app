import 'package:chat_app/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

 Stream<List<Map<String, dynamic>>> getUsersStream() {
  return FirebaseFirestore.instance.collection('users').snapshots().map(
    (snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          "id": doc.id,
          ...data,
        };
// Handle null data gracefully
      }).toList();
    },
  );
}


  //send message
Future<void> sendMessage(String receiverID, message) async {
  //get current user
  final String currentUserId = _auth.currentUser!.uid;
  final String? currentUserEmail = _auth.currentUser!.email;
  final Timestamp timestamp = Timestamp.now();
  // create a new message document
  Message newMessage = Message(
    senderID: currentUserId,
    senderEmail: currentUserEmail!,
    receiverID: receiverID,
    message: message,
    timestamp: timestamp.toString(),
  );
  // construct the message data
  List<String> ids = [currentUserId, receiverID];
  ids.sort();
  String chatRoomID = ids.join('_');

  // add new message to database
  await _firestore.
  collection('Chat_rooms').
  doc(chatRoomID).
  collection('Messages').
  add(newMessage.toMap());
}

  //get messages
  Stream<List<Message>> getMessages(String userID,otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('Chat_rooms')
        .doc(chatRoomID)
        .collection('Messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final message = doc.data();
        return Message(
          senderID: message['senderID'],
          senderEmail: message['senderEmail'],
          receiverID: message['receiverID'],
          message: message['message'],
          timestamp: message['timestamp'],
        );
      }).toList();
    });
  }
}

