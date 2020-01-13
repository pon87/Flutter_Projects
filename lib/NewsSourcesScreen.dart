import 'package:flutter/material.dart';
import 'dart:async';

import 'package:news_app/services/NewsApi.dart';
import 'package:news_app/model/NewsSource.dart';
import 'package:news_app/ShareDataStore.dart';
import 'package:news_app/NewsSourceShareDataWidget.dart';


class NewsSourcesScreen extends StatefulWidget
{
  @override
  State createState()
  {
    return new NewsSourcesState();
  }
}

class NewsSourcesState extends State<NewsSourcesScreen>
{
  TextEditingController _filterSearchEditController;

  ShareDataStore _shareDatastore;

  List<NewsSource> _newsSourceList = null;
  List<NewsSource> _displayNewsSourceList = null;

  List<String> _checkedNewsSourceList;

  double _clearIconOpacity = 1.0;

  NewsApi _newsApi;

  // Use this key as a reference to get direct access to the child
  // listview widget's context.
  GlobalKey _listviewKey = new GlobalKey();


  NewsSourcesState()
  {
    _newsApi = new NewsApi();

    _shareDatastore = new ShareDataStore();

    _checkedNewsSourceList = new List<String>();

    _filterSearchEditController = new TextEditingController();
  }

  Future<bool> _onExitScreen(BuildContext context)
  {
    return showDialog(

        context: context,

        builder: (BuildContext theContext) => new AlertDialog(

          title: new Text("Warning"),

          content: new Text("Have not chose any sources, are you sure you want to exit?"),

          actions: <Widget>[

            new FlatButton(

              child: new Text("No"),

              onPressed: () => Navigator.of(context).pop(false),
            ),

            new FlatButton(

              child: new Text ("Yes"),

              onPressed: () => Navigator.pop(context) ,
            ),
          ],
        )
    );
  }

  _exitScreenAndSave(BuildContext context)
  {
    _shareDatastore.saveNewsSources(_checkedNewsSourceList).then( (bool isSuccess) {

      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context)
  {
    print("PS: NewsSourceState: build() called!");

    return _bodyWidget(context);
  }

  @override
  void initState()
  {
    print("PS: NewsSourceState: initState() called!");

    _filterSearchEditController.addListener(_filterNewsSourceSearch);
    _filterSearchEditController.clear();

    _newsApi.getNewsSource().then( (sourcesList) {

      _newsSourceList = sourcesList;

      _displayNewsSourceList = sourcesList;

      setState(() {
      });
    });

    _shareDatastore.getNewsSources().then( (List<String> newsSourceList) {

      String source;

      for (int i = 0; i < newsSourceList.length; ++i) {

        source = newsSourceList[i];
        _checkedNewsSourceList.add(source);
      }
    });
  }

  @override
  void dispose()
  {
    _filterSearchEditController.removeListener(_filterNewsSourceSearch);
  }

  void _filterNewsSourceSearch()
  {
    if (_filterSearchEditController.text == '')
    {
      setState(() {

        // Hide the clear icon button when text field is empty.
        _clearIconOpacity = 0.0;

        _displayNewsSourceList = _newsSourceList;
      });
    }
    else
    {
      List<NewsSource> filterNewsSource = _newsSourceList
          .where(
              (NewsSource source) => source.id.toLowerCase().contains(_filterSearchEditController.text.toLowerCase())
      )
          .toList();

      // Display the clear icon button when user enter text. Provide user friendly
      // usage to just clear the search text field whenever the user may want to
      // enter new search.
      _clearIconOpacity = 1.0;

      setState(() {
        _displayNewsSourceList = filterNewsSource;
      });
    }
  }

  void onItemCheckChange(ValueData data)
  {
    //print("PS: iteem checked clicked! name: ${data.newsSource.name}");

    (data.value) ? _checkedNewsSourceList.add(data.newsSource.id) : _checkedNewsSourceList.remove(data.newsSource.id);
  }

  void _onClearAllChecked(BuildContext context)
  {
    List<String> emptyList = new List<String>();

    _checkedNewsSourceList.clear();

    //NotifierWidget.of(context).reDrawAllWidget = true;
    //NotifierWidget.of(context).updateShouldNotify(oldWidget)

    // Clear the shared preferance...
    _shareDatastore.saveNewsSources(emptyList).then( (bool isSuccess) {

      NotifierState notifierState = _listviewKey.currentContext.ancestorStateOfType(const TypeMatcher<NotifierState>());

      notifierState.checkedNewsSourceList = emptyList;
      notifierState.setState(() {});
    });

    print("PS: clear all check box clicked!");

    // 9-7-2018
    // PS: Not sure why doing this way doesn't work...leave it for now.
//    TheInheritedWidget theInheritedWidget =  context.inheritFromWidgetOfExactType(TheInheritedWidget);
//    theInheritedWidget.notifierState.setState((){});
  }

  Widget _bodyWidget(BuildContext context)
  {
    Widget bodyWidget;

    bodyWidget = new Scaffold(

        appBar: new AppBar(

          title: new Text("News Sources"),

          // Setting this flag will remove the default back arrow and allow us to
          // manually handle it ourselves how we want to navigate back.
          automaticallyImplyLeading: false,

          // Adding the "Close" icon button to manually navigate back and return
          // result back.
          actions: <Widget>[

            new FlatButton (

              child: new Text(

                "Clear All",

                style: TextStyle(
                    color: Colors.white
                ),
              ),
              onPressed: () => _onClearAllChecked(context),
            ),

            new IconButton(

                icon: new Icon(Icons.close),

                onPressed: () => _exitScreenAndSave(context) //Navigator.pop(context, _checkedNewsSourceList)
            ),
          ],
        ),

        body:  new Container(

          padding: EdgeInsets.all(10.0),

          child: new Column(

            children: <Widget>[

              _searchFieldWidget(),

              new Expanded(
                  child: _listViewWidget()
              ),
            ],
          ),
        )
    );

    // Will cause application to crash...seems like can't have references to
    // widget objects that's being rendered to screen.
    //mainBodyWidget = bodyWidget;

    return bodyWidget;
  }

  void _clearSearchTextField()
  {
    _filterSearchEditController.clear();
  }

  Widget _searchFieldWidget()
  {
    Widget row;

    row = new Row(

      children: <Widget>[

        new Expanded(
            child: new TextField(

              decoration: new InputDecoration(
                  hintText: "Search"
              ),

              controller: _filterSearchEditController,
            )
        ),

        new Opacity(
          opacity: _clearIconOpacity,

          child: new IconButton(

              icon: new Icon(Icons.clear),

              onPressed: _clearSearchTextField
          ),
        )
      ],
    );
    return row;
  }

  Widget _listViewWidget()
  {
    Widget listView;

    listView = new NewsSourceShareDataWidget(

      child: new ListView.builder(

        key: _listviewKey,

        itemBuilder: (BuildContext context, int index) {

          Widget listViewItem;

          if (_displayNewsSourceList == null) {

            listViewItem = new Text("Empty");
          }
          else {
            listViewItem = new ListViewItemWidget( _displayNewsSourceList[index], onItemCheckChange, key: _listviewKey);
          }

          return listViewItem;
        },

        itemCount: (_displayNewsSourceList != null) ? _displayNewsSourceList.length : 0,
      ),
    );

    return listView;
  }
}

class ValueData
{
  bool value;

  NewsSource newsSource;
}

class ListViewItemWidget extends StatefulWidget
{
  NewsSource newsSource;

  String title;

  final ValueChanged<ValueData> onChangeCallback;

  // Constructor
  ListViewItemWidget(this.newsSource, this.onChangeCallback, {Key key});

  @override
  State createState()
  {
    return new _ListViewItemState();
  }
}

class _ListViewItemState extends State<ListViewItemWidget>
{
  ShareDataStore _dataStore;

  _ListViewItemState()
  {
    _dataStore = new ShareDataStore();
  }

  void _onCheckBoxChange(BuildContext context, bool newValue)
  {
    print ("PS: checkbox clicked. New value => ${newValue}");

    if (newValue) {

      NewsSourceShareDataWidget
          .of(context)
          .checkedNewsSourceList.add(widget.newsSource.id);
    }
    else {
      NewsSourceShareDataWidget
          .of(context)
          .checkedNewsSourceList.remove(widget.newsSource.id);
    }

    setState(() {
    });

    ValueData data;

    data = new ValueData();
    data.value = newValue;
    data.newsSource = widget.newsSource;

    // Callback to parent widget to allow to handle the event.
    widget.onChangeCallback (data);
  }

  @override
  Widget build(BuildContext context)
  {
    List<String> checkedNewsSourceStrList;

    Widget listViewItemWidget;

    bool checkboxValue = false;

    print("PS: _ListViewItemState: build() called!");

    checkedNewsSourceStrList = NewsSourceShareDataWidget.of(context).checkedNewsSourceList;

    if (checkedNewsSourceStrList != null) {

      String source;

      for (int j = 0; j < checkedNewsSourceStrList.length; ++j) {

        source = checkedNewsSourceStrList[j];
        print ("PS: checked news source => ${source}");
      }

      for (int i = 0; i < checkedNewsSourceStrList.length; ++i) {

        source = checkedNewsSourceStrList[i];
        if (widget.newsSource.id == source) {
          checkboxValue = true;
          break;
        }
      }
    }

    listViewItemWidget = new ListTile (

      leading: new Checkbox(

          value: checkboxValue,
          onChanged: (bool newValue) => _onCheckBoxChange(context, newValue)
      ),

      title: new Text(widget.newsSource.name),
    );
    return listViewItemWidget;
  }

  @override
  void initState()
  {
    print("PS: _ListViewItemState: initState() called! newSource => ${widget.newsSource.id}");

    _dataStore.getNewsSources().then((List<String> newsSourceList) {

      // 9-8-2018
      // This will be set when this widget is attached to a context object.
      if (this.mounted) {

        NewsSourceShareDataWidget.of(this.context).checkedNewsSourceList = newsSourceList;

        setState(() {
        });
      }
    });
  }
}