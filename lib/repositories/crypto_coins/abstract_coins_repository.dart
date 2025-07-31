import 'package:crypto_app/repositories/crypto_coins/models/crypto_coin.dart';

abstract class AbstractCoinsRepository {
  Future<List<CryptoCoin>> getCoinsList();
  Future<CryptoCoin> getCoinDetail(String currencyCode);
}