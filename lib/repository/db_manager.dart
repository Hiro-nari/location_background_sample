
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final dbManager = ChangeNotifierProvider((ref) => DbManager());

class DbManager with ChangeNotifier {
  final db = FirebaseFirestore.instance;
  DocumentSnapshot? lastDoc;


  Future<List<String>> getNames () async{
    var result = <String>[];
   final query = await db.collection("users").limit(10).get();
      if(query.docs.isNotEmpty){
        for (var element in query.docs) {
          result.add(element.data()["name"]);
        }
      lastDoc = query.docs.last;
      }
      return result;
  }


  Future<List<String>> getNamesNext () async{
    var result = <String>[];
    final query = await db.collection("users").startAfterDocument(lastDoc!).limit(10).get();

    if(query.docs.isNotEmpty){
      for (var element in query.docs) {
        result.add(element.data()["name"]);
      }
      lastDoc = query.docs.last;
    }
    return result;
  }

  Future<void>addNames (List<String> names) async {
    await Future.forEach(names, (String name) async {
      final id = const Uuid().v1();
      await db.collection("users").doc(id).set({
        "id": id,
        "name" : name,
      });
    });
  }

  Future<void>deleteNames () async {
    await db.collection("users").get().then((value) async {
    if(value.docs.isNotEmpty){
      await Future.forEach(value.docs, (DocumentSnapshot element) async {
       await element.reference.delete();
      });
    }
    });
  }

}



