// import 'package:flutter/material.dart';
// import 'package:splitwise_app/functions/db_functions.dart';
// import 'package:splitwise_app/model/participant_model.dart';

// Future<void> onAddParticipantClicked(String name,BuildContext context)async{
//   final participant = ParticipantModel(participantName: name, amount: 0);
//   addParticipant(participant);
//   Navigator.of(context).pop();
// }

 import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/group model/group_model.dart';
FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> createGroup(Group groupname) async {
    await firestore.collection('groups').add(groupname.toJson());
  }