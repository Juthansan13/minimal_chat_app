
import 'package:chat_app/componets/my_drawer.dart';
import 'package:chat_app/componets/user_tile.dart';
import 'package:chat_app/pages/chat_page.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/chat/chat_service.dart';
import 'package:flutter/material.dart';
class  HomePage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
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
  print ("current user name: ${_authService.getCurrentUser()?.displayName}");
  print("Email: ${_emailController.text.trim()}");  // Debugging the email format



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
  // Only show users who are not the current user
  if (userData["name"] != _authService.getCurrentUser()!.displayName) { 
    return UserTile(
      text: userData["name"],  // Use the 'name' field for displaying the username
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"], // You still need the email for chat purposes
              receiverID: userData["uid"],
            ),
          ),
        );
      }
    );
  } else {
    return Container();  // Do not display the current user
  }
}

     
}