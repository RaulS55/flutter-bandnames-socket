import 'package:band_names/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
      body: Container(
        child: Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [Text("Server Status: ${socketService.serverStatus}")],
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket!.emit("emitir-mensaje", {
            "nombre": "Flutter",
            "mensaje": "Hola desde Flutter",
          });
        },
        child: Icon(Icons.message),
      ),
    );
  }
}
