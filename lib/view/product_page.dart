import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/model/rate.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/view/add_cart.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  var data, averageRating, totalCounts;
  ProductPage({super.key, this.data, this.averageRating, this.totalCounts});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? userId;
  String? userRole;
  String? userEmail;
  bool? canRateProduct;

  @override
  void initState() {
    super.initState();
    getValue();
  }

  getValue() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString("userId");
      userRole = prefs.getString("userRole");
      userEmail = prefs.getString("userEmail");
    });
    if (userId != null) {
      await checkUserRatingOfProductData(widget.data.id, userId!);
      await checkUserPurchase(widget.data.id, userId!);
    }
  }

  checkUserRatingOfProductData(String id, String userId) async {
    var provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.checkRatingOfProducts(id, userId);
  }

  checkUserPurchase(String productId, String userId) async {
    var provider = Provider.of<ProductProvider>(context, listen: false);
    await provider.checkOrderForBoughtProducts(productId, userId);
    setState(() {
      canRateProduct = provider.hasPurchasedProduct;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.data.category!}",
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CustomBottomNavigationBar(initialIndex: 0),
                    ),
                    (route) => false);
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: backGroundColor,
          foregroundColor: buttonForegroundColor,
        ),
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            // If loading, show the CircularProgressIndicator centered on the screen
            if (productProvider.checkRatingOfProduct == StatusUtil.loading ||
                productProvider.checkOrderForBoughtProduct ==
                    StatusUtil.loading) {
              return Center(child: CircularProgressIndicator());
            }
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.40,
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          child: Image.network(
                            "${widget.data.image!}",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rs.${widget.data.price!}",
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 18),
                            ),
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.040,
                              width: MediaQuery.of(context).size.width * 0.50,
                              child: CustomButton(
                                backgroundColor:
                                    const Color.fromARGB(255, 21, 164, 26),
                                foregroundColor: buttonForegroundColor,
                                onPressed: () async {
                                  final SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  userId = prefs.getString("userId");
                                  userRole = prefs.getString("userRole");
                                  if (userId == null || userId!.isEmpty) {
                                    Helper.displaySnackbar(context,
                                        "Please login to your account!");
                                    return;
                                  }
                                  if (userRole == "admin") {
                                    Helper.displaySnackbar(context,
                                        "Admin cannot add product to the cart!");
                                    return;
                                  }

                                  Cart cart = Cart(
                                    userId: userId,
                                    userEmail: userEmail,
                                    id: widget.data.id!,
                                    name: widget.data.name!,
                                    quantity: "1",
                                    price: widget.data.price!,
                                    image: widget.data.image!,
                                  );

                                  await productProvider
                                      .checkProductInCart(cart);

                                  if (productProvider.isSuccessProductInCart!) {
                                    Helper.displaySnackbar(context,
                                        "Product is already in the cart");
                                  } else {
                                    productProvider.saveProductCart(cart);
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CustomBottomNavigationBar(
                                                initialIndex: 2),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                },
                                child: const Text("Add to cart"),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 10, right: 10.0, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 239, 237, 237),
                              borderRadius: BorderRadius.circular(8)),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7.0, vertical: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("${widget.data.name!}",
                                        style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900)),
                                    Spacer(),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.orange,
                                      size: 20,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                        "${(widget.averageRating.toStringAsFixed(1))}/5 (${(widget.totalCounts.toStringAsFixed(1))})"),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "In Stock:",
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(" ${(widget.data.quantity!)}")
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                const Text("Specifications",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900)),
                                Row(
                                  children: [
                                    Text("Model:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.model!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Cpu:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.cpu!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("OS:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("${widget.data.operatingSystem!}")
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Memory:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.memory!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Storage: ",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.storage!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Camera:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.camera!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Graphics:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.graphics!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Screen:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.screen!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Warranty:",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.warranty!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Wireless Connectivity:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.wirelessConnectivity!}",
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Description:",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w900)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      "${widget.data.description!}",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      productProvider.isAlreadyRated ?? false
                          ? SizedBox(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Row(
                                  children: [
                                    Text("You have already rated the product.",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Colors.red)),
                                  ],
                                ),
                              ),
                            )
                          : userId == null ||
                                  userRole == "admin" ||
                                  canRateProduct == false
                              ? const SizedBox()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0,
                                      left: 10,
                                      right: 10,
                                      bottom: 10),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.39,
                                        child: CustomButton(
                                          backgroundColor: Colors.redAccent,
                                          foregroundColor:
                                              buttonForegroundColor,
                                          onPressed: () async {
                                            Rate rate = Rate(
                                              productId: widget.data.id,
                                              isRated: true,
                                              userId: userId,
                                              rating: productProvider
                                                  .ratingController.text,
                                              image: widget.data.image,
                                              name: widget.data.name,
                                              category: widget.data.category,
                                              price: widget.data.price,
                                              model: widget.data.model,
                                              cpu: widget.data.cpu,
                                              operatingSystem:
                                                  widget.data.operatingSystem,
                                              memory: widget.data.memory,
                                              storage: widget.data.storage,
                                              screen: widget.data.screen,
                                              graphics: widget.data.graphics,
                                              wirelessConnectivity: widget
                                                  .data.wirelessConnectivity,
                                              camera: widget.data.camera,
                                              warranty: widget.data.warranty,
                                              description:
                                                  widget.data.description,
                                            );

                                            await productProvider
                                                .addRatingToProducts(rate);
                                            if (productProvider
                                                    .addRatingToProduct ==
                                                StatusUtil.success) {
                                              Helper.displaySnackbar(context,
                                                  "Product Successfully Rated");
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           ProductPage(
                                              //         data: widget.data,
                                              //         averageRating:
                                              //             widget.averageRating,
                                              //         totalCounts:
                                              //             widget.totalCounts,
                                              //       ),
                                              //     ));
                                              // Navigator.pop(context, true);
                                            } else {
                                              Helper.displaySnackbar(context,
                                                  "Product Rating Failed!");
                                            }
                                          },
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 18,
                                                color: Colors.yellowAccent,
                                              ),
                                              SizedBox(width: 4),
                                              Text("Rate Product"),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 3),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.55,
                                        child: RatingBar.builder(
                                          initialRating: 3,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            productProvider
                                                .setRating(rating.toString());
                                          },
                                          ignoreGestures: false,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                    ],
                  ),
                ),
                // Loading indicator centered on the screen
                // if (productProvider.checkRatingOfProduct != StatusUtil.success)
                //   Center(child: CircularProgressIndicator()),
              ],
            );
          },
        ),
      ),
    );
  }
}
