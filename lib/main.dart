import 'package:band_names/services/socket_service.dart';
import 'package:band_names/src/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SocketService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material APP',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: Pages.routes,
        initialRoute: Pages.INITIAL,
      ),
    );
  }
}
