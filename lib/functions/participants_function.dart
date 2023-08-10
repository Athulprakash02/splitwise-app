import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:splitwise_app/functions/group_functions.dart';
import 'package:splitwise_app/model/participant_model.dart';

Future<void> createParticipant(String groupName, Participants participant) async {
 try {
  print('keri');
   
      await firestore.collection('participants').add(participant.toJson());
 }on FirebaseException catch (e) {
  print(e.message.toString());
   
 }
}

Future<Stream<List<Participants>>> fetchParticipantsFromFirebase(String groupName) async{
  List<Participants> participantList = [];
  try {
    QuerySnapshot participantSnapshot = await firestore.collection('participants').where('group name',isEqualTo: groupName).get();
    for(var part in participantSnapshot.docs){
      Participants user = Participants(groupName: part['groupName'], participantName: part['participant name'], amount: part['amount']);
participantList.add(user);
    }
  } catch (e) {
    
  }
  return participantList;
}

