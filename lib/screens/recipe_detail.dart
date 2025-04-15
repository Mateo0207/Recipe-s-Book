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

/* Para hacer las animaciones a nuestro gusto y poder utilizarlas se añade el "with SingleTickerProviderStateMixin",
ayuda a tener todo el ciclo de vida de lo que seria la app, fundamental para que las animaciones sepan cuando iniciar y
en donde terminar */
class _RecipeDetailState extends State<RecipeDetail> with SingleTickerProviderStateMixin{
  bool isFavorite = false; // para saber favoritos
  // para las animaciones
  late AnimationController  _controller;
  late Animation<double> _scaleAnimation;

 // creación del componente para que se inicialice la funcion de las animaciones 
 @override
 //funcion vacia 
 void initState(){
  super.initState();
  //declaracion de los controladores, aca se indica cuando va a ser el inicio y el final de la animación
  _controller =AnimationController(vsync: this,
  duration: Duration(milliseconds: 300) 
  );

  // con esta se controla lo que pasa medio de la duración anterior
  // aca se muestra lo que sucede cada vez que se le de clic al corazon
  _scaleAnimation = Tween<double>(begin: 1.0, end:1.5).animate(
    CurvedAnimation(parent: _controller, curve: Curves.easeInOut) 
     )..addStatusListener((status){
      // aca se reversa, es decir pasa de pequeño a grande
      if (status == AnimationStatus.completed) {
        _controller.reverse();
        
      }
     });
 }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isFavorite = Provider.of<RecipesProvider>(context, listen: false).favoriteRecipe.contains(widget.recipesData); // acceder a la data que viene 
  }

  // la escucha de la animación, esperando que el controlador indique que ya finalizo la animación
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          // se agrega animación al botón de favoritos
          icon: ScaleTransition(
            scale: _scaleAnimation, 
            child: Icon(
            isFavorite?Icons.favorite: 
            Icons.favorite_border,
            color:Colors.red,))
          )
         
        ],
      ),

      // acceder dinamicamente a los detalles de la receta
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




  