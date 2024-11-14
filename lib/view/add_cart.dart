import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/services/stripe_service.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddCart extends StatefulWidget {
  const AddCart({super.key});

  @override
  State<AddCart> createState() => _AddCartState();
}

class _AddCartState extends State<AddCart> {
  @override
  String? userId;
  void initState() {
    // TODO: implement initState
    super.initState();
    getDataFromCart();
    getValue();
    getCartProduct();
    // Listen to changes in the cart list and recalculate the total
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var provider = Provider.of<ProductProvider>(context, listen: false);
      provider.addListener(() {
        getCartProduct();
      });
    });
  }

  getDataFromCart() {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<ProductProvider>(context, listen: false);
        await provider.getFromProductCart();
      },
    );
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

  int currentQuantity = 0;
  double totalPrice = 0.0;
  var userCartList = [];
  getCartProduct() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId");

    var provider = Provider.of<ProductProvider>(context, listen: false);
    userCartList = provider.cartList.where((product) {
      return product.userId == userId;
    }).toList();

    calculateTotalPrice(); // Calculate total price after getting the cart products
  }

  void calculateTotalPrice() {
    totalPrice = 0.0;
    for (var product in userCartList) {
      double productPrice = double.parse(product.price!);
      int productQuantity = int.parse(product.quantity!);
      totalPrice += productPrice * productQuantity;
    }
    setState(() {
      totalPrice; // This will trigger a UI update
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: backGroundColor,
          foregroundColor: buttonForegroundColor,
          title: Text(
            "Cart",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [],
        ),
        body: Consumer<ProductProvider>(
            builder: (context, productProvider, child) {
          return Padding(
            padding: const EdgeInsets.only(left: 10.0, top: 10),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.75,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: productProvider.cartList.length,
                    itemBuilder: (context, index) {
                      return userId == productProvider.cartList[index].userId
                          ? Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          child: Image.network(
                                            productProvider
                                                .cartList[index].image!,
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text("Name: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  productProvider
                                                      .cartList[index].name!,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text("Price: ",
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                                Text(
                                                  productProvider
                                                      .cartList[index].price!,
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Spacer(),
                                        Row(
                                          children: [
                                            IconButton(
                                                onPressed: () async {
                                                  await productProvider
                                                      .deleteProductCart(
                                                          productProvider
                                                              .cartList[index]
                                                              .id!,productProvider.cartList[index].userId!);
                                                  if (productProvider
                                                          .deleteProductsInCart ==
                                                      StatusUtil.success) {
                                                    getDataFromCart();
                                                  } else {
                                                    Helper.displaySnackbar(
                                                        context,
                                                        "Deletion failed");
                                                  }
                                                  // getCartProduct();
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                          ],
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(
                                            onPressed: () async {
                                              if (int.parse(productProvider
                                                      .cartList[index]
                                                      .quantity!) >
                                                  1) {
                                                currentQuantity = int.parse(
                                                    productProvider
                                                        .cartList[index]
                                                        .quantity!);
                                                currentQuantity--;
                                                productProvider.cartList[index]
                                                        .quantity =
                                                    currentQuantity.toString();
                                              }
                                              await productProvider
                                                  .updateQuantity(
                                                      productProvider
                                                          .cartList[index]);
                                              getCartProduct();
                                            },
                                            icon: Icon(Icons.remove)),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Text(
                                            productProvider
                                                .cartList[index].quantity!,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () async {
                                              setState(() {
                                                currentQuantity = int.parse(
                                                    productProvider
                                                        .cartList[index]
                                                        .quantity!);
                                                currentQuantity++;
                                                productProvider.cartList[index]
                                                        .quantity =
                                                    currentQuantity.toString();
                                              });
                                              await productProvider
                                                  .updateQuantity(
                                                      productProvider
                                                          .cartList[index]);
                                              getCartProduct();
                                            },
                                            icon: Icon(Icons.add)),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          "Rs " +
                                              (double.parse(productProvider
                                                          .cartList[index]
                                                          .price!) *
                                                      int.parse(productProvider
                                                          .cartList[index]
                                                          .quantity!))
                                                  .toStringAsFixed(2),
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Total Price:",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "\Rs.${totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red),
                          ),
                        ],
                      ),
                      Spacer(),
                      userId == null || userId!.isEmpty
                          ? SizedBox()
                          : SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                              width: MediaQuery.of(context).size.width * 0.40,
                              child: CustomButton(
                                backgroundColor: Colors.green,
                                foregroundColor: buttonForegroundColor,
                                onPressed: () async {
                                  // int amountInCents = (totalPrice * 100).toInt();
                                  int amountInCents = (totalPrice).round();
                                  final isSuccessfulPayment =
                                      await StripeService.instance
                                          .makePayment(amountInCents);
                                  if (isSuccessfulPayment) {
                                    await productProvider.saveSoldProduct(
                                        userCartList,
                                        userId!,
                                        totalPrice.toString());
                                    await productProvider
                                        .deleteCartAfterPayment(userId!);
                                    getDataFromCart();
                                    await Helper.displaySnackbar(
                                        context, "Order Successful");
                                  } else {
                                    await Helper.displaySnackbar(
                                        context, "Payment Failed.");
                                  }
                                },
                                child: Text(
                                  "Check Out",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            )
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
