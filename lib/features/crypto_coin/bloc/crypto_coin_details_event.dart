part of 'crypto_coin_details_bloc.dart';

abstract class CryptoCoinDetailsEvent extends Equatable {
  const CryptoCoinDetailsEvent();

  @override
  List<Object> get props => [];
}

class LoadCryptoCoinDetail extends CryptoCoinDetailsEvent {
  const LoadCryptoCoinDetail({
    required this.currencyCode,
  });

  final String currencyCode;

  @override
  List<Object> get props => super.props..add(currencyCode);
}