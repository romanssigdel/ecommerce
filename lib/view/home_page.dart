import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
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
      },
    );
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
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    child: SearchBar(
                      leading: Icon(Icons.search),
                      hintText: searchProduct,
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
                  height: MediaQuery.of(context).size.height * 0.18,
                  width: MediaQuery.of(context).size.width * 0.97,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: productProvider.categoryImages.length,
                    itemBuilder: (context, index) {
                      return Container(
                        child: Card(
                          child: Column(
                            children: [
                              ClipRRect(
                                child: Image.asset(
                                  productProvider.categoryImages[index],
                                  height: 120,
                                  width: 150,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(productProvider.categories[index])
                            ],
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
                      mainAxisSpacing: 4,
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      children: List.generate(
                          productProvider.productslist.length, (index) {
                        return Center(
                          child: SizedBox(
                            height: 200,
                            width: 300,
                            child: Card(
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    productProvider.productslist[index].image !=
                                            null
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
                                                  productProvider
                                                      .productslist[index]
                                                      .image!),
                                              height: 120,
                                              width: 177,
                                              fit: BoxFit.fill,
                                              imageErrorBuilder:
                                                  (context, error, stackTrace) {
                                                return Shimmer.fromColors(
                                                  baseColor: Colors.red,
                                                  highlightColor: Colors.yellow,
                                                  child: Container(
                                                    color: Colors.grey,
                                                    height: 120,
                                                    width: 177,
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
                                                    height: 120,
                                                    width: 177,
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
                                              height: 120,
                                              width: 177,
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

                                    // Image.network(
                                    //   productProvider
                                    //       .productslist[index].image!,
                                    //   height: 120,
                                    //   width: 177,
                                    //   fit: BoxFit.cover,
                                    // ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(productProvider
                                          .productslist[index].name!),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        "Rs." +
                                            productProvider
                                                .productslist[index].price!,
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold),
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
