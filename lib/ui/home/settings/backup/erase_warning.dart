// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:io';
import 'package:envoy/business/envoy_seed.dart';
import 'package:envoy/ui/envoy_button.dart';
import 'package:envoy/ui/envoy_method_channel.dart';
import 'package:envoy/ui/onboard/manual/widgets/mnemonic_grid_widget.dart';
import 'package:envoy/ui/onboard/onboard_page_wrapper.dart';
import 'package:envoy/ui/onboard/onboarding_page.dart';
import 'package:envoy/ui/onboard/wallet_setup_success.dart';
import 'package:envoy/ui/widgets/blur_dialog.dart';
import 'package:flutter/material.dart';
import 'package:envoy/generated/l10n.dart';

import 'package:envoy/business/account_manager.dart';
import 'package:envoy/ui/onboard/manual/manual_setup.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:envoy/ui/envoy_colors.dart';
import 'package:envoy/ui/state/home_page_state.dart';
import 'package:rive/rive.dart' as Rive;

class EraseWalletsAndBackupsWarning extends StatefulWidget {
  const EraseWalletsAndBackupsWarning({Key? key}) : super(key: key);

  @override
  State<EraseWalletsAndBackupsWarning> createState() =>
      _EraseWalletsAndBackupsWarningState();
}

class _EraseWalletsAndBackupsWarningState
    extends State<EraseWalletsAndBackupsWarning> {
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Column(
              children: [
                Image.asset(
                  "assets/exclamation_triangle.png",
                  height: 80,
                  width: 80,
                ),
                Padding(padding: EdgeInsets.all(4)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                      S().backups_erase_wallets_and_backups_modal_1_2_ios_heading,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    child: SizedBox(
                      height: 200,
                      child: PageView(
                        controller: _pageController,
                        children: [
                          Text(
                            Platform.isAndroid
                                ? S()
                                    .backups_erase_wallets_and_backups_modal_1_2_android_subheading
                                : S()
                                    .backups_erase_wallets_and_backups_modal_1_2_ios_subheading,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            S().backups_erase_wallets_and_backups_modal_2_2_subheading,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )),
                DotsIndicator(
                  totalPages: 2,
                  pageController: _pageController,
                ),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
            OnboardingButton(
                type: EnvoyButtonTypes.tertiary,
                label: S().backups_erase_wallets_and_backups_modal_1_2_ios_cta1,
                onTap: () {
                  Navigator.pop(context);
                }),
            OnboardingButton(
                label: S().backups_erase_wallets_and_backups_modal_1_2_ios_cta,
                onTap: () {
                  int currentPage = _pageController.page?.toInt() ?? 0;
                  if (currentPage == 1) {
                    if (AccountManager().hotWalletAccountsEmpty()) {
                      // Safe to delete
                      displaySeedBeforeNuke(context);
                    } else {
                      showEnvoyDialog(
                          context: context,
                          dialog: EraseWalletsBalanceWarning());
                    }
                  } else {
                    _pageController.nextPage(
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeInOut);
                  }
                }),
            Padding(padding: EdgeInsets.all(12)),
          ],
        ),
      ),
    );
  }
}

class EraseWalletsBalanceWarning extends ConsumerStatefulWidget {
  const EraseWalletsBalanceWarning({Key? key}) : super(key: key);

  @override
  ConsumerState<EraseWalletsBalanceWarning> createState() =>
      _EraseWalletsBalanceWarningState();
}

class _EraseWalletsBalanceWarningState
    extends ConsumerState<EraseWalletsBalanceWarning> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Column(
              children: [
                Image.asset(
                  "assets/exclamation_triangle.png",
                  height: 80,
                  width: 80,
                ),
                Padding(padding: EdgeInsets.all(4)),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                      S().backups_erase_wallets_and_backups_modal_1_2_ios_heading,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    S().erase_wallet_with_balance_modal_subheading,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
            OnboardingButton(
                type: EnvoyButtonTypes.tertiary,
                label: S().erase_wallet_with_balance_modal_CTA2,
                textStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: EnvoyColors.danger),
                onTap: () {
                  displaySeedBeforeNuke(context);
                }),
            OnboardingButton(
                label: S().erase_wallet_with_balance_modal_CTA1,
                onTap: () {
                  // Show home page and navigate to accounts
                  ref.read(homePageBackgroundProvider.notifier).state =
                      HomePageBackgroundState.hidden;
                  ref.read(homePageTabProvider.notifier).state =
                      HomePageTabState.accounts;
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                }),
            Padding(padding: EdgeInsets.all(12)),
          ],
        ),
      ),
    );
  }
}

class EraseWalletsConfirmation extends ConsumerStatefulWidget {
  const EraseWalletsConfirmation({Key? key}) : super(key: key);

  @override
  ConsumerState<EraseWalletsConfirmation> createState() =>
      _EraseWalletsConfirmationState();
}

class _EraseWalletsConfirmationState
    extends ConsumerState<EraseWalletsConfirmation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Column(
              children: [
                Image.asset(
                  "assets/exclamation_triangle.png",
                  height: 80,
                  width: 80,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    S().delete_wallet_for_good_modal_subheading,
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(padding: EdgeInsets.all(5)),
              ],
            ),
            OnboardingButton(
                type: EnvoyButtonTypes.tertiary,
                label: S().delete_wallet_for_good_modal_cta2,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => EraseProgress()));
                }),
            OnboardingButton(
                label: S().delete_wallet_for_good_modal_cta1,
                onTap: () {
                  Navigator.of(context).popUntil(ModalRoute.withName("/"));
                }),
            Padding(padding: EdgeInsets.all(12)),
          ],
        ),
      ),
    );
  }
}

void displaySeedBeforeNuke(BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return SeedIntroScreen(
      mode: SeedIntroScreenType.verify,
    );
  }));
}

class EraseProgress extends ConsumerStatefulWidget {
  const EraseProgress({Key? key}) : super(key: key);

  @override
  ConsumerState<EraseProgress> createState() => _EraseProgressState();
}

class _EraseProgressState extends ConsumerState<EraseProgress> {
  Rive.StateMachineController? _stateMachineController;

  bool _deleteInProgress = true;

  @override
  Widget build(BuildContext context) {
    return OnboardPageBackground(
        child: Material(
      color: Colors.transparent,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 260,
                child: Rive.RiveAnimation.asset(
                  "assets/envoy_loader.riv",
                  fit: BoxFit.contain,
                  onInit: (artboard) {
                    _stateMachineController =
                        Rive.StateMachineController.fromArtboard(
                            artboard, 'STM');
                    artboard.addController(_stateMachineController!);
                    _stateMachineController
                        ?.findInput<bool>("indeterminate")
                        ?.change(true);
                    _onInit();
                  },
                ),
              ),
            ),
            SliverPadding(padding: EdgeInsets.all(28)),
            SliverToBoxAdapter(
              child: Builder(
                builder: (context) {
                  String title = S().delete_wallet_for_good_loading_heading;
                  if (!_deleteInProgress) {
                    title = S().delete_wallet_for_good_success_heading;
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Padding(padding: EdgeInsets.all(18)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _onInit() async {
    try {
      setState(() {
        _deleteInProgress = true;
      });
      _stateMachineController?.findInput<bool>("indeterminate")?.change(true);
      _stateMachineController?.findInput<bool>("happy")?.change(false);
      _stateMachineController?.findInput<bool>("unhappy")?.change(false);
      //wait for animation
      await Future.delayed(Duration(seconds: 1));
      await EnvoySeed().delete();
      _stateMachineController?.findInput<bool>("indeterminate")?.change(false);
      _stateMachineController?.findInput<bool>("happy")?.change(true);
      _stateMachineController?.findInput<bool>("unhappy")?.change(false);
      setState(() {
        _deleteInProgress = false;
      });
      await Future.delayed(Duration(milliseconds: 2000));

      //Show android backup info
      if (Platform.isAndroid) {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
        await Future.delayed(Duration(milliseconds: 300));
        await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => AndroidBackupWarning(
                  onContinue: () async {
                    // Show home page and navigate to accounts
                    ref.read(homePageBackgroundProvider.notifier).state =
                        HomePageBackgroundState.hidden;
                    ref.read(homePageTabProvider.notifier).state =
                        HomePageTabState.accounts;
                    await Future.delayed(Duration(milliseconds: 100));
                    Navigator.of(context).popUntil(ModalRoute.withName("/"));
                  },
                )));
      } else {
        Navigator.of(context).popUntil(ModalRoute.withName("/"));
        //wait for pop animation to finish
        await Future.delayed(Duration(milliseconds: 300));
        // Show home page and navigate to accounts
        ref.read(homePageBackgroundProvider.notifier).state =
            HomePageBackgroundState.hidden;
        ref.read(homePageTabProvider.notifier).state =
            HomePageTabState.accounts;
      }
    } catch (e) {}
  }
}

class AndroidBackupWarning extends StatelessWidget {
  final bool skipSuccessScreen;
  final GestureTapCallback? onContinue;

  const AndroidBackupWarning(
      {Key? key, this.skipSuccessScreen = false, this.onContinue = null})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool _iphoneSE = MediaQuery.of(context).size.height < 700;
    return WillPopScope(
      onWillPop: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WalletSetupSuccess();
        }));
        return Future.value(false);
      },
      child: OnboardPageBackground(
        child: Material(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Image.asset(
                    "assets/exclamation_icon.png",
                    height: 180,
                    width: 180,
                  ),
                  height: _iphoneSE ? 220 : 250,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        S().delete_wallet_for_good_instant_android_heading,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Padding(padding: EdgeInsets.all(12)),
                      LinkText(
                        text: S()
                            .delete_wallet_for_good_instant_android_subheading,
                        onTap: () {
                          openAndroidSettings();
                        },
                        linkStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 14, color: EnvoyColors.blue),
                        textStyle: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontSize: 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      OnboardingButton(
                        type: EnvoyButtonTypes.tertiary,
                        label: S().delete_wallet_for_good_instant_android_cta2,
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return WalletSetupSuccess();
                          }));
                        },
                      ),
                      OnboardingButton(
                        label: S().delete_wallet_for_good_instant_android_cta1,
                        onTap: () {
                          openAndroidSettings();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
            color: Colors.transparent),
      ),
    );
  }
}
