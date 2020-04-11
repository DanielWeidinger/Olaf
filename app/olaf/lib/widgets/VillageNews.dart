import 'package:flutter/material.dart';
import 'package:olaf/services/MQTTManager.dart';
import 'package:olaf/services/states/MQTTState.dart';
import 'package:provider/provider.dart';

class VillageNews extends StatefulWidget {
  VillageNews(MQTTManager manager);

  @override
  _VillageNewsState createState() => _VillageNewsState();
}

class _VillageNewsState extends State<VillageNews> {
  @override
  Widget build(BuildContext context) {
    MQTTAppState _state = Provider.of<MQTTAppState>(context);

    return Container(
      height: 330,
      child: ListView(
        reverse: true,
        children: _state.getAllMessages.map((msg) => MQTTMessageItem(msg)).toList(),
      ),
    );
  }
}


class MQTTMessageItem extends StatefulWidget {
  final MQTTMessage msg;

  MQTTMessageItem(this.msg);

  @override
  _MQTTMessageItemState createState() => _MQTTMessageItemState();
}

class _MQTTMessageItemState extends State<MQTTMessageItem> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: _isAlert(widget.msg.topic) ? Colors.red : null,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Topic: " + widget.msg.topic),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(widget.msg.Json["title"] + " : "),
              Text(widget.msg.Json["msg"].toString())
            ],
          ),
          Divider(),
          Text(DateTime.fromMicrosecondsSinceEpoch(widget.msg.Json["time"]).toIso8601String())
        ],
      ),
    );
  }

  bool _isAlert(String topic){
    return topic.contains("infrared") ||
           topic.contains("eyesight") ||
           topic.contains("heartbeat");
  }
}

