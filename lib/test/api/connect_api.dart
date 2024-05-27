import 'dart:convert';

import 'package:Camera/test/api/user_mode.dart';
import 'package:http/http.dart' as http;

class Api {
  List<UserModel> _dataUser = [];
  List<UserModel> get dataUser => _dataUser;

  Future<void> getApi() async {
    var url = Uri.parse("https://api.mockapi.com/api/v1/users");
    var response = await http.get(
      url,
      headers: {"x-api-key": "aee6c4c74abf40f9ad4a3e5e4572b479"},
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      // List<Map<String, dynamic>> jsonData = jsonDecode(response.body);
      _dataUser = jsonDecode(response.body)
          .map((json) => UserModel.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load data');
    }
  }
}
