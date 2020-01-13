import 'package:flutter/material.dart';


class TheInheritedWidget extends InheritedWidget
{
  final NotifierState notifierState;
  //static NotifierState notifierState;

  TheInheritedWidget({Key key, @required Widget child, @required this.notifierState}) : super (key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget)
  {
    return true;
  }
}

// This widget purpose is to store the checked news list of sources the user have
// selected. It's a way for the child sub-node widget to access what the user
// have selected and for the listview child widget to render it's checkboxes
// accordingly.
class NewsSourceShareDataWidget extends StatefulWidget
{
  final Widget child;

  NewsSourceShareDataWidget({Key key, this.child}) : super (key: key);

  @override
  State createState()
  {
    return new NotifierState();
  }

  static NotifierState of(BuildContext context)
  {
    TheInheritedWidget theInheritedWidget = context.dependOnInheritedWidgetOfExactType<TheInheritedWidget>();

    return theInheritedWidget.notifierState;
  }

  static void subscribe(BuildContext context)
  {
    // When calling "inheritFromWidgetOfExactType()" internally the param widget's context
    // is subscribe to the notification of re-build when "setState()" is called
    // on this widget state's object.
    TheInheritedWidget wid =  context.dependOnInheritedWidgetOfExactType<TheInheritedWidget>();

    if (wid != null) {
      print("PS: subscribe success!");
    }
  }

  static void rebuild(BuildContext context)
  {
    TheInheritedWidget theWidget = (context.inheritFromWidgetOfExactType(TheInheritedWidget) as TheInheritedWidget);

    if (theWidget == null) {
      print ("PS: theWidget is null!");
    }
    else {
      print ("PS: theWidget is not null!");

      if (theWidget.notifierState == null) {
        print ("PS: theWidget.notifierState is null!");
      }
    }

    theWidget.notifierState.setState((){
    });
  }
}

class NotifierState extends State<NewsSourceShareDataWidget>
{
  List<String> checkedNewsSourceList;

  @override
  Widget build(BuildContext context)
  {
    return new TheInheritedWidget(child: widget.child, notifierState: this);
  }
}