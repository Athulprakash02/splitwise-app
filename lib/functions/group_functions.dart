// import 'package:flutter/material.dart';
// import 'package:splitwise_app/functions/db_functions.dart';
// import 'package:splitwise_app/model/participant_model.dart';

// Future<void> onAddParticipantClicked(String name,BuildContext context)async{
//   final participant = ParticipantModel(participantName: name, amount: 0);
//   addParticipant(participant);
//   Navigator.of(context).pop();
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitwise_app/functions/auth.dart';

import '../model/group model/group_model.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> createGroup(Group groupname) async {
  await firestore.collection('groups').add(groupname.toJson());
}

// Future<List<Group>> fetchGroupsFromFirebase() async {
//   List<Group> groups = [];

//   try {
//     QuerySnapshot groupSnapshot = await firestore.collection('groups').get();
//     for (var groupDoc in groupSnapshot.docs) {
//       Group group = Group(
//         id: groupDoc.id,
//         groupName: groupDoc["group name"],
//         imageAvatar: groupDoc["image avatar url"],
//         path: groupDoc["image path"],
//         amount: groupDoc["amount"],
//         // amountPersonOne: groupDoc["person one amount"],
//         // amountPersonTwo: groupDoc["person two amount"],
//         // amountPersonThree: groupDoc["person three amount"],
//       );
//       groups.add(group);
//     }

//     // ignore: empty_catches, unused_catch_clause
//   } on FirebaseException catch (e) {}

//   return groups;
// }


// Future<List<Group>> fetchGroupsByName(String fullName) async {
//   List<Group> groups = [];

//   try {
//     QuerySnapshot groupSnapshot = await firestore.collection('groups').where('full name', isEqualTo: fullName).get();
//     for (var groupDoc in groupSnapshot.docs) {
//       Group group = Group(
//         id: groupDoc.id,
//         groupName: groupDoc["group name"],
//         imageAvatar: groupDoc["image avatar url"],
//         path: groupDoc["image path"],
//         amount: groupDoc["amount"],
//         // amountPersonOne: groupDoc["person one amount"],
//         // amountPersonTwo: groupDoc["person two amount"],
//         // amountPersonThree: groupDoc["person three amount"],
//       );
//       groups.add(group);
//     }

//     // ignore: empty_catches, unused_catch_clause
//   } on FirebaseException catch (e) {}

//   return groups;
// }
Future<List<Group>> fetchGroupsFromFirebase() async {
 final loggedInUser =await  getUserTypeByEmail(FirebaseAuth.instance.currentUser!.email!);
  final userGroupsSnapshot = await firestore.collection('Users').doc(loggedInUser!.id).collection('my groups').get();
  
  List<Group> groups =[];
  
  for (var groupDoc in userGroupsSnapshot.docs) {
    var groupData = groupDoc.data();
    var groupID = groupData['group id'];

    var groupSnapshot = await firestore.collection('groups').where('group name',isEqualTo: groupID).get();
    if (groupSnapshot.docs.isNotEmpty) {
      var groupInfo = groupSnapshot.docs.first.data();
      Group group = Group(
        id: groupID,
        groupName: groupInfo["group name"],
        imageAvatar: groupInfo["image avatar url"],
        path: groupInfo["image path"],
        amount: groupInfo["amount"],
        // amountPersonOne: groupDoc["person one amount"],
        // amountPersonTwo: groupDoc["person two amount"],
        // amountPersonThree: groupDoc["person three amount"],
      );
      groups.add(group);
        // Add more fields as needed
     
    }
  }
  
  return groups;
}
Future<void> updateDate(Group updatedGroup, String groupName) async {
   
    try {
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('groups');

      QuerySnapshot querrySnapshot =
          await collectionRef.where('group name', isEqualTo: groupName).get();
      for (QueryDocumentSnapshot docSnapshot in querrySnapshot.docs) {
        // Define the fields you want to update
        Map<String, dynamic> updatedData = {
          "group name": updatedGroup.groupName,
          "amount": updatedGroup.amount,
          "image path": updatedGroup.path,
          // "person one amount": amountOne,
          "image avatar url": updatedGroup.imageAvatar,

          // "person two amount": amountTwo,
          // "person three amount": amountThree,
          // Add other fields you want to update
        };

        // double.parse(_amountPersonThreeController.text);
        await docSnapshot.reference.update(updatedData);
      }
      // ignore: empty_catches
    } catch (e) {}
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
