import 'package:PokedeX/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';

var box = Hive.box('Authenticate');
var username=box.get('status');
var pokewallet= Hive.box('Pokewallet');
List<dynamic> pokemons=pokewallet.get(username,defaultValue: []);
List<Map<String, dynamic>> details = [];


class PokeBank extends StatefulWidget {
  const PokeBank({super.key});

  @override
  State<PokeBank> createState() => _PokeBankState();


}

class _PokeBankState extends State<PokeBank> {
  
   List<Map<String, dynamic>> details = [];

  @override
  void initState() {
    super.initState();
    fetchlist();
  }

  void fetchlist() {
    var box = Hive.box('Authenticate');
    var username = box.get('status');
    var pokewallet = Hive.box('Pokewallet');
    List<dynamic> pokemons = pokewallet.get(username, defaultValue: []);

    setState(() {
      details = [];
      for (var k in pokedex) {
        if (pokemons.contains(k["name"])) {
          if (!details.any((detail) => detail["name"] == k["name"])) {
            details.add(k);
          }
        }
      }
    });
  }


  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar:  AppBar(
      backgroundColor: Colors.blueGrey,
      elevation: 4,
      title: Text('Pokebank', style: TextStyle(fontSize: 20,color: Colors.amber,fontWeight:FontWeight.bold)),
      centerTitle: true,
    ),

    body: Column(
  children: [
    
    Padding(
      padding: const EdgeInsets.all(3.0),
      child: Text(
        'My Pokemons : ${details.length}',
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
    
   
    Expanded( 
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1, 
            childAspectRatio: 1.8, 
          ),
          itemCount: details.length, 
          itemBuilder: (context, index) {
            var type = 'grass';
            return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8), 
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF2A3439),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black, 
                blurRadius: 5,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
                        Positioned(
            top: 2,
            right: 20,
            child: CachedNetworkImage(
              imageUrl: details[index]['img'],
              height: 150,
              width: 150,
              fit: BoxFit.contain, // Correct BoxFit
            ),
          ),

              Positioned(
                top: 30,
                left: 20,
                child: Text(
                  details[index]['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16, 
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 60,
                left: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.black38, 
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    details[index]['type'][0],
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
             Positioned(
                bottom: 20,
                left: 20,
                child: SizedBox( 
                  width: 100,
                  height: 40,
                  
                  child: FloatingActionButton.extended(
                  onPressed: () {
                  showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Confirm',style: TextStyle(color: Colors.red),),
                    content: Text('${details[index]['name']} will be left in jungle',style: TextStyle(color: Colors.green),),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(), // Close dialog
                        child: Text('Cancel'),
                      ),
                      

                  TextButton(
                    onPressed: () {
                      setState(() {
                     
                        pokemons.remove(details[index]['name']);

                        details.remove(details[index]);
                        
                        pokewallet.put(username, pokemons);

                 
                        print("Updated pokemons list: $pokemons");
                      });

                  
                      Navigator.of(context).pop();
                    },
                    child: Text('OK'),
                  ),

                    ],
                  ),
                );
                  },
                  label: const Text("release"), 
                  backgroundColor: Colors.red,
                ))
              )


            ],
          ),
        ),
            );
          },
        ),
      ),

    ),] ));
  }


 



}