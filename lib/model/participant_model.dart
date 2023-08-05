import 'package:hive/hive.dart';
part 'participant_model.g.dart';

@HiveType(typeId: 1)
class ParticipantModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  final String participantName;

  @HiveField(2)
   num amount;

  ParticipantModel({required this.participantName, required this.amount});
}
