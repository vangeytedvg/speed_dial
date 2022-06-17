/*
  Contacts model for Quick Dialer
  Author : DenkaTech
  Created : 16/05/2022
    LM    : 16/05/2022
*/

class LocalContact {
  final int? id;
  final String? name;
  final String? firstName;
  final String? phoneNr;

  // ctor
  LocalContact({
    this.id,
    required this.name,
    required this.firstName,
    required this.phoneNr,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'firstName': firstName,
      'phoneNr': phoneNr,
    };
  }

  LocalContact.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        firstName = res["firstName"],
        phoneNr = res["phoneNr"];

  @override
  String toString() {
    return 'todo{id: $id, name: $name, firstName: $firstName, phoneNr: $phoneNr';
  }
}
