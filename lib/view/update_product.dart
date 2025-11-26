import 'dart:io';
import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/custom/custom_button.dart';
import 'package:ecommerce/custom/custom_textformfield.dart';
import 'package:ecommerce/provider/product_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/custom_bottom_navbar.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UpdateProduct extends StatefulWidget {
  final dynamic data;
  UpdateProduct({super.key, required this.data});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  File? file;
  final _formKey = GlobalKey<FormState>();
  String? downloadUrl;
  bool loader = false;

  @override
  void initState() {
    super.initState();
    // Initialize downloadUrl with existing image URL
    downloadUrl = widget.data.image ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: backGroundColor,
          foregroundColor: buttonForegroundColor,
          title: Text(
            "Update Product",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Consumer<ProductProvider>(
            builder: (context, productProvider, child) => Column(
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Image Display (Existing or New)
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: file == null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  downloadUrl ?? "",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                          "assets/images/add-product.png"),
                                ),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.file(file!),
                              ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.50,
                        height: MediaQuery.of(context).size.height * 0.05,
                        child: CustomButton(
                          backgroundColor: backGroundColor,
                          onPressed: () async {
                            await pickImage();
                          },
                          child: loader
                              ? CircularProgressIndicator()
                              : Text(
                                  "Select Image",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: CustomTextFormField(
                          initialValue: widget.data.name,
                          onChanged: (value) {
                            productProvider.setProductName(value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return nameValidationStr;
                            }
                            return null;
                          },
                          labelText: "Name",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: CustomTextFormField(
                          initialValue: widget.data.brand,
                          onChanged: (value) {
                            productProvider.setProductBrand(value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return nameValidationStr;
                            }
                            return null;
                          },
                          labelText: "Brand",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: CustomTextFormField(
                          initialValue: widget.data.price,
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
                          initialValue: widget.data.quantity,
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
                          initialValue: widget.data.category,
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
                          initialValue: widget.data.model,
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
                          initialValue: widget.data.cpu,
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
                          initialValue: widget.data.operatingSystem,
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
                          initialValue: widget.data.memory,
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
                          initialValue: widget.data.storage,
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
                          initialValue: widget.data.screen,
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
                          initialValue: widget.data.graphics,
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
                          initialValue: widget.data.wirelessConnectivity,
                          onChanged: (value) {
                            productProvider.setWirelessConnectivity(value);
                          },
                          labelText: "Wireless Connectivity",
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 10),
                        child: CustomTextFormField(
                          initialValue: widget.data.camera,
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
                          initialValue: widget.data.warranty,
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
                          initialValue: widget.data.description,
                          onChanged: (value) {
                            productProvider.setProductDescription(value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return descriptionValidationStr;
                            }
                            return null;
                          },
                          maxLines:
                              null, // Allows the TextFormField to grow dynamically
                          minLines: 7, // Sets a minimum number of lines
                          keyboardType:
                              TextInputType.multiline, // Allows multiline input
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
                            // Save updated image URL in the provider
                            productProvider.setProductImage(downloadUrl ?? "");
                            await productProvider.updateProduct(widget.data.id);

                            if (productProvider.updateProductStatus ==
                                StatusUtil.success) {
                              Helper.displaySnackbar(
                                  context, "Product Successfully Updated!");
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        CustomBottomNavigationBar(
                                            initialIndex: 3),
                                  ),
                                  (route) => false);
                            } else if (productProvider.updateProductStatus ==
                                StatusUtil.error) {
                              Helper.displaySnackbar(
                                  context, "Product not Updated.");
                            }
                          }
                        },
                        child: productProvider.updateProductStatus ==
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Image Picker and Upload
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      file = File(image.path);
      setState(() {
        loader = true;
      });
      try {
        String fileName = file!.path.split('/').last;
        var storageReference = FirebaseStorage.instance.ref().child(fileName);
        await storageReference.putFile(file!);
        downloadUrl = await storageReference.getDownloadURL();
      } catch (e) {
        print("Image upload error: $e");
      }
      setState(() {
        loader = false;
      });
    }
  }
}
