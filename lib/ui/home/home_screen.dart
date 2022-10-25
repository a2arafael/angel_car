import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:angel_car/global/conexa/conexa_repository.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/cards_home.dart';
import 'package:angel_car/global/utils/app-alerts.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/utils/app-utils.dart';
import 'package:angel_car/global/widgets/app_bar_home.dart';
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/ui/accredited_network/accredited_network_screen.dart';
import 'package:angel_car/ui/benefit/benefit_screen.dart';
import 'package:angel_car/ui/call_center/call_center.dart';
import 'package:angel_car/ui/discount_medicines/discount_medicines_screen.dart';
import 'package:angel_car/ui/home/widgets/card_default_home.dart';
import 'package:angel_car/ui/home/widgets/card_focus_home.dart';
import 'package:angel_car/ui/plan/plan_screen.dart';
import 'package:angel_car/ui/teleconsultation/complete_teleconsultation_user_data_screen.dart';
import 'package:angel_car/ui/teleconsultation/select_teleconsultation_user_screen.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static GetStorage storage = GetStorage();
  String _documentHolder = "";
  double screenHeight = Get.height;
  String appName = "";
  String packageName = "";
  String version = "";
  String buildNumber = "";

  Map<String, dynamic> discountMedicines = {
    'image': 'assets/images/ic_desconto_medicamentos.png',
    'text': 'Desconto em Medicamentos',
    'page': 'Discount Medicines'
  };

  Map<String, dynamic> lifeInsurance = {
    'image': 'assets/images/ic_seguro_vida.png',
    'text': 'Angel Car Rastreadores',
    'page': 'Life Insurance'
  };

  Map<String, dynamic> funeralAssistance = {
    'image': 'assets/images/ic_auxilio_funeral.png',
    'text': 'Assistência 24h ao Veículo',
    'page': 'Funeral Assistance'
  };

  Map<String, dynamic> callCenter = {
    'image': 'assets/images/ic_chat.png',
    'text': 'Central de atendimento',
    'page': 'Call Center'
  };

  Map<String, dynamic> teleconsulta = {
    'image': 'assets/images/ic_teleconsulta.png',
    'text': 'Teleconsulta',
    'tipo': 'teleconsulta'
  };

  Map<String, dynamic> consulta = {
    'image': 'assets/images/ic_consulta_exame.png',
    'text': 'Consulta ou Exame\nPresencial',
    'tipo': 'consulta'
  };

  Map<String, dynamic> plano = {
    'image': 'assets/images/ic_meu_plano.png',
    'text': 'Meu Plano',
    'tipo': 'plano'
  };

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
            preferredSize: const Size.fromHeight(60.0), child: appBarHome()),
        body: SingleChildScrollView(
          child: Padding(
            padding: screenHeight > 650.0
                ? const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0)
                : const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
            child: Stack(
              children: [
                StreamBuilder(
                    stream: AppDatabase.getScreenStream(document: "home"),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          context.loaderOverlay.show();
                          return Container();
                        default:
                          DocumentSnapshot documentSnapshot =
                              snapshot.data as DocumentSnapshot;
                          log("=====> AQUI <===== ${documentSnapshot.exists}");
                          Map<String, dynamic> map =
                              documentSnapshot.data() as Map<String, dynamic>;

                          var cardsHome = CardsHome.fromJson(map);
                          List<Map<String, dynamic>> items = [];
                          List<Map<String, dynamic>> itemsInFocus = [];

                          if (cardsHome.buttons?.cardPadrao
                                  ?.descontoEmMedicamentos ==
                              true) {
                            items.add(discountMedicines);
                          }
                          if (cardsHome.buttons?.cardPadrao?.seguroDeVida ==
                              true) {
                            items.add(lifeInsurance);
                          }
                          if (cardsHome.buttons?.cardPadrao?.auxLioFuneral ==
                              true) {
                            items.add(funeralAssistance);
                          }
                          if (cardsHome
                                  .buttons?.cardPadrao?.centralDeAtendimento ==
                              true) {
                            items.add(callCenter);
                          }
                          if (cardsHome.buttons?.cardDestaque?.teleconsulta ==
                              true) {
                            itemsInFocus.add(teleconsulta);
                          }
                          if (cardsHome.buttons?.cardDestaque
                                  ?.consultaOuExamePresencial ==
                              true) {
                            itemsInFocus.add(consulta);
                          }
                          if (cardsHome.buttons?.cardDestaque?.meuPlano ==
                              true) {
                            itemsInFocus.add(plano);
                          }

                          return FutureBuilder(
                            future: AppDatabase.getAuthUser(
                                uid: FirebaseAuth.instance.currentUser?.uid),
                            builder: (context, authSnapshot) {
                              switch (authSnapshot.connectionState) {
                                case ConnectionState.none:
                                case ConnectionState.waiting:
                                  context.loaderOverlay.show();
                                  return Container();
                                default:
                                  DocumentSnapshot documentSnapshot =
                                      authSnapshot.data as DocumentSnapshot;
                                  Map<String, dynamic> map = documentSnapshot
                                      .data() as Map<String, dynamic>;
                                  _documentHolder = map['holder_document'];

                                  return FutureBuilder(
                                    future: AppDatabase.getUser(
                                        document: AppUtils.unmaskDocument(
                                            map['document'])),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          context.loaderOverlay.show();
                                          return Container();
                                        default:
                                          context.loaderOverlay.hide();
                                          DocumentSnapshot documentSnapshot =
                                              snapshot.data as DocumentSnapshot;
                                          Map<String, dynamic> map =
                                              documentSnapshot.data()
                                                  as Map<String, dynamic>;
                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ///Título
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: 'Olá ',
                                                    style: AppTextStyles
                                                        .robotoLight(
                                                      size: 22.0,
                                                      color: AppColors.gray,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            "${map['name'].split(' ')[0]}\nComo podemos Ajudar?",
                                                        style: AppTextStyles
                                                            .robotoMedium(
                                                          color: AppColors.gray,
                                                          size: 22.0,
                                                        ),
                                                      ),
                                                      // can add more TextSpans here...
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              divider(AppColors.gray),
                                              const SizedBox(
                                                height: 32.0,
                                              ),

                                              ///Cards em foco
                                              itemsInFocus.length == 1
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.0,
                                                              right: 16.0,
                                                              bottom: 16.0),
                                                      child: GridView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            const NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            itemsInFocus.length,
                                                        gridDelegate:
                                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                                childAspectRatio:
                                                                    screenHeight >
                                                                            650.0
                                                                        ? 2 / 1
                                                                        : 1 /
                                                                            0.8,
                                                                crossAxisCount:
                                                                    1,
                                                                mainAxisSpacing:
                                                                    4,
                                                                crossAxisSpacing:
                                                                    4),
                                                        itemBuilder:
                                                            (ctx, index) {
                                                          VoidCallback? page;
                                                          switch (itemsInFocus[
                                                              index]['tipo']) {
                                                            case 'teleconsulta':
                                                              page = () =>
                                                                  cardTeleconsulta(
                                                                      map);
                                                              break;
                                                            case 'consulta':
                                                              page = () =>
                                                                  Get.to(() =>
                                                                      const AccreditedNetworkScreen());
                                                              break;
                                                            case 'plano':
                                                              page = () =>
                                                                  Get.to(() =>
                                                                      PlanScreen(
                                                                        document:
                                                                            map['document'],
                                                                      ));
                                                              break;
                                                          }
                                                          return cardFocusHome(
                                                              image:
                                                                  itemsInFocus[
                                                                          index]
                                                                      ['image'],
                                                              text:
                                                                  itemsInFocus[
                                                                          index]
                                                                      ['text'],
                                                              onPressed: page);
                                                        },
                                                      ),
                                                    )
                                                  : itemsInFocus.length == 2
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 16.0,
                                                                  right: 16.0,
                                                                  bottom: 16.0),
                                                          child:
                                                              GridView.builder(
                                                            shrinkWrap: true,
                                                            physics:
                                                                const NeverScrollableScrollPhysics(),
                                                            itemCount:
                                                                itemsInFocus
                                                                    .length,
                                                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                childAspectRatio:
                                                                    screenHeight >
                                                                            650.0
                                                                        ? 1 /
                                                                            1.2
                                                                        : 2 / 2,
                                                                crossAxisCount:
                                                                    2,
                                                                mainAxisSpacing:
                                                                    4,
                                                                crossAxisSpacing:
                                                                    4),
                                                            itemBuilder:
                                                                (ctx, index) {
                                                              VoidCallback?
                                                                  page;
                                                              switch (
                                                                  itemsInFocus[
                                                                          index]
                                                                      [
                                                                      'tipo']) {
                                                                case 'teleconsulta':
                                                                  page = () =>
                                                                      cardTeleconsulta(
                                                                          map);
                                                                  break;
                                                                case 'consulta':
                                                                  page = () =>
                                                                      Get.to(() =>
                                                                          const AccreditedNetworkScreen());
                                                                  break;
                                                                case 'plano':
                                                                  page = () =>
                                                                      Get.to(() =>
                                                                          PlanScreen(
                                                                            document:
                                                                                map['document'],
                                                                          ));
                                                                  break;
                                                              }
                                                              return cardFocusHome(
                                                                  image: itemsInFocus[
                                                                          index]
                                                                      ['image'],
                                                                  text: itemsInFocus[
                                                                          index]
                                                                      ['text'],
                                                                  onPressed:
                                                                      page);
                                                            },
                                                          ),
                                                        )
                                                      : itemsInFocus.length == 3
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          16.0,
                                                                      right:
                                                                          16.0,
                                                                      bottom:
                                                                          16.0),
                                                              child: GridView
                                                                  .builder(
                                                                shrinkWrap:
                                                                    true,
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                itemCount:
                                                                    itemsInFocus
                                                                        .length,
                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                    childAspectRatio: screenHeight >
                                                                            650.0
                                                                        ? 2.8 /
                                                                            5
                                                                        : 2.5 /
                                                                            4,
                                                                    crossAxisCount:
                                                                        3,
                                                                    mainAxisSpacing:
                                                                        4,
                                                                    crossAxisSpacing:
                                                                        4),
                                                                itemBuilder:
                                                                    (ctx,
                                                                        index) {
                                                                  VoidCallback?
                                                                      page;
                                                                  switch (itemsInFocus[
                                                                          index]
                                                                      [
                                                                      'tipo']) {
                                                                    case 'teleconsulta':
                                                                      page = () =>
                                                                          cardTeleconsulta(
                                                                              map);
                                                                      break;
                                                                    case 'consulta':
                                                                      page = () =>
                                                                          Get.to(() =>
                                                                              const AccreditedNetworkScreen());
                                                                      break;
                                                                    case 'plano':
                                                                      page = () =>
                                                                          Get.to(() =>
                                                                              PlanScreen(
                                                                                document: map['document'],
                                                                              ));
                                                                      break;
                                                                  }
                                                                  return cardFocusHome(
                                                                      image: itemsInFocus[
                                                                              index]
                                                                          [
                                                                          'image'],
                                                                      text: itemsInFocus[
                                                                              index]
                                                                          [
                                                                          'text'],
                                                                      onPressed:
                                                                          page);
                                                                },
                                                              ),
                                                            )
                                                          : Container(),

                                              ///Grid de Cards
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 16.0,
                                                    right: 16.0,
                                                    bottom:
                                                        screenHeight * 0.06),
                                                child: GridView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  itemCount: items.length,
                                                  gridDelegate:
                                                      SliverGridDelegateWithFixedCrossAxisCount(
                                                          childAspectRatio:
                                                              screenHeight >
                                                                      650.0
                                                                  ? 3.6 / 5
                                                                  : 3.3 / 4.2,
                                                          crossAxisCount: 3,
                                                          mainAxisSpacing: 8,
                                                          crossAxisSpacing: 8),
                                                  itemBuilder: (ctx, index) {
                                                    VoidCallback? page;
                                                    switch (items[index]
                                                        ['page']) {
                                                      case 'Discount Medicines':
                                                        page = () => Get.to(() =>
                                                            const DiscountMedicinesScreen());
                                                        break;
                                                      case 'Call Center':
                                                        page = () => Get.to(() =>
                                                            const CallCenterScreen());
                                                        break;
                                                      case 'Life Insurance':
                                                        page = () => Get.to(
                                                              () =>
                                                                  const BenefitScreen(
                                                                title:
                                                                    'Angel Car Rastreadores',
                                                                document:
                                                                    'rastreadores',
                                                              ),
                                                            );
                                                        break;
                                                      case 'Funeral Assistance':
                                                        page = () => Get.to(
                                                              () =>
                                                                  const BenefitScreen(
                                                                title:
                                                                    'Assistência 24h ao Veículo',
                                                                document:
                                                                    'veiculo',
                                                              ),
                                                            );
                                                        break;
                                                    }
                                                    return cardDefaultHome(
                                                        image: items[index]
                                                            ['image'],
                                                        text: items[index]
                                                            ['text'],
                                                        onPressed: page);
                                                  },
                                                ),
                                              ),
                                            ],
                                          );
                                      }
                                    },
                                  );
                              }
                            },
                          );
                      }
                    }),

                ///Número da versão do app
                Positioned(
                  bottom: 8.0,
                  right: 8.0,
                  child: FutureBuilder(
                      future: PackageInfo.fromPlatform(),
                      builder: (context, snapshot) {
                        PackageInfo packageInfo = snapshot.data as PackageInfo;
                        return Text(
                          "v ${packageInfo.version}",
                          style: AppTextStyles.robotoRegular(
                            color: AppColors.gray,
                            size: 16.0,
                          ),
                        );
                      }
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future? cardTeleconsulta(Map<String, dynamic> map) {
   if (map['is_holder'] != null && map['is_holder']) {
      return Get.to(() => SelectTeleconsultationUserScreen(
            document: map['document'],
            isHolder: map['is_holder'],
          ));
    } else {
      if (map['full_registration'] == true && map['conexa_id'] != null) {
        context.loaderOverlay.show();
        ConexaRepository().generateMagicLink(map['conexa_id']).then((glmValue) {
          if (glmValue.data['status'] == 200) {
            context.loaderOverlay.hide();
            _launchURL(context, glmValue.data['object']['linkMagicoWeb']);
          }
        }).catchError((onError){
          context.loaderOverlay.hide();
          DioError dioError = onError;
          AppAlerts.snackbarError('Atenção', dioError.response!.data['msg']);
        });
      } else {
        return Get.to(() => CompleteTeleconsultationUserDataScreen(
              document: map['document'],
              dependentName: null,
              isHolder: false,
              documentHolder: _documentHolder,
            ));
      }
    }
    return null;
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
