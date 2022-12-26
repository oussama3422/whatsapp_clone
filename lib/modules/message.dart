import 'dart:convert';

import 'package:whatsapp_ui/core/enums/message_enum.dart';

class Message {
  final String snderId;
  final String reciverid;
  final String text;
  final MessageEnum type;
  final DateTime timeSent;
  final String messageId;
  final bool isSeen;
  Message({
    required this.snderId,
    required this.reciverid,
    required this.text,
    required this.type,
    required this.timeSent,
    required this.messageId,
    required this.isSeen,
  });

  Message copyWith({
    String? snderId,
    String? reciverid,
    String? text,
    MessageEnum? type,
    DateTime? timeSent,
    String? messageId,
    bool? isSeen,
  }) {
    return Message(
      snderId: snderId ?? this.snderId,
      reciverid: reciverid ?? this.reciverid,
      text: text ?? this.text,
      type: type ?? this.type,
      timeSent: timeSent ?? this.timeSent,
      messageId: messageId ?? this.messageId,
      isSeen: isSeen ?? this.isSeen,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'snderId': snderId,
      'reciverid': reciverid,
      'text': text,
      'type': type.type,
      'timeSent': timeSent.toUtc().toIso8601String(),
      'messageId': messageId,
      'isSeen': isSeen,
    };
  }

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      snderId: map['snderId'],
      reciverid: map['reciverid'],
      text: map['text'],
      type: (map['type'] as String).toEnum(),
      timeSent: DateTime.parse(map['timeSent']).toLocal(),
      messageId: map['messageId'],
      isSeen: map['isSeen'],
    );
  }
}
