import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/model/cart.dart';
import 'package:ecommerce/model/product.dart';
import 'package:ecommerce/model/rate.dart';
import 'package:ecommerce/provider/auth_provider.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/view/add_cart.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:ecommerce/view/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductPage extends StatefulWidget {
  final dynamic data;
  final double? averageRating;
  final int? totalCounts;
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
    // getValue();
    // getUserId();
    // initializeUserData();
    initializeAllData();
  }

  String? uId, uRole, uEmail;

  Future<void> initializeAllData() async {
    var authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    var productProvider = Provider.of<ProductProvider>(context, listen: false);

    //  Get user ID and email safely
    uId = authProvider.currentUser?.uid;
    uEmail = authProvider.currentUser?.email;

    if (uId == null) return; // Stop if user is not logged in

    // Get user role
    uRole = await authProvider.getUserRole(uId!);

    //  Check rating and purchase data
    await productProvider.checkRatingOfProducts(widget.data.id, uId!);
    await productProvider.checkOrderForBoughtProducts(widget.data.id, uId!);

    // Update UI safely
    setState(() {
      canRateProduct = productProvider.hasPurchasedProduct;
    });
  }
  // Future<String?> getUserId() async {
  //   var provider = Provider.of<AuthenticationProvider>(context, listen: false);
  //   uId = provider.currentUser!.uid;
  //   return uId;
  // }

  // void initializeUserData() async {
  //   var provider = Provider.of<AuthenticationProvider>(context, listen: false);

  //   uId = provider.currentUser?.uid;
  //   uEmail = provider.currentUser?.email;
  //   if (uId != null) {
  //     uRole = await provider.getUserRole(uId!);
  //     setState(() {
  //     uRole;
  //     }); // Refresh UI after data is fetched
  //   }
  // }

  // getValue() async {
  //   setState(() {
  //     userId = uId;
  //   });
  //   if (userId != null) {
  //     await checkUserRatingOfProductData(widget.data.id, uId!);
  //     await checkUserPurchase(widget.data.id, uId!);
  //   }
  // }

  // checkUserRatingOfProductData(String id, String userId) async {
  //   var provider = Provider.of<ProductProvider>(context, listen: false);
  //   await provider.checkRatingOfProducts(id, userId);
  // }

  // checkUserPurchase(String productId, String userId) async {
  //   var provider = Provider.of<ProductProvider>(context, listen: false);
  //   await provider.checkOrderForBoughtProducts(productId, userId);
  //   setState(() {
  //     canRateProduct = provider.hasPurchasedProduct;
  //   });
  // }

  Widget _buildSpecsGrid() {
    // Present specs in two-column grid
    final specs = {
      "Model": widget.data.model ?? "N/A",
      "CPU": widget.data.cpu ?? "N/A",
      "OS": widget.data.operatingSystem ?? "N/A",
      "Memory": widget.data.memory ?? "N/A",
      "Storage": widget.data.storage ?? "N/A",
      "Camera": widget.data.camera ?? "N/A",
      "Graphics": widget.data.graphics ?? "N/A",
      "Screen": widget.data.screen ?? "N/A",
      "Warranty": widget.data.warranty ?? "N/A",
      "Wireless": widget.data.wirelessConnectivity ?? "N/A",
    };

    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: specs.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, childAspectRatio: 4.5),
      itemBuilder: (context, index) {
        String key = specs.keys.elementAt(index);
        String val = specs.values.elementAt(index);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "$key: ",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
              ),
              Expanded(
                child: Text(
                  val,
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // sizes
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: backGroundColor,
          foregroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "${widget.data.category ?? ''}",
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
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
        ),
        body: Consumer<ProductProvider>(
          builder: (context, productProvider, child) {
            // show loading if provider operations are loading
            if (productProvider.checkRatingOfProduct == StatusUtil.loading ||
                productProvider.checkOrderForBoughtProduct ==
                    StatusUtil.loading) {
              return Center(child: CircularProgressIndicator());
            }

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 110),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero image with rounded corners and subtle shadow
                      Container(
                        width: width,
                        height: height * 0.42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 18,
                                offset: Offset(0, 6))
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.network(
                            "${widget.data.image ?? ''}",
                            fit: BoxFit.fill,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(child: CircularProgressIndicator());
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                  child: Icon(Icons.broken_image, size: 64));
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: 16),

                      // Price, name, rating section (card)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14.0, vertical: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Row: Name & Price
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        "${widget.data.name ?? ''}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      "Rs.${widget.data.price ?? '0'}",
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 18),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                // Rating & stock
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.orange, size: 20),
                                    SizedBox(width: 6),
                                    Text(
                                        "${(widget.averageRating ?? 0.0).toStringAsFixed(1)}/5"),
                                    SizedBox(width: 10),
                                    Text(
                                        "(${(widget.totalCounts ?? 0.0).toStringAsFixed(0)})",
                                        style: TextStyle(color: Colors.grey)),
                                    Spacer(),
                                    Text(
                                      "In Stock: ${widget.data.quantity ?? '0'}",
                                      style: TextStyle(fontSize: 14),
                                    ),
                                    Spacer(),
                                    Text(
                                      "Brand: ${widget.data.brand ?? 'Unknown'}",
                                      style: TextStyle(fontSize: 14),
                                    )
                                  ],
                                ),
                                SizedBox(height: 12),
                                // Short description
                                Text(
                                  "${widget.data.description ?? ''}",
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.grey.shade800),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      // Specifications card
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Specifications",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900)),
                                SizedBox(height: 8),
                                _buildSpecsGrid(),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      // Full description / details
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("About this product",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900)),
                                SizedBox(height: 8),
                                Text(
                                  "${widget.data.description ?? ''}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 12),

                      // Rating area (only show if not already rated & allowed)
                      if (productProvider.isAlreadyRated ?? false)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 8),
                          child: Text(
                            "You have already rated the product.",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.red),
                          ),
                        )
                      else if (uId != null &&
                          uRole != "admin" &&
                          canRateProduct != false)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14.0, vertical: 8),
                          child: Card(
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0, vertical: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Rate this product",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900)),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
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
                                      SizedBox(
                                        width: 10,
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20.0, vertical: 10),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: CustomButton(
                                            backgroundColor: Colors.redAccent,
                                            foregroundColor:
                                                buttonForegroundColor,
                                            onPressed: () async {
                                              Rate rate = Rate(
                                                productId: widget.data.id,
                                                isRated: true,
                                                userId: uId,
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
                                                await productProvider
                                                    .checkRatingOfProducts(
                                                        widget.data.id, uId!);
                                                Helper.displaySnackbar(context,
                                                    "Product Successfully Rated");
                                              } else {
                                                Helper.displaySnackbar(context,
                                                    "Product Rating Failed!");
                                              }
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Icon(Icons.star,
                                                //     size: 18,
                                                //     color: Colors.yellowAccent),
                                                // SizedBox(width: 6),

                                                // if (hasRated == false &&
                                                //     uId != null &&
                                                //     uRole != "admin" &&
                                                //     canRateProduct != false)
                                                  Text("Rate Product"),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),

                      SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "Related Products",
                          style: TextStyle(
                              fontWeight: FontWeight.w900, fontSize: 18),
                        ),
                      ),
                      FutureBuilder(
                        future: productProvider
                            .getRecommendedProductsManually(widget.data),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData)
                            return CircularProgressIndicator();

                          final relatedProducts = snapshot.data!;
                          return SizedBox(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProducts.length,
                              itemBuilder: (context, index) {
                                final product = relatedProducts[index];

                                productProvider
                                    .calculateAverageRating(product.id!);
                                double averageRating = 0.0;
                                int totalReviews = 0;

                                // Check if ratings exist for this product in the provider
                                if (productProvider.productRatings
                                    .containsKey(product.id)) {
                                  averageRating =
                                      productProvider.productRatings[product.id]
                                              ?['average'] ??
                                          0.0;
                                  totalReviews =
                                      productProvider.productRatings[product.id]
                                              ?['count'] ??
                                          0;
                                }
                                return ProductCard(
                                    averageRating: averageRating,
                                    totalCounts: totalReviews,
                                    product: relatedProducts[index]);
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),

                // Sticky bottom action bar (Add to cart)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 12,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: Offset(0, 6))
                        ],
                      ),
                      child: Row(
                        children: [
                          // Favorite or small thumbnail could go here (kept simple)
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.grey.shade300)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                "${widget.data.image ?? ''}",
                                fit: BoxFit.cover,
                                errorBuilder: (context, e, st) {
                                  return Icon(Icons.broken_image);
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("${widget.data.name ?? ''}",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 4),
                                Text("Rs.${widget.data.price ?? '0'}",
                                    style:
                                        TextStyle(fontWeight: FontWeight.w900)),
                              ],
                            ),
                          ),

                          SizedBox(width: 8),
                          SizedBox(
                            width: width * 0.36,
                            height: 46,
                            child: uRole == "admin"
                                ? SizedBox()
                                : CustomButton(
                                    backgroundColor:
                                        const Color.fromARGB(255, 21, 164, 26),
                                    foregroundColor: buttonForegroundColor,
                                    onPressed: () async {
                                      // final SharedPreferences prefs =
                                      //     await SharedPreferences.getInstance();
                                      // userId = prefs.getString("userId");
                                      // userRole = prefs.getString("userRole");
                                      if (uId == null || uId!.isEmpty) {
                                        Helper.displaySnackbar(context,
                                            "Please login to your account!");
                                        return;
                                      }
                                      if (uRole == "admin") {
                                        Helper.displaySnackbar(context,
                                            "Admin cannot add product to the cart!");
                                        return;
                                      }

                                      Cart cart = Cart(
                                        userId: uId,
                                        userEmail: uEmail,
                                        id: widget.data.id!,
                                        name: widget.data.name!,
                                        quantity: "1",
                                        price: widget.data.price!,
                                        image: widget.data.image!,
                                      );

                                      await productProvider
                                          .checkProductInCart(cart);

                                      if (productProvider
                                          .isSuccessProductInCart!) {
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
                                    child: Text("Add to cart"),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;
  final double? averageRating;
  final int? totalCounts;
  const ProductCard(
      {super.key, required this.product, this.averageRating, this.totalCounts});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(
                totalCounts: widget.totalCounts,
                averageRating: widget.averageRating,
                data: widget.product),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                widget.product.image ?? '',
                height: 110,
                width: double.infinity,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: Colors.grey.shade200,
                  child: const Icon(Icons.image_not_supported, size: 30),
                ),
              ),
            ),

            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name ?? 'Unnamed Product',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  // const SizedBox(height: 4),

                  // Price
                  Text(
                    "Rs. ${widget.product.price ?? '0.00'}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      color: Colors.green.shade700,
                    ),
                  ),

                  // const SizedBox(height: 6),

                  // Ratings
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: Colors.orange.shade600),
                      const SizedBox(width: 4),
                      Text(
                          "${(widget.averageRating ?? 0.0).toStringAsFixed(1)}/5"),
                      SizedBox(width: 10),
                      Text(
                          "(${(widget.totalCounts ?? 0.0).toStringAsFixed(0)})",
                          style: TextStyle(color: Colors.grey)),
                      Spacer(),
                    ],
                  ),

                  // const SizedBox(height: 8),

                  // Add to Cart button
                  // ElevatedButton(
                  //   onPressed: () {
                  //     // Add to cart logic here
                  //   },
                  //   style: ElevatedButton.styleFrom(
                  //     backgroundColor: Colors.deepPurple,
                  //     minimumSize: const Size(double.infinity, 36),
                  //     shape: RoundedRectangleBorder(
                  //       borderRadius: BorderRadius.circular(10),
                  //     ),
                  //     elevation: 0,
                  //   ),
                  //   child: const Text(
                  //     "Add to Cart",
                  //     style: TextStyle(fontSize: 13, color: Colors.white),
                  //   ),f
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
