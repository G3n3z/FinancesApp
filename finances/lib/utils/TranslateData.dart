import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TranslateData{

  static Map<String,Map<String, String>> daysPerLanguage = {
    "PT" : {
      "MON" :   "SEG", "TUE" : "TER", "WED" : "QUA", "THU" : "QUI", "FRI" : "SEX", "SAT" : "SAB", "SUN" : "DOM",

    }
  };

  static Map<String,Map<String, String>> monthPerLanguage = {
    "PT" : {
      "JAN" : "JAN", "FEB" : "FEV", "MAR" : "MAR", "APR" : "ABR", "MAY" : "MAI", "JUN" : "JUN", "JUL" : "JUL",
      "AGU" : "AGO", "SEP" : "SET", "OCT" : "OUT", "NOV" : "NOV", "DEC" : "DEZ"
    }
  };

  static String translate (DateTime data, String language){
    String day = data.day.toString();
    String month = DateFormat.MMM().format(data).toUpperCase();
    String dayExtensive = DateFormat.E().format(data).toUpperCase();
    Map<String, String>? days = daysPerLanguage["PT"];
    Map<String, String>? months = monthPerLanguage["PT"];
    String? dayTranslate = null;
    String? monthTranslate = null;
    if(days != null) {
      dayTranslate = days[dayExtensive];
    }
    if(months != null){
      monthTranslate = months[month];
    }
    return (dayTranslate ?? dayExtensive ) + ", " + day + " " + (monthTranslate ?? month);
  }
}