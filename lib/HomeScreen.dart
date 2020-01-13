import 'package:flutter/material.dart';

import 'package:news_app/model/NewsArticle.dart';
import 'package:news_app/services/NewsApi.dart';
import 'package:news_app/NewsSourcesScreen.dart';
import 'package:news_app/ShareDataStore.dart';
import 'package:news_app/NewsArticlesListViewWidget.dart';
import 'package:news_app/NewsSourceShareDataWidget.dart';


class HomeScreen extends StatefulWidget
{
  @override
  State createState()
  {
    return new HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin
{
  TabController _tabController;

  ShareDataStore _shareDataStore;

  NewsApi _newsApi;

  List<NewsArticle> _articleList;

  List<String> _newsSourceList;

  HomeScreenState()
  {
    _newsApi = new NewsApi();

    _newsSourceList = new List<String>();

    _shareDataStore = new ShareDataStore();
  }

  _onSettingsMenuHandler(BuildContext context) async
  {
    await Navigator.push(context, new MaterialPageRoute(builder: (context) {

      return new NewsSourcesScreen();
    }));

    _shareDataStore.getNewsSources().then( (List<String> sourceList) {

      _newsSourceList = sourceList;

      // Important to instantiate the new "TabController" which manages the tabs to
      // be in sync with the news sources the user may have selected.
      _tabController = new TabController(length: _newsSourceList.length, vsync: this);

      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context)
  {
    Widget screen;

    screen = _mainScreenWidget();
    return screen;
  }

  Widget _mainScreenWidget()
  {
    Widget screen;

    screen = new Scaffold(

      appBar: new AppBar(

        title: new Text("News"),

        actions: <Widget>[

          new PopupMenuButton(

            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[

              new PopupMenuItem <String>(
                child: const Text("Settings"),
                value: "Settings",
              )
            ],

            onSelected: (String selectedItem) => _onSettingsMenuHandler(context),
          )
        ],

        bottom: _tabBarWidget(),
      ),

      body: TabBarView(

        controller: _tabController,

        children: _tabViewWidget(),
      ),
    );

    return screen;
  }

  Widget _tabBarWidget()
  {
    Widget tabBar;

    List<Widget> tabList;

    tabList = new List<Widget>();

    for (int i = 0; i < _newsSourceList.length; ++i) {

      tabList.add(new Tab(text: _newsSourceList[i]));
    }

    tabBar = new TabBar(

      tabs: tabList,

      controller: _tabController,
    );
    return tabBar;
  }

  List<Widget> _tabViewWidget()
  {
    List<Widget> tabViewList;

    String newsSource;

    tabViewList = new List<Widget>();

    for (int i = 0; i < _newsSourceList.length; ++i) {

      newsSource = _newsSourceList[i];

      tabViewList.add(new NewsArticlesListViewWidget(newsSource));
    }

    return tabViewList;
  }


  @override
  void initState()
  {
    _tabController = new TabController(vsync: this, length: _newsSourceList.length);

    _shareDataStore.getNewsSources().then( (List<String> sourceList) {

      _newsSourceList = sourceList;

      // Important to instantiate the new "TabController" which manages the tabs to
      // be in sync with the news sources the user may have selected.
      _tabController = new TabController(vsync: this, length: _newsSourceList.length);

      setState( (){
      });
    });
  }


}