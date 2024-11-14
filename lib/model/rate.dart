class Rate {
  String? rating;
  String? productId;
  String? userId;
  bool? isRated;
  String? image;
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

  Rate(
      {this.rating,
      this.isRated = false,
      this.productId,
      this.userId,
      this.image,
      this.description,
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

  Rate.fromJson(Map<String, dynamic> json) {
    rating = json['rating'];
    isRated = json['isRated'] ?? false;
    userId = json['userid'];
    productId = json['productid'];
    image = json['image'];
    description = json['description'];
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
    data['rating'] = this.rating;
    data['isRated'] = this.isRated;
    data['userId'] = this.userId;
    data['productId'] = this.productId;
    data['description'] = this.description;
    data['image'] = this.image;
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
