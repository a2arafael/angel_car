import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:angel_car/ui/home/home_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String? title;
  final String? url;
  const WebViewScreen({Key? key, this.url, this.title}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  var isHttpError = false;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      overlayOpacity: 0.7,
      overlayColor: AppColors.black,
      useDefaultLoading: false,
      overlayWidget: const Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary)),
      ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(60.0),
            child: appBarDefault(
                widget.title ?? '',
                onPressed: widget.title == 'TELECONSULTA' ? () => Get.offAll(() => const HomeScreen()) : null
            )),
        body: isHttpError
            ? Center(
          child: Image.asset(
            'assets/images/ic_error.png',
            width: MediaQuery.of(context).size.width - 16,
          ),
        )
            : Stack(
          children: [
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.url,
              onPageFinished: (String value) {
                context.loaderOverlay.hide();
              },
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
                context.loaderOverlay.show();
                setState(() {
                  isHttpError = false;
                });
              },
              onWebResourceError: (error) {
                if (kDebugMode) {
                  print("Error Webview: ${error.description}");
                }
                context.loaderOverlay.hide();
                setState(() {
                  isHttpError = true;
                });
              },
            ),
          ],
        )
      ),
    );
  }
}
