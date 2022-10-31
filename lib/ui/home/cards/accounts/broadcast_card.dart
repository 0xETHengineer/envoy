// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'package:envoy/business/exchange_rate.dart';
import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/home/cards/accounts/qr_tab.dart';
import 'package:envoy/ui/home/cards/navigation_card.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:envoy/generated/l10n.dart';
import 'package:envoy/ui/pages/scanner_page.dart';
import 'package:wallet/wallet.dart';
import 'package:envoy/ui/envoy_icons.dart';
import 'package:envoy/ui/amount.dart';

import '../../../../business/account.dart';
import '../../../../business/devices.dart';
import '../../../envoy_button.dart';

//                         account.wallet
//                             .broadcastTx(
//                                 Settings()
//                                     .electrumAddress(account.wallet.network),
//                                 Tor().port,
//                                 decoded.rawTx)
//                             .then((_) {
//                           navigator!.pop(depth: 3);
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(S().envoy_psbt_transaction_sent),
//                           ));
//                         }, onError: (_) {
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                             content: Text(S().envoy_psbt_transaction_not_sent),
//                           ));
//                         });

//ignore: must_be_immutable
class BroadcastCard extends StatelessWidget with NavigationCard {
  final Account account;
  final Psbt psbt;

  BroadcastCard(this.account, this.psbt, {CardNavigator? navigationCallback})
      : super(key: UniqueKey()) {
    optionsWidget = null;
    modal = true;
    title = S().envoy_home_accounts.toUpperCase();
    navigator = navigationCallback;
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  "Your transaction is ready to be sent",
                  style: Theme.of(context).textTheme.headline5,
                ),
                Text(
                  "Confirm the transaction details are correct before sending.",
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(
                  height: 40,
                ),
                AccountTab(
                  title: account.name,
                  account: account,
                  subtitle: Devices().getDeviceName(account.deviceSerial),
                  widget: Column(
                    children: [
                      ListTile(
                        title: Text("Amount"),
                        leading: Icon(EnvoyIcons.accounts),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              getFormattedAmount(-psbt.amount),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                                ExchangeRate().getFormattedAmount(-psbt.amount),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .color))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      ListTile(
                        title: Text("Fee"),
                        leading: Icon(Icons.transfer_within_a_station_rounded),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              getFormattedAmount(psbt.fee),
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(ExchangeRate().getFormattedAmount(psbt.fee),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .caption!
                                            .color))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                      Text(
                        "Transaction ID:",
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        psbt.txid,
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ],
                  ),
                ),
              ]),
        ),
        Padding(
          padding: EdgeInsets.all(50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              EnvoyButton(
                "Cancel",
                onTap: () {},
                light: true,
              ),
              EnvoyButton(
                "Send Transaction",
                onTap: () {
                  // Jump to spinner man
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
