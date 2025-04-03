import 'package:flutter/material.dart';
import 'package:flutter_app2/provider/recipes_provider.dart';
import 'package:flutter_app2/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // se envuelve en un widget y se agrega el multiprovider, se llama el notificador para llamar el provider y que toda la app lo escuche
      providers: [ChangeNotifierProvider(create: (_) => RecipesProvider())],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false, //esconder la marca de agua
        title: "hola Mundo",
        home: RecipeBook(),
      ),
    );
  }
}

class RecipeBook extends StatelessWidget {
  const RecipeBook({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // numero de pestañas
      
      //scaffold es como esa hoja en blanco
      child: Scaffold(

       /*bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.orange,
          selectedItemColor: Colors.white,
          type: BottomNavigationBarType.fixed, // para agregar más de 3 items
        
        
        //currentIndex: 0,
        items:[
          BottomNavigationBarItem(
      
            label: "Home",
            icon: Icon(Icons.home, color: Colors.white,)),
            
          
          BottomNavigationBarItem(
            label:"Favorite",
            icon: Icon(Icons.favorite),
            ),

            BottomNavigationBarItem(
            label:"Profile",
            icon: Icon(Icons.person),
            ),

            BottomNavigationBarItem(
            label:"Settings",
            icon: Icon(Icons.settings, color: Colors.white,),
            ),
            
            

          
        ]
      ),*/
        
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text(
            'Recipe´s Book',
            style: TextStyle(
              color: const Color.from(alpha: 1, red: 1, green: 1, blue: 1),
            ),
          ),

      
          bottom: TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white,
            tabs: [
              Tab(icon: Icon(Icons.home), text: 'Home'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
              Tab(icon: Icon(Icons.person), text: 'Profile'),
              Tab(icon: Icon(Icons.settings), text: 'Settings'),
              
              ]),
        ),
      
        body: TabBarView(children: [HomeScreen()]),
      ),
    );
  }


}