
import 'package:wall_clod/Helpers/errorHandling.dart';
import 'package:wall_clod/Models/responseModal.dart';
import 'package:wall_clod/Models/topic.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const apiKey = "S9NdAgRednOojzI_OwNCBZqUPsJi71AA7IsiF60MBok";
const apiUrl = 'https://api.unsplash.com/photos?client_id=$apiKey';
const mainUrl = 'https://api.unsplash.com';
const per_page = "per_page=30";

class FetchImages {
  Future getLatestImages(int pageNumber) async {
    http.Response response;
    String url =
        '$apiUrl&order_by=latest&orientation=portrait&&=15&$per_page&page=$pageNumber';
    response = await http.get(Uri.parse(url));

    List<UnPlashResponse> unPlashResponseList = [];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var i = 0; i < data.length; i++) {
        UnPlashResponse unPlashResponse = new UnPlashResponse.fromJson(data[i]);
        unPlashResponseList.add(unPlashResponse);
      }
      return unPlashResponseList;
    } else {
      return showError(response);
    }
  }

  Future getCategory(int pageNumber) async {
    String url = '$mainUrl/collections?client_id=$apiKey&$per_page&page=$pageNumber';
    http.Response response = await http.get(Uri.parse(url));

    List<Topics> topicsList = [];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var i = 0; i < data.length; i++) {
        Topics topics = new Topics.fromJson(data[i]);
        topicsList.add(topics);
      }
      return topicsList;
    } else {
      return showError(response);
    }
  }

  Future getTopicImage(int pageNumber, String topicId) async {
    String url =
        '$mainUrl/collections/$topicId/photos?client_id=$apiKey&$per_page&page=$pageNumber';
    http.Response response = await http.get(Uri.parse(url));

    List<UnPlashResponse> unPlashResponseList = [];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var i = 0; i < data.length; i++) {
        UnPlashResponse unPlashResponse = new UnPlashResponse.fromJson(data[i]);
        unPlashResponseList.add(unPlashResponse);
      }
      return unPlashResponseList;
    } else {
      return showError(response);
    }
  }

  Future getTrendingImages(int pageNumber) async {
    String url = '$apiUrl&order_by=popular&$per_page&page=$pageNumber';
    http.Response response = await http.get(Uri.parse(url));

    List<UnPlashResponse> unPlashResponseList = [];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      for (var i = 0; i < data.length; i++) {
        UnPlashResponse unPlashResponse = new UnPlashResponse.fromJson(data[i]);
        unPlashResponseList.add(unPlashResponse);
      }
      return unPlashResponseList;
    } else {
      return showError(response);
    }
  }

  Future getSearchedImages(int pageNumber, String query) async {
    String url =
        'https://api.unsplash.com/search/photos?client_id=$apiKey&$per_page&query=$query&page=$pageNumber';
    http.Response response = await http.get(Uri.parse(url));

    List<UnPlashResponse> unPlashResponseList = [];
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);

      for (var i = 0; i < data['results'].length; i++) {
        UnPlashResponse unPlashResponse =
        new UnPlashResponse.fromJson(data['results'][i]);
        unPlashResponseList.add(unPlashResponse);
      }
      return unPlashResponseList;
    } else {
      return showError(response);
    }
  }

  //Thor Error

  showError(
      http.Response response,
      ) {
    if (response.statusCode != 500) {
      return ErrorHandling().apiErrorHandling(response);
    }
  }
}