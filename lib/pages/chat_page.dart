import 'package:chat_app/models/message.dart';
import 'package:chat_app/services/auth/auth_service.dart';
import 'package:chat_app/services/auth/chat/chat_service.dart';
import 'package:chat_app/themes/theme_provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

 ChatPage({super.key, 
  required this.receiverEmail,
  required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  _ChatPageState();
  final FocusNode myFocusNode = FocusNode();
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  void iniState(){
    super.initState();
  

  myFocusNode.addListener((){ 
    if(myFocusNode.hasFocus){
      Future.delayed(
        const Duration(milliseconds: 500),
         () => scrollDown());
        
   
    }
  });
  Future.delayed(
    const Duration(milliseconds: 500),
    () => scrollDown());
  }

  @override
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
  }

  void sendMessage() async {
   // final message = _messageController.text;
   
    if(_messageController.text.isNotEmpty){
      
      await _chatService.sendMessage(
       widget.receiverID, _messageController.text
      );
      _messageController.clear();
     
    }
    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
     appBar: AppBar(
        title: Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0.0,
       
        ),
      
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(),
          ),
         _buildUserInput(),
        ],
      ),
    );
  }

 // final ScrollController _scrollController = ScrollController();

  Widget _buildMessageList(){
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder<List<Message>>(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot){
        if(snapshot.hasError){
          return const Center(child: Text("Error loading messages."));
        }

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Center(child: CircularProgressIndicator());
        }

        if(!snapshot.hasData || snapshot.data!.isEmpty){
          return const Center(child: Text("No messages found."));
        }
          // Automatically scroll to the latest message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });

        return ListView(
          controller: _scrollController,
          children: snapshot.data!
          .map<Widget>((message) => _buildMessageItem(context, message))
          .toList(),
        );
      },
    );
      
  }

  Widget _buildMessageItem(BuildContext context, Message message){
   // Map<String, dynamic> messageData = doc.data() as Map<String, dynamic>;
    bool isCurrentUser = message.senderID == _authService.getCurrentUser()!.uid;
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
   
    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isCurrentUser ? 
          isDarkMode ? Colors.green.shade600 : Colors.green.shade500 :
          isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(12.0),
        child: Text(message.message,
        style: TextStyle(
          color: isCurrentUser ? Colors.white :
          (isDarkMode ? Colors.white : Colors.black),
        ),
        ),
      ),
    );
  }
  Widget _buildUserInput() {
  bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
   // Ensure the keyboard is shown by requesting focus
  WidgetsBinding.instance.addPostFrameCallback((_) {
    if (!myFocusNode.hasFocus) {
      FocusScope.of(context).requestFocus(myFocusNode);
    }
  });
  return Padding(
    padding: const EdgeInsets.only(bottom: 50.0),
    child: Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 20.0),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: TextField(
              focusNode: myFocusNode, // Use the defined FocusNode
              controller: _messageController,
              decoration: const InputDecoration(
                hintText: "      Type a message...",
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          margin: const EdgeInsets.only(right: 25.0),
          child: IconButton(
            icon: const Icon(
              Icons.send,
              color: Colors.white,
            ),
            onPressed: sendMessage,
          ),
        ),
      ],
    ),
  );
}



}