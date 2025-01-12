import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math';

List pokedex = [];

    
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  //Allcontrollers
  final TextEditingController usernameController = TextEditingController();  
  final TextEditingController passwordController = TextEditingController();
  List filteritem=[];

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      checkStatusKey();
    });

    if (mounted) {
      fetchData();
    }
    setState(() {
      filteritem=pokedex;
    });
    
   
  }

  void filteritems(String query) {
    setState(() {
      filteritem = pokedex
          .where((poke) =>
              poke['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  
  }

  

  @override
 
  GlobalKey<ScaffoldState>_ScaffoldKEy=GlobalKey<ScaffoldState>();
  int PokeFirstIndex = Random().nextInt(50);

  


  
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var box = Hive.box('Authenticate');
    var username=box.get('status');

    
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      key:_ScaffoldKEy,
      drawer: Drawer(
  child: ListView(
    children: [
      UserAccountsDrawerHeader(
        accountName: Text('Features Just For You!'),
        accountEmail: Text('username : ${username}'),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: Icon(Icons.person, color: Colors.grey),
        ),
      ),
       ListTile(
        leading: Icon(Icons.account_balance),
        title: Text('Pokebank'),
        onTap: () {
            Navigator.pushNamed(context, '/pokebank');
          },
      ),
      ListTile(
        leading: Icon(Icons.swap_horiz),
        title: Text('Trading'),
        onTap: () {
            Navigator.pushNamed(context, '/poketrade');
          },
      ),
      ListTile(
          leading: Icon(Icons.camera_alt),
          title: Text('PokeHunt'),
          onTap: () {
            Navigator.pushNamed(context, '/pokehunt');
          },
          
        ),

      ListTile(
        leading: Icon(Icons.logout,color: Colors.red,),
        title: Text('Logout',
        style: TextStyle(color: Colors.red),),
        onTap: () async{
            await box.delete('status');
            setState(() {
              
            });
            Navigator.pushNamed(context, '/');
          },
        
      ),
    ],
  ),
),








      body: Stack(
        children: [
           Positioned(
            top: -50,
            right: -50,
            child: Image.asset(
              "images/pokeball.png",
              width: 200,
              fit: BoxFit.fitWidth,
              color: Colors.blueGrey,
            ),
          ),
         
          Positioned(
            top: 26,
            right: 26,
            child: IconButton(
              icon: Icon(Icons.menu,color: Colors.white,size:33.0),
              onPressed: () => _ScaffoldKEy.currentState!.openDrawer(),
            ),
          ),

          Positioned(
            top: 90,
            left: 20,
            child: Text('PokedeX', style: TextStyle(
              color:   Colors.yellow.shade700,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),)
          ),
          Positioned(
            top: 33, 
            left: 20,
            right: 90,
            child: CupertinoSearchTextField(
              placeholder: 'Search for pokemons',
              style: TextStyle(color: Colors.black,),
              placeholderStyle: TextStyle(color: Colors.black),
              onChanged: (value) {
                filteritems(value);
              },
               decoration: BoxDecoration(
              color: Colors.white54, 
              borderRadius: BorderRadius.circular(8), 
            ),
            ),
          ),
          
          Positioned(
            top:150,
            bottom:1,
            width: width,
        
            child: Column(
              children: [
                pokedex!=null? Expanded(
                child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, 
              childAspectRatio: 1.4, 
            ),
            itemCount: filteritem.length, 
            itemBuilder: (context, index) {
              var type=filteritem[index]['type'][0];
              return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                child: Container(
                  decoration: BoxDecoration(
                     color: pokedex[index]['type'][0] == "Grass" 
    ? Colors.green[800] 
: pokedex[index]['type'][0] == "Fire" 
        ? Colors.red[800] 
        : pokedex[index]['type'][0] == "Water" 
            ? Colors.blue[800] 
            : pokedex[index]['type'][0] == "Poison" 
                ? Colors.deepPurple[700] 
                : pokedex[index]['type'][0] == "Electric" 
                    ? Colors.amber[800] 
                    : pokedex[index]['type'][0] == "Rock" 
                        ? Colors.grey[700] 
                        : pokedex[index]['type'][0] == "Ground" 
                            ? Colors.brown[800] 
                            : pokedex[index]['type'][0] == "Psychic" 
                                ? Colors.indigo[800] 
                                : pokedex[index]['type'][0] == "Fighting" 
                                    ? Colors.orange[800] 
                                    : pokedex[index]['type'][0] == "Bug" 
                                        ? Colors.lightGreen[700]
                                        : pokedex[index]['type'][0] == "Ghost" 
                                            ? Colors.deepPurple[700]
                                            : pokedex[index]['type'][0] == "Normal" 
                                                ? Colors.grey[600] 
                                                : Colors.pink[800], 

                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        bottom:-10,
                        right:-10,
                        child: Image.asset('images/pokeball.png',height:100,fit:BoxFit.fitHeight,)),
                   Positioned(
                    top:30,
                    left:20,
                     child: Text(
                            filteritem[index]['name'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,fontSize: 15,color: Colors.white
                            ),
                          ),
                     ),
                     Positioned(
                    bottom:15,
                    left:20,
                     child: Container(
                      
                       child: Padding(
                         padding: const EdgeInsets.only(left:8.0,right:8.0,top:4.0,bottom:4.0),
                         child: Text(
                                type.toString()
                                ,style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
                              ),
                       ),
                       decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black26
                
                       ),
                     ),
                     ),
                      
                      
                    Positioned(
                      bottom:5,
                      right: 5,
                      child: CachedNetworkImage(imageUrl: filteritem[index]['img']))
                    ]
                  ),
                ),
                
              );
            },
                ),
              ):Center(
                child: CircularProgressIndicator(),
              )
            ],
            ),
          ),
        ],
      ),
      

    );
  }

  void fetchData() async {
    var url = Uri.https("raw.githubusercontent.com", "/Biuni/PokemonGO-Pokedex/master/pokedex.json");
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var decodedJson = jsonDecode(response.body);
      pokedex = decodedJson['pokemon'];

      setState(() {});

    } else {
      print("Failed to fetch data: ${response.statusCode}");
    }
    filteritem=pokedex;
  
  }
  
  Future<void> checkStatusKey() async {
    var login = Hive.box('Authenticate');
    if (!login.containsKey('status')) {
      await Future.delayed(Duration.zero, () {
        openDialog();
      });
    }
  }

  Future openDialog() => showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    title: Text('Login/SignUp'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: usernameController,
          decoration: InputDecoration(labelText: 'Create/Enter UserName',
           border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), )),
        ),
        SizedBox(height: 20),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(labelText: 'Create/Enter Password',
          border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10), )),
          obscureText: true,
        ),
      ],
    ),
    actions: [
      TextButton(
        child: Text('GET IN'),
        onPressed: () {
          saveToDatabase();

        },
      ),
    ],
  ),
   
  );

  



  Future<void> saveToDatabase() async {
  var loginBox = Hive.box('Authenticate');
  String username = usernameController.text.trim();
  String password = passwordController.text.trim();
  if(!loginBox.containsKey(username)){
    if (username.isNotEmpty && password.isNotEmpty) {
    loginBox.put(username, password);
   
    print('Data stored: $username, $password');
    Navigator.of(context).pop();
      Future.delayed(Duration(seconds: 1), () {
          openNewPokeDialog();
      });
    loginBox.put('status',username);
    setState(() {
      
    });
    
    

  } else {
    print('Fields cannot be empty');
  } 
  } else{
    print("username already exist logged in");
    Navigator.of(context).pop();
    loginBox.put('status',username);
    setState(() {
      
    });
    
  }

  
}
Future openNewPokeDialog() => showDialog(
  context: context,
  barrierDismissible: false,
  builder: (context) => AlertDialog(
    title: Text('Welcome Bonus!', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold)),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: CachedNetworkImage(
            imageUrl: pokedex[PokeFirstIndex]['img'],
            width: 180,
            height: 180,
            fit: BoxFit.contain,
          ),
        ),
        SizedBox(height: 10), 
        Text('You got a ${pokedex[PokeFirstIndex]['name']}!', style: TextStyle(fontSize: 16,color: Colors.red,fontWeight: FontWeight.w600)),
        Text('Your Pokemon is safe, checkout Pokebank', style: TextStyle(fontSize: 12,)),
      ],
      
    ),
    actions: [
      
      TextButton(
        child: Text('Thanks'),
        onPressed: () {
          Navigator.of(context).pop();
          var pokewallet= Hive.box('Pokewallet');
          var box = Hive.box('Authenticate');
          var username=box.get('status');
          pokewallet.put(username,[pokedex[PokeFirstIndex]['name']]);
        },
      ),
    ],
  ),
);

}
