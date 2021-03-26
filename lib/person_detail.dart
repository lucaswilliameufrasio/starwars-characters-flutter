import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:http/http.dart' as http;
import 'package:starwarsflutter/models/Films.dart';
import 'package:starwarsflutter/models/Person.dart';
import 'package:url_launcher/url_launcher.dart';

class PersonDetail extends StatefulWidget {
  PersonDetail({Key key, this.person}) : super(key: key);

  final Person person;

  @override
  _PersonDetailState createState() => _PersonDetailState();
}

Future<List<Films>> fetchFilms(http.Client client, PersonDetail widget) async {
  final uri = Uri.https("swapi.dev", "/api/films/", {
    "format": {"json"}
  });
  final response = await client.get(uri);

  Map<String, dynamic> args = Map();
  args["body"] = response.body;
  args["widget"] = widget;

  // return compute(parseFilms, response.body);
  return compute(parseFilms, args);
}

// A function that converts a response body into a List<Films>.
List<Films> parseFilms(Map args) {
  String responseBody = args["body"];
  PersonDetail widget = args["widget"];

  final parsed = jsonDecode(responseBody);
  var results = parsed['results'];

  List<dynamic> films = widget.person.films;
  List<dynamic> personFilms = List<dynamic>();

  for (var film in results) {
    var url = film['url'];
    if (films.contains(url)) personFilms.add(film);
  }

  return personFilms.map<Films>((json) => Films.fromJson(json)).toList();
}

class _PersonDetailState extends State<PersonDetail> {
  _launchURL(PersonDetail widget) async {
    var url =
        'mailto:?subject=${widget.person.name}%20info&body=So%20now%20i%20know%20where%20you%20are,%20Jedi. \n Im%20coming.';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person.name),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: <Widget>[
            ElevatedButton(
              child: Text('Send ${widget.person.name} via email'),
              onPressed: () {
                _launchURL(widget);
              },
            ),
            ElevatedButton(
              child: Text("Share Star Wars Api"),
              onPressed: () {
                Share.share('https://swapi.dev/');
              },
            ),
            Text("Name: ${widget.person.name}"),
            Text("Birth Year: ${widget.person.birthYear}"),
            Text("Height: ${widget.person.height}"),
            Text("Mass: ${widget.person.mass}"),
            Text("Hair Color: ${widget.person.hairColor}"),
            Text("Skin Color: ${widget.person.skinColor}"),
            Text("Eye Color: ${widget.person.eyeColor}"),
            Text("Gender: ${widget.person.gender}"),
            Text("\nFilms:"),
            FutureBuilder<List<Films>>(
              future: fetchFilms(http.Client(), widget),
              builder: (context, snapshot) {
                if (snapshot.hasError) print(snapshot.error);

                return snapshot.hasData
                    ? FilmsList(films: snapshot.data)
                    : Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class FilmsList extends StatelessWidget {
  final List<Films> films;

  FilmsList({Key key, this.films}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.90,
      child: ListView.builder(
          itemCount: films.length,
          itemBuilder: (context, index) {
            var title = films[index].title;
            var releaseDate = films[index].releaseDate;
            return ListTile(
              title: Text(title),
              subtitle: Text(releaseDate),
            );
          }),
    );
  }
}
