import 'package:ecommerce/core/status_util.dart';
import 'package:ecommerce/provider/user_provider.dart';
import 'package:ecommerce/utils/Helper.dart';
import 'package:ecommerce/utils/color_const.dart';
import 'package:ecommerce/utils/string_const.dart';
import 'package:ecommerce/view/signin_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> categories = [
    "Printer",
    "Mobile",
    "Laptop",
    "Earbuds",
    "Smart Watches"
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getValue();
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) => SafeArea(
        child: userProvider.getUserStatus == StatusUtil.loading
            ? Center(child: CircularProgressIndicator())
            : Scaffold(
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
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            return Container(
                              child: Card(
                                child: Column(
                                  children: [
                                    Image.asset(
                                      "assets/images/ecommerce1.png",
                                      height: 120,
                                      width: 150,
                                      fit: BoxFit.cover,
                                    ),
                                    Text(categories[index])
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 5, left: 10.0, bottom: 5),
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
                      // Expanded(
                      //   child: ListView.builder(
                      //     itemCount: userProvider.userList.length,
                      //     itemBuilder: (context, index) {
                      //       return Card(
                      //         child: Column(
                      //           children: [
                      //             Text(userProvider.userList[index].name!),
                      //             Text(userProvider.userList[index].email!)
                      //           ],
                      //         ),
                      //       );
                      //     },
                      //   ),
                      // ),
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
                            children: List.generate(categories.length, (index) {
                              return Center(
                                child: SizedBox(
                                  height: 300,
                                  width: 300,
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Image.asset(
                                          "assets/images/ecommerce1.png",
                                          height: 120,
                                          width: 177,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Text(categories[index]),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text(
                                            "Rs.2000",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        )
                                      ],
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
