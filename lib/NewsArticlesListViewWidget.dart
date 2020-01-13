import 'package:flutter/material.dart';

import 'package:news_app/model/NewsArticle.dart';
import 'package:news_app/services/NewsApi.dart';
import 'package:news_app/services/NetworkUtil.dart';
import 'package:news_app/DetailScreen.dart';
import 'package:news_app/ShareDataStore.dart';

class NewsArticlesListViewWidget extends StatefulWidget
{
  String mainNewsSource;

  NewsArticlesListViewWidget(String newsSource)
  {
    mainNewsSource = newsSource;
  }

  @override
  State createState()
  {
    return new _NewsArticlesListViewState();
  }
}

class _NewsArticlesListViewState extends State<NewsArticlesListViewWidget>
{
  ShareDataStore _shareDataStore;

  List<NewsArticle> _articleList;

  List<String> _newsSourceList;

  TextEditingController _searchFieldEditController;

  NewsApi _newsApi;

  double _clearIconOpacity = 0.0;


  _NewsArticlesListViewState()
  {
    _searchFieldEditController = new TextEditingController();

    _shareDataStore = new ShareDataStore();

    _newsApi = new NewsApi();
  }

  @override
  Widget build(BuildContext context)
  {
    return _bodyWidget();
  }

  @override
  void initState()
  {
    _searchFieldEditController.addListener(_onSearchTextChange);

    _newsApi.getNewsArticles(widget.mainNewsSource).then( (List<NewsArticle> newsList)
    {
      _articleList = newsList;

      // Important to check for this flag...else
      // we get an error exception.
      //
      // Url: https://stackoverflow.com/questions/49340116/setstate-called-after-dispose
      if (this.mounted) {

        setState(()
        {});
      }
    });
  }

  Widget _getImgWidget(String url){

    return new Container(

      width: 95.0,

      height: 95.0,

      child: new Material(

        borderRadius: new BorderRadius.only(

            topLeft: const Radius.circular(6.0),
            bottomLeft: const Radius.circular(6.0)
        ),

        child: NetworkUtil.getNetworkImageWidget(url),
      ),
    );
  }

  Widget _getArticleWidget(NewsArticle article)
  {
    String dateTimeStr = DateTime.parse(article.publishedAt).toString();

    return new Expanded(

      child: new Container(

        margin: new EdgeInsets.all(10.0),

        child: new Column(

            crossAxisAlignment:CrossAxisAlignment.start,

            children: <Widget>[

              new Text(

                article.title,
                maxLines: 1,
                style: new TextStyle(fontWeight: FontWeight.bold),
              ),

              new Text (

                dateTimeStr,
                style: new TextStyle(
                    color: Colors.grey,
                    fontSize: 10.0
                ),
              ),

              new Container(

                margin: new EdgeInsets.only(top: 5.0),

                child: new Text(

                  article.description,
                  maxLines: 3,
                ),
              ),
            ]
        ),
      ),
    );
  }

  _onTapHandler(BuildContext context, NewsArticle article)
  {
    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => new DetailScreen(article)));
  }

  Widget _itemBuilder(BuildContext context, int index)
  {
    Widget image;
    Widget card;

    NewsArticle article;

    article = _articleList[index];

    image = _getImgWidget(article.urlToImage);

    card = new GestureDetector(

      onTap: () => _onTapHandler(context, article),

      child: new Card(

        child: new Container(

          padding: EdgeInsets.all(5.0),

          child: new Row(

            children: <Widget>[

              // Using the "Hero" widget just allow the fade out effect when
              // navigating to another screen. Right now causing some error
              // exception with duplicate "tag". Not a high priority...
              //new Hero(tag: article.url, child: image),
              image,

              _getArticleWidget(article),
            ],
          ),
        ),
      ),
    );

    return card;
  }

  void _onSearchTextChange()
  {
    if (_searchFieldEditController.text == '') {

      _clearIconOpacity = 0.0;
    }
    else {
      _clearIconOpacity = 1.0;
    }

    setState(() {
    });
  }

  void _clearSearch()
  {
    _searchFieldEditController.clear();

    _newsApi.getNewsArticles(widget.mainNewsSource).then( (List<NewsArticle> newsList) {

      _articleList = newsList;

      setState(()
      {});
    });
  }

  void _onSearchNews()
  {
    String search;

    search = _searchFieldEditController.text;

    _newsApi.searchNews(widget.mainNewsSource, search).then( (List<NewsArticle> newArticleList) {

      _articleList = newArticleList;

      setState(() {
      });
    });
  }

  Widget _searchWidget()
  {
    Widget searchWidget;

    searchWidget = new Container(

      child: new Row (

        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,

        children: <Widget>[

          new Expanded(

            flex: 5,

            child: new TextField(
              controller: _searchFieldEditController,
            ),
          ),

          new Expanded(

            child: new IconButton(

                icon: new Icon(Icons.search),
                onPressed: _onSearchNews
            ),
          ),

          new Expanded(

            child: new Opacity(

              opacity: _clearIconOpacity,

              child: new IconButton(

                  icon: new Icon(
                    Icons.clear,
                    color: Colors.grey,
                  ),

                  onPressed: _clearSearch
              ),
            ),
          ),
        ],
      ),
    );

    return searchWidget;
  }

  Widget _bodyWidget()
  {
    Widget screen;

    screen = new Container(

      padding: EdgeInsets.all(10.0),

      child: new Column(

        //mainAxisAlignment: MainAxisAlignment.start,

        children: <Widget>[

          _searchWidget(),

          new Expanded(

            child: new Container(

              padding: EdgeInsets.only(top: 10.0),

              child: new ListView.builder(

                itemBuilder: _itemBuilder,
                itemCount: (_articleList != null) ? _articleList.length : 0,
              ),
            ),
          ),
        ],
      ),
    );


    return screen;
  }
}