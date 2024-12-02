import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
//import 'package:picovoice_sample/porcupine_manager_provider.dart';
import 'package:porcupine_flutter/porcupine_error.dart';
import 'package:porcupine_flutter/porcupine_manager.dart';
import 'package:wakeword/porcupine_manager_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _manager = ref.watch(porcupineManagerProvider);
    final _detected = ref.watch(detectedNumberProvider);
    print("$_detected state");

    return Scaffold(
      appBar: AppBar(
        title: Text('app test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _manager.when(
                data: (manager) {
                  // manager.start();
                  return Text(
                    _detected ? 'detected!' : "waiting..",
                    style: Theme.of(context).textTheme.headlineMedium,
                  );
                },
                error: (error, stackTrace) => Text(error.toString()),
                loading: () => CircularProgressIndicator()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print('toggle');
          ref.read(detectedNumberProvider.notifier).state = false;
        },
        tooltip: 'Toggle',
        child: Icon(_detected ? Icons.toggle_off : Icons.toggle_on),
      ),
    );
  }
}
