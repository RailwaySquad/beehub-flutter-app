import 'package:intl/intl.dart';
class TFormatter{
  static String formatDate(DateTime? date){
    date ??= DateTime.now();
    return DateFormat('dd-MMM-yyyy').format(date);
  }
  static String formatCurrency (double amount){
    return NumberFormat.currency(locale: 'en_US',symbol: '\$').format(amount);
  }
  static String formatPhoneNumber(String phone){
    // Assuming a 10 digit VN phone number format: 0919 941 037
    if(phone.length == 10 || phone.length==11){
      return '${phone.substring(0,4)} ${phone.substring(4,7)} ${phone.substring(7)}';
    }
    return phone;
  }
  
}