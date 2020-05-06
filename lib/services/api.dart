import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Api {

  int statusCode;
  Map mapResult;
  BuildContext context;

  Api(this.context);

  Future<Map> getJsonFromServer(String url, Map<String,dynamic> params) async {
    Map<String,dynamic> map = {
      'api_key': "xz]nNQz%mX+g<*Rd,*eA4'0w~EYs9N",
    };
    //print("params -- ${params}");
    if (params != null) {
      map.addAll(params);
    }

    try{
      FormData formData = new FormData.fromMap(map);
      final response = await Dio().post(url, data: formData);
      this.statusCode = response.statusCode;
      if (response.statusCode == 200) {
          //print(response.data.toString());
          mapResult = response.data;
          //print(mapResult['NOTIFYGROUP']);
      }
    }
    catch(e){
      print(e);
    }

    return mapResult;
  }

}