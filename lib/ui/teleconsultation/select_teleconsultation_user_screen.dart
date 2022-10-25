import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/conexa/conexa_repository.dart';
import 'package:angel_car/global/model/dependent.dart';
import 'package:angel_car/global/model/holder.dart';
import 'package:angel_car/global/utils/app-alerts.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-strings.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/utils/app-utils.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/ui/teleconsultation/complete_teleconsultation_user_data_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';

class SelectTeleconsultationUserScreen extends StatefulWidget {
  final String document;
  final bool isHolder;

  const SelectTeleconsultationUserScreen(
      {Key? key, required this.document, required this.isHolder})
      : super(key: key);

  @override
  _SelectTeleconsultationUserScreenState createState() =>
      _SelectTeleconsultationUserScreenState();
}

class _SelectTeleconsultationUserScreenState
    extends State<SelectTeleconsultationUserScreen> {
  List<Map<String, dynamic>> items = [];

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
            child: appBarDefault('TELECONSULTA')),
        body: SingleChildScrollView(
          child: Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(AppStrings.collectionUsers)
                  .doc(AppUtils.unmaskDocument(widget.document))
                  .snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    context.loaderOverlay.show();
                    return Container();
                  default:
                    items.clear();
                    DocumentSnapshot documentSnapshot =
                    snapshot.data as DocumentSnapshot;
                    Map<String, dynamic> map =
                    documentSnapshot.data() as Map<String, dynamic>;
                    Holder holder;
                    if (documentSnapshot.data() != null) {
                      holder = Holder.fromJson(map);
                      if (holder.dependents != null) {
                        context.loaderOverlay.hide();
                        items.add({
                          'name': holder.name,
                          'level': 'Titular',
                          'object': holder
                        });
                        holder.dependents?.forEach((element) {
                          if(element?.name != null && element!.name!.isNotEmpty){
                            items.add({
                              'name': element.name,
                              'level': 'Dependente',
                              'object': element
                            });
                          }
                        });
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            ///Título
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                              ),
                              child: Text(
                                'Selecione quem será atendido',
                                style: AppTextStyles.robotoMedium(
                                  color: AppColors.gray,
                                  size: 18.0,
                                ),
                              ),
                            ),
                            divider(AppColors.gray),

                            ///Lista de usuários
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    if (items[index]['level'] == 'Titular') {
                                      Holder holder = items[index]['object'];
                                      if (holder.fullRegistration == true) {
                                        assert(holder.conexaId != null);
                                        goToWebViewScreen(
                                            conexaId: holder.conexaId);
                                      } else {
                                        goToCompleteTeleconsultationUserDataScreen(
                                          document: holder.document,
                                          dependentName: null,
                                          isHolder: true,
                                          documentHolder: holder.document,
                                        );
                                      }
                                    } else {
                                      Dependent dependent =
                                      items[index]['object'];
                                      if (dependent.fullRegistration == true) {
                                        assert(dependent.conexaId != null);
                                        goToWebViewScreen(
                                            conexaId: dependent.conexaId);
                                      } else {
                                        goToCompleteTeleconsultationUserDataScreen(
                                          document: holder.document,
                                          dependentName: dependent.name,
                                          isHolder: true,
                                          documentHolder: holder.document,
                                        );
                                      }
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 16.0),
                                    child: Card(
                                      elevation: 5.0,
                                      color: AppColors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(10.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              items[index]['name'],
                                              style: AppTextStyles.robotoMedium(
                                                color: AppColors.black,
                                                size: 19.0,
                                              ),
                                            ),
                                            Text(
                                              items[index]['level'],
                                              style: AppTextStyles.robotoMedium(
                                                color: AppColors.primary,
                                                size: 14.0,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      } else {
                        if (holder.fullRegistration != null &&
                            holder.fullRegistration == true) {
                          context.loaderOverlay.show();
                          assert(holder.conexaId != null);
                          goToWebViewScreen(conexaId: holder.conexaId);
                        } else {
                          goToCompleteTeleconsultationUserDataScreen(
                              document: map['document'],
                              dependentName: null,
                              isHolder: true,
                              documentHolder: map['document']
                          );
                        }
                        return Container();
                      }
                    }
                    return Container();
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  void goToWebViewScreen({required int? conexaId}) {
    ConexaRepository().generateMagicLink(conexaId).then((glmValue) {
      if (glmValue.data['status'] == 200) {
        context.loaderOverlay.hide();
        Get.back();
        _launchURL(context, glmValue.data['object']['linkMagicoWeb']);
      }
    }).catchError((onError) {
      context.loaderOverlay.hide();
      DioError dioError = onError;
      AppAlerts.snackbarError('Atenção', dioError.response!.data['msg']);
    });
  }

  void goToCompleteTeleconsultationUserDataScreen({
    required String? document,
    required String? documentHolder,
    required String? dependentName,
    required bool? isHolder,
  }) {
    Get.to(() =>
        CompleteTeleconsultationUserDataScreen(
          document: document,
          dependentName: dependentName,
          isHolder: isHolder,
          documentHolder: documentHolder,
        ));
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          extraCustomTabs: const <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }
}
