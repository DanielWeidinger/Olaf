import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart' as mqtt;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  String broker           = '192.168.99.100';
  int port                = 1883;
  String username         = 'user';
  String passwd           = 'passwd';
  String clientIdentifier = 'VikingPhone';
  mqtt.MqttClient client;
  mqtt.MqttClientConnectionStatus connectionState;
  StreamSubscription subscription;
  String _val = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Olaf - Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(_val)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _connect,
      ),
    );
  }

  void _connect() async {
    client = mqtt.MqttClient(broker, '');
    client.port = port;
    client.logging(on: true);
    client.keepAlivePeriod = 30;
    client.onDisconnected = _onDisconnected;

    final mqtt.MqttConnectMessage connMess = mqtt.MqttConnectMessage()
        .withClientIdentifier(clientIdentifier)
        .startClean() // Non persistent session for testing
        .keepAliveFor(30)
        .withWillQos(mqtt.MqttQos.atMostOnce);
    client.connectionMessage = connMess;

    try {
      await client.connect(username, passwd);
    } catch (e) {
      print(e);
      _disconnect();
    }

    if (client.connectionState == mqtt.MqttConnectionState.connected) {
      setState(() {
        connectionState = client.connectionStatus;
      });
    } else {
      _disconnect();
    }

    subscription = client.updates.listen(_onMessage);

    _subscribeToTopic("temp");
  }

  void _subscribeToTopic(String topic) {
    if (connectionState == mqtt.MqttClientConnectionStatus) {
      client.subscribe(topic, mqtt.MqttQos.exactlyOnce);
    }
  }

  String _onMessage(List<mqtt.MqttReceivedMessage> event) {
    final mqtt.MqttPublishMessage recMess =
    event[0].payload as mqtt.MqttPublishMessage;
    final String message =
    mqtt.MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

    print('[MQTT client] MQTT message: topic is <${event[0].topic}>, '
        'payload is <-- ${message} -->');
    print(client.connectionState);
    print("[MQTT client] message with topic: ${event[0].topic}");
    print("[MQTT client] message with message: ${message}");
    setState(() {
       _val = message;
    });
  }

  void _disconnect() {
    print('[MQTT client] _disconnect()');
    client.disconnect();
    _onDisconnected();
  }

  void _onDisconnected() {
    print('[MQTT client] _onDisconnected');
    setState(() {
      //topics.clear();
      if(client != null)
      connectionState = client.connectionStatus;
      client = null;
      if(subscription != null)
        subscription.cancel();
      subscription = null;
    });
    print('[MQTT client] MQTT client disconnected');
  }
}
