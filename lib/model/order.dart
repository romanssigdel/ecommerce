import 'package:cloud_firestore/cloud_firestore.dart';

class Orders {
  String? orderId;
  String? userId;
  String? totalAmount;
  DateTime? orderDate;
  List<Products>? products;

  Orders(
      {this.orderId,
      this.userId,
      this.totalAmount,
      this.orderDate,
      this.products});

  Orders.fromJson(Map<String, dynamic> json) {
    orderId = json['orderId'];
    userId = json['userId'];
    totalAmount = json['totalAmount'];
    orderDate = json['orderDate'] is Timestamp
        ? (json['orderDate'] as Timestamp).toDate()
        : json['orderDate'] as DateTime?;
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderId'] = this.orderId;
    data['userId'] = this.userId;
    data['totalAmount'] = this.totalAmount;
    data['orderDate'] = this.orderDate;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Products {
  String? id;
  String? name;
  String? price;
  String? quantity;
  String? image;

  Products({this.id, this.name, this.price, this.quantity, this.image});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['image'] = this.image;
    return data;
  }
}
