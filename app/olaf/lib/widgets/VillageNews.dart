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
        children: _state.getAllMessages.map((msg) => MQTTMessageItem(msg.Json)).toList(),
      ),
    );
  }
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

