import 'dart:convert';

import 'package:catfact/model/fact_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FetchData with ChangeNotifier {
  final List<Fact> _facats = [];
  List<Fact> get fatcts {
    return _facats;
  }

  String imageUrlGenerator(int number) {
    return "https://placekitten.com/g/${number + 150}/$number";
  }

  Future<void> getFacts(String page) async {
    const baseUrl = "https://catfact.ninja/facts?page=";
    try {
      final url = Uri.parse(baseUrl + page);
      final response = await http.get(url);
      final body = jsonDecode(response.body);
      final resultFactsJson = body["data"];

      int counter = 100;
      resultFactsJson.forEach((element) {
        final factModel = Fact(counter, element["fact"],
            imageUrlGenerator(counter), element["length"]);
        _facats.add(factModel);
        counter++;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  notifyListeners();
}
