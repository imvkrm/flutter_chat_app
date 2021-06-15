import 'package:chat_app/widgets/chat/messages.dart';
import 'package:chat_app/widgets/chat/new_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      print('onMessage ${remoteMessage.data}');
      return;
    });
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      print('onMessageOpenedApp  ${remoteMessage.data}');
      return;
    });
    fbm.subscribeToTopic('chat'); //required to send notification from backend
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        FirebaseAuth.instance.signOut();
        break;
      case 'Settings':
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          // PopupMenuButton<String>(
          //   onSelected: handleClick,
          //   itemBuilder: (BuildContext context) {
          //     return ['Logout', 'Settings'].map((String choice) {
          //       return PopupMenuItem<String>(
          //         value: choice,
          //         child: Text(choice),
          //       );
          //     }).toList();
          //   },
          // ),

          DropdownButton(
            underline: Container(),
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black87,
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(),
            ),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
// StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//         //.doc('Unk5Xz858Qw2nlZegDGq').collection('messages')
//         stream: FirebaseFirestore.instance
//             .collection('chats/Unk5Xz858Qw2nlZegDGq/messages')
//             .snapshots(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) print('Vikram ${snapshot.data!.docs.length}');
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           final document = snapshot.data!.docs;
//           return ListView.builder(
//             itemCount: document.length,
//             itemBuilder: (ctx, index) => Container(
//               padding: EdgeInsets.all(12),
//               child: Text(document[index].get('text')),
//             ),
//           );
//         },
//       ),
