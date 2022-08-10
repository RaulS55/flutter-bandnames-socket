import 'dart:io';

import 'package:band_names/services/socket_service.dart';
import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket!.on("active-bands", (payload) {
      this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket!.off("active-bands");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Band Name", style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          Container(
              margin: EdgeInsets.only(right: 10),
              child: socketService.serverStatus == ServerStatus.Online
                  ? Icon(Icons.check_circle, color: Colors.blue)
                  : Icon(Icons.offline_bolt, color: Colors.red))
        ],
      ),
      body: Column(
        children: [
          _grafica(),
          Expanded(
            child: ListView.builder(
                itemCount: bands.length,
                itemBuilder: (context, index) => _bandTile(bands[index])),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) =>
          socketService.socket!.emit("delete-band", {"id": band.id}),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(15),
        child: const Text(
          "Delete Band",
          style: TextStyle(color: Colors.white, fontSize: 15),
        ),
      ),
      key: Key(band.id),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          band.votes.toString(),
          style: const TextStyle(fontSize: 20),
        ),
        onTap: (() => socketService.socket!.emit("vote-band", {"id": band.id})),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: ((_) => AlertDialog(
                title: const Text("New Band name"),
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                    elevation: 5,
                    textColor: Colors.blue,
                    onPressed: () => addBandToList(textController.text),
                    child: const Text("Add"),
                  )
                ],
              )));
    }

    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: const Text("New band Name"),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () => addBandToList(textController.text),
                  child: const Text("Add"),
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Dismiss"),
                )
              ],
            ));
  }

  addBandToList(String name) {
    if (name.length > 1) {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket!.emit("add-band", {"name": name});
    }
    Navigator.pop(context);
  }

  Widget _grafica() {
    Map<String, double> dataMap = {"": 0};
    dataMap.clear();
    bands.forEach((band) {
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });
    return dataMap.isNotEmpty
        ? Container(
            width: double.infinity,
            height: 300,
            child: PieChart(dataMap: dataMap))
        : SizedBox();
  }
}
