
import 'package:chat_app/componets/my_drawer.dart';
import 'package:chat_app/componets/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/chat/chat_service.dart';
import 'package:flutter/material.dart';
class  HomePage extends StatelessWidget {
   HomePage({super.key});

final ChatService _chatService = ChatService();
final AuthService _authService = AuthService();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0.0,
       
        ),
        drawer: const MyDrawer(),
        body: _buildUserList(),
    );
  }

 Widget _buildUserList() {
  return StreamBuilder<List<Map<String, dynamic>>>(
    stream: _chatService.getUsersStream(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(child: Text("Error loading users."));
      }

      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text("No users found."));
      }
       // Debugging: Print data
  print("Current user email: ${_authService.getCurrentUser()?.email}");


      return ListView(
        children: snapshot.data!
            .map<Widget>((userData) => _buildUserListItem(userData, context))
            .toList(),
      );
    },
  );
}


  Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context
  ) { 
   if(userData["email"] != _authService.getCurrentUser()!.email){	
     return UserTile(
      text: userData["email"],
      onTap: () {
        Navigator.push(
          context, 
        MaterialPageRoute(
          builder: (context) => ChatPage(
            receiverEmail: userData["email"],
            receiverID: userData["uid"],
            ),
          ),
        );
      }
    );
   }
   else{
    return Container();
   }

   
  }
}