import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:entermarket_user/Helper/Color.dart';
import 'package:entermarket_user/Helper/Session.dart';
import 'package:entermarket_user/Helper/String.dart';
import 'package:entermarket_user/Model/Section_Model.dart';
import 'package:entermarket_user/Screen/starting_view/SubCategory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'HomePage.dart';
import 'Seller_Details.dart';

class SellerList extends StatefulWidget {
  final catId;
  final subId;
  final catName;
  final getByLocation;
  List<Product> sellerList;
   SellerList(
      {Key? key, this.catId, this.subId, this.catName, this.getByLocation,required this.sellerList})
      : super(key: key);

  @override
  _SellerListState createState() => _SellerListState();
}

class _SellerListState extends State<SellerList> {
  bool loading = true;
  List<Product> sellerList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.sellerList.length>0){
      loading = false;
      sellerList=widget.sellerList.toList();
    }else{
      getSeller();
    }

  }
  void getSeller() {

    Map parameter = {
      "category_id":widget.catId,
    };
    apiBaseHelper.postAPICall(getSellerApi, parameter).then((getdata) {
      bool error = getdata["error"];
      String? msg = getdata["message"];
      if (!error) {
        var data = getdata["data"];
        setState(() {
          loading=false;
          sellerList =
              (data as List).map((data) => new Product.fromSeller(data)).toList();
        });

      } else {
        setSnackbar(msg!);
      }
    }, onError: (error) {
      setSnackbar(error.toString());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: getAppBar(widget.catName!=""?widget.catName:getTranslated(context, 'SHOP_BY_SELLER')!, context),
        body: !loading&&sellerList.length>0
            ? ListView.builder(
          itemCount: sellerList.length,
          physics: AlwaysScrollableScrollPhysics(),
          itemBuilder: (context, index) {
                return listItem(index);
              },
            )
            : Center(child: CircularProgressIndicator())
    );
  }
  Widget listItem(int index) {
    if (index < sellerList.length) {
      Product model = sellerList[index];
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 10),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Card(
              elevation: 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                child: Stack(children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Hero(
                          tag: "ProList$index${model.id}",
                          child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                              child: Stack(
                                children: [
                                  FadeInImage(
                                    image: CachedNetworkImageProvider(
                                        sellerList[index].seller_profile!),
                                    height: 125.0,
                                    width: 135.0,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder:
                                        (context, error, stackTrace) =>
                                        erroWidget(125),
                                    placeholder: placeHolder(125),
                                  ),
                                ],
                              ))),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                sellerList[index].seller_name!,
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1!
                                    .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .lightBlack),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 5,),
                              Text(
                                calculateDistance(latitudeHome.toString(), longitudeHome.toString(), model.latitude, model.longitude),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,fontSize: 10.sp,),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(height: 10,),
                              /*Container(
                                child: Text(
                                  "Delivery Time : ${sellerList[index].delivery_tiem.toString()}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .fontColor,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w500,),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),*/
                              Row(
                                children: [
                                  InkWell(
                                    onTap: (){
                                      _makePhoneCall(sellerList[index].seller_mobile!);
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(Icons.call),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      if(sellerList[index].permissions!['whatsapp_show'] == "1"){
                                        openwhatsapp(sellerList[index].seller_whatsapp!);
                                      } else {
                                        Fluttertoast.showToast(msg: "Seller Not Allow Whatsapp permission",
                                          backgroundColor: colors.primary,
                                        );
                                      }
                                    },
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset("assets/icons/whatsapp.png", height: 25, width: 25,),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ]),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubCategory(
                            title: sellerList[index]
                                .store_name
                                .toString(),
                            sellerId: sellerList[index]
                                .seller_id
                                .toString(),
                            sellerData: sellerList[index],
                            catId: sellerList[index].category_ids!.contains(",")?sellerList[index].category_ids!.split(",")[0]:sellerList[index].category_ids!,
                          )));
                },
              ),
            ),
          ],
        ),
      );
    } else
      return Container();
  }
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launch(launchUri.toString());
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

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.black),
      ),
      backgroundColor: Theme.of(context).colorScheme.white,
      elevation: 1.0,
    ));
  }

  Widget catItem(int index, BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(25.0),
                  child: FadeInImage(
                    image: CachedNetworkImageProvider(
                        sellerList[index].seller_profile!),
                    fadeInDuration: Duration(milliseconds: 150),
                    fit: BoxFit.fill,
                    imageErrorBuilder: (context, error, stackTrace) =>
                        erroWidget(50),
                    placeholder: placeHolder(50),
                  )),
            ),
          ),
          Text(
            sellerList[index].seller_name! + "\n",
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .caption!
                .copyWith(color: Theme.of(context).colorScheme.fontColor),
          )
        ],
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SellerProfile(
                      sellerStoreName: sellerList[index].store_name ?? "",
                      sellerRating: sellerList[index].seller_rating ?? "",
                      sellerImage: sellerList[index].seller_profile ?? "",
                      sellerName: sellerList[index].seller_name ?? "",
                      sellerID: sellerList[index].seller_id,
                      storeDesc: sellerList[index].store_description,
                    )));
      },
    );
  }
}
