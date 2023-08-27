import 'dart:async';
import 'dart:convert';
import 'package:chatgpt/authentication_screens/login_screen.dart';
import 'package:chatgpt/navigation_screens/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../chat_screen_widgets/api_key.dart';
import '../chat_screen_widgets/chat_message.dart';
import '../chat_screen_widgets/three_dots.dart';
import '../setting_screen_functionalities/setting_screen_functionalities.dart';
import '../utils/utils.dart';
import 'header_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'history_screen.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final TextEditingController messageController = TextEditingController();
  final List<ChatMessage> messages = [];
  bool _isTyping = false;
  final user = FirebaseAuth.instance.currentUser;
  late String userEmail;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserEmail();
  }
  Future<void> getUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      userEmail = user.email.toString();
      firestore.collection(userEmail);
    }
  }
  void _sendMessage() async {
    if (messageController.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: messageController.text,
      sender: "You",
      isImage: false,
    );
    setState(() {
      messages.insert(0, message);
      _isTyping = true;
    });

    String id = DateTime.now().millisecondsSinceEpoch.toString();
    firestore.collection(userEmail).doc(id).set({
      'title' : messageController.text.toString(),
      'id': id,
    }).then((value){
    }).onError((error, stackTrace) {
      Utils().toastMessage(error.toString());
    });
    messageController.clear();
    String response = await sendMessageToChatGpt(message.text);
    ChatMessage chatGpt = ChatMessage(
        text: response, sender: "ChatGPT", isImage: false);

    setState(() {
      messages.insert(0, chatGpt);
      _isTyping = false;
    });
  }

  Future<String> sendMessageToChatGpt(String message) async {
    Uri uri = Uri.parse('https://api.openai.com/v1/chat/completions');
    Map<String, dynamic> body = {
      "model": "gpt-3.5-turbo",
      "messages": [
        {"role": "user", "content": message}
      ],
      "max_tokens": 500,
    };
    final response = await http.post(uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${ApiKey.apikey}",
        },
        body: jsonEncode(body));

    print(response.body);
    Map<String, dynamic> parsedReponse = json.decode(response.body);
    String reply = parsedReponse['choices'][0]['message']['content'];
    print (reply);
    return reply;
  }

  Widget _textMessageBuilder() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: messageController,
            onSubmitted: (value) => _sendMessage(),
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Type a Message',
              focusedBorder: OutlineInputBorder(
                // Customize focused border here
                borderSide: BorderSide(
                    color: Colors.orangeAccent,
                    width: 1),
              ),
            ),
          ),
        ),
        IconButton(
            onPressed: () => _sendMessage(),
            icon: const Icon(
              Icons.send_outlined,
              color: Colors.orangeAccent,
            )),
      ],
    ).p16();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('ChatGPT'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
                    reverse: true,
                    padding: Vx.m8,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return messages[index];
                    })),
            if (_isTyping) const ThreeDots(),
            const Divider(
              height: 1.0,
            ),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _textMessageBuilder(),
            )
          ],
        ),
      ),
      drawer: Drawer(
          child: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              const HeaderDrawer(),
              DrawerList(),
            ],
          ),
        ),
      )),
    );
  }

  Widget DrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.history),
              title: const Text('History'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout_outlined),
              title: const Text('Logout'),
              onTap: () {
                logoutPopup();
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<void> logoutPopup() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Are you sure for logout?'),
            content: Container(
              height: 5,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    auth.signOut().then((value) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('No')),
            ],
          );
        });
  }
}
