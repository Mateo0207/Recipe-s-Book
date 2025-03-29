import 'package:flutter/material.dart';



class RecipeDetail extends StatelessWidget {
  final String recipeName; // Variable declarada
  const RecipeDetail({super.key, required this.recipeName}); // constructor

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:AppBar(
        title: Text(recipeName),
        backgroundColor: Colors.orange,
        leading: 
        IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, onPressed: (){Navigator.pop(context);},), // al oprimir el icono se devuelve
      ),
    );
  }
}