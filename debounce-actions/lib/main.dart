import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:rxdart/rxdart.dart';

void main() {
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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends HookWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // create our behavior subject every time widget is rebuilt
    final subject = useMemoized(
      () => BehaviorSubject<String>(),
      [key],
    );

    // dispose of the old subject every time widget is rebuilt
    useEffect(
      () => subject.close,
      [subject],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("RX DART"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<String>(
              stream: subject.stream
                  .distinct()
                  .debounceTime(const Duration(seconds: 1)),
              initialData: "Please Start Typing",
              builder: (context, snapshot) {
                return Text(snapshot.requireData);
              },
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                onChanged: subject.sink.add,
              ),
            )
          ],
        ),
      ),
    );
  }
}
