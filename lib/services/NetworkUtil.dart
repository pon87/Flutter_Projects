import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NetworkUtil
{
  static Widget getNetworkImageWidget(String url)
  {
    Widget imgWidget;

    try {
      bool isValid;

      isValid = _isValidUrl(url);

      if (isValid) {

        imgWidget = new FadeInImage.assetNetwork(

          placeholder: 'assets/place_holder.jpg',

          image: url,

          fit: BoxFit.cover,);
      }
      else {
        imgWidget = new Image.asset('assets/place_holder.jpg');
      }
    }
    catch(err){
      imgWidget = new Image.asset('assets/place_holder.jpg');
    }
    return imgWidget;
  }

  static bool _isValidUrl(String url)
  {
    bool isValid;
    bool bTemp;

    int index = url.indexOf("file");
    isValid = (index >= 0) ? false : true;

    index = url.indexOf("http");
    bTemp = (index < 0) ? false : true;
    isValid = bTemp && isValid;

    index = url.indexOf("https");
    bTemp = (index < 0) ? false : true;
    isValid = bTemp && isValid;

    return isValid;
  }
}