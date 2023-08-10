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


// Future<List<Group>> fetchGroupsFromFirebase() async{
//   print('haii');
//   List<Group> groups = [];

//   try {
//     QuerySnapshot groupSnapshot = await firestore.collection('groups').get();
//     for(var groupDoc in groupSnapshot.docs){
//       Group group = Group(groupName: groupDoc["group name"]);
//       groups.add(group);

//     }
      

      
//   }on FirebaseException catch (e) {
//     print(e.message);
      
//   }
//   print('sd');
//   print(groups);
//   return groups;
// }
  Stream<List<Group>> fetchGroupsFromFirebaseStream() {
    print('object');
  return FirebaseFirestore.instance.collection('groups').snapshots().map(
    (QuerySnapshot snapshot) {
      List<Group> groups = [];
      for (var groupDoc in snapshot.docs) {
        Group group = Group(id: groupDoc.id, groupName: groupDoc["group name"],amount: groupDoc["amount"]);
        groups.add(group);
        print(group);
      }
      return groups;
    },
  );
}