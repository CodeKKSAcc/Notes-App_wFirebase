class UserModel {
  int age;
  String name;
  String uId;
  String city;
  String state;
  String country;
  int createdAt;

  UserModel({
    required this.uId,
    required this.age,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    required this.createdAt,
  });

  factory UserModel.fromMap(Map<String, dynamic> myMap) {
    return UserModel(
      age: myMap["age"],
      name: myMap["name"],
      uId: myMap[""],
      city: myMap["city"],
      state: myMap["state"],
      country: myMap["country"],
      createdAt: myMap["createdAt"],
    );
  }
}
