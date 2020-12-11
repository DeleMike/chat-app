import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats/Ex46OnjPWwZZg7dloDxa/messages')
            .snapshots(),
        builder: (ctx, streamSnapshot) {
          if(streamSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(),);
          }
          final documents = streamSnapshot.data.docs;
          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (ctx, index) => Container(
              padding: const EdgeInsets.all(8),
              child: Text(documents[index]['text']),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          FirebaseFirestore.instance.collection('chats/Ex46OnjPWwZZg7dloDxa/messages').add({
            'text': 'This was added by clicking FAB button'
          });
        },
      ),
    );
  }
}
