// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:splitwise_app/model/group%20model/group_model.dart';

// class GroupProvider extends ChangeNotifier {
//   Group? _currentGroup;
//   Group? get currentGroup => _currentGroup;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;

//   Future<void> createGroup(Group groupname) async {
//     await firestore.collection('groups').add(groupname.toJson());
//   }
// }
