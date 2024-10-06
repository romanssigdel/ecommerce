import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:flutter/material.dart';

class ProductPage extends StatefulWidget {
  var data;
  ProductPage({super.key, this.data});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text("${widget.data.category!}"),
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
          child: Column(
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
                        backgroundColor: Color.fromARGB(255, 21, 164, 26),
                        foregroundColor: buttonForegroundColor,
                        onPressed: () {},
                        child: const Text("Add to cart"),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10.0, top: 10),
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
                        // Text("Cpu: ${widget.data.cpu!}",
                        //     style: const TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.w900)),
                        // Text(
                        //     "Operating System: ${widget.data.operatingSystem!}",
                        //     style: const TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.w900)),
                        // Text("Memory: ${widget.data.memory!}",
                        //     style: const TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.w900)),
                        // Text("Storage: ${widget.data.storage!}",
                        //     style: const TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.w900)),
                        // Text("Model: ${widget.data.model!}",
                        //     style: const TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.w900)),
                        // Text("Model: ${widget.data.model!}",
                        //     style: const TextStyle(
                        //         fontSize: 16, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
