class Participants {
  final String? id;
  final String groupName;
  final String participantName;
  final double amount;

  Participants({
     this.id,
    required this.groupName,
    required this.participantName,
    required this.amount,
  });


  toJson() {
    return {
      
      "group name": groupName,
      "partcipant names": participantName,
      "amount" : amount

    };
  }
}
