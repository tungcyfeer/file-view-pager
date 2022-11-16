import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:photo_view/photo_view.dart';
import 'extension.dart';

class PageViewAttachment extends StatefulWidget {
  final List<String> listAttachment;
  final int initPosition;
  final Function(int position) onPageChanged;

  PageViewAttachment(
      {required this.listAttachment,
      required this.initPosition,
      required this.onPageChanged});

  @override
  _PageViewAttachmentState createState() => _PageViewAttachmentState();
}

class _PageViewAttachmentState extends State<PageViewAttachment> {
  bool _isLock = false;
  late PageController _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController(initialPage: widget.initPosition);
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      children: listPage(),
      physics: _isLock ? const NeverScrollableScrollPhysics() : null,
      onPageChanged: widget.onPageChanged,
      controller: _pageController,
    );
    // return PageView.builder(
    //   itemBuilder: (context, index) =>
    //       _buildItem(widget.listAttachment[index], index),
    //   itemCount: widget.listAttachment.length,
    //   physics:
    //   _isLock ? const NeverScrollableScrollPhysics() : null,
    //   onPageChanged: widget.onPageChanged,
    //   controller: _pageController,
    // );
  }

  List<Widget> listPage() {
    return widget.listAttachment
        .map((e) => PageItem(
              url: e,
              callback: (scaleState) {
                scaleStateChangedCallback(scaleState);
              },
            ))
        .toList();
  }

  // List<Widget> listPage() {
  //   return widget.listAttachment.map((e) => _buildItem(e)).toList();
  // }

  // Widget _buildItem(String url) {
  //   if (url.isImage) {
  //     return PhotoView(
  //         imageProvider: NetworkImage(url),
  //         minScale: PhotoViewComputedScale.contained,
  //         initialScale: PhotoViewComputedScale.contained * 0.9,
  //         scaleStateChangedCallback: scaleStateChangedCallback);
  //   } else {
  //     // return WebView(
  //     //   initialUrl: "https://docs.google.com/gview?embedded=true&url=" + url,
  //     // );
  //     return getWebViewInApp(
  //         "https://docs.google.com/gview?embedded=true&url=" + url);
  //   }
  // }

  void scaleStateChangedCallback(PhotoViewScaleState scaleState) {
    setState(() {
      // _isLock = (scaleState == PhotoViewScaleState.initial ||
      //         scaleState == PhotoViewScaleState.zoomedOut)
      //     ? false
      //     : true;

      _isLock = (scaleState == PhotoViewScaleState.zoomedIn) ? true : false;
    });
  }
}

class PageItem extends StatefulWidget {
  final String url;
  final Function(PhotoViewScaleState scaleState) callback;

  const PageItem({Key? key, required this.url, required this.callback})
      : super(key: key);

  @override
  _PageItemState createState() => _PageItemState();
}

class _PageItemState extends State<PageItem>
    with AutomaticKeepAliveClientMixin<PageItem> {
  late InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useWideViewPort: false,
        domStorageEnabled: true,
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (widget.url.isImage) {
      return PhotoView(
          imageProvider: NetworkImage(widget.url),
          minScale: PhotoViewComputedScale.contained,
          initialScale: PhotoViewComputedScale.contained * 0.9,
          scaleStateChangedCallback: widget.callback);
    }
    if (widget.url.isFileDriver) {
      return getWebViewInApp(
          "https://docs.google.com/gview?embedded=true&url=" + widget.url);
    }

    return getOtherFilePage(widget.url);
  }

  Widget getWebViewInApp(String url) {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: Uri.parse(url)),
      initialOptions: options,
      onWebViewCreated: (controller) {
        webViewController = controller;
      },
      androidOnPermissionRequest: (controller, origin, resources) async {
        return PermissionRequestResponse(
            resources: resources,
            action: PermissionRequestResponseAction.GRANT);
      },
      onConsoleMessage: (controller, consoleMessage) {
        print(consoleMessage);
      },
      onLoadStop: (controller, urlLoad) async {
        String title = (await controller.getTitle()) ?? "";
        if (title.isEmpty) {
          controller.loadUrl(urlRequest: URLRequest(url: Uri.parse(url)));
        }
        // if (controller.getTitle().)
        // webViewController.loadUrl(urlRequest: URLRequest(url: Uri.parse("javascript:(function() { " +
        //     "document.querySelector('[role=\"toolbar\"]').remove();})()")));
        // await webViewController.evaluateJavascript(source: "function() { " +
        // "document.getElementsByClassName('ndfHFb-c4YZDc-GSQQnc-LgbsSe ndfHFb-c4YZDc-to915-LgbsSe VIpgJd-TzA9Ye-eEGnhe ndfHFb-c4YZDc-LgbsSe')[0].style.display='none'; })()");
      },
    );
  }

  Widget getOtherFilePage(String url) {
    return Container(
      alignment: Alignment.center,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.file_copy,
              color: Colors.white,
              size: 60,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              url.extension.toUpperCase(),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
