// SPDX-FileCopyrightText: 2022 Foundation Devices Inc.
//
// SPDX-License-Identifier: GPL-3.0-or-later

import 'dart:async';
import 'package:tor/tor.dart';
import 'package:envoy/business/settings.dart';

enum ConnectivityManagerEvent {
  TorStatusChange,
  TorConnectedDoesntWork,
  ElectrumUnreachable,
  ElectrumReachable
}

class ConnectivityManager {
  bool get torEnabled {
    if (torTemporarilyDisabled) {
      return false;
    }

    return Tor().enabled;
  }

  bool get torCircuitEstablished => Tor().circuitEstablished;
  bool get usingDefaultServer => Settings().usingDefaultElectrumServer;

  bool electrumConnected = true;
  bool nguConnected = false;

  bool torTemporarilyDisabled = false;

  final StreamController<ConnectivityManagerEvent> events =
      StreamController.broadcast();

  static final ConnectivityManager _instance = ConnectivityManager._internal();

  factory ConnectivityManager() {
    return _instance;
  }

  static Future<ConnectivityManager> init() async {
    var singleton = ConnectivityManager._instance;
    return singleton;
  }

  ConnectivityManager._internal() {
    print("Instance of ConnectivityManager created!");

    Tor().events.stream.listen((event) {
      // Nudge listeners
      events.add(ConnectivityManagerEvent.TorStatusChange);
    });
  }

  electrumSuccess() {
    electrumConnected = true;
    events.add(ConnectivityManagerEvent.ElectrumReachable);
  }

  electrumFailure() {
    electrumConnected = false;
    events.add(ConnectivityManagerEvent.ElectrumUnreachable);
  }

  nguSuccess() {
    nguConnected = true;
  }

  nguFailure() {
    nguConnected = false;

    // TODO: consider having a counter of times we have failed?
    restartTor();
    events.add(ConnectivityManagerEvent.TorConnectedDoesntWork);
  }

  restartTor() {
    // ENV-175
    if (torEnabled) {
      print("Restarting Tor");
      Tor().restart();
    }
  }
}