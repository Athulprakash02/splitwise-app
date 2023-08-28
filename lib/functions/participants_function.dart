import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:splitwise_app/model/participant%20model/participant_model.dart';
import 'package:splitwise_app/screens/widgets/show_snackbar.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> createParticipant(Participants participant, String userName,
    BuildContext context, String groupId) async {
  await firestore.collection('participants').add(participant.toJson());
  // ignore: use_build_context_synchronously
  await addSubCollection(userName, context, groupId);
}

Future<void> addSubCollection(
    String userName, BuildContext context, String groupId) async {
  final querySnapshot = await firestore
      .collection('Users')
      .where('full name', isEqualTo: userName)
      .limit(1)
      .get();
  if (querySnapshot.docs.isNotEmpty) {
    var id = querySnapshot.docs.first.id;
    firestore
        .collection('Users')
        .doc(id)
        .collection('my groups')
        .add({'group id': groupId});
  } else {
    // ignore: use_build_context_synchronously
    showSnackBar(context, Colors.red, 'Invalid username');
  }
}

// Future<List<Participants>> fetchParticipantsFromFirebase(
//     String groupName) async {
//   List<Participants> participantList = [];
//   try {
//     QuerySnapshot participantSnapshot = await firestore
//         .collection('participants')
//         .where('group name', isEqualTo: groupName)
//         .get();
//     for (var participantDoc in participantSnapshot.docs) {
//       Participants user = Participants(
//           groupName: participantDoc['group name'],
//           participantName: participantDoc["participant name"],
//           amount: participantDoc["amount"]);
//       participantList.add(user);
//     }
//     // ignore: empty_catches
//   } catch (e) {}
//   return participantList;
// }
Stream<List<Participants>>? streamParticipantsFromFirebase(String groupName) {
  try {
    return firestore
        .collection('participants')
        .where('group name', isEqualTo: groupName)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs.map((doc) {
              return Participants(
                groupName: doc['group name'],
                participantName: doc['partcipant name'],
                amount: doc['amount'],
              );
            }).toList());
  } on FirebaseException catch (e) {
    log(e.message as num);

    return null;
  }
}

Future<void> updateDataInFirestore(List newValue, String groupName) async {
  QuerySnapshot querySnapshot = await firestore
      .collection('participants') // Replace with your actual collection name
      .where('group name', isEqualTo: groupName) // Replace with your condition
      .get();
  for (int i = 0; i < querySnapshot.docs.length; i++) {
    QueryDocumentSnapshot doc = querySnapshot.docs[i];

    // Update the specific field with the new value
    await doc.reference.update({
      'amount': newValue[i],
    });
  }
  // Loop through the documents in the query result and update the field
  // for (QueryDocumentSnapshot doc in querySnapshot.docs) {
  //   // Update the specific field with the new value

  //   await doc.reference.update({
  //     'amount': newValue,
  //   });
  // }
}

// Stream<List<Participants>> streamParticipantsFromFirebase(String groupName) {
//   Stream<List<Participants>> participantsStream = firestore
//       .collection('participants')
//       .where('group name', isEqualTo: groupName)
//       .snapshots()
//       .map((querySnapshot) => querySnapshot.docs.map((doc) {
//             return Participants(
//               groupName: doc['group name'],
//               participantName: doc["participant name"],
//               amount: doc["amount"],
//             );
//           }).toList());

//   // Print the results
//   participantsStream.listen((participantsList) {
//     print('Participants for group $groupName:');
//     for (var participant in participantsList) {
//       print('Name: ${participant.participantName}, Amount: ${participant.amount}');
//     }
//   });

//   return participantsStream;
// }


// Stream<List<Participants>> fetchParticipantsFromFirebase(String groupName) {
//   return FirebaseFirestore.instance
//       .collection('participants')
//       .where('group name', isEqualTo: groupName)
//       .snapshots()
//       .map((QuerySnapshot snapshot) {
//     List<Participants> participantList = [];

//     for (var participantDoc in snapshot.docs) {
//       Participants user = Participants(
//         groupName: participantDoc['group name'],
//         participantName: participantDoc['participant names'],
//         amount: participantDoc['amount'],
//       );
//       participantList.add(user);
//     }

//     return participantList;
//   });
// }



// Stream<List<Participants>> fetchParticipantsFromFirebase(String groupName) {
//  List<Participants> participantList = [];
 
//     return FirebaseFirestore.instance.collection('participants').where('group name',isEqualTo: groupName).snapshots().map((QuerySnapshot snapshot) {
       
//        for(var participantDoc in snapshot.docs){
//         Participants user = Participants(groupName: participantDoc['group name'], participantName: participantDoc["participant names"], amount: participantDoc['amount']);
//         participantList.add(user);
//         print(user.groupName);
//        }
//        print(participantList.first.groupName);
//        return participantList;
//     });
    
  
// }


// import 'package:cloud_firestore/cloud_firestore.dart';

// class Participants {
//   final String groupName;
//   final String participantName;
//   final double amount;

//   Participants({required this.groupName, required this.participantName, required this.amount});
// }
