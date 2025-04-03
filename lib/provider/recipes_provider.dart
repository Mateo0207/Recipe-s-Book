import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app2/models/recipe_models.dart';
import 'package:http/http.dart' as http;

class RecipesProvider extends ChangeNotifier{
  // variable de carga, nos permite saber cuando tenemos los datos y cuando esta cargando
  bool isLoading = false;
  // se guardan las recetas en una lista
  List<Recipe> recipes =[];


   // llamado a la API
   // ya no es una lista dinámica por que ya tenemos la lista de recetas
   Future <void> fetchRecipes()async{
    // inicializar la carga de datos
    isLoading = true;
    notifyListeners(); // escuchamos los movimientos que se hacen
    // puertos: Android 10.0.2.2
    // iOS: 127.0.0.1
    // WEB: 'http://localhost:12345/recipes'
    final url = Uri.parse('http://10.0.2.2:12345/recipes');
    // manejo de cara a nuestra llamada
    try {
      final response = await http.get(url); // capturar la respuesta de la API
      if (response.statusCode ==200) {
        final data = jsonDecode(response.body); // aca traemos la información de la rta en un body
        // ya no nos traemos la data de recipe, sino, se hace un casteo del modelo con respecto a la data que esta lllegando
        recipes = List<Recipe>.from(data["recipes"].map((recipes)=> Recipe.fromJSON(recipes)));
      } else{
        print('Error ${response.statusCode}');
        recipes = []; // retornamos una lista vacia indicando que no se estan consumiendo datos
      }
    } catch (e) {
      print('Error in request: $e');
      recipes = []; 
      
    } finally {
      isLoading = false;
      notifyListeners();
    }
        
  }




}