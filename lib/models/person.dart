// Creamos un objeto persona
class Person {
  int? id;
  String name, description, pathImage;
  int age;
  Person(
      {this.id,
      required this.name,
      required this.description,
      required this.age,
      required this.pathImage});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        age: json['age'],
        pathImage: json['pathimage']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'age': age,
      'pathimage': pathImage
    };
  }
}
