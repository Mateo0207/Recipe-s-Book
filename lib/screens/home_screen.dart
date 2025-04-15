import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app2/provider/recipes_provider.dart';
import 'package:flutter_app2/screens/recipe_detail.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  
  @override
  Widget build(BuildContext context) {
    //llamado al provider
    final recipesProvider = Provider.of<RecipesProvider>(context,listen: false);
    recipesProvider.fetchRecipes();
    //FetchRecipes(); // cada vez que se construya la pantalla nos muestre la data que se solicita
    return Scaffold(
      body:
      // Se recibe los datos traidos del json
      Consumer<RecipesProvider>(
        builder: (context,provider, child){
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator(),);
            
          }
          else if(provider.recipes.isEmpty){
            return Center(child: Text(AppLocalizations.of(context)!.noRecipes),);// mostramos informacion del l10n

          } else {
            return ListView.builder( // Permite mostrar una lista de datos larga de forma optima
            itemCount: provider.recipes.length,
            itemBuilder: (context, index){
            return _recipesCard(context,provider.recipes[index]);
            });
          }

          
          
        }
        )
      ,
      /*Column(
        children: <Widget>[
          _recipesCard(context),
          _recipesCard(context),
          _recipesCard(context),
          _recipesCard(context),
        ],
      ),*/


      //Botón flotante parte inferior
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        // para dejar redondo el botón
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          //side: BorderSide(color: Colors.white, width: 3) // dejar el borde del circulo blanco 
        ),
        child: Icon(Icons.add, color: Colors.white, size: 30,),
        //Cuando se oprima el botón
        onPressed: () {
          _showBottom(context); // llamado del modal
        },
      ),
    );
  }



  //Creación del modal redondeado
  Future<void> _showBottom(BuildContext context) {
  return showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    // Se agrega shape para redondear en la parte superior
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20), // Borde redondeado en la parte superior
      ),
    ),
    builder: (contexto) => Wrap( // Permite que el modal se ajuste dinámicamente
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          //height: 600,
          // se agrega un Boxdecoration para asegurarse que el container tambien tenga bordes redondos
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20), // Aplica el borde aquí también
            ),
          ),
          child: Padding( //Permite que el modal suba con el teclado
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom), // permite ajustar el espacio  en la parte inferior de un widget cuando aparece el teclado
            child: SingleChildScrollView( // Habilita desplazamiento interno
              physics: BouncingScrollPhysics(), // Mejora la fluidez del scroll
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag, // Oculta el teclado al desplazar
              child: Column(
                mainAxisSize: MainAxisSize.min, // Permite que el modal se ajuste al contenido
                // indicador redondeado en la parte superior del modal
                children: [
                  Container(
                    margin: const EdgeInsets.only(top:12), // margen superior
                    width: 80, // ancho 
                    height: 8, // alto 
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const RecipeForm(), // Se hace el llamado del formulario dentro del modal
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

  // Card de las recetas
  Widget _recipesCard(BuildContext context, dynamic recipe) {
    return GestureDetector( // se coloca el gesture detector para oprimir e ir a la otra pantalla para detalles
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => RecipeDetail(recipesData:recipe))); // para ir a la otra pantalla --- con recipeName:'Lasagna' podemos enviar y recibir información, esta variable se declara en la otra pantalla de recipe_detail
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          
          width: MediaQuery.of(context).size.width,
          height: 120, // maneja el tamaño de la card
          child: Card(
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 125,
                  width: 100,
                  
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
      
                    child: Image.network(
                      recipe.image_link,
                      fit:BoxFit.cover,
                    ),
                  ),
                ),
      
                SizedBox(width: 26),
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, //Organizar de forma vertical
                  crossAxisAlignment:
                      CrossAxisAlignment.start, //Organizar de forma horizontal en el inicio
                  children: <Widget>[
                    Text(
                      recipe.name,
                      //"Lasagna",
                      style: TextStyle(fontSize: 18, fontFamily: 'Poppins'),
                    ),
                    SizedBox(height: 4),
                    Container(height: 1, width: 75, color: Colors.orange),
                    Text(
                      recipe.author,
                      //"Julian Bosa",
                      style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    ),
                    SizedBox(height: 4),
                    
                    /*
                    Text(
                      recipe['description'],
                      style: TextStyle(fontSize: 12, fontFamily: 'Poppins'),
                      textAlign:context
                    )
                    */
                    
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Formulario
class RecipeForm extends StatelessWidget {
  
  const RecipeForm({super.key});
 
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>(); // para guardar y validar los datos en el formulario
    
    // para cada campos en el formulario se necesita un controlador para que cada campo sea editado y guardado
    // después se agregan los controladores a cada textField
    final TextEditingController _recipeName = TextEditingController();
    final TextEditingController _recipeAuthor = TextEditingController();
    final TextEditingController _recipeIMG = TextEditingController();
    final TextEditingController _recipeDescription = TextEditingController();



    return Padding(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Add new recipe',
              style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.bold ),
            ),
            Text(
              'Enter the data for the new recipe',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),


            
            SizedBox(height: 16), // espaciado entre texto y label
            
            // Label Nombre
            _buildTextField(
              controller:_recipeName,
              label: 'Recipe Name',
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Please enter the name recipe'; // se hace este condicional con el fin de verificar el campo si esta vacio
                }
              return null;
              // cuando validator aparece con error es por que se tiene que agregar a la widget personalizada que se creo anteriormente, igualmente sucede con el controller
            }),



            SizedBox(height: 12), // espaciado entre label

            // Label autor
            _buildTextField(
              controller:_recipeAuthor,
              label: 'Author',
              validator: (value){
                if (value == null || value.isEmpty){
                return 'Please enter the author'; // se hace este condicional con el fin de verificar el campo si esta vacio
                }
              
              return null;
              // cuando validator aparece con error es por que se tiene que agregar a la widget personalizada que se creo anteriormente, igualmente sucede con el controller
            }),


            SizedBox(height: 12), // espaciado entre label

            // label Imagen URL
            _buildTextField(
              controller:_recipeIMG,
              label: 'Image URL',
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Please enter the Image URL'; // se hace este condicional con el fin de verificar el campo si esta vacio
                }
                return null;
              // cuando validator aparece con error es por que se tiene que agregar a la widget personalizada que se creo anteriormente, igualmente sucede con el controller
            }),



            SizedBox(height: 12), // espaciado entre label

            // Label descripción receta
            _buildTextField(
              maxLines: 4,
              controller:_recipeDescription,
              label: 'Description',
              validator: (value){
                if (value == null || value.isEmpty){
                  return 'Please enter the recipe description'; // se hace este condicional con el fin de verificar el campo si esta vacio
                }
                return null;
              // cuando validator aparece con error es por que se tiene que agregar a la widget personalizada que se creo anteriormente, igualmente sucede con el controller
            }          
            
            ),


            SizedBox(height: 12), // espaciado entre label

            // botóm para enviar, se agrega center para que el botón esté centrado
            Center(
              child: ElevatedButton(
                // Cuando se oprima el botón se llama la llave del form y se menciona el estado se valida si esta lleno o vacio
                // el formkey contiene el estado del formulario, currentState es el estado mas cercano
                // si el estado no se encuentra se llama al validate
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                  Navigator.pop(context); // se cierra el formulario cuando ya no se necesita

                  }
                },
                
                // decoración del botón
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                ),
                //Styles para el titulo del botón
                child: 
                Text('Save Recipe', 
                style: TextStyle(
                  color: Colors.white, 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold),)),
            )
            
          ],
        ),
      ),
    );
  }

  // widget personalizada label para ingresar receta
  Widget _buildTextField({
  required String label,
  required TextEditingController controller, 
  required String? Function(String?)validator,
  int maxLines = 1}) 
  {
    return TextFormField(
      decoration: InputDecoration(
        // se ingresa el label
        labelText: label,
        // se le da estilo al label
        labelStyle: TextStyle(fontFamily: 'Proppins', color: const Color.fromARGB(255, 0, 0, 0)),
        // Cuando esta sin seleccionar
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        // Cuando esta en estado focus
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: validator,
      maxLines: maxLines,

      
    );
  }
}
