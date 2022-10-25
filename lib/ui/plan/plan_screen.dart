import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:angel_car/global/firebase/app_database.dart';
import 'package:angel_car/global/model/bill.dart';
import 'package:angel_car/global/model/customer.dart';
import 'package:angel_car/global/model/dependent.dart';
import 'package:angel_car/global/model/holder.dart';
import 'package:angel_car/global/model/subscription.dart';
import 'package:angel_car/global/utils/app-colors.dart';
import 'package:angel_car/global/utils/app-text-styles.dart';
import 'package:angel_car/global/utils/app-utils.dart';
import 'package:angel_car/global/vindi/vindi_view_model.dart';
import 'package:angel_car/global/widgets/app_bar_default.dart';
import 'package:angel_car/global/widgets/button_solid.dart';
import 'package:angel_car/global/widgets/divider.dart';
import 'package:angel_car/global/widgets/social_media_buttons.dart';
import 'package:loader_overlay/loader_overlay.dart';

class PlanScreen extends StatefulWidget {
  final String? document;

  const PlanScreen({Key? key, required this.document}) : super(key: key);

  @override
  _PlanScreenState createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  double screenWidth = Get.width;
  double screenHeight = Get.height;
  bool isExpanded = false;
  bool isVisible = false;
  bool isPhone = true;
  bool _isBenefitHodler = true;
  String? recipient = '';

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
            child: appBarDefault('MEU PLANO')),
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: StreamBuilder(
                stream: AppDatabase.getUserStream(
                    document: AppUtils.unmaskDocument(widget.document)),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                    case ConnectionState.none:
                      context.loaderOverlay.show();
                      return Container();
                    default:
                      DocumentSnapshot documentSnapshot =
                          snapshot.data as DocumentSnapshot;
                      Map<String, dynamic> map =
                          documentSnapshot.data() as Map<String, dynamic>;
                      Holder holder = Holder();
                      Dependent dependent = Dependent();
                      context.loaderOverlay.hide();
                      if (map['is_holder'] == true) {
                        holder = Holder.fromJson(map);
                        return bodyHolder(holder: holder);
                      } else {
                        dependent = Dependent.fromJson(map);
                        return bodyDependent(dependent: dependent);
                      }
                  }
                }),
          ),
        ),
      ),
    );
  }

  Widget bodyHolder({required Holder holder}) {
    return FutureBuilder(
      future: VindiViewModel.getCustomer(
          cpf: AppUtils.unmaskDocument(holder.document)),
      builder: (contex, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            context.loaderOverlay.show();
            return Container();
          default:
            Customer customer = snapshot.data as Customer;
            String? createdAt = AppUtils.dateFormat(customer.createdAt);
            return FutureBuilder(
                future: VindiViewModel.getBill(customerId: customer.id),
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      context.loaderOverlay.show();
                      return Container();
                    default:
                      Bill bill = snapshot.data as Bill;
                      String? plan = bill.subscription?.plan?.name;
                      String? price = '';
                      String? paymentMethod = '';
                      if (!plan!.toLowerCase().contains('cortesia')) {
                        price = bill.billItems?[0].pricingSchema?.shortFormat !=
                                null
                            ? bill.billItems![0].pricingSchema!.shortFormat
                            : bill.billItems?[0].pricingSchema?.price;

                        if (bill.amount != '0.0') {
                          paymentMethod =
                              bill.charges?[0].paymentMethod?.publicName;
                        }
                      }
                      return FutureBuilder(
                          future: VindiViewModel.getSubscription(
                              customerId: bill.customer?.id),
                          builder: (context, snapshot) {
                            switch (snapshot.connectionState) {
                              case ConnectionState.none:
                              case ConnectionState.waiting:
                                context.loaderOverlay.show();
                                return Container();
                              default:
                                Subscription subscription =
                                    snapshot.data as Subscription;
                                String? nextBill = '';
                                String? planDuration = '';
                                if (subscription.plan!.name!
                                    .toLowerCase()
                                    .contains('vitalício')) {
                                  nextBill = 'Vitalício';
                                  planDuration = 'Vitalício';
                                } else if (subscription.plan!.name!
                                    .toLowerCase()
                                    .contains('mensal')) {
                                  nextBill = AppUtils.dateFormat(
                                      subscription.nextBillingAt);
                                  planDuration = 'Mensal';
                                } else if (subscription.plan!.name!
                                    .toLowerCase()
                                    .contains('anual')) {
                                  nextBill = AppUtils.dateFormat(
                                      subscription.nextBillingAt);
                                  planDuration = 'Anual';
                                } else {
                                  nextBill = AppUtils.dateFormat(
                                      subscription.nextBillingAt);
                                  planDuration = '';
                                }
                                context.loaderOverlay.hide();
                                return _isBenefitHodler
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ///Título, Nome do usuário e Botão para alterar usuário
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ///Título e Nome do usuário
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ///Título
                                                      Text(
                                                        'Beneficiário',
                                                        style: AppTextStyles
                                                            .robotoLight(
                                                          color: AppColors.gray,
                                                          size: 14.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8.0,
                                                      ),

                                                      ///Nome do usuário
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.5,
                                                        child: Text(
                                                          holder.name ?? '',
                                                          style: AppTextStyles
                                                              .robotoExtraBold(
                                                            color: AppColors
                                                                .primary,
                                                            size: 17.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                ///Botão para alterar usuário
                                                buttonSolid(
                                                  height: 40.0,
                                                  width: 80.0,
                                                  text: 'Alterar',
                                                  textSize: 15.0,
                                                  onPressed: () =>
                                                      showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'Selecione o beneficiário',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppTextStyles
                                                            .robotoSemiBold(
                                                          color:
                                                              AppColors.primary,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                      content: SizedBox(
                                                        width: double.maxFinite,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: holder
                                                                        .dependents !=
                                                                    null
                                                                ? holder.dependents!
                                                                        .length +
                                                                    1
                                                                : 0,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              List<String>
                                                                  names = [];
                                                              names.add(
                                                                  holder.name ??
                                                                      '');
                                                              holder.dependents
                                                                  ?.forEach(
                                                                      (element) {
                                                                names.add(element
                                                                        ?.name ??
                                                                    '');
                                                              });
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        if (index !=
                                                                            0) {
                                                                          _isBenefitHodler =
                                                                              false;
                                                                          recipient =
                                                                              names[index];
                                                                        } else {
                                                                          _isBenefitHodler =
                                                                              true;
                                                                        }
                                                                      });
                                                                      Get.back();
                                                                    },
                                                                    child: Text(
                                                                      names[
                                                                          index],
                                                                      style: AppTextStyles
                                                                          .robotoMedium(
                                                                        color: AppColors
                                                                            .gray,
                                                                        size:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                  divider(AppColors
                                                                      .grayLight),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          divider(AppColors.gray),
                                          const SizedBox(
                                            height: 16.0,
                                          ),

                                          ///Carteirinha
                                          Card(
                                            color: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                color: AppColors.primary,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: SizedBox(
                                                width: double.maxFinite,
                                                child: Stack(
                                                  children: [
                                                    ///Logo e Cód. cliente
                                                    Row(
                                                      children: [
                                                        ///Logo
                                                        Image.asset(
                                                          'assets/images/logo_carteirinha.png',
                                                          width: 60,
                                                          fit: BoxFit.cover,
                                                        ),

                                                        ///Cód. cliente
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'cod. cliente',
                                                                style: AppTextStyles
                                                                    .robotoLight(
                                                                  color: AppColors
                                                                      .primary,
                                                                  size: 14.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                holder
                                                                    .customerId
                                                                    .toString(),
                                                                style: AppTextStyles
                                                                    .robotoExtraBold(
                                                                  color:
                                                                      AppColors
                                                                          .gray,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    ///Nome
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 70.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ///Nome
                                                                Text(
                                                                  'nome',
                                                                  style: AppTextStyles
                                                                      .robotoLight(
                                                                    color: AppColors
                                                                        .primary,
                                                                    size: 12.0,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  holder.name ??
                                                                      '',
                                                                  style: AppTextStyles
                                                                      .robotoExtraBold(
                                                                    color:
                                                                        AppColors
                                                                            .gray,
                                                                    size: 18.0,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8.0,
                                                                ),

                                                                ///Titular
                                                                Text(
                                                                  'titular',
                                                                  style: AppTextStyles
                                                                      .robotoLight(
                                                                    color: AppColors
                                                                        .primary,
                                                                    size: 12.0,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  holder.name ??
                                                                      '',
                                                                  style: AppTextStyles
                                                                      .robotoMedium(
                                                                    color:
                                                                        AppColors
                                                                            .gray,
                                                                    size: 14.0,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8.0,
                                                                ),

                                                                ///Plano e validade
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:

                                                                          ///Plano
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'plano',
                                                                            style:
                                                                                AppTextStyles.robotoLight(
                                                                              color: AppColors.primary,
                                                                              size: 12.0,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.5,
                                                                            child:
                                                                                Text(
                                                                              plan,
                                                                              style: AppTextStyles.robotoMedium(
                                                                                color: AppColors.gray,
                                                                                size: 14.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    ///Validade
                                                                    // Column(
                                                                    //   crossAxisAlignment:
                                                                    //   CrossAxisAlignment.end,
                                                                    //   children: [
                                                                    //     Text(
                                                                    //       'validade',
                                                                    //       style: AppTextStyles.robotoLight(
                                                                    //         color: AppColors.primary,
                                                                    //         size: 12.0,
                                                                    //       ),
                                                                    //     ),
                                                                    //     Text(
                                                                    //         holder.nextBill ?? '10/2022',
                                                                    //         textAlign: TextAlign.end,
                                                                    //         style: AppTextStyles.robotoMedium(
                                                                    //           color: AppColors.gray,
                                                                    //           size: 16.0,
                                                                    //         ),
                                                                    //     ),
                                                                    //   ],
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24.0,
                                          ),

                                          ///Detalhes do plano
                                          plan
                                                  .toLowerCase()
                                                  .contains('cortesia')
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            dividerColor: Colors
                                                                .transparent),
                                                    child: ExpansionTile(
                                                      initiallyExpanded:
                                                          isExpanded,
                                                      expandedCrossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      onExpansionChanged:
                                                          (value) =>
                                                              isExpanded =
                                                                  value,
                                                      iconColor: AppColors.gray,
                                                      backgroundColor:
                                                          AppColors.transparent,
                                                      title: Text(
                                                        'DETALHES DO PLANO',
                                                        style: AppTextStyles
                                                            .robotoMedium(
                                                          color: AppColors.gray,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                      children: [
                                                        divider(AppColors.gray),
                                                        const SizedBox(
                                                          height: 16.0,
                                                        ),

                                                        ///Plano e olho
                                                        Row(
                                                          children: [
                                                            ///Plano
                                                            Expanded(
                                                              child: Text(
                                                                plan,
                                                                style: AppTextStyles
                                                                    .robotoBlack(
                                                                  color: AppColors
                                                                      .primary,
                                                                  size: 18.0,
                                                                ),
                                                              ),
                                                            ),

                                                            ///Ícone olho
                                                            isVisible
                                                                ? IconButton(
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .visibility,
                                                                      color: AppColors
                                                                          .primary,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        isVisible =
                                                                            !isVisible;
                                                                        isExpanded =
                                                                            true;
                                                                      });
                                                                    },
                                                                  )
                                                                : IconButton(
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .visibility_off,
                                                                      color: AppColors
                                                                          .primary,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        isVisible =
                                                                            !isVisible;
                                                                        isExpanded =
                                                                            true;
                                                                      });
                                                                    },
                                                                  )
                                                          ],
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Status do plano
                                                        Row(
                                                          children: const [
                                                            Expanded(
                                                              child: Text(
                                                                'Status do plano:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            SizedBox(
                                                              width: 4.0,
                                                            ),
                                                            Text(
                                                              'Ativo',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Beneficiário
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Titular:',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                            const SizedBox(
                                                              width: 16.0,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                holder.name ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Cód. Cliente
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Cód. Cliente:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              holder.customerId
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// CPF
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'CPF:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              isVisible
                                                                  ? holder.document ??
                                                                      ''
                                                                  : '***.${holder.document?.substring(4, 7)}.${holder.document?.substring(8, 11)}-**',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Telefone
                                                        isPhone
                                                            ? Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Telefone:',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: AppColors.black,
                                                                              fontSize: 16.0,
                                                                              fontWeight: FontWeight.w900),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        isVisible
                                                                            ? AppUtils.maskPhone(holder.cellphone)
                                                                            : '(**) ***** - ${holder.cellphone?.substring(7)}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            color: AppColors
                                                                                .black,
                                                                            fontSize:
                                                                                16.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                  divider(
                                                                      AppColors
                                                                          .primary,
                                                                      thickness:
                                                                          1.0),
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),

                                                        /// E-mail
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'E-mail:',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color: AppColors.black,
                                                                  fontSize: 16.0,
                                                                  fontWeight: FontWeight.w900),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                AppUtils.hideEmail(holder.email, isVisible),
                                                                textAlign: TextAlign.right,
                                                                style: const TextStyle(
                                                                    color: AppColors.black,
                                                                    fontSize: 14.0,
                                                                    fontWeight: FontWeight.w500
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Preço
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Preço:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              price ?? '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Início do plano
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Início do plano:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              createdAt,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Próxima Cobrança
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Próxima Cobrança:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              nextBill,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Validade do plano
                                                        planDuration.isNotEmpty
                                                            ? Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'Validade do plano:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .black,
                                                                          fontSize:
                                                                              16.0,
                                                                          fontWeight:
                                                                              FontWeight.w900),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    planDuration,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                        planDuration.isNotEmpty
                                                            ? const SizedBox(
                                                                height: 8.0,
                                                              )
                                                            : Container(),
                                                        planDuration.isNotEmpty
                                                            ? divider(
                                                                AppColors
                                                                    .primary,
                                                                thickness: 1.0)
                                                            : Container(),
                                                        planDuration.isNotEmpty
                                                            ? const SizedBox(
                                                                height: 8.0,
                                                              )
                                                            : Container(),

                                                        /// Método de pagamento
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Método de pagamento:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              paymentMethod ??
                                                                  '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          plan
                                                  .toLowerCase()
                                                  .contains('cortesia')
                                              ? Container()
                                              : isExpanded
                                                  ? Container()
                                                  : divider(AppColors.gray),

                                          ///Espaçamento TODO: Vericicar espaçamento na Apple
                                          isExpanded
                                              ? const SizedBox(
                                                  height: 32.0,
                                                )
                                              : screenHeight > 650
                                                  ? SizedBox(
                                                      height:
                                                          Get.context!.height *
                                                              0.23,
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          Get.context!.height *
                                                              0.12,
                                                    ),

                                          ///Infos de contato
                                          contact(),
                                        ],
                                      )
                                    : Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ///Título, Nome do usuário e Botão para alterar usuário
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 16.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                ///Título e Nome do usuário
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ///Título
                                                      Text(
                                                        'Beneficiário',
                                                        style: AppTextStyles
                                                            .robotoLight(
                                                          color: AppColors.gray,
                                                          size: 14.0,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                        height: 8.0,
                                                      ),

                                                      ///Nome do usuário
                                                      SizedBox(
                                                        width:
                                                            screenWidth * 0.5,
                                                        child: Text(
                                                          recipient ?? '',
                                                          style: AppTextStyles
                                                              .robotoExtraBold(
                                                            color: AppColors
                                                                .primary,
                                                            size: 17.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),

                                                ///Botão para alterar usuário
                                                buttonSolid(
                                                  height: 40.0,
                                                  width: 80.0,
                                                  text: 'Alterar',
                                                  textSize: 15.0,
                                                  onPressed: () =>
                                                      showDialog<String>(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        AlertDialog(
                                                      title: Text(
                                                        'Selecione o beneficiário',
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: AppTextStyles
                                                            .robotoSemiBold(
                                                          color:
                                                              AppColors.primary,
                                                          size: 20.0,
                                                        ),
                                                      ),
                                                      content: SizedBox(
                                                        width: double.maxFinite,
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            itemCount: holder
                                                                        .dependents !=
                                                                    null
                                                                ? holder.dependents!
                                                                        .length +
                                                                    1
                                                                : 0,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              List<String>
                                                                  names = [];
                                                              names.add(
                                                                  holder.name ??
                                                                      '');
                                                              holder.dependents
                                                                  ?.forEach(
                                                                      (element) {
                                                                names.add(element
                                                                        ?.name ??
                                                                    '');
                                                              });
                                                              return Column(
                                                                children: [
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        if (index !=
                                                                            0) {
                                                                          _isBenefitHodler =
                                                                              false;
                                                                          recipient =
                                                                              names[index];
                                                                        } else {
                                                                          _isBenefitHodler =
                                                                              true;
                                                                        }
                                                                      });
                                                                      Get.back();
                                                                    },
                                                                    child: Text(
                                                                      names[
                                                                          index],
                                                                      style: AppTextStyles
                                                                          .robotoMedium(
                                                                        color: AppColors
                                                                            .gray,
                                                                        size:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                  divider(AppColors
                                                                      .grayLight),
                                                                ],
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 8.0,
                                          ),
                                          divider(AppColors.gray),
                                          const SizedBox(
                                            height: 16.0,
                                          ),

                                          ///Carteirinha
                                          Card(
                                            color: AppColors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                color: AppColors.primary,
                                                width: 1.0,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: SizedBox(
                                                width: double.maxFinite,
                                                child: Stack(
                                                  children: [
                                                    ///Logo e Cód. cliente
                                                    Row(
                                                      children: [
                                                        ///Logo
                                                        Image.asset(
                                                          'assets/images/logo_carteirinha.png',
                                                          width: 60,
                                                          fit: BoxFit.cover,
                                                        ),

                                                        ///Cód. cliente
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Text(
                                                                'cod. cliente',
                                                                style: AppTextStyles
                                                                    .robotoLight(
                                                                  color: AppColors
                                                                      .primary,
                                                                  size: 14.0,
                                                                ),
                                                              ),
                                                              Text(
                                                                holder
                                                                    .customerId
                                                                    .toString(),
                                                                style: AppTextStyles
                                                                    .robotoExtraBold(
                                                                  color:
                                                                      AppColors
                                                                          .gray,
                                                                  size: 20.0,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),

                                                    ///Nome
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 70.0),
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                ///Nome
                                                                Text(
                                                                  'nome',
                                                                  style: AppTextStyles
                                                                      .robotoLight(
                                                                    color: AppColors
                                                                        .primary,
                                                                    size: 12.0,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  recipient ??
                                                                      '',
                                                                  style: AppTextStyles
                                                                      .robotoExtraBold(
                                                                    color:
                                                                        AppColors
                                                                            .gray,
                                                                    size: 18.0,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8.0,
                                                                ),

                                                                ///Titular
                                                                Text(
                                                                  'titular',
                                                                  style: AppTextStyles
                                                                      .robotoLight(
                                                                    color: AppColors
                                                                        .primary,
                                                                    size: 12.0,
                                                                  ),
                                                                ),
                                                                Text(
                                                                  holder.name ??
                                                                      '',
                                                                  style: AppTextStyles
                                                                      .robotoMedium(
                                                                    color:
                                                                        AppColors
                                                                            .gray,
                                                                    size: 14.0,
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 8.0,
                                                                ),

                                                                ///Plano e validade
                                                                Row(
                                                                  children: [
                                                                    Expanded(
                                                                      child:

                                                                          ///Plano
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Text(
                                                                            'plano',
                                                                            style:
                                                                                AppTextStyles.robotoLight(
                                                                              color: AppColors.primary,
                                                                              size: 12.0,
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            width:
                                                                                screenWidth * 0.5,
                                                                            child:
                                                                                Text(
                                                                              plan,
                                                                              style: AppTextStyles.robotoMedium(
                                                                                color: AppColors.gray,
                                                                                size: 14.0,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),

                                                                    ///Validade
                                                                    // Column(
                                                                    //   crossAxisAlignment:
                                                                    //   CrossAxisAlignment.end,
                                                                    //   children: [
                                                                    //     Text(
                                                                    //       'validade',
                                                                    //       style: AppTextStyles.robotoLight(
                                                                    //         color: AppColors.primary,
                                                                    //         size: 12.0,
                                                                    //       ),
                                                                    //     ),
                                                                    //     Text(
                                                                    //         holder.nextBill ?? '10/2022',
                                                                    //         textAlign: TextAlign.end,
                                                                    //         style: AppTextStyles.robotoMedium(
                                                                    //           color: AppColors.gray,
                                                                    //           size: 16.0,
                                                                    //         ),
                                                                    //     ),
                                                                    //   ],
                                                                    // ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 24.0,
                                          ),

                                          ///Detalhes do plano
                                          plan
                                                  .toLowerCase()
                                                  .contains('cortesia')
                                              ? Container()
                                              : Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 16.0),
                                                  child: Theme(
                                                    data: Theme.of(context)
                                                        .copyWith(
                                                            dividerColor: Colors
                                                                .transparent),
                                                    child: ExpansionTile(
                                                      initiallyExpanded:
                                                          isExpanded,
                                                      expandedCrossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      onExpansionChanged:
                                                          (value) =>
                                                              isExpanded =
                                                                  value,
                                                      iconColor: AppColors.gray,
                                                      backgroundColor:
                                                          AppColors.transparent,
                                                      title: Text(
                                                        'DETALHES DO PLANO',
                                                        style: AppTextStyles
                                                            .robotoMedium(
                                                          color: AppColors.gray,
                                                          size: 16.0,
                                                        ),
                                                      ),
                                                      children: [
                                                        divider(AppColors.gray),
                                                        const SizedBox(
                                                          height: 16.0,
                                                        ),

                                                        ///Plano e olho
                                                        Row(
                                                          children: [
                                                            ///Plano
                                                            Expanded(
                                                              child: Text(
                                                                plan,
                                                                style: AppTextStyles
                                                                    .robotoBlack(
                                                                  color: AppColors
                                                                      .primary,
                                                                  size: 18.0,
                                                                ),
                                                              ),
                                                            ),

                                                            ///Ícone olho
                                                            isVisible
                                                                ? IconButton(
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .visibility,
                                                                      color: AppColors
                                                                          .primary,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        isVisible =
                                                                            !isVisible;
                                                                        isExpanded =
                                                                            true;
                                                                      });
                                                                    },
                                                                  )
                                                                : IconButton(
                                                                    icon: const Icon(
                                                                      Icons
                                                                          .visibility_off,
                                                                      color: AppColors
                                                                          .primary,
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      setState(
                                                                          () {
                                                                        isVisible =
                                                                            !isVisible;
                                                                        isExpanded =
                                                                            true;
                                                                      });
                                                                    },
                                                                  )
                                                          ],
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Status do plano
                                                        Row(
                                                          children: const [
                                                            Expanded(
                                                              child: Text(
                                                                'Status do plano:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Icon(
                                                              Icons
                                                                  .check_circle,
                                                              color:
                                                                  Colors.green,
                                                            ),
                                                            SizedBox(
                                                              width: 4.0,
                                                            ),
                                                            Text(
                                                              'Ativo',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Beneficiário
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'Titular:',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                            const SizedBox(
                                                              width: 16.0,
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                holder.name ??
                                                                    '',
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Cód. Cliente
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Cód. Cliente:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              holder.customerId
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// CPF
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'CPF:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              isVisible
                                                                  ? holder.document ??
                                                                      ''
                                                                  : '***.${holder.document?.substring(4, 7)}.${holder.document?.substring(8, 11)}-**',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Telefone
                                                        isPhone
                                                            ? Column(
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      const Expanded(
                                                                        child:
                                                                            Text(
                                                                          'Telefone:',
                                                                          textAlign:
                                                                              TextAlign.left,
                                                                          style: TextStyle(
                                                                              color: AppColors.black,
                                                                              fontSize: 16.0,
                                                                              fontWeight: FontWeight.w900),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        isVisible
                                                                            ? AppUtils.maskPhone(holder.cellphone)
                                                                            : '(**) ***** - ${holder.cellphone?.substring(7)}',
                                                                        textAlign:
                                                                            TextAlign.left,
                                                                        style: const TextStyle(
                                                                            color: AppColors
                                                                                .black,
                                                                            fontSize:
                                                                                16.0,
                                                                            fontWeight:
                                                                                FontWeight.w500),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                  divider(
                                                                      AppColors
                                                                          .primary,
                                                                      thickness:
                                                                          1.0),
                                                                  const SizedBox(
                                                                    height: 8.0,
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),

                                                        /// E-mail
                                                        Row(
                                                          children: [
                                                            const Text(
                                                              'E-mail:',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                AppUtils.hideEmail(
                                                                    holder
                                                                        .email,
                                                                    isVisible),
                                                                textAlign:
                                                                    TextAlign
                                                                        .right,
                                                                style: const TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Preço
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Preço:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              price ?? '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Início do plano
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Início do plano:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              createdAt,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Próxima Cobrança
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Próxima Cobrança:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              nextBill,
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),

                                                        /// Validade do plano
                                                        planDuration.isNotEmpty
                                                            ? Row(
                                                                children: [
                                                                  const Expanded(
                                                                    child: Text(
                                                                      'Validade do plano:',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .left,
                                                                      style: TextStyle(
                                                                          color: AppColors
                                                                              .black,
                                                                          fontSize:
                                                                              16.0,
                                                                          fontWeight:
                                                                              FontWeight.w900),
                                                                    ),
                                                                  ),
                                                                  Text(
                                                                    planDuration,
                                                                    textAlign:
                                                                        TextAlign
                                                                            .left,
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16.0,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ],
                                                              )
                                                            : Container(),
                                                        planDuration.isNotEmpty
                                                            ? const SizedBox(
                                                                height: 8.0,
                                                              )
                                                            : Container(),
                                                        planDuration.isNotEmpty
                                                            ? divider(
                                                                AppColors
                                                                    .primary,
                                                                thickness: 1.0)
                                                            : Container(),
                                                        planDuration.isNotEmpty
                                                            ? const SizedBox(
                                                                height: 8.0,
                                                              )
                                                            : Container(),

                                                        /// Método de pagamento
                                                        Row(
                                                          children: [
                                                            const Expanded(
                                                              child: Text(
                                                                'Método de pagamento:',
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                                style: TextStyle(
                                                                    color: AppColors
                                                                        .black,
                                                                    fontSize:
                                                                        16.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900),
                                                              ),
                                                            ),
                                                            Text(
                                                              paymentMethod ??
                                                                  '',
                                                              textAlign:
                                                                  TextAlign
                                                                      .left,
                                                              style: const TextStyle(
                                                                  color:
                                                                      AppColors
                                                                          .black,
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                        divider(
                                                            AppColors.primary,
                                                            thickness: 1.0),
                                                        const SizedBox(
                                                          height: 8.0,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          plan
                                                  .toLowerCase()
                                                  .contains('cortesia')
                                              ? Container()
                                              : isExpanded
                                                  ? Container()
                                                  : divider(AppColors.gray),

                                          ///Espaçamento TODO: Vericicar espaçamento na Apple
                                          isExpanded
                                              ? const SizedBox(
                                                  height: 32.0,
                                                )
                                              : screenHeight > 650
                                                  ? SizedBox(
                                                      height:
                                                          Get.context!.height *
                                                              0.23,
                                                    )
                                                  : SizedBox(
                                                      height:
                                                          Get.context!.height *
                                                              0.12,
                                                    ),

                                          ///Infos de contato
                                          contact(),
                                        ],
                                      );
                            }
                          });
                  }
                });
        }
      },
    );
  }

  Widget bodyDependent({required Dependent dependent}) {
    return StreamBuilder(
        stream: AppDatabase.getUserStream(
            document: AppUtils.unmaskDocument(dependent.holderDocument)),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              context.loaderOverlay.show();
              return Container();
            default:
              DocumentSnapshot documentSnapshot =
                  snapshot.data as DocumentSnapshot;
              Map<String, dynamic> map =
                  documentSnapshot.data() as Map<String, dynamic>;
              Holder holder = Holder();
              context.loaderOverlay.hide();
              holder = Holder.fromJson(map);

              return FutureBuilder(
                  future:
                      VindiViewModel.getPlanName(customerId: holder.customerId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      context.loaderOverlay.hide();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///Título, Nome do usuário e Botão para alterar usuário
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ///Título e Nome do usuário
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ///Título
                                      Text(
                                        'Beneficiário',
                                        style: AppTextStyles.robotoLight(
                                          color: AppColors.gray,
                                          size: 14.0,
                                        ),
                                      ),

                                      ///Nome do usuário
                                      Text(
                                        dependent.name ?? '',
                                        style: AppTextStyles.robotoMedium(
                                          color: AppColors.primary,
                                          size: 20.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          divider(AppColors.gray),
                          const SizedBox(
                            height: 16.0,
                          ),

                          ///Carteirinha
                          Card(
                            color: AppColors.white,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: AppColors.primary,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: Stack(
                                  children: [
                                    ///Logo e Cód. cliente
                                    Row(
                                      children: [
                                        ///Logo
                                        Image.asset(
                                          'assets/images/logo_carteirinha.png',
                                          width: 60,
                                          fit: BoxFit.cover,
                                        ),

                                        ///Cód. cliente
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'cod. cliente',
                                                style:
                                                    AppTextStyles.robotoLight(
                                                  color: AppColors.primary,
                                                  size: 14.0,
                                                ),
                                              ),
                                              Text(
                                                holder.customerId.toString(),
                                                style: AppTextStyles
                                                    .robotoExtraBold(
                                                  color: AppColors.gray,
                                                  size: 20.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    ///Nome
                                    Padding(
                                      padding: const EdgeInsets.only(top: 70.0),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ///Nome
                                                Text(
                                                  'nome',
                                                  style:
                                                      AppTextStyles.robotoLight(
                                                    color: AppColors.primary,
                                                    size: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  dependent.name ?? '',
                                                  style: AppTextStyles
                                                      .robotoExtraBold(
                                                    color: AppColors.gray,
                                                    size: 18.0,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),

                                                ///Titular
                                                Text(
                                                  'titular',
                                                  style:
                                                      AppTextStyles.robotoLight(
                                                    color: AppColors.primary,
                                                    size: 12.0,
                                                  ),
                                                ),
                                                Text(
                                                  holder.name ?? '',
                                                  style: AppTextStyles
                                                      .robotoMedium(
                                                    color: AppColors.gray,
                                                    size: 14.0,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 8.0,
                                                ),

                                                ///Plano e validade
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child:

                                                          ///Plano
                                                          Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'plano',
                                                            style: AppTextStyles
                                                                .robotoLight(
                                                              color: AppColors
                                                                  .primary,
                                                              size: 12.0,
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            width: screenWidth *
                                                                0.5,
                                                            child: Text(
                                                              snapshot.data
                                                                  .toString(),
                                                              style: AppTextStyles
                                                                  .robotoMedium(
                                                                color: AppColors
                                                                    .gray,
                                                                size: 14.0,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ///Infos de contato
                          contact(),
                        ],
                      );
                    } else {
                      context.loaderOverlay.show();
                      return Container();
                    }
                  });
          }
        });
  }

  Widget contact() {
    return socialMediaButtons(context);
  }
}
