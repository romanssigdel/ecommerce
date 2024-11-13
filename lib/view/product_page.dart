import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/view/add_cart.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  var data;
  ProductPage({super.key, this.data});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String? userId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
  }

  getValue() {
    Future.delayed(
      Duration.zero,
      () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        userId = prefs.getString("userId");
      },
    );
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
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
              )),
          backgroundColor: backGroundColor,
          foregroundColor: buttonForegroundColor,
          // leading: IconButton,
        ),
        body: SingleChildScrollView(
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) => Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                      child: Image.network(
                    "${widget.data.image!}",
                    fit: BoxFit.fill,
                  )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
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
                        height: MediaQuery.of(context).size.height * 0.040,
                        width: MediaQuery.of(context).size.width * 0.50,
                        child: CustomButton(
                          backgroundColor:
                              const Color.fromARGB(255, 21, 164, 26),
                          foregroundColor: buttonForegroundColor,
                          onPressed: () async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            userId = prefs.getString("userId");
                            // Ensure userId is fetched before proceeding
                            if (userId == null || userId!.isEmpty) {
                              Helper.displaySnackbar(
                                  context, "Please login to your account!");
                              return;
                            }

                            Cart cart = Cart(
                              userId: userId,
                              id: widget.data.id!,
                              name: widget.data.name!,
                              quantity: widget.data.quantity!,
                              price: widget.data.price!,
                              image: widget.data.image!,
                            );

                            await productProvider.checkProductInCart(cart);

                            // Check if the product is already in the cart
                            if (productProvider.isSuccessProductInCart!) {
                              Helper.displaySnackbar(
                                  context, "Product is already in the cart");
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
                  padding:
                      const EdgeInsets.only(left: 10, right: 10.0, top: 10),
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
                          Text("${widget.data.name!}",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          const Text("Specification",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w900)),
                          Text("Model: ${widget.data.model!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text("Cpu: ${widget.data.cpu!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text(
                              "Operating System: ${widget.data.operatingSystem!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text("Memory: ${widget.data.memory!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text("Storage: ${widget.data.storage!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text("Camera: ${widget.data.camera!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text("Storage: ${widget.data.storage!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text("Screen: ${widget.data.screen!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text("Warranty: ${widget.data.warranty!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                          Text(
                              "Wireless Connectivity: ${widget.data.wirelessConnectivity!}",
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 10.0, left: 10, right: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: CustomButton(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: buttonForegroundColor,
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 18,
                                color: Colors.yellowAccent,
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text("Rate Product"),
                            ],
                          ),
                        ),
                      ),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.45,
                      //   child: CustomButton(
                      //     backgroundColor: Colors.redAccent,
                      //     foregroundColor: buttonForegroundColor,
                      //     onPressed: () {},
                      //     child: const Row(children: [
                      //       Icon(
                      //         Icons.favorite,
                      //       ),
                      //       SizedBox(
                      //         width: 1,
                      //       ),
                      //       Text("Add to favorites")
                      //     ]),
                      //   ),
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
