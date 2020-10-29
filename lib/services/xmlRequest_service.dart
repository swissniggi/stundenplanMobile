import 'dart:convert';

import 'package:NAWI/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../providers/security_provider.dart';

class XmlRequestService {
  static String url = 'https://nawi.li/PHP/main.php';

  static Future<Map<String, dynamic>> createPost(Map body, BuildContext ctx,
      {bool withToken = true}) async {
    body['app'] = 'mobile';

    if (withToken) {
      body['securityToken'] =
          Provider.of<SecurityProvider>(ctx, listen: false).securityToken;
    }

    String username = Provider.of<UserProvider>(ctx, listen: false).username;

    if (username != null) {
      body['username'] = username;
    }

    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return json.decode(response.body);
    });
  }
}
