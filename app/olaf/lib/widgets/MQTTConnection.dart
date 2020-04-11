import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:olaf/services/MQTTManager.dart';
import 'package:olaf/services/states/MQTTState.dart';
import 'package:provider/provider.dart';


class MQTTConnection extends StatefulWidget {

  final connectionCB;

  MQTTConnection(this.connectionCB);

  @override
  State<StatefulWidget> createState() {
    return _MQTTConnectionState();
  }
}

class _MQTTConnectionState extends State<MQTTConnection> {
  final TextEditingController _hostTextController = TextEditingController();
  final TextEditingController _topicTextController = TextEditingController();
  MQTTAppState currentAppState;
  MQTTManager manager;

  @override
  void initState() {
    super.initState();

    /*
    _hostTextController.addListener(_printLatestValue);
    _messageTextController.addListener(_printLatestValue);
    _topicTextController.addListener(_printLatestValue);

     */
  }

  @override
  void dispose() {
    _hostTextController.dispose();
    _topicTextController.dispose();
    super.dispose();
  }

  /*
  _printLatestValue() {
    print("Second text field: ${_hostTextController.text}");
    print("Second text field: ${_messageTextController.text}");
    print("Second text field: ${_topicTextController.text}");
  }

   */

  @override
  Widget build(BuildContext context) {
    final MQTTAppState appState = Provider.of<MQTTAppState>(context);
    // Keep a reference to the app state.
    currentAppState = appState;
    return _buildColumn();
  }

  Widget _buildColumn() {
    return Column(
      children: <Widget>[
        _buildConnectionStateText(
            _prepareStateMessageFrom(currentAppState.getAppConnectionState)),
        _buildEditableColumn(),
      ],
    );
  }

  Widget _buildEditableColumn() {
    final result = Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: <Widget>[
          _buildTextFieldWith(_hostTextController, 'Enter broker address',currentAppState.getAppConnectionState),
          const SizedBox(height: 10),
          _buildTextFieldWith(
              _topicTextController, 'Enter a topic to subscribe or listen', currentAppState.getAppConnectionState),
          _buildConnecteButtonFrom(currentAppState.getAppConnectionState)
        ],
      ),
    );

    //set default values
    _hostTextController.text = "192.168.99.100";
    _topicTextController.text = "#";

    return result;
  }

  Widget _buildConnectionStateText(String status) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              color: Colors.deepOrangeAccent,
              child: Text(status, textAlign: TextAlign.center)),
        ),
      ],
    );
  }

  Widget _buildTextFieldWith(TextEditingController controller, String hintText,
      MQTTAppConnectionState state) {
    bool shouldEnable = false;
    if ((controller == _hostTextController &&
        state == MQTTAppConnectionState.disconnected) || (controller == _topicTextController &&
        state == MQTTAppConnectionState.disconnected)) {
      shouldEnable = true;
    }
    return TextField(
        enabled: shouldEnable,
        controller: controller,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 0, bottom: 0, top: 0, right: 0),
          labelText: hintText,
        ));
  }

  Widget _buildScrollableTextWith(String text) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Container(
        width: 300,
        height: 200,
        child: SingleChildScrollView(
          child: Text(text),
        ),
      ),
    );
  }

  Widget _buildConnecteButtonFrom(MQTTAppConnectionState state) {
    return Row(
      children: <Widget>[

        Expanded(
          child: RaisedButton(
            color: Colors.lightBlueAccent,
            child: const Text('Connect'),
            onPressed: state == MQTTAppConnectionState.disconnected
                ? _configureAndConnect
                : null, //
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RaisedButton(
            color: Colors.redAccent,
            child: const Text('Disconnect'),
            onPressed: state == MQTTAppConnectionState.connected
                ? _disconnect
                : null, //
          ),
        ),
      ],
    );
  }

  // Utility functions
  String _prepareStateMessageFrom(MQTTAppConnectionState state) {
    switch (state) {
      case MQTTAppConnectionState.connected:
        return 'Connected';
      case MQTTAppConnectionState.connecting:
        return 'Connecting';
      case MQTTAppConnectionState.disconnected:
        return 'Disconnected';
    }
  }

  void _configureAndConnect() {
    String osPrefix = 'Flutter_iOS';
    if(Platform.isAndroid){
      osPrefix = 'Flutter_Android';
    }
    widget.connectionCB(host: _hostTextController.text, topic: _topicTextController.text, identifier: osPrefix);
  }

  void _disconnect(){
    manager.disconnect();
  }
}
