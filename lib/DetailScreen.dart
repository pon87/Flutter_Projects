import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:async';

import 'package:news_app/model/NewsArticle.dart';
import 'package:news_app/services/NetworkUtil.dart';


class DetailScreen extends StatelessWidget
{
  final FlutterWebviewPlugin _webviewPlugin = new FlutterWebviewPlugin();

  NewsArticle _article;

  BuildContext _context;

  DetailScreen(NewsArticle article)
  {
    _article = article;
  }

  @override
  Widget build(BuildContext context)
  {
    Widget screenWidget;

    _context = context;

    screenWidget = new Scaffold(

      appBar: new AppBar(
        title: new Text(_article.title),
      ),

      body: _bodyWidget(),
    );

    return screenWidget;
  }



  Widget _bodyWidget()
  {
    Widget bodyWidget;

    bodyWidget = new Container(

      margin: EdgeInsets.all(10.0),
      child: new Material(
        elevation: 4.0,

        borderRadius: new BorderRadius.circular(6.0),

        child: new ListView(

          children: <Widget>[
            new Hero (

              tag: _article.title,

              child: new Container(

                height: 200.0,
                child: NetworkUtil.getNetworkImageWidget(_article.urlToImage),
              ),
            ),

            _bodyContentWidget()
          ],
        ),
      ),
    );

    return bodyWidget;
  }

  Widget _bodyContentWidget()
  {
    Widget content;

    content = new Container(
      margin: EdgeInsets.all(15.0),

      child: new Column (

        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[

          // Title
          new Text (

            _article.title,

            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0
            ),
          ),

          // Date
          new Container(

            margin: EdgeInsets.only(top: 4.0),
            child: new Row (

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[

                new Text(

                  _article.publishedAt,
                  style: new TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey
                  ),
                )
              ],
            ),
          ),

          // Description
          new Container (
            margin: EdgeInsets.only(top: 20.0),
            child: new Text (_article.description),
          ),

          // News Link
          new Container(

            margin: EdgeInsets.only(top: 30.0),

            child: new Text (
              "Detail News Link:",
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600]
              ),
            ),
          ),

          new GestureDetector(

            child: new Text (

              _article.url,
              style: new TextStyle(
                  color: Colors.blue
              ),
            ),

            onTap: () => _onTapHandler(_article.url),
          )
        ],
      ),
    );
    return content;
  }

  _onTapHandler(String url) async
  {
    print("PS: webview launch!");
    //_webviewPlugin.launch(url, withJavascript: false, rect: new Rect.fromLTWH(0.0, 0.0, MediaQuery.of(_context).size.width, 300.0));

    await launch(url);
  }
}