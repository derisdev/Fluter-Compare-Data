import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class FetchDatacsv {


  Future storeData(List<Map> datacsv) async {

    final listData = json.encode(datacsv);

    print(listData);

    String baseUrl =
        "https://preprocess-app.herokuapp.com/preprocess-all";
    var response = await http.post(baseUrl,
        headers: {"Accept": "application/json"},
        body: {listData});

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 201) {
      final jsonData = json.decode(response.body);

      return jsonData['data'];
    }

    else if (response.statusCode == 404) {
      showToast('Data tidak ditemukan');
      return false;
    }

    else {
      showToast('Terjadi kesalahan');
      return false;
    }
  }

  Future getDatacsv() async {

    String baseUrl =
        "https://preprocess-app.herokuapp.com/preprocess-all";
    var response = await http.get(baseUrl,
        headers: {"Accept": "application/json"});

    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return jsonData['data'];
    }

    else if (response.statusCode == 404) {
      showToast('Data tidak ditemukan');
      return false;
    }

    else {
      showToast('Terjadi kesalahan');
      return false;
    }
  }


}



showToast(String text) {
  Fluttertoast.showToast(
      msg:
      text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      fontSize: 14.0,
      backgroundColor: Colors.grey,
      textColor: Colors.white);
}
