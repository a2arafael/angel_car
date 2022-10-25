import 'package:flutter/material.dart';

class AppUtils {

  static String unmaskDocument(String? document) {
    assert(document != null);
    return document!
        .replaceAll(".", "")
        .replaceAll("-", "");
  }

  static String unmaskPhone(String? phone) {
    if(phone != null){
      return removeDDIPhone(phone
          .replaceAll(" ", "")
          .replaceAll("-", "")
          .replaceAll("(", "")
          .replaceAll(")", ""));
    }else{
      return "";
    }
  }

  static String removeDDIPhone(String phone) {
    var ph;
    if (phone.length >= 13 && phone.split("")[4] == "9" &&
        phone.split("")[0] == "5" && phone.split("")[1] == "5") {
      ph = phone.substring(2, phone.length);
    } else if (phone.length == 11 && phone.split("")[4] == "9"){
      ph = phone;
    } else {
      ph = "";
    }
    return ph;
  }

  static String maskPhone(String? phone) {
    assert(phone != null);
    if (phone!.contains('(') && phone.contains(')') && phone.contains('-')) {
      return phone;
    } else {
      return '(${phone.substring(0, 2)}) ${phone.substring(2, 7)} - ${phone
          .substring(7)}';
    }
  }

  static String hideEmail(String? email, bool isVisible) {
    assert(email != null);
    String em = email!.split('@')[0];
    if (isVisible) {
      return email;
    } else {
      return '${em.substring(0, 1)}******@*********${email.split('@')[1]
          .substring(email.split('@')[1].length - 1)}';
    }
  }

  static void hideKeyboard({required BuildContext context}) {
    FocusScope.of(context).unfocus();
  }


  static String dateFormat(String? date) {
    assert(date != null);
    var df = DateTime.parse(date!.split("T")[0]);
    var month, day;
    switch (df.month) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        month = "0${df.month}";
        break;
      default:
        month = df.month;
    }

    switch (df.day) {
      case 1:
      case 2:
      case 3:
      case 4:
      case 5:
      case 6:
      case 7:
      case 8:
      case 9:
        day = "0${df.day}";
        break;
      default:
        day = df.day;
    }

    return '$day/$month/${df.year}';
  }
}
