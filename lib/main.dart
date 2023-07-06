import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/firebase_options.dart';
import 'package:sample/view_model/app_lifecycle_state_provider.dart';
import 'package:sample/view_model/view_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends ConsumerWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(locationProvider(""));
    ref.listen<AppLifecycleState>(
      appLifecycleStateProvider,
      (previous, next) => print('Previous: $previous, Next: $next'),
    );

    return state.when(
      data: (location) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
          ),
          body: Center(
            child: Column(
              children: [
                Text("現在位置 $location"),
              ],
            ),
          ),
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('Error: $e'),
    );
  }
}
