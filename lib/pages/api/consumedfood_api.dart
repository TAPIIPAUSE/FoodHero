import 'dart:convert';
import 'package:foodhero/models/consumedfood_model.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:http/http.dart' as http;

class ConsumedFood {
  static String baseurl = "http://$myip:3000/api/v1/consume/";
// http://localhost:3000/api/v1/consume/showConsumedFood
  //get
  static Future<List<Consumedfood>> getConsumedfood() async {
    try {
      final res = await http
          .get(Uri.parse("http://$myip:3000/api/v1/consume/showConsumedFood"));

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        return (data as List)
            .map((item) => Consumedfood.fromJson(item))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }
}
