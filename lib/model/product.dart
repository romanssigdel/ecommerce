class Product {
  String? image;
  String? id;
  String? quantity;
  String? name;
  String? category;
  String? brand;
  String? price;
  String? model;
  String? cpu;
  String? operatingSystem;
  String? memory;
  String? storage;
  String? screen;
  String? graphics;
  String? wirelessConnectivity;
  String? camera;
  String? warranty;
  String? description;

  Product(
      {this.image,
      this.description,
      this.brand,
      this.quantity,
      this.id,
      this.name,
      this.category,
      this.price,
      this.model,
      this.cpu,
      this.operatingSystem,
      this.memory,
      this.storage,
      this.screen,
      this.graphics,
      this.wirelessConnectivity,
      this.camera,
      this.warranty});

  Product.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    brand = json['brand'];
    description = json['description'];
    quantity = json['quantity'];
    id = json['id'];
    name = json['name'];
    category = json['category'];
    price = json['price'];
    model = json['model'];
    cpu = json['cpu'];
    operatingSystem = json['operatingSystem'];
    memory = json['memory'];
    storage = json['storage'];
    screen = json['screen'];
    graphics = json['graphics'];
    wirelessConnectivity = json['wirelessConnectivity'];
    camera = json['camera'];
    warranty = json['warranty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['quantity'] = this.quantity;
    data['brand'] = this.brand;
    data['image'] = this.image;
    data['id'] = this.id;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    data['model'] = this.model;
    data['cpu'] = this.cpu;
    data['operatingSystem'] = this.operatingSystem;
    data['memory'] = this.memory;
    data['storage'] = this.storage;
    data['screen'] = this.screen;
    data['graphics'] = this.graphics;
    data['wirelessConnectivity'] = this.wirelessConnectivity;
    data['camera'] = this.camera;
    data['warranty'] = this.warranty;
    return data;
  }
}
