import 'package:flutter/material.dart';

import 'package:news_app/model/NewsSource.dart';


class AppShareDataWidget extends StatefulWidget
{
  final Widget childWidget;

  final List<NewsSource> newsSourceList;

  AppShareDataWidget({Key key, @required this.childWidget, @required this.newsSourceList}) : super(key:key);

  @override
  State createState()
  {
    return new AppShareState();
  }
}

class AppShareState extends State<AppShareDataWidget>
{
  @override
  Widget build(BuildContext context)
  {
    return new _AppDataRegistry(childWidget: widget.childWidget, newsSourceList: widget.newsSourceList);
  }

  @override
  void dispose()
  {
    //widget.childWidget.close();
    super.dispose();
  }
}

class _AppDataRegistry extends InheritedWidget
{
  final List<NewsSource> newsSourceList;

  _AppDataRegistry({Key key, @required childWidget, @required this.newsSourceList}) : super (key: key, child: childWidget);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)
  {
    return false;
  }
}