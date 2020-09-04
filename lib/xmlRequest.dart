import 'package:http/http.dart' as http;
import 'dart:convert';

class XmlRequest {
  static String url = 'https://nawi.li/PHP/main.php';

  static Future<Map<String, dynamic>> createPost(Map body) async {
    return http.post(url, body: body).then((http.Response response) {
      final int statusCode = response.statusCode;

      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return jsonDecode(response.body);
    });
  }
}
