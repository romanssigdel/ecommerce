import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/product_category.dart';
import 'package:ecommerce/view/product_page.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  TextEditingController _searchController = TextEditingController();
  List<Product> filteredProducts = [];
  bool isSearching = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
    getProductData();
  }

  getValue() async {
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

        for (var product in provider.productslist) {
          await provider.calculateAverageRating(product.id!);
        }

        bubbleSortProductsByRating(provider.productslist, provider);
        setState(() {
          filteredProducts = provider.productslist;
        });
      },
    );
  }

  void _filteredProducts(String query) {
    final productProvider =
        Provider.of<ProductProvider>(context, listen: false);
    List<Product> results = [];

    if (query.isEmpty) {
      results = productProvider.productslist;
    } else {
      results = productProvider.productslist
          .where((product) =>
              product.name!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {
      filteredProducts = results;
    });
  }

  void bubbleSortProductsByRating(
      List<Product> products, ProductProvider productProvider) {
    int n = products.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        // Get the average ratings for the cars
        double ratingA =
            productProvider.productRatings[products[j].id]?['average'] ?? 0.0;
        double ratingB = productProvider.productRatings[products[j + 1].id]
                ?['average'] ??
            0.0;

        // Swap if the car at j has a lower rating than the car at j+1
        if (ratingA < ratingB) {
          // Swap cars
          Product temp = products[j];
          products[j] = products[j + 1];
          products[j + 1] = temp;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: backGroundColor,
            leadingWidth: 110,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: [
                  Text(
                    "Epasal",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Icon(
                  Icons.chat,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Icon(
                  Icons.notifications_none,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 15.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage("assets/images/user.png"),
                ),
              )
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "assets/images/banner.png",
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // Shadow position
                        ),
                      ],
                    ),
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: TextField(
                      decoration: InputDecoration(
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14.0),
                        hintText: "Search...",
                      ),
                      onChanged: _filteredProducts,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Categories",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: MediaQuery.of(context).size.width * 0.97,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.categoryImages.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductCategory(
                                  data: productProvider.categories[index],
                                ),
                              ));
                        },
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              // border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                ClipRRect(
                                  child: Image.asset(
                                    productProvider.categoryImages[index],
                                    height: 70,
                                    width: 115,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                Text(productProvider.categories[index])
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5, left: 10.0, bottom: 5),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Products",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width * 1,
                    child: GridView.count(
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      children: List.generate(filteredProducts.length, (index) {
                        var product = filteredProducts[index];
                        productProvider.calculateAverageRating(product.id!);
                        double averageRating = 0.0;
                        int totalReviews = 0;

                        // Check if ratings exist for this product in the provider
                        if (productProvider.productRatings
                            .containsKey(product.id)) {
                          averageRating = productProvider
                                  .productRatings[product.id]?['average'] ??
                              0.0;
                          totalReviews = productProvider
                                  .productRatings[product.id]?['count'] ??
                              0;
                        }

                        return SizedBox(
                          height: 300,
                          width: 300,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductPage(
                                    data: productProvider.productslist[index],
                                    averageRating: averageRating,
                                    totalCounts: totalReviews,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 3,
                                      offset: Offset(0, 3), // Shadow position
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    filteredProducts[index].image != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadiusDirectional.only(
                                                    topEnd: Radius.circular(10),
                                                    topStart:
                                                        Radius.circular(10)),
                                            child: FadeInImage(
                                              placeholder: AssetImage(
                                                  'assets/images/placeholder.png'), // Use an asset image placeholder or use `Shimmer` widget here
                                              image: NetworkImage(
                                                  filteredProducts[index]
                                                      .image!),
                                              height: 180,
                                              width: 220,
                                              fit: BoxFit.fill,
                                              imageErrorBuilder:
                                                  (context, error, stackTrace) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.red,
                                                  highlightColor: Colors.yellow,
                                                  child: Container(
                                                    color: Colors.grey,
                                                    height: 180,
                                                    width: 220,
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      'Image Error',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 20.0,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              placeholderErrorBuilder:
                                                  (context, error, stackTrace) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.grey[300]!,
                                                  highlightColor:
                                                      Colors.grey[100]!,
                                                  child: Container(
                                                    color: Colors.white,
                                                    height: 180,
                                                    width: 220,
                                                    alignment: Alignment.center,
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                        : Shimmer.fromColors(
                                            baseColor: Colors.red,
                                            highlightColor: Colors.yellow,
                                            child: Container(
                                              height: 180,
                                              width: 220,
                                              alignment: Alignment.center,
                                              child: Text(
                                                'Shimmer',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 40.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child:
                                          Text(filteredProducts[index].name!),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Rs." + filteredProducts[index].price!,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            color: Colors.orange,
                                            size: 16,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                              "${(averageRating.toStringAsFixed(1))}/5 (${(totalReviews.toStringAsFixed(0))})")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }

  logoutUserFromSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('isLogin');
    Helper.displaySnackbar(context, "Successfully Logged Out!");
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => SigninPage(),
        ),
        (route) => false);
  }
}
