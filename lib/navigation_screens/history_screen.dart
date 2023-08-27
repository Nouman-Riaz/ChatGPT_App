import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late final firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  late String userEmail;
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
    }
  }

  Future<void> deleteChatHistory() async {
    if (userEmail.isNotEmpty) {
      WriteBatch batch = firestore.batch();
      QuerySnapshot snapshot = await firestore.collection(userEmail).get();

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        final chatId = doc['id'];

        // Skip deleting the chat with id "profileImage"
        if (chatId != "profileImage") {
          batch.delete(doc.reference);
        }
      }

      await batch.commit();
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        backgroundColor: Colors.orangeAccent,
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'delete') {
                deleteChatHistory();
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete History'),
                ),
              ];
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
              stream: firestore.collection(userEmail).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  ); // Show a loading indicator while data is loading
                }
                if (snapshot.hasError) {
                  return Center(child:Align(alignment:Alignment.center,child: Text('Error: ${snapshot.error}')));
                }
                final chatDocs = snapshot.data!.docs.where((doc) => doc['id'] != 'profileImage').toList();
                return Expanded(
                    child: chatDocs.isEmpty//(snapshot.data!.docs.isEmpty || !snapshot.hasData)
                        ? Center(child: Text('No history available'))
                        : ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              final chatData = snapshot.data!.docs[index];
                              final chatId = chatData['id'];

                              // Check if the chat message has id "profileImage"
                              if (chatId == "profileImage") {
                                // Skip displaying the chat with id "profileImage"
                                return SizedBox.shrink();
                              }

                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Card(
                                  child: ListTile(
                                    title: Text(chatData['title'].toString()),
                                  ),
                                ),
                              );
                            }));
              }),
        ],
      ),
    );
  }
}
