import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';

class SteamScreen extends StatefulWidget {
  const SteamScreen({Key? key}) : super(key: key);

  @override
  State<SteamScreen> createState() => _SteamScreenState();
}

class _SteamScreenState extends State<SteamScreen> {
  // Here we will create a stream for out stream builder
  // For that we have to take a function that returns stream
  // We will use asyn* as we have to listen to all the streams That would come in future
  Stream<int> getNumber() async* {
    while (true) {
      await Future.delayed(Duration(seconds: 1));
      yield DateTime.now().second;
    }
    // WE have to use yield instead of return
  }

  // Here we created a list that accepts string
  // it means whenever someting is wriiten in the textformfield
  // it gets insertedin the list
  List<String> list = [];
  StreamScockets scockets = StreamScockets();
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
                stream: scockets.getResponse,
                builder: ((context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: Text('W R I T E   H E R E'));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  }
                  return ListView.builder(
                      itemCount: list.length,
                      itemBuilder: ((context, index) {
                        return Text(snapshot.data![index].toString());
                      }));
                })),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: editingController,
                ),
              ),
              IconButton(
                  onPressed: () {
                    list.add(editingController.text.toString());
                    scockets.addResponse(list);
                  },
                  icon: const Icon(Icons.send))
            ],
          )
        ],
      ),
    );
  }
}

class StreamScockets {
  // Here we used a stream Controller that listens to the values that are type of LIST<STRING>
  //We used broadcast keyword that means whenever a data inserted, it get broadcasted

  final _stream = StreamController<List<String>>.broadcast();

  // Here we created a property of te class that add data to the stream
  // It takes data in the form of list<String>
  void Function(List<String>) get addResponse => _stream.sink.add;

  // Here we created a stream of type list<String>
  // As we added data as list<String>
  Stream<List<String>> get getResponse => _stream.stream.asBroadcastStream();
}
