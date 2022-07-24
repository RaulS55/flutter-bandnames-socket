import 'dart:io';

import 'package:band_names/src/models/band.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: "1", name: "Metalica", votes: 10),
    Band(id: "2", name: "Queen", votes: 5),
    Band(id: "3", name: "Bon Jobi", votes: 6),
    Band(id: "1", name: "RHCP", votes: 15),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: const Text("Band Name", style: TextStyle(color: Colors.black54)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        elevation: 1,
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => print("Borrado"),
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
        onTap: (() => print(band.name)),
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();
    if (Platform.isAndroid) {
      return showDialog(
          context: context,
          builder: ((context) => AlertDialog(
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
      //Agregar
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
