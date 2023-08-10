import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitwise_app/functions/group_functions.dart';
import 'package:splitwise_app/model/participant_model.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Future<void> createParticipant(
    String groupName, Participants participant) async {
  print('keri');

  await firestore.collection('participants').add(participant.toJson());
}

Future<List<Participants>> fetchParticipantsFromFirebase(
    String groupName) async {
  List<Participants> participantList = [];
  try {
    QuerySnapshot participantSnapshot = await firestore
        .collection('participants')
        .where('group name', isEqualTo: groupName)
        .get();
    for (var participantDoc in participantSnapshot.docs) {
      Participants user = Participants(
          groupName: participantDoc['group name'],
          participantName: participantDoc["participant names"],
          amount: participantDoc["amount"]);
          participantList.add(user);
    }
  } catch (e) {}
  return participantList;
}


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
