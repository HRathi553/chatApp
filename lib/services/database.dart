import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods{

  getUserByName(String username) async{
    return await Firestore.instance.collection("users")
        .where("name", isEqualTo: username)
        .getDocuments();
  }

  getUserByUserEmail(String userEmail) {
    return Firestore.instance.collection("users")
        .where("email", isEqualTo: userEmail)
        .getDocuments();
  }

  uploadUserInfo(userMap) {                    //  uploadUserInfo(String name, String email) ==> userMap is our name & email fetched from user input textfields.
    Firestore.instance.collection("users")    //  In "cloud firestore" we have created a collection named "users"
    .add(userMap).catchError((e){
      print(e.toString());
    });
  }

   createChatRoom(String chatRoomId, chatRoomMap) {   //  In "cloud_firestore" we have "ChatRoom" collection whose "document" id fetched in "chatRoomId" and "chatRoomMap" has the array values.
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId).setData(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  ///*********************************************Backend of the conversation screen between two users********************************************************

   addConversationMessages(String chatRoomId, messageMap) {
    Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .add(messageMap).catchError((e){print(e.toString());});
  }

  getConversationMessages(String chatRoomId) async{
    return await Firestore.instance.collection("ChatRoom")
        .document(chatRoomId)
        .collection("chats")
        .orderBy("time", descending: true)            //    To arrange our messages in the chatScreen according to the time.
        .snapshots();
  }

  getChatRooms(String userName) async {
    return await Firestore.instance
        .collection("ChatRoom")
        .where("users", arrayContains: userName)
        .snapshots();                                 //  Snapshot returns a "Stream". We are using snapshots so that the data must be synced i.e.
                                      // if a user deletes a message then this message also gets deleted automatically from the screen of the other user also.
  }
 }