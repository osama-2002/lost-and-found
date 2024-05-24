import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mafqodat/widgets/request_widget.dart';

class HomeRequests extends StatefulWidget {
  const HomeRequests({super.key});

  @override
  State<HomeRequests> createState() => _HomeRequestsState();
}

class _HomeRequestsState extends State<HomeRequests> {
  final Stream<QuerySnapshot> _usersStream =
      FirebaseFirestore.instance.collection('reports').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _usersStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading");
        }
        return ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data =
                document.data()! as Map<String, dynamic>;
            String id = document.id;
            print(
                "uid: ${FirebaseAuth.instance.currentUser!.uid} \nrequest uid: ${data['uid']}");
            return FirebaseAuth.instance.currentUser!.uid == data['uid']
                ? Request(
                    description: data['description'],
                    lost: data['lost'],
                    id: id)
                : const SizedBox();
          }).toList(),
        );
      },
    );
  }
}
