import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import 'package:mighty_news/components/CategoryItemWidget.dart';
import 'package:mighty_news/models/CategoryData.dart';
import 'package:mighty_news/network/RestApis.dart';
import 'package:mighty_news/screens/SubCategoryScreen.dart';
import 'package:mighty_news/shimmer/TopicShimmer.dart';
import 'package:mighty_news/utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../AppLocalizations.dart';

class CategoryFragment extends StatefulWidget {
  static String tag = '/CategoryScreen';

  @override
  CategoryFragmentState createState() => CategoryFragmentState();
}

class CategoryFragmentState extends State<CategoryFragment> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

 
  List<CategoryData> getInitialData() {
    List<CategoryData> list = [];
    String s = getStringAsync(CATEGORY_DATA);

    if (s.isNotEmpty) {
      Iterable it = jsonDecode(s);
      list.addAll(it.map((e) => CategoryData.fromJson(e)).toList());
    }

    return list;
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WebView(
          initialUrl: 'https://player.twitch.tv/?channel=nffonline&parent=www.thenff.com',
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          javascriptChannels: <JavascriptChannel>{
            _toasterJavascriptChannel(context),
          },
   
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
        )
      );
      
    
    
  }
   JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

}
