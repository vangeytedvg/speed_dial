/*
  Contacts class for Quick Dialer
  Author : DenkaTech
  Created : 16/05/2022
    LM    : 16/05/2022
*/

class QuickContact {
  final int id;
  final String name;
  final String firstName;
  final String phone;
  final String comments;

  const QuickContact(
      {required this.id,
      required this.firstName,
      required this.name,
      required this.phone,
      required this.comments});

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'name': name,
      'phone': phone,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'QuickContact{id: $id, name: $name, firstName: $firstName, phone: $phone}';
  }
}

