class Dish {
  final String title;
  final String description;
  final String image;
  final double price;
  final bool isMain;

  Dish({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    this.isMain = false,
  });
}
