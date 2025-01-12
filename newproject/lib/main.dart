import 'package:PokedeX/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:PokedeX/pokehunt.dart';
import 'package:PokedeX/poketrade.dart';
import 'package:PokedeX/pokebank.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async{
  await Hive.initFlutter();  //hive initilaize

  var login = await Hive.openBox('Authenticate');

  var pokewallet =await Hive.openBox('Pokewallet');

  var trade = await Hive.openBox('Poketrade');

  runApp(Pokedex());
}

class Pokedex extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
      routes: {
        '/pokehunt':(context)=>PokeHunt(),
        '/poketrade':(context)=>poketrade(),
        '/pokebank':(context)=>PokeBank(),
      },
    );
  }

  
}
