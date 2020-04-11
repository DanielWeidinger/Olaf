
import 'dart:convert';

import 'package:flutter/material.dart';

enum MQTTAppConnectionState { connected, disconnected, connecting }
class MQTTAppState with ChangeNotifier{
  MQTTAppConnectionState _appConnectionState = MQTTAppConnectionState.disconnected;
  List<MQTTMessage> _messages = List();

  void receiveMessage(String topic, String payload) {
    _messages.add(MQTTMessage(topic, payload));
    notifyListeners();
  }
  void setAppConnectionState(MQTTAppConnectionState state) {
    _appConnectionState = state;
    notifyListeners();
  }

  List<MQTTMessage> get getAllMessages => _messages;
  MQTTAppConnectionState get getAppConnectionState => _appConnectionState;

}

class MQTTMessage{
  final String topic;
  final String payload;

  Map<String, dynamic> get Json => jsonDecode(payload);

  MQTTMessage(this.topic, this.payload);
}

class MQTTMessageItem extends StatefulWidget {
  final Map<String, dynamic> json;

  MQTTMessageItem(this.json);

  @override
  _MQTTMessageItemState createState() => _MQTTMessageItemState();
}

class _MQTTMessageItemState extends State<MQTTMessageItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Text(widget.json["title"])
        ],
      ),
    );
  }
}
