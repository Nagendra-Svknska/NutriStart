class OrderModel {

  final int id;

  final String status;

  final double total;

  final String createdAt;

  final List<dynamic> items;

  OrderModel({

    required this.id,
    required this.status,
    required this.total,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(
    Map<String, dynamic> json,
  ) {

    return OrderModel(

      id: json['id'],

      status: json['status'],

      total:
          (json['total'] as num)
              .toDouble(),

      createdAt:
          json['created_at'],

      items:
          json['items'],
    );
  }
}