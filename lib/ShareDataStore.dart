import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:convert';

import 'package:news_app/services/NewsApi.dart';

class ShareDataStore
{
  static const String _sourceKey = "news_source_key";

  SharedPreferences _sharePreference;

  NewsApi newsApi;

  List<String> _newsSources;


  ShareDataStore()
  {
    _init();
  }

  _init() async
  {
    _sharePreference = await SharedPreferences.getInstance();
  }

  _loadSavedNewsSources() async
  {
    String jsonSources;

    if (_sharePreference == null) {
      await _init();
    }
    else {
      jsonSources = _sharePreference.getString(_sourceKey);
      if (jsonSources != null) {

        //print("PS: JSON Source => ${jsonSources}");

        _newsSources = json.decode(jsonSources).cast<String>();
        if (_newsSources.isNotEmpty)
          return;
      }
    }

    // No news sources have been saved by user yet so just load the default news
    // sources
    _newsSources = ["abc-news"];

    saveNewsSources(_newsSources);
  }

  Future<List<String>> getNewsSources() async
  {
    await _loadSavedNewsSources();

    return _newsSources;
  }

  Future<bool> saveNewsSources(List<String> sourceList) async
  {
    if (_sharePreference == null) {
      await _init();
    }

    //print("PS: News Source saved!");
    return _sharePreference.setString(_sourceKey, jsonEncode(sourceList));
  }

  void updateNewsSources(String newsSource, bool isActive)
  {
    if (isActive && !_newsSources.contains(newsSource)) {
      _newsSources.add(newsSource);
    }
    else {
      _newsSources.remove(newsSource);
    }

    saveNewsSources(_newsSources);
  }

  String getUrlFormattedNewsSources(List<String> sourcesList)
  {
    String urlStr = "";

    sourcesList.forEach((source) {
      urlStr += "$source,";
    });

    if (urlStr.endsWith(",")) {
      urlStr = urlStr.substring(0, urlStr.length - 1);
    }
    return urlStr;
  }
}