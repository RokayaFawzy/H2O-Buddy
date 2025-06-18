class Ingredient {
  final String foodName;
  final int calories;
  final String imageUrl;
  final double price;
  int count;

  Ingredient({
    required this.foodName,
    required this.calories,
    required this.imageUrl,
    required this.price,
    this.count = 0,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      foodName: json['food_name'],
      calories: json['calories'],
      imageUrl: json['image_url'],
      price: 12, 
    );
  }
}
