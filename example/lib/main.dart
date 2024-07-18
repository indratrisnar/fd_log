import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fd_log/fd_log.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

FDLog dLog = FDLog();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TestFDLog(),
    );
  }
}

class TestFDLog extends StatelessWidget {
  const TestFDLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('D Log'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ElevatedButton(
            onPressed: () {
              FDLog().basic('basic');
            },
            child: const Text('Basic'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              dLog.basic('basic 2');
            },
            child: const Text('Basic 2'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              dLog.title(
                'Lorem ipsum',
                'Lorem ipsum is placeholder text commonly used in the graphic, print, and publishing industries for previewing layouts and visual mockups.',
              );
            },
            child: const Text('Title'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              String url = 'https://jsonplaceholder.typicode.com/todos/1';
              final response = await http.get(Uri.parse(url));
              dLog.response(response);
            },
            child: const Text('Response Http'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              try {
                final doc = await FirebaseFirestore.instance
                    .collection('Cars')
                    .doc('jFIrKWrOCMNoWBcwUrgq')
                    .get();
                dLog.firestoreDocument(doc);
              } catch (e) {
                dLog.basic(e.toString());
              }
            },
            child: const Text('Document Firestore'),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
