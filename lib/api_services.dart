import 'dart:convert';
// import 'dart:html';

import 'package:http/http.dart' as http;

class ApiServices {
  String apikey = "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";
 static String baseUrl = "https://api.openai.com/v1/completions";

static  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization':
        'Bearer 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'
  };

  static sendMessege(String? messege) async {
    var res = await http.post(Uri.parse(baseUrl),
        headers: header,
        body: jsonEncode({
          "model": "text-davinci-003",
          "prompt": "$messege",
          "max_tokens": 100,
          "temperature": 0,
          "top_p": 1,
          "n": 1,
          "stream": false,
          "logprobs": null,
          "stop": [" Human:", " AI:"]
        }));

    if (res.statusCode == 200) {
      var data = jsonDecode(res.body.toString());
      var msg = data['choices'][0]['text'];
      return msg;
    } else {
      print("Failed");
    }
  }
}
