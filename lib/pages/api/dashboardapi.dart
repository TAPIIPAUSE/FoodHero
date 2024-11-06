import 'package:dio/dio.dart';
import 'package:foodhero/models/chart/bar/hhbar_model.dart';
import 'package:foodhero/models/chart/bar/orgbar_model.dart';
import 'package:foodhero/models/chart/expensepie/hhexpensepie_model.dart';
import 'package:foodhero/models/chart/expensepie/orgexpensepie_model.dart';
import 'package:foodhero/models/chart/heatmap/hhheatmap_model.dart';
import 'package:foodhero/models/chart/heatmap/orgheatmap_model.dart';
import 'package:foodhero/models/chart/savetypepie/hhfoodtypepie_model.dart';
import 'package:foodhero/models/chart/savetypepie/interorgfoodtypepie_model.dart';
import 'package:foodhero/models/chart/savetypepie/orgfoodtypepie_model.dart';
import 'package:foodhero/models/chart/wastepie/hhwastepie_model.dart';
import 'package:foodhero/models/chart/wastepie/interorgwastepie_model.dart';
import 'package:foodhero/models/chart/wastepie/orgwastepie_model.dart';
import 'package:foodhero/models/chart/wastetypepie/hhwastetypepie_model.dart';
import 'package:foodhero/models/chart/wastetypepie/orgwastetypepie_model.dart';
import 'package:foodhero/models/score/housescore_model.dart';
import 'package:foodhero/models/score/interscore_model.dart';
import 'package:foodhero/models/score/orgscore_model.dart';
import 'package:foodhero/pages/api/ApiClient.dart';
import 'package:foodhero/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardApi {
  final Dio dio = Dio();
  final String baseurl = '$myip/api/v1/dashboard';
  final authService = AuthService();

  // get house score
  Future<HouseScore> getHouseScore() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/score',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===HouseScore===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HouseScore.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch house score: ${e.toString()}');
    }
  }

  // get inter score
  Future<InterScore> getInterScore() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/inter_organization/score',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===Inter Score===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return InterScore.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch inter score: ${e.toString()}');
    }
  }

  // get org score
  Future<OrgScore> getOrgScore() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/organization/score',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===Org Score===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgScore.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch org score: ${e.toString()}');
    }
  }

  // get hh waste pie data
  Future<HouseholdFoodWastePieData> getHHWastePie() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/visualization/fs-pie-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===HH waste pie===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HouseholdFoodWastePieData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH waste pie: ${e.toString()}');
    }
  }

  // get org waste pie data
  Future<OrgFoodWastePieData> getOrgWastePie() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/organization/visualization/fs-pie-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
        // queryParameters: {'hID': hID},
      );

      print("===Org waste pie===");
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgFoodWastePieData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org waste pie: ${e.toString()}');
    }
  }

  // ! get inter org waste pie data ???
  // Future<InterFoodWastePieData> getInterWastePie() async {
  //   try {
  //     print("===Inter Org waste pie===");
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final token = prefs.getString('user_token');
  //     // print('token: $token');

  //     final res = await dio.get(
  //       '$baseurl/inter_organization/fs-pie-chart',
  //       options: Options(
  //         headers: {
  //           'Content-Type': 'application/json',
  //           'Authorization': 'Bearer $token',
  //         },
  //       ),
  //       // queryParameters: {'hID': hID},
  //     );

  //     print("Response status: ${res.statusCode}");
  //     print("Response body: ${res.data}");

  //     if (res.statusCode == 200) {
  //       final Map<String, dynamic> data = res.data;
  //       return InterFoodWastePieData.fromJson(data);
  //     } else {
  //       throw Exception('Invalid response format: ${res.data.runtimeType}');
  //     }
  //   } catch (e) {
  //     print('Error: $e');
  //     throw Exception('Failed to fetch Inter Org waste pie: ${e.toString()}');
  //   }
  // }

  // get food type pie for inter org
  Future<InterOrgFoodTypePie> getInterOrgFoodTypePie() async {
    try {
      print("===Org food type pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/inter_organization/foodtype_pie_chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return InterOrgFoodTypePie.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception(
          'Failed to fetch Inter Org food type pie: ${e.toString()}');
    }
  }

  // get food type pie for hh
  Future<HHFoodTypePie> getHHFoodTypePie() async {
    try {
      print("===HH food type pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/foodtype_pie_chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HHFoodTypePie.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH food type pie: ${e.toString()}');
    }
  }

  // get food type pie for org
  Future<OrgFoodTypePie> getOrgFoodTypePie() async {
    try {
      print("===Org food type pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/organization/foodtype_pie_chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgFoodTypePie.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org food type pie: ${e.toString()}');
    }
  }

  // waste food by type pie
  Future<HHWasteTypePie> getHHWasteTypePie() async {
    try {
      print("===HH waste type pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/visualization/foodtype_pie_chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HHWasteTypePie.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH waste type pie: ${e.toString()}');
    }
  }

  Future<OrgWasteTypePie> getOrgWasteTypePie() async {
    try {
      print("===Org waste type pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("user_token");
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/organization/visualization/foodtype_pie_chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgWasteTypePie.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org waste type pie: ${e.toString()}');
    }
  }

  // get hh expense pie data
  Future<HHExpensePieData> getHHExpensePie() async {
    try {
      print("===HH expense pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/visualization/fe-pie-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HHExpensePieData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH expense pie: ${e.toString()}');
    }
  }

  // get org expense pie data
  Future<OrgExpensePieData> getOrgExpensePie() async {
    try {
      print("===Org expense pie===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/organization/visualization/fe-pie-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgExpensePieData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org expense pie: ${e.toString()}');
    }
  }

  // get hh bar chart
  Future<HouseholdFoodSaved> getHHBar() async {
    try {
      print("===HH bar===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');

      final res = await dio.get(
        '$baseurl/household/visualization/fs-bar-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HouseholdFoodSaved.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH bar: ${e.toString()}');
    }
  }

  // get org bar chart
  Future<OrgFoodSaved> getOrgBar() async {
    try {
      print("===Org bar===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');
      final res = await dio.get(
        '$baseurl/organization/visualization/fs-bar-chart',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgFoodSaved.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org bar: ${e.toString()}');
    }
  }

  // hh heatmap
  Future<HouseholdHeatmapData> getHHHeatmap() async {
    try {
      print("===HH heatmap===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');
      final res = await dio.get(
        '$baseurl/household/visualization/heatmap',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return HouseholdHeatmapData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch HH heatmap: ${e.toString()}');
    }
  }

  // org heatmap
  Future<OrgHeatmapData> getOrgHeatmap() async {
    try {
      print("===Org heatmap===");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('user_token');
      // print('token: $token');
      final res = await dio.get(
        '$baseurl/organization/visualization/heatmap',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Response status: ${res.statusCode}");
      print("Response body: ${res.data}");

      if (res.statusCode == 200) {
        final Map<String, dynamic> data = res.data;
        return OrgHeatmapData.fromJson(data);
      } else {
        throw Exception('Invalid response format: ${res.data.runtimeType}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch Org heatmap: ${e.toString()}');
    }
  }
}
