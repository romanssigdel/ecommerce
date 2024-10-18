import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/utils/color_const.dart';
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
          final userCartList = productProvider.cartList.where((product) {
            return product.userId ==
                userId; // Assuming you use userId from SharedPreferences
          }).toList();

          // Calculate the total price for the user
          double totalPrice = 0.0;
          for (var product in userCartList) {
            totalPrice += double.tryParse(product.price ?? '0') ?? 0.0;
          }
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ClipRRect(
                                    //   child: Image.network(
                                    //     productProvider
                                    //         .cartList[index].image!,
                                    //     height: 70,
                                    //     width: 70,
                                    //     fit: BoxFit.fill,
                                    //   ),
                                    // ),
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
                                              style: TextStyle(fontSize: 16),
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
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            "\Rs.${totalPrice.toStringAsFixed(2)}",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Spacer(),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.40,
                        child: CustomButton(
                          backgroundColor: buttonBackgroundColor,
                          foregroundColor: buttonForegroundColor,
                          onPressed: () {},
                          child: Text("Check Out"),
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
