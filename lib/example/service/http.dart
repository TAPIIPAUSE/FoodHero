import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:foodhero/example/model/product_model.dart';

class Http {
  static String baseurl = "http://192.168.182.61/api/";

  // post
  static postProduct(Map pdata) async {
    try {
      final res =
          await http.post(Uri.parse("${baseurl}add_product"), body: pdata);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body.toString());
        print(data);
      } else {
        print("Failed to load data");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // get
  static getProduct() async {
    List<Product> product = [];
    try {
      final res = await http.get(Uri.parse("${baseurl}get_product"));

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);

        data['product'].forEach((value) => {
              product.add(
                Product(
                  value['id'].toString(),
                  value['name'],
                  value['price'],
                  value['desc'],
                ),
              )
            });
        return product;
      } else {
        return [];
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // put update
  static putProduct(id, body) async {
    try {
      final res =
          await http.put(Uri.parse("${baseurl}put_product/$id"), body: body);
      if (res.statusCode == 200) {
        print(jsonDecode(res.body));
      } else {
        print("failed to update data");
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
