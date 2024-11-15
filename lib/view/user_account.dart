import 'dart:ffi';
import 'dart:io';

import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/model/user.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:ecommerce/view/update_product.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserAccount extends StatefulWidget {
  UserAccount({super.key, this.product});
  Product? product;

  @override
  State<UserAccount> createState() => _UserAccountState();
}

class _UserAccountState extends State<UserAccount> {
  User? user;

  List<String> adminFunctions = [
    "Add Product",
    "Customer List",
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
      'Customer List',
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
    // if (widget.product != null) {
    //   var provider = Provider.of<ProductProvider>(context, listen: false);
    //   provider.setProductId(widget.product!.id ?? "");
    //   provider.setProductName(widget.product!.name ?? "");
    //   provider.setProductPrice(widget.product!.price ?? "");
    //   provider.setCamera(widget.product!.camera ?? "");
    //   provider.setProductCategory(widget.product!.category ?? "");
    //   provider.setCpu(widget.product!.cpu ?? "");
    //   provider.setProductDescription(widget.product!.description ?? "");
    //   provider.setGraphics(widget.product!.graphics ?? "");
    //   provider.setProductImage(widget.product!.image ?? "");
    //   provider.setMemory(widget.product!.memory ?? "");
    //   provider.setModel(widget.product!.model ?? "");
    //   provider.setOperatingSystem(widget.product!.operatingSystem ?? "");
    //   provider.setScreen(widget.product!.screen ?? "");
    //   provider.setStorage(widget.product!.storage ?? "");
    //   provider.setWaranty(widget.product!.warranty ?? "");
    //   provider
    //       .setWirelessConnectivity(widget.product!.wirelessConnectivity ?? "");
    // }
    // TODO: implement initState
    super.initState();
    getValue();
    getUserData();
    getProductData();
    getOrderFromCart();
  }

  String? userName, userEmail, userRole;
  bool isLoading = true;
  getValue() {
    Future.delayed(
      Duration.zero,
      () async {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        userName = prefs.getString("userName");
        userEmail = prefs.getString("userEmail");
        userRole = prefs.getString("userRole");
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

  // void clearForm(ProductProvider productProvider) {
  //   _formKey.currentState?.reset(); // Resets the form's state

  //   // Clear product data in provider
  //   productProvider.setProductName("");
  //   productProvider.setProductPrice("");
  //   productProvider.setProductCategory("");
  //   productProvider.setModel("");
  //   productProvider.setCpu("");
  //   productProvider.setOperatingSystem("");
  //   productProvider.setMemory("");
  //   productProvider.setStorage("");
  //   productProvider.setScreen("");
  //   productProvider.setGraphics("");
  //   productProvider.setWirelessConnectivity("");
  //   productProvider.setCamera("");
  //   productProvider.setWaranty("");
  //   productProvider.setProductDescription("");
  //   setState(() {});
  // }

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
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    //admin page starts from here
    return userRole == "admin"
        ? Consumer<UserProvider>(
            builder: (context, userProvider, child) => SafeArea(
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: backGroundColor,
                      title: Text(
                        userName ?? "",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      leading: Builder(
                        builder: (context) {
                          return IconButton(
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                              icon: Icon(
                                Icons.menu,
                                color: Colors.white,
                              ));
                        },
                      ),
                      actions: [
                        Row(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.settings,
                                  size: 30,
                                  color: Colors.white,
                                )),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      AssetImage("assets/images/user.png")),
                            ),
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
                                  color: Colors.white,
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
                        ListTile(
                          title: const Text('Customer List'),
                          selected: selectedIndex == 1,
                          onTap: () {
                            onItemTapped(1);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Sold Products'),
                          selected: selectedIndex == 2,
                          onTap: () {
                            onItemTapped(2);
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: const Text('Products List'),
                          selected: selectedIndex == 3,
                          onTap: () {
                            onItemTapped(3);
                            Navigator.pop(context);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 310.0, left: 10, right: 10),
                          child: CustomButton(
                            backgroundColor: backGroundColor,
                            foregroundColor: buttonForegroundColor,
                            onPressed: () {
                              logoutShowDialog(context, userProvider);
                            },
                            child: Text("Logout"),
                          ),
                        ),
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
                                      width: MediaQuery.of(context).size.width *
                                          0.50,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.05,
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
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                          productProvider
                                              .setProductPrice(value);
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
                                          productProvider
                                              .setProductQuantity(value);
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
                                          productProvider
                                              .setProductCategory(value);
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
                                          productProvider
                                              .setOperatingSystem(value);
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
                                          hintText:
                                              'Description of the Product...',
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
                                          if (productProvider
                                                  .saveProductStatus ==
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
                                      child: productProvider
                                                  .saveProductStatus ==
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
                            if (selectedIndex == 1)
                              Consumer<UserProvider>(
                                builder: (context, value, child) => Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: ListView.builder(
                                        itemCount: userProvider.userList.length,
                                        itemBuilder: (context, index) {
                                          return Card(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 10.0,
                                                      vertical: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Text("Name: ",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        userProvider
                                                            .userList[index]
                                                            .name!,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text("Email: ",
                                                          style: TextStyle(
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                        userProvider
                                                            .userList[index]
                                                            .email!,
                                                        style: TextStyle(
                                                            fontSize: 18),
                                                      ),
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
                              ),
                            if (selectedIndex == 2)
                              Consumer<ProductProvider>(
                                builder: (context, productProvider, child) =>
                                    Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.50,
                                      width: MediaQuery.of(context).size.width *
                                          0.95,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount:
                                            productProvider.orderList.length,
                                        itemBuilder: (context, orderIndex) {
                                          final order = productProvider
                                              .orderList[orderIndex];
                                          productProvider.getUserEmailForOrders(
                                              order.userId!);
                                          // final userEmail =
                                          //     productProvider.userEmailforOrder;
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Order ID: ${order.orderId}",
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  // Padding(
                                                  //   padding:
                                                  //       const EdgeInsets.all(
                                                  //           8.0),
                                                  //   child: Text(
                                                  //     "User Email: $userEmail",
                                                  //     style: TextStyle(
                                                  //       fontSize: 16,
                                                  //       fontWeight:
                                                  //           FontWeight.bold,
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
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
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Text(
                                                      "Total Amount: \Rs.${double.parse(order.totalAmount!).toStringAsFixed(2) ?? '0.00'}",
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  Divider(),
                                                  ListView.builder(
                                                    physics:
                                                        NeverScrollableScrollPhysics(),
                                                    shrinkWrap: true,
                                                    itemCount: order
                                                            .products?.length ??
                                                        0,
                                                    itemBuilder: (context,
                                                        productIndex) {
                                                      final product =
                                                          order.products![
                                                              productIndex];
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 8.0,
                                                                horizontal:
                                                                    8.0),
                                                        child: Row(
                                                          children: [
                                                            ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                product.image ??
                                                                    '',
                                                                height: 70,
                                                                width: 70,
                                                                fit:
                                                                    BoxFit.fill,
                                                                errorBuilder:
                                                                    (context,
                                                                        error,
                                                                        stackTrace) {
                                                                  return Icon(
                                                                    Icons
                                                                        .broken_image,
                                                                    size: 70,
                                                                    color: Colors
                                                                        .grey,
                                                                  );
                                                                },
                                                                loadingBuilder:
                                                                    (context,
                                                                        child,
                                                                        loadingProgress) {
                                                                  if (loadingProgress ==
                                                                      null)
                                                                    return child;
                                                                  return SizedBox(
                                                                    height: 70,
                                                                    width: 70,
                                                                    child:
                                                                        Center(
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
                                                                            FontWeight.bold),
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
                            if (selectedIndex == 3)
                              Consumer<ProductProvider>(
                                builder:
                                    (context, value, child) =>
                                        productProvider.getProductStatus ==
                                                StatusUtil.loading
                                            ? CircularProgressIndicator()
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.9,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.95,
                                                    child: ListView.builder(
                                                      itemCount: productProvider
                                                          .productslist.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return Card(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        10.0,
                                                                    vertical:
                                                                        10),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                ClipRRect(
                                                                  child: Image
                                                                      .network(
                                                                    productProvider
                                                                        .productslist[
                                                                            index]
                                                                        .image!,
                                                                    height: 70,
                                                                    width: 70,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                                Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Name: ",
                                                                            style:
                                                                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                        Text(
                                                                          productProvider
                                                                              .productslist[index]
                                                                              .name!,
                                                                          style:
                                                                              TextStyle(fontSize: 16),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                      children: [
                                                                        Text(
                                                                            "Price: ",
                                                                            style:
                                                                                TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                                                        Text(
                                                                          productProvider
                                                                              .productslist[index]
                                                                              .price!,
                                                                          style:
                                                                              TextStyle(fontSize: 16),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    IconButton(
                                                                        onPressed:
                                                                            () {
                                                                          updateShowDialog(
                                                                              context,
                                                                              productProvider.productslist[index]);
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .edit,
                                                                          color:
                                                                              Colors.green,
                                                                        )),
                                                                    IconButton(
                                                                        onPressed:
                                                                            () async {
                                                                          deleteShowDialog(
                                                                              context,
                                                                              productProvider,
                                                                              productProvider.productslist[index].id!);
                                                                        },
                                                                        icon:
                                                                            Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.redAccent,
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
                ))
        //userPage starts from here
        : Consumer<UserProvider>(
            builder: (context, userProvider, child) => SafeArea(
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: backGroundColor,
                  title: Text(
                    userName ?? "",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  leading: Builder(
                    builder: (context) {
                      return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                          icon: Icon(
                            Icons.menu,
                            color: Colors.white,
                          ));
                    },
                  ),
                  actions: [
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.settings,
                              size: 30,
                              color: Colors.white,
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage("assets/images/user.png")),
                        ),
                      ],
                    )
                  ],
                ),
                drawer: Drawer(
                  child: Text(
                    "hello",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                body: Column(
                  children: [
                    Container(
                      color: buttonBackgroundColor,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    "My WishList",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Text(
                                    "10",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Vouchers",
                                      style: TextStyle(color: Colors.white)),
                                  Text("10",
                                      style: TextStyle(color: Colors.white))
                                ],
                              ),
                              Column(
                                children: [
                                  Text("Stores",
                                      style: TextStyle(color: Colors.white)),
                                  Text("10",
                                      style: TextStyle(color: Colors.white))
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: Color(0xffF6F6F6),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "My Orders",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("View All",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset(
                                        "assets/images/package_box_alt.png"),
                                    Text("To Pay")
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/package.png"),
                                  Text("To Ship")
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/package_car.png"),
                                  Text("To Receive")
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/Chat_alt_3.png"),
                                    Text("Chat")
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10.0, bottom: 10),
                            child: Row(
                              children: [
                                Image.asset(
                                    "assets/images/Refund_back_light.png"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("My Returns"),
                                Spacer(),
                                Image.asset(
                                    "assets/images/package_cancellation.png"),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("My Cancellations")
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Color(0xffF6F6F6),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "My Services",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text("View All",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/Message.png"),
                                    Text("Messages")
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/Credit_card.png"),
                                  Text("Payment")
                                ],
                              ),
                              Column(
                                children: [
                                  Image.asset("assets/images/Question.png"),
                                  Text("Help")
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: Column(
                                  children: [
                                    Image.asset("assets/images/Send_fill.png"),
                                    Text("To Review")
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Color(0xffF6F6F6),
                      width: MediaQuery.of(context).size.width * 0.95,
                      child: const Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 8.0),
                                  child: Text(
                                    "Location Tracker of Products Arrival",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "Country: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "Nepal",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "City: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "Bhaktapur",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Row(
                              children: [
                                Text(
                                  "Exact Location: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "Sanotimi",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 10.0, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  "Arrival Time: ",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 30,
                                ),
                                Text(
                                  "0days, 3hrs",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () {
                        logoutShowDialog(context, userProvider);
                      },
                      child: Text("Logout"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    CustomButton(
                      onPressed: () async {
                        createShowDialog(context, userProvider);
                      },
                      child:
                          userProvider.getDeleteUserStatus == StatusUtil.loading
                              ? CircularProgressIndicator()
                              : Text("Delete"),
                    )
                  ],
                ),
              ),
            ),
          );
  }

  logoutUserFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
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

  logoutShowDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to Logout?'),
          actions: [
            TextButton(
              onPressed: () async {
                await logoutUserFromSharedPreference();
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
                // Navigator.pushAndRemoveUntil(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => UpdateProduct(

                //       ),
                //     ),
                //     (route) => false);
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
