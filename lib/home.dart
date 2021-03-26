import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:starwarsflutter/models/Person.dart';
import 'package:starwarsflutter/person_detail.dart';

Future<List<Person>> fetchPeople(http.Client client) async {
  final uri = Uri.https("swapi.dev", "/api/people/", {
    "format": {"json"}
  });
  final completer = Completer<List<Person>>();

  try {
    final response = await client.get(uri);

    completer.complete(parsePeople(response.body));
    return completer.future;
  } catch (e) {
    completer.completeError("Something happened.");
    return completer.future;
  }
}

List<Person>? parsePeople(String responseBody) {
  final parsed = jsonDecode(responseBody);
  var results = parsed['results'];

  return results.map<Person>((json) => Person.fromJson(json)).toList();
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: FutureBuilder<List<Person>>(
        future: fetchPeople(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(snapshot.error.toString()),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                      fetchPeople(http.Client());
                    },
                    child: Text("Try again"),
                  )
                ],
              ),
            );
          }

          return snapshot.hasData
              ? PeopleList(people: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class PeopleList extends StatelessWidget {
  final List<Person>? people;

  PeopleList({Key? key, this.people}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: people!.length,
      itemBuilder: (context, index) {
        // return Text(results[index]['name']);
        var person = people![index];
        var name = person.name!;
        var birthyear = person.birthYear!;

        return ListTile(
          title: Text(name),
          subtitle: Text(birthyear),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PersonDetail(
                  person: person,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
