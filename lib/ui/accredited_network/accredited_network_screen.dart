import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:get/get.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AccreditedNetworkScreen extends StatefulWidget {
  const AccreditedNetworkScreen({Key? key}) : super(key: key);

  @override
  _AccreditedNetworkScreenState createState() => _AccreditedNetworkScreenState();
}

class _AccreditedNetworkScreenState extends State<AccreditedNetworkScreen> {
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  var isHttpError = false;

  @override
  void initState() {
    if (GetPlatform.isAndroid) WebView.platform = AndroidWebView();
    super.initState();
  }

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
            child: appBarDefault('REDE CREDENCIADA')),
        body: isHttpError
            ? Center(
          child: Image.asset(
            'assets/images/ic_error.png',
            width: MediaQuery.of(context).size.width - 16,
          ),
        )
            : Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: WebView(
                javascriptMode: JavascriptMode.unrestricted,
                initialUrl: 'https://cartaosaudededescontos.com.br/rede-credenciada-app',
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
                navigationDelegate: (NavigationRequest request) {
                  if (request.url
                      .startsWith('https://api.whatsapp.com/')) {
                    var url = Uri.parse(request.url);
                    _launchUrl(url);
                    return NavigationDecision.prevent;
                  }
                  return NavigationDecision.navigate;
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
            ),
          ],
        )
      ),
    );
  }

  Future<void> _launchUrl(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }
}
