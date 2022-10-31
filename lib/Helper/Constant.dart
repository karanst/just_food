import 'package:shared_preferences/shared_preferences.dart';

final String appName = 'JustFoodz';

final String packageName = 'com.ente_market';
final String androidLink = 'https://play.google.com/store/apps/details?id=';

final String iosPackage = 'com.ente_market';
final String iosLink = 'your ios link here';
final String appStoreId = '123456789';

final String deepLinkUrlPrefix = 'https://alpha.ecommerce.link';
final String deepLinkName = 'alpha.ecommerce.link';

final int timeOut = 50;
const int perPage = 10;

// String razorPayKey="rzp_test_UUBtmcArqOLqIY";
// String razorPaySecret="NTW3MUbXOtcwUrz5a4YCshqk";

String razorPayKey="rzp_test_K7iUQiyMNy1FIT";
String razorPaySecret="Bb03yFC5dGa9lXTtLnF3qkXQ";
//final String baseUrl = 'https://alphawizztest.tk/ENTEMARKET/app/v1/api/';
final String baseUrl = 'https://alphawizztest.tk/justfoodz/app/v1/api/';
final String imageBase = "https://alphawizztest.tk/justfoodz/";
final String jwtKey = "78084f1698c9fcff5a668b68dcd103db39be2605";
class App {
  static late SharedPreferences localStorage;
  static Future init() async {
    localStorage = await SharedPreferences.getInstance();
  }
}