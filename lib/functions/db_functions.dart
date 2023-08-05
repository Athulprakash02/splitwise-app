import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:splitwise_app/model/participant_model.dart';

ValueNotifier<List<ParticipantModel>> participantNotifier = ValueNotifier([]);

Future<void> addParticipant(ParticipantModel participant) async{
  final participantBox = await Hive.openBox<ParticipantModel>('participants');
  final user = await participantBox.add(participant);
  participant.id = user;
  participantNotifier.notifyListeners();
}

Future<void> fetchAllParticipants() async{
final participantsBox = await Hive.openBox<ParticipantModel>('participants');
participantNotifier.value.clear();
participantNotifier.value.addAll(participantsBox.values);
participantNotifier.notifyListeners();
}