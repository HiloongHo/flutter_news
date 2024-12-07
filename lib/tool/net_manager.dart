import 'dart:io';
import 'dart:convert';
import 'package:flutter_news/base/base.dart';
import 'package:flutter_news/model/home_model.dart';

import '../utils/log_util.dart';

class NetManager {
  Future<HomeModel> queryHomeData(int page, {String? path}) async {
    var httpClient = HttpClient();
    try {
      // Base parameters
      Map<String, String> params = {
        "key": URL_KEY,
        "num": "20",
        "page": "$page"
      };
      
      // Construct the path without double /index
      String apiPath = path ?? URL_HOME_DATA_PATH;
      if (!apiPath.endsWith('/index')) {
        apiPath = "$apiPath/index";
      }
      
      var uri = Uri.https(
        URL_DOMAIN, 
        apiPath,
        params
      );
      Log.i('NetManager', 'Request URL: $uri');
      
      var request = await httpClient.getUrl(uri);
      request.headers.add('Content-Type', 'application/json');
      
      var response = await request.close();
      var responseBody = await response.transform(utf8.decoder).join();
      Log.i('NetManager', 'Response status: ${response.statusCode}');
      Log.i('NetManager', 'Response body: $responseBody');
      
      if (response.statusCode == HttpStatus.ok) {
        var jsonData = json.decode(responseBody);
        
        // 验证 JSON 数据结构
        if (jsonData == null) {
          throw Exception('返回数据为空');
        }
        
        // 如果 API 返回错误信息
        if (jsonData['code'] != 200) {
          throw Exception('API错误: ${jsonData['msg']} (错误码: ${jsonData['code']})');
        }
        
        return HomeModel.fromJson(jsonData);
      } else {
        throw Exception('HTTP请求失败，状态码: ${response.statusCode}, 响应内容: $responseBody');
      }
    } catch (e) {
      Log.e('NetManager', '网络请求失败', e);
      throw Exception('网络请求失败: $e');
    } finally {
      httpClient.close();
    }
  }
}