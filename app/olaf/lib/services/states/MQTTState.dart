
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
