class Product {
  String? image;
  String? id;
  String? name;
  String? description;
  String? category;
  String? price;

  Product({this.image, this.name, this.description, this.price, this.category});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
    category = json['category'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image'] = this.image;
    data['name'] = this.name;
    data['description'] = this.description;
    data['category'] = this.category;
    data['price'] = this.price;
    return data;
  }
}
