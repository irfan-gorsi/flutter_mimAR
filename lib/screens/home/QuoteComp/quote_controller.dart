import 'package:mimar/screens/home/QuoteComp/quote_apiservice.dart';

class QuoteController {
  Future<Map<String, dynamic>> fetchQuote() async {
    return await QuoteApiService.getRandomQuote();
  }
}
