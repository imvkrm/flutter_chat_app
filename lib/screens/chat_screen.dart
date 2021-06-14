import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          DropdownButton(
            icon: Icon(Icons.more_vert),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Text('Logout'),
                      SizedBox(
                        width: 8,
                      ),
                      Icon(Icons.exit_to_app)
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
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        //.doc('Unk5Xz858Qw2nlZegDGq').collection('messages')
        stream: FirebaseFirestore.instance
            .collection('chats/Unk5Xz858Qw2nlZegDGq/messages')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) print('Vikram ${snapshot.data!.docs.length}');
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final document = snapshot.data!.docs;
          return ListView.builder(
            itemCount: document.length,
            itemBuilder: (ctx, index) => Container(
              padding: EdgeInsets.all(12),
              child: Text(document[index].get('text')),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FirebaseFirestore.instance
              .collection('chats/Unk5Xz858Qw2nlZegDGq/messages')
              .add({'text': 'Button Clicked'});
        },
        child: Icon(Icons.add),
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