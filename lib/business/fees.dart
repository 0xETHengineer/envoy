// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:async';
import 'dart:convert';
import 'package:envoy/business/local_storage.dart';
import 'package:http_tor/http_tor.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:tor/tor.dart';
import 'package:wallet/wallet.dart';
import 'package:envoy/business/fee_rates.dart';

// Generated
part 'fees.g.dart';

LocalStorage _ls = LocalStorage();

@JsonSerializable()
class Fees {
  // All in BTC per kb
  double fastRate(Network network) {
    return fees[network]!.mempoolFastestRate;
  }

  double slowRate(Network network) {
    return fees[network]!.mempoolHourRate;
  }

  static _defaultFees() {
    return {Network.Mainnet: FeeRates(), Network.Testnet: FeeRates()};
  }

  static _feesToJson(Map<Network, FeeRates> fees) {
    Map<String, dynamic> jsonMap = {};
    for (var entry in fees.entries) {
      jsonMap[entry.key.name] = entry.value.toJson();
    }

    return jsonMap;
  }

  static _feesFromJson(Map<String, dynamic> fees) {
    Map<Network, FeeRates> map = {};
    for (var entry in fees.entries) {
      map[Network.values.byName(entry.key)] = FeeRates.fromJson(entry.value);
    }

    return map;
  }

  @JsonKey(
      defaultValue: _defaultFees, toJson: _feesToJson, fromJson: _feesFromJson)
  var fees = _defaultFees();

  static const String FEE_RATE_PREFS = "fees";
  static final Fees _instance = Fees._internal();

  static const _mempoolUrls = {
    Network.Mainnet: "https://mempool.space/api/v1/fees/recommended",
    Network.Testnet: "https://mempool.space/testnet/api/v1/fees/recommended",
    Network.Signet: "https://mempool.space/signet/api/v1/fees/recommended"
  };

  factory Fees() {
    return _instance;
  }

  static Future<Fees> init() async {
    var singleton = Fees._instance;
    return singleton;
  }

  Fees._internal() {
    print("Instance of Fees created!");

    // Fetch the latest from mempool.space
    _getRates();

    // Refresh from time to time
    Timer.periodic(Duration(minutes: 5), (_) {
      _getRates();
    });
  }

  void _getRates() {
    // Just mainnet and testnet for now
    _getMempoolRates(Network.Mainnet);
    _getMempoolRates(Network.Testnet);
  }

  static restore() {
    if (_ls.prefs.containsKey(FEE_RATE_PREFS)) {
      var storedFees = jsonDecode(_ls.prefs.getString(FEE_RATE_PREFS)!);
      Fees.fromJson(storedFees);
    }

    Fees.init();
  }

  _storeRates() {
    String json = jsonEncode(this);
    _ls.prefs.setString(FEE_RATE_PREFS, json);
  }

  _getMempoolRates(Network network) {
    HttpTor(Tor()).get(_mempoolUrls[network]!).then((response) {
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        fees[network]!.mempoolFastestRate =
            json["fastestFee"].toDouble() / 100000.0;
        fees[network]!.mempoolHalfHourRate =
            json["halfHourFee"].toDouble() / 100000.0;
        fees[network]!.mempoolHourRate = json["hourFee"].toDouble() / 100000.0;
        fees[network]!.mempoolEconomyRate =
            json["economyFee"].toDouble() / 100000.0;
        fees[network]!.mempoolMinimumRate =
            json["minimumFee"].toDouble() / 100000.0;

        _storeRates();
      } else {
        throw Exception("Couldn't get mempool.space fees");
      }
    });
  }

  // Generated
  factory Fees.fromJson(Map<String, dynamic> json) => _$FeesFromJson(json);

  Map<String, dynamic> toJson() => _$FeesToJson(this);
}
