import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'timer_change_notifier.dart';

class TimerView extends StatefulWidget {
  final String? timerPrefixText;
  final TextStyle? timerTextStyle;
  final TextStyle? timerPrefixTextStyle;

  const TimerView({
    super.key,
    this.timerPrefixText,
    this.timerTextStyle,
    this.timerPrefixTextStyle,

  });

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerChangeNotifier>.value(
      value: TimerChangeNotifier(),
      builder: (context, child) {
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: widget.timerPrefixText,
            style: widget.timerPrefixTextStyle ??
                widget.timerTextStyle ??
                Theme.of(context).textTheme.titleSmall,
            children: [
              TextSpan(
                text: context
                    .watch<TimerChangeNotifier>()
                    .formatedRemainingSeconds,
                style: widget.timerTextStyle ?? Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    TimerChangeNotifier().stopTimer();
    super.dispose();
  }
}
