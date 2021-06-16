import 'package:gitpodflutter/models/article_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//Service class can be expanded on if needed
class SpaceFlightService {
  static Future<List<ArticleModel>> fetch() async {
    var response = await http.get(
        Uri.parse('https://api.spaceflightnewsapi.net/v3/articles?_limit=50'));
    print(response.statusCode);
    if (response.statusCode == 200) {
      List listOfArticles = jsonDecode(response.body);

      return listOfArticles
          .map((article) => ArticleModel.fromJson(article))
          .toList();
    } else {
      return [];
    }
  }
}
