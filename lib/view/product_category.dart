import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/view/product_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductCategory extends StatefulWidget {
  var data;
  ProductCategory({super.key, this.data});

  @override
  State<ProductCategory> createState() => _ProductCategoryState();
}

class _ProductCategoryState extends State<ProductCategory> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductData();
  }

  List<dynamic> filteredList = [];
  getProductData() {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<ProductProvider>(context, listen: false);
        await provider.getProduct();
        filteredList = provider.productslist
            .where((product) => product.category == widget.data)
            .toList();
        // bubbleSortProductsByRating(filteredList, provider);
        // setState(() {});
      },
    );
  }

  void bubbleSortProductsByRating(
      List<Product> products, ProductProvider productProvider) {
    int n = products.length;
    for (int i = 0; i < n - 1; i++) {
      for (int j = 0; j < n - i - 1; j++) {
        double ratingA =
            productProvider.productRatings[products[j].id]?['average'] ?? 0.0;
        double ratingB = productProvider.productRatings[products[j + 1].id]
                ?['average'] ??
            0.0;

        if (ratingA < ratingB) {
          Product temp = products[j];
          products[j] = products[j + 1];
          products[j + 1] = temp;
        }
      }
    }
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: buttonBackgroundColor,
          foregroundColor: Colors.white,
          title: Text(
            "${widget.data!}",
            style: const TextStyle(fontWeight: FontWeight.w900),
          ),
          actions: [],
        ),
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) => SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 10),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 1,
                    width: MediaQuery.of(context).size.width * 1,
                    child: GridView.count(
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 6,
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      scrollDirection: Axis.vertical,
                      physics: const ScrollPhysics(),
                      children: List.generate(filteredList.length, (index) {
                        var product = filteredList[index];
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
                          height: 200,
                          width: 300,
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductPage(
                                      data: filteredList[index],
                                      averageRating: averageRating,
                                      totalCounts: totalReviews,
                                    ),
                                  ),
                                );
                              },
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
                                // height: 300,
                                // width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    filteredList[index].image != null
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
                                                  filteredList[index].image!),
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
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(productProvider
                                          .productslist[index].name!),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "Rs." +
                                            productProvider
                                                .productslist[index].price!,
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
                                              "${(averageRating.toStringAsFixed(1))}/5 (${(totalReviews.toStringAsFixed(1))})")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )),
                        );
                      }),
                    ),
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
