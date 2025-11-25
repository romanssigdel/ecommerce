import 'dart:ffi';
import 'dart:io';

import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/edit_user.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:ecommerce/view/update_product.dart';
import 'package:ecommerce/view/user_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AdminFunctions extends StatefulWidget {
  AdminFunctions({super.key, this.product, this.userRole, this.uId});
  Product? product;
  String? uId;
  String? userRole;

  @override
  State<AdminFunctions> createState() => _UserAccountState();
}

class _UserAccountState extends State<AdminFunctions> {
  // User? user;

  List<String> adminFunctions = [
    "Add Product",
    "Sold Products",
    "Products List"
  ];
  int selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> widgetOptions = <Widget>[
    Text(
      'Add Product',
      style: optionStyle,
    ),
    Text(
      'Sold Products',
      style: optionStyle,
    ),
    Text(
      'Products list',
      style: optionStyle,
    ),
  ];
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    //
    // TODO: implement initState
    super.initState();
    // getValue();
    // getUserData();
    getProductData();
    getOrderFromCart();
  }

  String? userName, userRole, authenticationType, userPassword, userEmail;
  bool isLoading = true;
  getValue() {
    Future.delayed(
      Duration.zero,
      () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        authenticationType = prefs.getString("authenticationType");
        userName = prefs.getString("userName");
        userRole = prefs.getString("userRole");
        userPassword = prefs.getString("userPassword");
        userEmail = prefs.getString("userEmail");
        setState(() {
          // user = User(email: userEmail, name: userName, role: userRole);
          isLoading = false;
        });
      },
    );
  }

  getUserData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<UserProvider>(context, listen: false);
        await provider.getUser();
      },
    );
  }

  getProductData() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<ProductProvider>(context, listen: false);
        await provider.getProduct();
      },
    );
  }

  File file = File("");
  final _formKey = GlobalKey<FormState>();
  String? downloadUrl;
  bool loader = false;
  String? productName, description, category;
  Double? price;

  getOrderFromCart() async {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<ProductProvider>(context, listen: false);
        await provider.getOrdersFromCart();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const Center(
    //     child: CircularProgressIndicator(),
    //   );
    // }
    //admin page starts from here
    return Consumer<AuthenticationProvider>(
        builder: (context, authProvider, child) => SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: backGroundColor,
                  title: Text(
                    authProvider.currentUser!.displayName ?? "",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.black,
                          ));
                    },
                  ),
                  actions: [
                    Row(
                      children: [
                        // IconButton(
                        //     onPressed: () {},
                        //     icon: Icon(
                        //       Icons.settings,
                        //       size: 30,
                        //       color: Colors.white,
                        //     )),
                        Padding(
                          padding: const EdgeInsets.only(right: 15.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomBottomNavigationBar(
                                      initialIndex: 3,
                                    ),
                                  ),
                                  (route) => false);
                            },
                            child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  authProvider.currentUser?.photoURL != null
                                      ? NetworkImage(
                                          authProvider.currentUser!.photoURL!)
                                      : AssetImage("assets/images/user.png")
                                          as ImageProvider,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
                drawer: Drawer(
                    child: ListView(
                  children: [
                    DrawerHeader(
                        decoration: BoxDecoration(color: backGroundColor),
                        child: Text(
                          "Admin Panel",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold),
                        )),
                    ListTile(
                      title: const Text('Add Product'),
                      selected: selectedIndex == 0,
                      onTap: () {
                        onItemTapped(0);
                        Navigator.pop(context);
                      },
                    ),
                    // ListTile(
                    //   title: const Text('Customer List'),
                    //   selected: selectedIndex == 1,
                    //   onTap: () {
                    //     onItemTapped(1);
                    //     Navigator.pop(context);
                    //   },
                    // ),
                    ListTile(
                      title: const Text('Sold Products'),
                      selected: selectedIndex == 1,
                      onTap: () {
                        onItemTapped(1);
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      title: const Text('Products List'),
                      selected: selectedIndex == 2,
                      onTap: () {
                        onItemTapped(2);
                        Navigator.pop(context);
                      },
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.only(
                    //       top: 310.0, left: 10, right: 10),
                    //   child: CustomButton(
                    //     backgroundColor: backGroundColor,
                    //     foregroundColor: buttonForegroundColor,
                    //     onPressed: () {
                    //       logoutShowDialog(context, authProvider);
                    //     },
                    //     child: Text("Logout"),
                    //   ),
                    // ),
                  ],
                )),
                body: SingleChildScrollView(
                  child: Consumer<ProductProvider>(
                    builder: (context, productProvider, child) => Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            widgetOptions[selectedIndex],
                          ],
                        ),
                        // add products
                        if (selectedIndex == 0)
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                file.path.isEmpty
                                    ? SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          child: Image.asset(
                                            "assets/images/add-product.png",
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 100,
                                        width: 100,
                                        child: ClipRRect(
                                          child: Image.file(file),
                                        ),
                                      ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.50,
                                  height:
                                      MediaQuery.of(context).size.height * 0.05,
                                  child: CustomButton(
                                      backgroundColor: backGroundColor,
                                      onPressed: () async {
                                        await pickImage();
                                      },
                                      child: loader == true
                                          ? CircularProgressIndicator()
                                          : Text(
                                              "Select Image",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            )),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue:
                                    //     productProvider.productName,
                                    onChanged: (value) {
                                      productProvider.setProductName(value);
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return productNameValidationStr;
                                      }
                                      return null;
                                    },
                                    labelText: "Product name",
                                  ),
                                ),
                                if (downloadUrl != null)
                                  Visibility(
                                    visible: false,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 10),
                                      child: CustomTextFormField(
                                        initialValue: productProvider
                                            .imageTextField
                                            .toString(),
                                        controller: productProvider
                                            .setProductImage(downloadUrl!),
                                        labelText: "Product Image",
                                      ),
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue:
                                    //     productProvider.productPrice,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      productProvider.setProductPrice(value);
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return priceValidationStr;
                                      }
                                      return null;
                                    },
                                    labelText: "Price",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue:
                                    //     productProvider.productCategory,
                                    onChanged: (value) {
                                      productProvider.setProductQuantity(value);
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return categoryValidationStr;
                                      }
                                      return null;
                                    },
                                    labelText: "Quantity",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue:
                                    //     productProvider.productCategory,
                                    onChanged: (value) {
                                      productProvider.setProductCategory(value);
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return categoryValidationStr;
                                      }
                                      return null;
                                    },
                                    labelText: "Category",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.model,
                                    onChanged: (value) {
                                      productProvider.setModel(value);
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Please enter model.";
                                      }
                                      return null;
                                    },
                                    labelText: "model",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.cpu,
                                    onChanged: (value) {
                                      productProvider.setCpu(value);
                                    },
                                    labelText: "Cpu",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue:
                                    //     productProvider.opertingSystem,
                                    onChanged: (value) {
                                      productProvider.setOperatingSystem(value);
                                    },
                                    labelText: "Operating System",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.memory,
                                    onChanged: (value) {
                                      productProvider.setMemory(value);
                                    },
                                    labelText: "Memory",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.storage,
                                    onChanged: (value) {
                                      productProvider.setStorage(value);
                                    },
                                    labelText: "Storage",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.screen,
                                    onChanged: (value) {
                                      productProvider.setScreen(value);
                                    },
                                    labelText: "Screen",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.graphics,
                                    onChanged: (value) {
                                      productProvider.setGraphics(value);
                                    },
                                    labelText: "Graphics",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider
                                    //     .wirelessConnectivity,
                                    onChanged: (value) {
                                      productProvider
                                          .setWirelessConnectivity(value);
                                    },
                                    labelText: "Wireless Connectivity",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.camera,
                                    onChanged: (value) {
                                      productProvider.setCamera(value);
                                    },
                                    labelText: "Camera",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10.0, horizontal: 10),
                                  child: CustomTextFormField(
                                    // initialValue: productProvider.warranty,
                                    onChanged: (value) {
                                      productProvider.setWaranty(value);
                                    },
                                    labelText: "Waranty",
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 10),
                                  child: TextFormField(
                                    // initialValue:
                                    //     productProvider.productDescription,
                                    onChanged: (value) {
                                      productProvider
                                          .setProductDescription(value);
                                    },
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return descriptionValidationStr;
                                      }
                                      return null;
                                    },
                                    maxLines:
                                        null, // Allows the TextFormField to grow dynamically
                                    minLines:
                                        7, // Sets a minimum number of lines
                                    keyboardType: TextInputType
                                        .multiline, // Allows multiline input
                                    decoration: InputDecoration(
                                      hintText: 'Description of the Product...',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                CustomButton(
                                  backgroundColor: backGroundColor,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await productProvider.saveProduct();
                                      if (productProvider.saveProductStatus ==
                                          StatusUtil.success) {
                                        Helper.displaySnackbar(context,
                                            "Product Successfully Saved!");
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  CustomBottomNavigationBar(
                                                      initialIndex: 3),
                                            ),
                                            (route) => false);
                                      } else if (productProvider
                                              .saveProductStatus ==
                                          StatusUtil.error) {
                                        Helper.displaySnackbar(
                                            context, "Product not Saved.");
                                      }
                                    }
                                  },
                                  child: productProvider.saveProductStatus ==
                                          StatusUtil.loading
                                      ? CircularProgressIndicator()
                                      : Text("Submit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                        // if (selectedIndex == 1)
                        //   Consumer<UserProvider>(
                        //     builder: (context, value, child) => Column(
                        //       children: [
                        //         SizedBox(
                        //           height:
                        //               MediaQuery.of(context).size.height * 0.50,
                        //           width:
                        //               MediaQuery.of(context).size.width * 0.95,
                        //           child: ListView.builder(
                        //             itemCount: value.userList.length,
                        //             itemBuilder: (context, index) {
                        //               return Card(
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.symmetric(
                        //                       horizontal: 10.0, vertical: 10),
                        //                   child: Column(
                        //                     crossAxisAlignment:
                        //                         CrossAxisAlignment.start,
                        //                     children: [
                        //                       Row(
                        //                         children: [
                        //                           Text("Name: ",
                        //                               style: TextStyle(
                        //                                   fontSize: 20,
                        //                                   fontWeight:
                        //                                       FontWeight.bold)),
                        //                           Text(
                        //                             value.userList[index].name!,
                        //                             style:
                        //                                 TextStyle(fontSize: 18),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                       Row(
                        //                         children: [
                        //                           Text("Email: ",
                        //                               style: TextStyle(
                        //                                   fontSize: 20,
                        //                                   fontWeight:
                        //                                       FontWeight.bold)),
                        //                           Text(
                        //                             value
                        //                                 .userList[index].email!,
                        //                             style:
                        //                                 TextStyle(fontSize: 18),
                        //                           ),
                        //                         ],
                        //                       ),
                        //                     ],
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        if (selectedIndex == 1)
                          Consumer<ProductProvider>(
                            builder: (context, productProvider, child) =>
                                Column(
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.8,
                                  width:
                                      MediaQuery.of(context).size.width * 0.97,
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: productProvider.orderList.length,
                                    itemBuilder: (context, orderIndex) {
                                      final order =
                                          productProvider.orderList[orderIndex];

                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 10),
                                        child: Card(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Order ID: ${order.orderId}",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "User Email: ${order.userEmail}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Order Date: ${order.orderDate?.toLocal().toString().split(' ')[0] ?? ''}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Total Amount: \Rs.${double.parse(order.totalAmount!).toStringAsFixed(2) ?? '0.00'}",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              Divider(),
                                              ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    order.products?.length ?? 0,
                                                itemBuilder:
                                                    (context, productIndex) {
                                                  final product = order
                                                      .products![productIndex];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 8.0,
                                                        horizontal: 8.0),
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                          child: Image.network(
                                                            product.image ?? '',
                                                            height: 70,
                                                            width: 70,
                                                            fit: BoxFit.fill,
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
                                                              return Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 70,
                                                                color:
                                                                    Colors.grey,
                                                              );
                                                            },
                                                            loadingBuilder:
                                                                (context, child,
                                                                    loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return SizedBox(
                                                                height: 70,
                                                                width: 70,
                                                                child: Center(
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(width: 10),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "Name: ${product.name ?? ''}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                              Text(
                                                                "Price: \Rs.${double.parse(product.price!).toStringAsFixed(2) ?? '0.00'}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                              Text(
                                                                "Quantity: ${product.quantity ?? 0}",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        //product list
                        if (selectedIndex == 2)
                          Consumer<ProductProvider>(
                            builder: (context, value, child) => productProvider
                                        .getProductStatus ==
                                    StatusUtil.loading
                                ? CircularProgressIndicator()
                                : Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.9,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.95,
                                        child: ListView.builder(
                                          itemCount: productProvider
                                              .productslist.length,
                                          itemBuilder: (context, index) {
                                            return Card(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 10.0,
                                                        vertical: 10),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    ClipRRect(
                                                      child: Image.network(
                                                        productProvider
                                                            .productslist[index]
                                                            .image!,
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text("Name: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Text(
                                                              productProvider
                                                                  .productslist[
                                                                      index]
                                                                  .name!,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text("Price: ",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            Text(
                                                              productProvider
                                                                  .productslist[
                                                                      index]
                                                                  .price!,
                                                              style: TextStyle(
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {
                                                              updateShowDialog(
                                                                  context,
                                                                  productProvider
                                                                          .productslist[
                                                                      index]);
                                                            },
                                                            icon: Icon(
                                                              Icons.edit,
                                                              color:
                                                                  Colors.green,
                                                            )),
                                                        IconButton(
                                                            onPressed:
                                                                () async {
                                                              deleteShowDialog(
                                                                  context,
                                                                  productProvider,
                                                                  productProvider
                                                                      .productslist[
                                                                          index]
                                                                      .id!);
                                                            },
                                                            icon: Icon(
                                                              Icons.delete,
                                                              color: Colors
                                                                  .redAccent,
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                          )
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }

  logoutUserFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("");
    await prefs.remove("userId");
    await prefs.remove('isLogin');
    await prefs.remove('userName');
    await prefs.remove('userEmail');
    await prefs.remove('userRole');
    Helper.displaySnackbar(context, "Successfully Logged Out!");
  }

  createShowDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete File'),
          content: Text('Are you sure you want to delete this file?'),
          actions: [
            TextButton(
              onPressed: () async {
                await userProvider.deleteUserData();
                if (userProvider.getDeleteUserStatus == StatusUtil.success) {
                  Helper.displaySnackbar(context, "Data Successfully deleted");
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomBottomNavigationBar(
                          initialIndex: 3,
                        ),
                      ),
                      (route) => false);
                }
                // Perform delete operation here
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  logoutShowDialog(BuildContext context, AuthenticationProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                await authProvider.logoutUser();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomBottomNavigationBar(
                        initialIndex: 3,
                      ),
                    ),
                    (route) => false);

                // Perform delete operation here
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  deleteShowDialog(
      BuildContext context, ProductProvider productProvider, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete'),
          content: Text('Are you sure you want to Delete?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await productProvider.deleteProduct(id);
                await getProductData();
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  updateShowDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update'),
          content: Text('Are you sure you want to Update?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateProduct(data: product),
                    ));
                // Perform delete operation here
                // Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  googleSignOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
      Helper.displaySnackbar(context, "Google Signout Successful");
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => CustomBottomNavigationBar(
              initialIndex: 0,
            ),
          ),
          (route) => false);
    } catch (e) {
      Helper.displaySnackbar(context, "Google Signout UnSuccessful");
    }
  }

  pickImage() async {
    final ImagePicker picker = ImagePicker();
// Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    file = File(image!.path);
    setState(() {
      loader = true;
      file;
    });
    try {
      // List<String> fileName = file.path.split('/');
      String fileName = file.path.split('/').last;
      var storageReference = FirebaseStorage.instance.ref();
      var uploadReference = storageReference.child(fileName);
      await uploadReference.putFile(file);
      downloadUrl = await uploadReference.getDownloadURL();
      setState(() {
        downloadUrl;
        loader = false;
      });
      // print("downloadUrl$downloadUrl");
    } catch (e) {
      setState(() {
        loader = false;
      });
    }
  }
}
