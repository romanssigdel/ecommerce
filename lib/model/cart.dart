class Cart {
  String? image;
  String? userId;
  String? id;
  String? name;
  String? category;
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

  Cart(
      {this.image,
      this.description,
      this.userId,
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

  Cart.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    description = json['description'];
    id = json['id'];
    userId = json['userId'];
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
    data['image'] = this.image;
    data['id'] = this.id;
    data['userId'] = this.userId;
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
