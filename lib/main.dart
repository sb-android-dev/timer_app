import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:timer_app/timer.dart';
import 'package:timer_app/timer_change_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const _HomeScreen(),
    );
  }
}

class _HomeScreen extends StatefulWidget {
  const _HomeScreen();

  @override
  State<_HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<_HomeScreen> {
  int duration = 30;
  final TextEditingController controller = TextEditingController(text: '');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(maxWidth: 256),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    labelText: 'Enter Duration (in Seconds)',
                    hintText: '30',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onChanged: (value) =>
                      setState(() => duration = int.tryParse(value) ?? 30),
                ),
              ),
              ElevatedButton(
                child: const Text('Open Timer'),
                onPressed: () => _openTimer(duration: int.tryParse(controller.text) ?? 30),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                children: [
                  OutlinedButton(onPressed: () => _openTimer(duration: 60), child: const Text('01:00')),
                  OutlinedButton(onPressed: () => _openTimer(duration: 120), child: const Text('02:00')),
                  OutlinedButton(onPressed: () => _openTimer(duration: 300), child: const Text('05:00')),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _openTimer({required int duration}) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => _TimerScreen(
            duration: duration),
      ),
    );

    for (int i in (result as List<int>)) {
      print(i);
    }
  }
}

class _TimerScreen extends StatelessWidget {
  final int duration;
  final List<int> lapList = [];

  _TimerScreen({required this.duration});

  @override
  Widget build(BuildContext context) {
    TimerChangeNotifier().startTimer(duration,
        timerFormat: TimerFormat.mm_ss_SS, onComplete: () {
      Fluttertoast.showToast(msg: 'Time out!!');
      Navigator.of(context).pop(lapList);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: TimerView(
                timerPrefixText: 'Remaining Time\n',
                timerTextStyle: Theme.of(context).textTheme.displayLarge,
                timerPrefixTextStyle: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            ElevatedButton(
              onPressed: () => TimerChangeNotifier().startTimer(duration),
              child: const Text('Restart Timer'),
            ),
            ElevatedButton(
              onPressed: () => TimerChangeNotifier().resumeTimer(),
              child: const Text('Resume Timer'),
            ),
            ElevatedButton(
              onPressed: () => TimerChangeNotifier().stopTimer(),
              child: const Text('Stop Timer'),
            ),
            ElevatedButton(
              onPressed: () => lapList.add(TimerChangeNotifier().remainingTime),
              child: const Text('Lap'),
            ),
          ],
        ),
      ),
    );
  }
}
