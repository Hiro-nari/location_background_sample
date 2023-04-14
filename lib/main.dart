import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/firebase_options.dart';
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
    final model = ref.watch(viewModel);

    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text("ページネーション"),
          actions: [
            Row(
              children: [
                // IconButton(
                //     onPressed: () => model.addNames(ref, names),
                //     icon: const Icon(Icons.add)),
                TextButton(onPressed: () => model.getNames(ref), child: const Text("取得",style: TextStyle(color: Colors.white),))
              ],
            ),
          ]),
      body: model.stackedNameList.isEmpty //ここで見ているのは、イメージ図の「名前リスト２」です
          ? const Center(child: Text("まだ何もありません"))
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: model.stackedNameList.length,
                        itemBuilder: (context, int index) {
                          final name = model.stackedNameList[index];
                          return Center(
                              child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(name),
                          ));
                        }),
                    model.currentNameList.isEmpty//ここで見ているのは、イメージ図の「名前リスト１」です
                        ? const Center(child: Text("結果は以上です"))
                        : TextButton(
                            onPressed: () => model.getNamesNext(ref),
                            child: const Text("もっと読み込む"))
                  ],
                ),
              ),
            ),
    );
  }
}
