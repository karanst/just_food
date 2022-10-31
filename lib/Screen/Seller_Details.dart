import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:provider/src/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Helper/ApiBaseHelper.dart';
import '../Helper/Color.dart';
import '../Helper/Session.dart';
import '../Helper/String.dart';
import '../Provider/UserProvider.dart';
import 'Cart.dart';
import 'Favorite.dart';
import 'Login.dart';
import 'ProductList.dart';

class SellerProfile extends StatefulWidget {
  var sellerID,
      sellerName,
      sellerImage,
      sellerRating,
      storeDesc,
      sellerStoreName,
      subCatId;
  final sellerMobile;
  final sellerWhatsappNumber;
  final sellerPermission;
  final sellerData;
  final search;
  final extraData;
  final coverImage;

  SellerProfile(
      {Key? key,
        this.sellerID,
        this.sellerName,
        this.sellerImage,
        this.sellerRating,
        this.storeDesc,
        this.sellerStoreName,
        this.subCatId,
        this.sellerData,
        this.search,
        this.extraData,
        this.coverImage, this.sellerMobile, this.sellerWhatsappNumber, this.sellerPermission})
      : super(key: key);

  @override
  State<SellerProfile> createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  late TabController _tabController;
  bool _isNetworkAvail = true;

  bool isDescriptionVisible = false;
  bool favoriteSeller = false;
  // String _phone = widget.sellerMobile;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    // Use `Uri` to ensure that `phoneNumber` is properly URL-encoded.
    // Just using 'tel:$phoneNumber' would create invalid URLs in some cases,
    // such as spaces in the input, which would cause `launch` to fail on some
    // platforms.
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var checkOut = Provider.of<UserProvider>(context);

    return Scaffold(
      // appBar: getAppBar("Store", context),
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Theme.of(context).colorScheme.white,
        leading: Builder(
          builder: (BuildContext context) {
            return Container(
              margin: EdgeInsets.all(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () => Navigator.of(context).pop(),
                child: Center(
                  child: Icon(
                    Icons.arrow_back_ios_rounded,
                    color: colors.primary,
                  ),
                ),
              ),
            );
          },
        ),
        title: Text(
          "Store",
          style: TextStyle(color: colors.primary, fontWeight: FontWeight.normal),
        ),
        actions: <Widget>[
          IconButton(
              icon: SvgPicture.asset(
                imagePath + "search.svg",
                height: 20,
                color: colors.primary,
              ),
              onPressed: () {
                // Navigator.push(
                //     context,
                //     MaterialPageRoute(
                //       builder: (context) => ItemSearch(),
                //     ));
              }),
          "Store" == getTranslated(context, "FAVORITE")
              ? Container()
              : IconButton(
            padding: EdgeInsets.all(0),
            icon: SvgPicture.asset(
              imagePath + "desel_fav.svg",
              color: colors.primary,
            ),
            onPressed: () {
              CUR_USERID != null
                  ? Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Favorite(),
                ),
              )
                  : Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
          ),
          Selector<UserProvider, String>(
            builder: (context, data, child) {
              return IconButton(
                icon: Stack(
                  children: [
                    Center(
                        child: SvgPicture.asset(
                          imagePath + "appbarCart.svg",
                          color: colors.primary,
                        )),
                    (data != null && data.isNotEmpty && data != "0")
                        ? new Positioned(
                      bottom: 20,
                      right: 0,
                      child: Container(
                        //  height: 20,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: colors.primary),
                        child: new Center(
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: new Text(
                              data,
                              style: TextStyle(
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.white),
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container()
                  ],
                ),
                onPressed: () {
                  CUR_USERID != null
                      ? Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cart(
                        fromBottom: false,
                      ),
                    ),
                  )
                      : Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Login(),
                    ),
                  );
                },
              );
            },
            selector: (_, homeProvider) => homeProvider.curCartCount,
          )
        ],
      ),
      bottomSheet: int.parse(checkOut.curCartCount) > 0
          ? Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(colors.primary)),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Cart(fromBottom: false)));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Check out",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      )
          : SizedBox(width: 0,),
      body: Material(
        child: Column(
          children: [
            widget.search
                ? Container()
                : Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  height: 200,
                  width: width * 1,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(
                              widget.sellerData!.seller_profile),
                          fit: BoxFit.fill)),
                  child: Container(
                    height: height * 0.35,
                    width: width * 0.35,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          color: Colors.black.withOpacity(.5),
                          child: Column(
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      widget.sellerData!.seller_profile),
                                ),
                                title: Text(
                                  "${widget.sellerData.store_name!}"
                                      .toUpperCase(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                subtitle: Text(
                                  "${widget.sellerData.store_description}",
                                  maxLines: 2,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15, 0, 15, 5),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             SellerRatingsPage(
                                        //               sellerId:
                                        //               widget.sellerID,
                                        //             )));
                                      },
                                      child: Column(
                                        children: [
                                          Icon(
                                            Icons.star_rounded,
                                            color: colors.primary,
                                          ),
                                          Text(
                                            "${widget.sellerData.seller_rating}",
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: AddRemveSeller(sellerID: widget.sellerID),
                  ),
                ),*/
                // SizedBox(height: MediaQuery.of(context).size.height*0.2),
              ],
            ),
            widget.search
                ? Stack(
              alignment: Alignment.centerRight,
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              widget.sellerImage.toString()))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        color: Colors.black.withOpacity(.6),
                        child: Column(
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    widget.sellerImage.toString()),
                              ),
                              title: Text(
                                "${widget.sellerStoreName}".toUpperCase(),
                                style: TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${widget.storeDesc}",
                                style: TextStyle(color: Colors.white),
                                maxLines: 2,
                              ),
                            ),

                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceBetween,
                            //     children: [
                            //       Column(
                            //         children: [
                            //           Icon(
                            //             Icons.star_rounded,
                            //             color: Colors.white,
                            //           ),
                            //           Text(
                            //             "${widget.extraData["rating"]}",
                            //             style: TextStyle(
                            //                 color: colors.primary,
                            //                 fontWeight: FontWeight.bold),
                            //           )
                            //         ],
                            //       ),
                            //       widget.extraData["estimated_time"] != ""
                            //           ? Column(
                            //               children: [
                            //                 Text(
                            //                   "Delivery Time",
                            //                   style: TextStyle(
                            //                       color: Colors.white),
                            //                 ),
                            //                 Text(
                            //                   "${widget.extraData["estimated_time"]}",
                            //                   style: TextStyle(
                            //                       color: colors.primary,
                            //                       fontWeight:
                            //                           FontWeight.bold),
                            //                 ),
                            //               ],
                            //             )
                            //           : Container(),
                            //       widget.extraData["food_person"] != ""
                            //           ? Column(
                            //               children: [
                            //                 Text(
                            //                   "₹/Person",
                            //                   style: TextStyle(
                            //                       color: Colors.white),
                            //                 ),
                            //                 Text(
                            //                   "${widget.extraData["food_person"]}",
                            //                   style: TextStyle(
                            //                       color: colors.primary,
                            //                       fontWeight:
                            //                           FontWeight.bold),
                            //                 ),
                            //               ],
                            //             )
                            //           : Container(),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: AddRemveSeller(sellerID: widget.sellerID),
                  ),
                ),*/
              ],
            )
                : Container(),
            // Card(
            //   shape:
            //   RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            //   child: Column(
            //     children: [
            //       ListTile(
            //         leading: CircleAvatar(
            //           backgroundImage: NetworkImage(widget.sellerData!.seller_profile),
            //         ),
            //         title: Text("${widget.sellerData.store_name!}".toUpperCase()),
            //         subtitle: Text(
            //           "${widget.sellerData.store_description}",
            //           maxLines: 2,
            //         ),
            //       ),
            //       // ListTile(title: Text("Address"), subtitle: Text("${widget.sellerData.address}"),),
            //       Padding(
            //         padding: const EdgeInsets.all(8.0),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Column(
            //               children: [
            //                 Icon(
            //                   Icons.star_rounded,
            //                   color: colors.primary,
            //                 ),
            //                 Text("${widget.sellerData.seller_rating}")
            //               ],
            //             ),
            //             widget.sellerData.estimated_time !=""?
            //             Column(
            //               children: [
            //                 Text("Delivery Time"),
            //                 Text(
            //                   "${widget.sellerData.estimated_time}",
            //                   style: TextStyle(color: Colors.green),
            //                 ),
            //               ],
            //             ):Container(),
            //             widget.sellerData.food_person !=""?
            //             Column(
            //               children: [
            //                 Text("₹/Person"),
            //                 Text("${widget.sellerData.food_person}"),
            //               ],
            //             ):Container()
            //           ],),
            //       ),
            //       SizedBox(height: 10,)
            //
            //     ],
            //   ),
            // ),

            Expanded(
              child: ProductList(
                fromSeller: true,
                name: "",
                id: widget.sellerID,
                subCatId: widget.subCatId,
                tag: false,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: (){
              print(widget.sellerMobile);
              _makePhoneCall(widget.sellerMobile);
            },
            child: Icon(Icons.call),
          ),
          SizedBox(height: 10.0,),
          FloatingActionButton(
            onPressed: (){
              if(widget.sellerPermission == "1"){
                openwhatsapp(widget.sellerWhatsappNumber);
              } else {
                Fluttertoast.showToast(msg: "Seller Not Allow Whatsapp permission",
                  backgroundColor: colors.primary,
                );
              }
            },
            child: Icon(Icons.chat),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }

  openwhatsapp(phone) async{
    var whatsapp ="+91$phone";
    var whatsappURl_android = "whatsapp://send?phone="+whatsapp+"&text=hello";
    var whatappURL_ios ="https://wa.me/$whatsapp?text=${Uri.parse("hello")}";
    if(Platform.isIOS){
      // for iOS phone only
      if( await canLaunch(whatappURL_ios)){
        await launch(whatappURL_ios, forceSafariVC: false);
      }else{
        Fluttertoast.showToast(msg: "Whatsapp not installed");
      }
    }else{
      // android , web
      if( await canLaunch(whatsappURl_android)){
        await launch(whatsappURl_android);
      }else{
        Fluttertoast.showToast(msg: "Whatsapp not installed");
      }
    }
  }

  Widget detailsScreen() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0),
            child: CircleAvatar(
              radius: 80,
              backgroundColor: colors.primary,
              backgroundImage: NetworkImage(widget.sellerImage!),
              // child: ClipRRect(
              //   borderRadius: BorderRadius.circular(40),
              //   child: FadeInImage(
              //     fadeInDuration: Duration(milliseconds: 150),
              //     image: NetworkImage(widget.sellerImage!),
              //
              //     fit: BoxFit.cover,
              //     placeholder: placeHolder(100),
              //     imageErrorBuilder: (context, error, stackTrace) =>
              //         erroWidget(100),
              //   ),
              // )
            ),
          ),
          getHeading(widget.sellerStoreName!),
          SizedBox(
            height: 5,
          ),
          Text(
            widget.sellerName!,
            style: TextStyle(
                color: Theme.of(context).colorScheme.lightBlack2, fontSize: 16),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: colors.primary),
                      child: Icon(
                        Icons.star,
                        color: Theme.of(context).colorScheme.white,
                        size: 30,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      widget.sellerRating!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.lightBlack2,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.0),
                            color: colors.primary),
                        child: Icon(
                          Icons.description,
                          color: Theme.of(context).colorScheme.white,
                          size: 30,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          isDescriptionVisible = !isDescriptionVisible;
                        });
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      getTranslated(context, 'DESCRIPTION')!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.lightBlack2,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Column(
                  children: [
                    InkWell(
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              color: colors.primary),
                          child: Icon(
                            Icons.list_alt,
                            color: Theme.of(context).colorScheme.white,
                            size: 30,
                          ),
                        ),
                        onTap: () => _tabController
                            .animateTo((_tabController.index + 1) % 2)),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      getTranslated(context, 'PRODUCTS')!,
                      style: TextStyle(
                          fontSize: 12,
                          color: Theme.of(context).colorScheme.lightBlack2,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Visibility(
              visible: isDescriptionVisible,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 8,
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: colors.primary)),
                child: SingleChildScrollView(
                    child: Text(
                      (widget.storeDesc != "" || widget.storeDesc != null)
                          ? "${widget.storeDesc}"
                          : getTranslated(context, "NO_DESC")!,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.lightBlack2),
                    )),
              ))
        ],
      ),
    );
  }

  Widget getHeading(String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headline6!.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.fontColor,
      ),
    );
  }

  Widget getRatingBarIndicator(var ratingStar, var totalStars) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: RatingBarIndicator(
        rating: ratingStar,
        itemBuilder: (context, index) => const Icon(
          Icons.star_outlined,
          color: colors.yellow,
        ),
        itemCount: totalStars,
        itemSize: 20.0,
        direction: Axis.horizontal,
        unratedColor: Colors.transparent,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
