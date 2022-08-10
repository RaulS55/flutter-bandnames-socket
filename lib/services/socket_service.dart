import 'package:flutter/cupertino.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  SocketService() {
    initConfig();
  }

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? get socket => _socket;

  void initConfig() {
// Dart client
    _socket = IO.io(
        'http://192.168.100.6:3000/',
        IO.OptionBuilder()
            .setTransports(["websocket"])
            .enableAutoConnect()
            .build());

    _socket.onConnect((_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket.onDisconnect((_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

/*
    socket.on("nuevo-mensaje", (payload) {
      print("nuevo-mensaje:");
      print("nombre:" + payload["nombre"]);
      print("mensaje:" + payload["mensaje"]);
      print(payload.containsKey("mensaje2") ? payload["mensaje2"] : "No hay");
    });*/
  }
}
