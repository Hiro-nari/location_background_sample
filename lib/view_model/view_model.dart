
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample/repository/db_manager.dart';

final viewModel = ChangeNotifierProvider((ref) => ViewModel());

class ViewModel with ChangeNotifier {

  List<String> stackedNameList = [];
  List<String> currentNameList = [];

  Future<void> getNames (WidgetRef ref) async {
    stackedNameList = [];
    currentNameList = await ref.read(dbManager).getNames();
    for (var element in currentNameList) {
      stackedNameList.add(element);
    }
    notifyListeners();
  }

  Future<void> getNamesNext (WidgetRef ref) async {
    currentNameList = await ref.read(dbManager).getNamesNext();
    for (var element in currentNameList) {
      stackedNameList.add(element);
    }
    notifyListeners();
  }

  Future<void> deleteNames (WidgetRef ref) async{
   await ref.read(dbManager).deleteNames();
  }

  Future<void> addNames (WidgetRef ref,List<String> names) async{
    await ref.read(dbManager).addNames(names);
  }

}