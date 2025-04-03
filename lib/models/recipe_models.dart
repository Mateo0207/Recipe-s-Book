// un modelo define los atributos que un conjunto de datos que debe tener


class Recipe {
  String name;
  String author;
  String image_link;
  String description;
  String preparation_time;
  List<String> recipeSteps;

  Recipe({
    required this.name,
    required this.author,
    required this.image_link,
    required this.description,
    required this.preparation_time,    
    required this.recipeSteps,
  });

  // manejo y cambio de estado de la clase
  factory Recipe.fromJSON(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      author: json['author'],
      image_link: json['image_link'],
      description: json['description'],
      preparation_time: json['preparation_time'],
      recipeSteps: List<String>.from(json['steps'])
    );
  }

  // consersor
  Map<String, dynamic> toJson(){
    return{
      'name': name,
      'author': author,
      'image_linkg': image_link,
      'description': description,
      'preparation_time':preparation_time,
      'steps': recipeSteps
    };
  }

  // se agrega el override para que cada que se imprima poder verlas en nuestra consola
  @override
  String toString (){
    return 'Recipe{name:$name, $author, $image_link,$description, $preparation_time, steps:$recipeSteps}';
  }

}
