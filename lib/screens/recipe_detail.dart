import 'package:flutter/material.dart';
import 'package:flutter_app2/models/recipe_models.dart';
import 'package:flutter_app2/provider/recipes_provider.dart';
import 'package:provider/provider.dart';

class RecipeDetail extends StatefulWidget {
  final Recipe recipesData;
  const RecipeDetail({super.key, required this.recipesData});

  @override
  _RecipeDetailState createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  bool isFavorite = false;

 
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isFavorite = Provider.of<RecipesProvider>(context, listen: false).favoriteRecipe.contains(widget.recipesData); // acceder a la data que viene 
  }
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:AppBar(
        title: Text(widget.recipesData.name, style: TextStyle(color: Colors.white),), // se muestra el título al abrir el detalle de la receta
        backgroundColor: Colors.orange,
        leading: 
        IconButton(icon: Icon(Icons.arrow_back), color: Colors.white, onPressed: (){Navigator.pop(context);},), // al oprimir el icono se devuelve
        actions: [
          IconButton(onPressed:() async{
            await Provider.of<RecipesProvider>(context, listen: false).toggleFavoriteStatus(widget.recipesData); // para saber si esta en favoritos o no
            setState(() {
              isFavorite =!isFavorite; // para llenar 
            });
          }, 
          icon: Icon(isFavorite?Icons.favorite: Icons.favorite_border, color: const Color.fromARGB(255, 255, 255, 255),))
        ],
      ),

      // 
      body: Padding(padding: EdgeInsets.all(18),
        child:Column(children: [
          Image.network(widget.recipesData.image_link, fit:BoxFit.cover,),
          Text(widget.recipesData.name),
          SizedBox(height: 8,),
          Text("by ${widget.recipesData.author}"),
          SizedBox(height: 8,),
          Text('Recipes steps:'),
          for (var step in widget.recipesData.recipeSteps) Text('- $step'),
        ],) ,),
    );
  }
}




  