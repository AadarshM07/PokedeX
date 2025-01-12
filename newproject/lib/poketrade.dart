import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:PokedeX/pokebank.dart';
import 'package:cached_network_image/cached_network_image.dart';

var boxx=Hive.box('Poketrade');
List<dynamic> history=boxx.get(username,defaultValue: []);


class poketrade extends StatefulWidget {
  const poketrade({super.key});

  @override
  State<poketrade> createState() => _poketradeState();
}

class _poketradeState extends State<poketrade> {
  final TextEditingController userController = TextEditingController();  
  final TextEditingController tradeController = TextEditingController();


  @override
  

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey ,
      appBar:  AppBar(
      backgroundColor: Colors.blueGrey,
      elevation: 4,
      title: Text('Poketrade', style: TextStyle(fontSize: 20,color: Colors.amber,fontWeight:FontWeight.bold)),
      centerTitle: true,
    ),
    body: Stack(
  children: [
    Positioned(
      top: 40,
      left: 10,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Text(
          'Trading Options',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    ),
    Positioned(
  top: 100,
  left: 20,
  child: Container(
    width: 170,
    height: 50,
    child: FloatingActionButton(
      onPressed: () {
        openDialog();
      },
      backgroundColor: Colors.purple,
      child: Text(
        'Trade with friends',
        style: TextStyle(
          fontSize: 12,
          color: Colors.white,
        ),
      ),
    ),
  ),
),
Positioned(
  top: 170,
  left: 10,
  child: Padding(
    padding: const EdgeInsets.all(14.0),
    child: Text(
      'Trade history',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  ),
),
Positioned(
  top: 240,
  left: 10,
  right: 20,
  bottom: 10, 

  child: 
    GridView.builder(
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 1,
      childAspectRatio: 3.4,
    ),
    itemCount: history.length,
    itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: CachedNetworkImage(
            imageUrl:'dds' ,
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
                title: Text(
                  'You Transferred a ${history[index][0]} to ${history[index][1]}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
        
            ],
          ),
        ),
      );
    },
  ),
),


  ],
),


    );
  

  }
  Future openDialog() => showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Enter Details'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: userController,
          decoration: InputDecoration(labelText: 'To : user id',
           border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), )),
        ),
        SizedBox(height: 20),
        TextField(
          controller: tradeController,
          decoration: InputDecoration(labelText: 'Trade : Pokemon name',
          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), )),
        ),
      ],
    ),
    actions: [
      TextButton(
        child: Text('CANCEL', style: TextStyle(color: Colors.red)),
        onPressed: () {
          userController.clear();
          tradeController.clear();
          Navigator.of(context).pop();

        },
      ),
      TextButton(
        child: Text('SEND'),
       onPressed: () {
  var loginBox = Hive.box('Authenticate');
  String username = loginBox.get('status'); // Current user's username
  String user = userController.text.trim(); // Target user's username
  String pokemonName = tradeController.text.trim(); // Pokémon to trade

  var pokewallet = Hive.box('Pokewallet');
  List<dynamic> pokemons = pokewallet.get(username, defaultValue: []);

  if (loginBox.containsKey(user)) {
    if (pokemons.contains(pokemonName)) {
      pokemons.remove(pokemonName);
      pokewallet.put(username, pokemons);

      List<dynamic> otheruserPokemons = pokewallet.get(user, defaultValue: []);
      otheruserPokemons.add(pokemonName);
      pokewallet.put(user, otheruserPokemons);
      history.add([pokemonName,user]);
      boxx.put(username,history);

      print("Success: Pokémon traded!");
      Navigator.of(context).pop();
    } else {
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: You dont own this pokemon.',style: TextStyle(color: Colors.yellow),),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
    }
  } else {
     ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
        content: Text('Error: Target username doesnt exist',style: TextStyle(color: Colors.yellow),),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
      ));
  }

  setState(() {
  });
}


            
          
        
      ),
    ],
  ),
);


}