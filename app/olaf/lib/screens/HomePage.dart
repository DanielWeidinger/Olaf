import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;
import 'package:olaf/services/MQTTManager.dart';
import 'package:olaf/services/states/MQTTState.dart';
import 'package:olaf/widgets/MQTTConnection.dart';
import 'package:olaf/widgets/MQTTMessenger.dart';
import 'package:olaf/widgets/VillageNews.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  MQTTManager _manager;
  MQTTMessenger _messenger;

  @override
  Widget build(BuildContext context) {

    _messenger = MQTTMessenger();


    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Olaf - Village Administration'),
        backgroundColor: Colors.greenAccent,
      ),
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.only(top: 25),
          child: MQTTConnection(_createManager),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              Column(
                    children: <Widget>[
                      Image.asset("assets/profile.jpg", scale: 10,),
                      Text("name: Olaf Olafson"),
                      Text("occupation: Professional Viking")
                    ],
              ),
              VillageNews(_manager),
              _messenger
            ],
          ),
        ),
      ),
    );
  }

  _createManager({host, topic, identifier}){

    MQTTAppState _currentState = Provider.of<MQTTAppState>(context);

    _manager = MQTTManager(
        host: host,
        topic: topic,
        identifier: identifier,
        state: _currentState);
    _manager.initializeMQTTClient();
    _manager.connect();
    _messenger.manager = _manager;
  }

  /*
   if (controller == _messageTextController &&
        state == MQTTAppConnectionState.connected) {
      shouldEnable = true;
    } else
  */

}
