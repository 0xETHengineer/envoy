import 'package:envoy/ui/indicator_shield.dart';
import 'package:flutter/material.dart';
import 'package:tor/tor.dart';
import 'package:envoy/generated/l10n.dart';

class TorLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: IndicatorShield(),
        ),
        Opacity(
          opacity: 0.50,
          child: Text(Tor().enabled && !Tor().circuitEstablished
              ? "Establishing a private connection over Tor"
              : "Loading over the Tor network"),
        )
      ],
    );
  }

}