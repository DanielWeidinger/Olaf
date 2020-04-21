import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:olaf/services/MQTTManager.dart';
import 'package:olaf/services/states/MQTTState.dart';
import 'package:provider/provider.dart';

class MQTTMessenger extends StatefulWidget {

  MQTTManager manager;

  MQTTMessenger();

  @override
  _MQTTMessengerState createState() => _MQTTMessengerState();
}

class _MQTTMessengerState extends State<MQTTMessenger> {

  TextEditingController _messageTextController = TextEditingController();
  MQTTAppState _currentAppState;

  @override
  Widget build(BuildContext context) {
    _currentAppState = Provider.of<MQTTAppState>(context);
    return
      Container(
        width: MediaQuery.of(context).size.height/2.2,
        child: _buildPublishMessageRow()
    );
  }


  @override
  void dispose() {
    super.dispose();
    _messageTextController.dispose();
  }

  Widget _buildPublishMessageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(child: _buildTextFieldWith(_messageTextController, 'Enter a message', _currentAppState.getAppConnectionState)),
        _buildSendButtonFrom(_currentAppState.getAppConnectionState)
      ],
    );
  }

  Widget _buildSendButtonFrom(MQTTAppConnectionState state) {
    return RaisedButton(
      color: Colors.green,
      child: const Text('Send'),
      onPressed: state == MQTTAppConnectionState.connected
          ? () {
        _publishMessage(_messageTextController.text);
      }
          : null, //
    );
  }

  void _publishMessage(String text) {
    String osPrefix = 'Flutter_iOS';
    if(Platform.isAndroid){
      osPrefix = 'Flutter_Android';
    }
    final String message = osPrefix + ' says: ' + text;
    widget.manager.publish(message);
    _messageTextController.clear();
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText, MQTTAppConnectionState state) {
    return TextField(
        enabled: _currentAppState.getAppConnectionState == MQTTAppConnectionState.connected,
        controller: controller,
        decoration: InputDecoration(
          helperText: hintText,
          labelText: hintText,
        ));
  }

}
