import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:news_app/model/NewsSource.dart';
import 'package:news_app/model/NewsArticle.dart';


class NewsApi
{
  final String _baseUrl = "https://newsapi.org/v2";
  final String _apiKey = "";

  Future<List<NewsArticle>> _getNewsArticlesUtil(String url) async
  {
    List<NewsArticle> articleList;

    http.Response httpResp;

    Map<String, String> httpHeaders;

    String jsonStr;

    try {
      httpHeaders = _httpHeaders();

      httpResp = await http.get(url, headers: httpHeaders);
      if (httpResp.statusCode == 200)
      {
        jsonStr = httpResp.body;

        var data = json.decode(jsonStr);

        List<dynamic> jsonData;

        jsonData = data["articles"] as List<dynamic>;

        articleList = jsonData.map((jsonArticle) => NewsArticle.fromJson(jsonArticle)).toList();
      }
    }
    on Exception {
    }

    return articleList;
  }

  Future<List<NewsArticle>> searchNews(String newsSource, String searchText) async
  {
    List<NewsArticle> articleList;

    String url;

    try {

      url = Uri.encodeFull("$_baseUrl/everything?q=${searchText}&sources=${newsSource}");

      articleList = await _getNewsArticlesUtil(url);
    }
    on Exception {
    }
    return articleList;
  }

  Future<List<NewsArticle>> getNewsArticles(@required String newsSources) async
  {
    List<NewsArticle> listArticles = null;

    Map<String, String> httpHeaders;

    http.Response httpResp;

    String jsonStr = "";

    String url;

    try {
      //url = Uri.encodeFull("${_baseUrl}/top-headlines?sources=$newsSources");
      url = Uri.encodeFull("${_baseUrl}/everything?sources=$newsSources");

      listArticles = await _getNewsArticlesUtil(url);
    }
    on Exception {
    }

    return listArticles;
  }

  Future<List<NewsSource>> getNewsSource() async
  {
    http.Response httpResp;

    List<NewsSource> newsSourceList = null;

    String url;

    try {
      url = Uri.encodeFull("${_baseUrl}/sources");

      httpResp = await http.get(url, headers: _httpHeaders());
      if (httpResp.statusCode == 200) {

        var data = json.decode(httpResp.body);

        List<dynamic> jsonData = (data["sources"] as List<dynamic>);

        newsSourceList = jsonData.map( (jsonSource) => NewsSource.fromJson(jsonSource) ).toList();
      }
    }
    on Exception {
    }

    return newsSourceList;
  }

  Map<String, String> _httpHeaders()
  {
    return {
      "Accept": "application/json",
      "X-Api-Key": _apiKey,
    };
  }
}