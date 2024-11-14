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
  List<dynamic> filteredList = [];
  void initState() {
    // TODO: implement initState
    super.initState();
    getProductData();
  }

  getProductData() {
    Future.delayed(
      Duration.zero,
      () async {
        var provider = Provider.of<ProductProvider>(context, listen: false);
        await provider.getProduct();
        filteredList = provider.productslist
            .where((product) => product.category == widget.data)
            .toList();
      },
    );
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
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 4,
                      crossAxisCount: 2,
                      scrollDirection: Axis.vertical,
                      physics: ScrollPhysics(),
                      children: List.generate(filteredList.length, (index) {
                        return Center(
                          child: SizedBox(
                            height: 200,
                            width: 300,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductPage(
                                        data: filteredList[index],
                                      ),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: SizedBox(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        filteredList[index].image != null
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadiusDirectional
                                                        .only(
                                                            topEnd:
                                                                Radius.circular(
                                                                    10),
                                                            topStart:
                                                                Radius.circular(
                                                                    10)),
                                                child: FadeInImage(
                                                  placeholder: AssetImage(
                                                      'assets/images/placeholder.png'), // Use an asset image placeholder or use `Shimmer` widget here
                                                  image: NetworkImage(
                                                      filteredList[index]
                                                          .image!),
                                                  height: 120,
                                                  width: 177,
                                                  fit: BoxFit.fill,
                                                  imageErrorBuilder: (context,
                                                      error, stackTrace) {
                                                    return Shimmer.fromColors(
                                                      baseColor: Colors.red,
                                                      highlightColor:
                                                          Colors.yellow,
                                                      child: Container(
                                                        color: Colors.grey,
                                                        height: 120,
                                                        width: 177,
                                                        alignment:
                                                            Alignment.center,
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
                                                      (context, error,
                                                          stackTrace) {
                                                    return Shimmer.fromColors(
                                                      baseColor:
                                                          Colors.grey[300]!,
                                                      highlightColor:
                                                          Colors.grey[100]!,
                                                      child: Container(
                                                        color: Colors.white,
                                                        height: 120,
                                                        width: 177,
                                                        alignment:
                                                            Alignment.center,
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
                                                      fontWeight:
                                                          FontWeight.bold,
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
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(productProvider
                                              .productslist[index].name!),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
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
                                )),
                          ),
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
