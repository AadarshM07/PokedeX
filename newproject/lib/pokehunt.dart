import 'package:PokedeX/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:math';
import 'package:hive_flutter/hive_flutter.dart';

var box = Hive.box('Authenticate');
var username=box.get('status');
var pokewallet= Hive.box('Pokewallet');
List<dynamic> pokemons=pokewallet.get(username,defaultValue: []);


class PokeHunt extends StatefulWidget {
  const PokeHunt({super.key});

  @override
  State<PokeHunt> createState() => _PokeHuntState();
}

class _PokeHuntState extends State<PokeHunt> {
  final TextEditingController pokeController = TextEditingController();
  
  String Pokename="";
  String Image="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {

    int index = Random().nextInt(pokedex.length);
    Image=pokedex[index]['img'];
    Pokename=pokedex[index]['name'];
    print(Pokename);

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar:  AppBar(
      backgroundColor: Colors.blueGrey,
      elevation: 4,
      title: Text('Pokehunt', style: TextStyle(fontSize: 20,color: Colors.amber,fontWeight:FontWeight.bold)),
      centerTitle: true,
    ),
    body:  
       index == null
          ? Center(child: CircularProgressIndicator(),) 
          :  Stack(
        children: [
           Align(
            alignment: Alignment(0.0, -0.6),
            child: CachedNetworkImage(
              imageUrl: pokedex[index]['img'], 
              width: 180, 
              height: 180, 
              color: Colors.black,
              fit: BoxFit.contain,
            ),),
            Align(
                  alignment:Alignment(0.0, 0.2),
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: pokeController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow,width: 2), 
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.yellow,width: 2), 
                      ),
                      labelText: 'Pokemon Name',
                      labelStyle: TextStyle(color: Colors.yellow),
                      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16), // Padding inside the TextField
                    ),
                  ),       
                  
                ),

                ),
            Align(
            alignment: Alignment(0.0, 0.5),
            child: Container(
              width: 150, 
              height: 50, 
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(15), 
              ),
              child: FloatingActionButton(
                onPressed: () {evaluate();},
                
                child: Text(
                  'GUESS',
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
            ),
          ) 
                  ] 
      
      
    ),
    );
  }

  void evaluate() async{
    String pokemon = pokeController.text.toLowerCase().trim();
    if(pokemon==Pokename.toLowerCase()){
       

       openNewPokeDialog();
       print(username);
       pokemons.add(Pokename);
       pokewallet.put(username,pokemons);
       print(pokemons);
       pokeController.clear();
       setState(() {
        
       });

    }else{
      print("wrong");
      pokeController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Wrong it was ${Pokename} , Try Again !',style: TextStyle(color: Colors.yellow),),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ),
    );
      setState(() {});
    }

  }




  Future openNewPokeDialog() => showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    title: Text('Nice Catch!', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl:Image ,
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 10), 
        Text('You got a ${Pokename}!', style: TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.w600)),
        Text('Your Pokemon is safe, checkout Pokebank', style: TextStyle(fontSize: 12,)),
      ],
      
    ),
    actions: [
      TextButton(
        child: Text('Thanks'),
        onPressed: () {
          Navigator.of(context).pop(); 
        },
      ),
    ],
  ),
);
  
}