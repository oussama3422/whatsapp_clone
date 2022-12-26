import 'dart:convert';

class ChatContact {
  final String name;
  final String profilePic;
  final String contactId;
  final DateTime timeSent;
  final String lastMessage; 
  ChatContact({
    required this.name,
    required this.profilePic,
    required this.contactId,
    required this.timeSent,
    required this.lastMessage,
  });

  ChatContact copyWith({
    String? name,
    String? profilePic,
    String? contactId,
    DateTime? timeSent,
    String? lastMessage,
  }) {
    return ChatContact(
      name: name ?? this.name,
      profilePic: profilePic ?? this.profilePic,
      contactId: contactId ?? this.contactId,
      timeSent: timeSent ?? this.timeSent,
      lastMessage: lastMessage ?? this.lastMessage,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'profilePic': profilePic,
      'contactId': contactId,
      'timeSent': timeSent.toUtc().toIso8601String(),
      'lastMessage': lastMessage,
    };
  }

  factory ChatContact.fromMap(Map<String, dynamic> map) {
    return ChatContact(
      name: map['name'],
      profilePic: map['profilePic'],
      contactId: map['contactId'],
      timeSent: DateTime.parse(map['timeSent']).toLocal(),
      lastMessage: map['lastMessage'],
    );
  }
}
