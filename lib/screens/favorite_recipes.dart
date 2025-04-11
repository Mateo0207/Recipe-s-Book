import 'package:flutter/material.dart';
import 'package:flutter_app2/models/recipe_models.dart';
import 'package:flutter_app2/provider/recipes_provider.dart';
import 'package:flutter_app2/screens/recipe_detail.dart';
import 'package:provider/provider.dart';


class FavoriteRecipes extends StatelessWidget {
  
  const FavoriteRecipes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Consumer<RecipesProvider>(
        builder: (context, RecipesProvider, child) {
          final favoritesRecipes = RecipesProvider.favoriteRecipe;

          return favoritesRecipes.isEmpty ?
            Center(child: Text('No favorites recipes'),)
          : ListView.builder(
              itemCount: favoritesRecipes.length, // cuente cuantos items tenemos
              itemBuilder: (context, index){
                //return Center(child: Text('No favorites recipes'),); // prueba a ver si trae info
                //return Text(favoritesRecipes[index].toString()); // prueba 2 para ver si trae info
                final recipe = favoritesRecipes[index]; // colocar la información de la receta
                return favoriteRecipesCard(recipe: recipe);

              },
              );
            
        }
        
      ),
    );
  }
}


// clase personalizada para las recetas, es la card nueva de los favoritas
class favoriteRecipesCard extends StatelessWidget {
  final Recipe recipe;
  const favoriteRecipesCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetail(recipesData: recipe))); // push con ventana de detalle con la ventana e receta, se construye la ventana de recetas
      },
      child: Card(
        color: Colors.white,
        child: Column(
          children: [
            Text(recipe.name),
            Text(recipe.author),
          ],
         ),
      ),

    );
  }
}