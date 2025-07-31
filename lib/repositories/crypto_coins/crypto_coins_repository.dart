
import 'package:crypto_app/repositories/crypto_coins/crypto_coins.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:talker_flutter/talker_flutter.dart';

class CryptoCoinsRepository implements AbstractCoinsRepository{

  CryptoCoinsRepository({required this.dio, required this.cryptoCoinsBox});

  final Dio dio;
  final Box<CryptoCoin> cryptoCoinsBox;

  @override
  Future<List<CryptoCoin>> getCoinsList() async {
    var cryptoCoinList = <CryptoCoin>[];
    try {
      cryptoCoinList = await _fetchCoinsListFromApi();

      final cryptoCoinsMap = { for (var e in cryptoCoinList) e.name: e};
      await cryptoCoinsBox.putAll(cryptoCoinsMap);
    } catch (e,st) {
      GetIt.I<Talker>().handle(e,st);
      cryptoCoinList = cryptoCoinsBox.values.toList();
    }
    
    cryptoCoinList.sort((a, b) => b.details.priceInUSD.compareTo(a.details.priceInUSD));
    return cryptoCoinList;
  }

  Future<List<CryptoCoin>> _fetchCoinsListFromApi() async {
    final response = await dio.get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=BTC,ETH,SOL,AVAX,LUN&tsyms=USD');
    final data = response.data as Map<String,dynamic>;
    final dataRaw = data['RAW'] as Map<String,dynamic>;
    final cryptoCoinList = dataRaw.entries.map((e) {
    final usdData = (
        e.value as Map<String,dynamic>)['USD'] as Map<String,dynamic>;
        final details = CryptoCoinDetail.fromJson(usdData);
        return CryptoCoin(
            name: e.key,
            details: details,
        );
    }).toList();
    return cryptoCoinList;
  }

  @override
  Future<CryptoCoin> getCoinDetail(String currencyCode) async{
    try {
      final coin = await _fetchCoinDetailFromApi(currencyCode);
      cryptoCoinsBox.put(currencyCode, coin);
      return coin;
    } catch (e,st) {
      GetIt.I<Talker>().handle(e,st);
      return cryptoCoinsBox.get(currencyCode)!;
    }
  }

  Future<CryptoCoin> _fetchCoinDetailFromApi(String currencyCode) async {
    final response = await dio.get(
      'https://min-api.cryptocompare.com/data/pricemultifull?fsyms=$currencyCode&tsyms=USD');
    
    final data = response.data as Map<String,dynamic>;
    final dataRaw = data['RAW'] as Map<String,dynamic>;
    final coinData = dataRaw[currencyCode] as Map<String,dynamic>;
    final usdData = coinData['USD'] as Map<String,dynamic>;
    final details = CryptoCoinDetail.fromJson(usdData);
    return CryptoCoin(name: currencyCode, details: details);
  }

}