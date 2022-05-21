/*
  Contact call history
  Author : DenkaTech
  Created : 21/05/2022
    LM    : 21/05/2022
*/

class History {
  final int? id;
  final int? calledId;
  final String? called;

  // ctor
  History({
    this.id,
    required this.calledId,
    required this.called,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'calledId': calledId,
      'called': called,
    };
  }

  History.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        calledId = res["calledId"],
        called = res["called"];

  @override
  String toString() {
    return 'todo{id: $id, calledId: $calledId, called: $called}';
  }
}
