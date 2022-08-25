import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hiveviewerproject/backend_manager.dart' as bm;
import 'package:hiveviewerproject/lib/src/backend/storage_backend.dart';
import 'package:hiveviewerproject/transaction.dart';
import 'package:hive/src/backend/storage_backend.dart' as StorageBackendclass;
import 'package:flutter/services.dart'
    show ByteData, PlatformAssetBundle, rootBundle;

import 'box_impl.dart';

import 'lib/src/hive_impl.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter("prince");
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Transaction>("randombox");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _counter = 0;

  void _incrementCounter() async {
//     print("working director ${Directory.current}");
//     String path =
//         "/data/user/0/com.example.hiveviewerproject/app_flutter/"; //randombox.hive";
//     var file = File(path);
//
//     BackendManager backendManager = BackendManager();
//     StorageBackend storageBackend =
//         await backendManager.open("randombox", path, false, null);
//
//     print(storageBackend.toString());
//     bool customiseGreeting(int x, int y) {
//       return false;
//     }
//
//     Box newBox = BoxImpl<Transaction>(
//         "randombox", null, customiseGreeting, storageBackend);
//
//     print("box is empty");
//     print(newBox.isEmpty);
//     print(newBox.length);
//     var systemTempDir = Directory.systemTemp;
//
//     // List directory contents, recursing into sub-directories,
//     // but not following symbolic links.
//     await for (var entity
//         in systemTempDir.list(recursive: true, followLinks: false)) {
// //      print(entity.path);
//     }
//     // Future<ByteData> value =
//     //     DefaultAssetBundle.of(context).load("assests/randombox.hive");
//     // String data = await rootBundle.loadString('assests/randombox.hive');
//     //
//     // print(data);
//     // print(value);

    if (Hive.isBoxOpen("randombox")) {
      Box box = Hive.box<Transaction>("randombox");
      final transaction = Transaction()
        ..name = _counter.toString()
        ..amount = _counter;
      box.add(transaction);
      print("box length ${box.length}");
      await box.close();
    }

    setState(() {
      _counter++;
    });
    //=============================working with hive

    HiveImpls hiveImpl = HiveImpls();

    // StorageBackendclass.StorageBackend storageBackend= await backendManager.open("randombox",  "/data/user/0/com.example.hiveviewerproject/app_flutter/", true, null);
    Box box = await hiveImpl.openBox("randombox",
        path: "/data/user/0/com.example.hiveviewerproject/app_flutter/");
    print(box.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
