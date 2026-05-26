class MenuItem {

  final int id;

  final String name;

  final int quantity;

  final double price;

  final String? image;

  MenuItem({

    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.image,
  });

  factory MenuItem.fromJson(
    Map<String, dynamic> json,
  ) {

    return MenuItem(

      id: json['id'],

      name: json['Item_Name'],

      quantity: json['Item_Quantity'],

      price:
          (json['Item_Price'] as num)
              .toDouble(),

      image: json['Item_Image'],
    );
  }
}