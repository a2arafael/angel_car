class AppFormat{

  static String? monthToString(String? date){
    var dt = date?.split(" ");
    var month = dt?[1].split("/")[1];
    String? monthString = "";
    switch(month){
      case "01":
      case "1": monthString = "JAN"; break;
      case "02":
      case "2": monthString = "FEV"; break;
      case "03":
      case "3": monthString = "MAR"; break;
      case "04":
      case "4": monthString = "ABR"; break;
      case "05":
      case "5": monthString = "MAI"; break;
      case "06":
      case "6": monthString = "JUN"; break;
      case "07":
      case "7": monthString = "JUL"; break;
      case "08":
      case "8": monthString = "AGO"; break;
      case "09":
      case "9": monthString = "SET"; break;
      case "10":monthString = "OUT"; break;
      case "11": monthString = "NOV"; break;
      case "12": monthString = "DEZ"; break;
    }
    return monthString;
  }

  static String? dayOfDate(String? date){
    var dt = date?.split(" ");
    return dt?[1].split("/")[0];
  }

  static String? dateTime(String? date){
    var dt = date?.split(" ");
    return dt?[3];
  }

  static String initSalutation() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return '*Bom dia!*';
    }
    if (hour < 18) {
      return '*Boa tarde!*';
    }
    return '*Boa noite!*';
  }
}