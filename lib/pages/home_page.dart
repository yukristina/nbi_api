import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:nbiapi/model/player.dart';
import '../model/team.dart';

class HomePage extends StatelessWidget {
  List<Player> players = [];

  get index => null;

  // get teams
  Future getPlayers() async {
    var response =
        await http.get(Uri.https('balldontlie.io', 'api/v1/players'));
    var jsonData = jsonDecode(response.body);

    for (var eachPlayer in jsonData['data']) {
      final player = Player(
          firstname: eachPlayer['first_name'],
          lastname: eachPlayer['last_name'],
          id: eachPlayer['team']['id'],
          position: eachPlayer['position'],
          abbreviation: eachPlayer['team']['abbreviation'],
          city: eachPlayer['team']['city'],
          fullname: eachPlayer['team']['full_name'],
          name: eachPlayer['team']['name']);

      players.add(player);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder(
            future: getPlayers(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          color: Colors.grey,
                          child: Column(
                            children: [
                              Text(players[index].abbreviation),
                              Text(players[index].firstname),
                              Text(players[index].lastname),
                            ],
                          ),
                        ),
                      );
                    });
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }
}
