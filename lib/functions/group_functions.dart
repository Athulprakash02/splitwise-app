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

Future<List<Group>> fetchGroupsFromFirebase() async{
  List<Group> groups = [];

  try {
    QuerySnapshot groupSnapshot = await firestore.collection('groups').get();
    for(var groupDoc in groupSnapshot.docs){
      Group group = Group(
            id: groupDoc.id,
            groupName: groupDoc["group name"],
            imageAvatar: groupDoc["image avatar url"],
            path: groupDoc["image path"],
            amount: groupDoc["amount"],
            amountPersonOne: groupDoc["person one amount"],
            amountPersonTwo: groupDoc["person two amount"],
            amountPersonThree: groupDoc["person three amount"]);
      groups.add(group);

    }

  // ignore: empty_catches, unused_catch_clause
  }on FirebaseException catch (e) {
    

  }
  
 
  return groups;
}
// Stream<List<Group>> fetchGroupsFromFirebaseStream() {
//   print('object');
//   return FirebaseFirestore.instance.collection('groups').snapshots().map(
//     (QuerySnapshot snapshot) {
//       List<Group> groups = [];
//       for (var groupDoc in snapshot.docs) {
//         Group group = Group(
//             id: groupDoc.id,
//             groupName: groupDoc["group name"],
//             amount: groupDoc["amount"],
//             amountPersonOne: groupDoc["person one amount"],
//             amountPersonTwo: groupDoc["person two amount"],
//             amountPersonThree: groupDoc["person three amount"]);
//         groups.add(group);
//         print(group);
//       }
//       return groups;
//     },
//   );
// }
