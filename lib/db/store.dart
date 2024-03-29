import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_fimber/flutter_fimber.dart';
import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:hidden_box/db/db_constant.dart';
import 'package:hidden_box/db/model/cards_model.dart';
import 'package:hidden_box/db/model/categories_model.dart';
import 'package:hidden_box/db/model/notes.dart';
import 'package:hidden_box/db/model/password_model.dart';
import 'package:hidden_box/ext/ext.dart';

@lazySingleton
class Store {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ***********************************
  // ************PASSWORD***************
  // ***********************************

  Future<bool> addPassword(PasswordModel model, {bool update = false}) async {
    try {
      var pass = _firestore.collection(DbConstant.PASSWORD);
      var options = SetOptions(merge: update);
      await pass.doc(model.uuid).set(model.toMap(), options);
      return true;
    } catch (e, s) {
      Fimber.e("Error on add password", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<bool> deletePassword(String uuid) async {
    try {
      var pass = _firestore.collection(DbConstant.PASSWORD);
      await pass.doc(uuid).delete();
      return true;
    } catch (e, s) {
      Fimber.e("Error on delete password", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<QuerySnapshot> getPassword() async {
    var pass = _firestore.collection(DbConstant.PASSWORD);
    return await pass.get();
  }

  Future<QuerySnapshot> getCategoryPassword(String categoryID) async {
    var pass = _firestore.collection(DbConstant.PASSWORD);
    return await pass.where("category", isEqualTo: categoryID).get();
  }

  Future<bool> addNote(NotesModel model, {bool update = false}) async {
    try {
      var cat = _firestore.collection(DbConstant.NOTES);
      var options = SetOptions(merge: update);
      await cat.doc(model.uuid).set(model.toMap(), options);
      return true;
    } catch (e, s) {
      Fimber.e("Error on categories", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<bool> deleteNote(String uuid) async {
    try {
      var cat = _firestore.collection(DbConstant.NOTES);
      await cat.doc(uuid).delete();
      return true;
    } catch (e, s) {
      Fimber.e("Error on delete notes", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<QuerySnapshot> getNotes(String uuid) async {
    var pass = _firestore.collection(DbConstant.NOTES);
    return await pass.where("passwordUUID", isEqualTo: uuid).get();
  }

  // ***********************************
  // ************CATEGORY***************
  // ***********************************

  Future<bool> addCategory(CategoriesModel model, {bool update = false}) async {
    try {
      var cat = _firestore.collection(DbConstant.CATEGORIES);
      var options = SetOptions(merge: update);
      await cat.doc(model.uuid).set(model.toMap(), options);
      return true;
    } catch (e, s) {
      Fimber.e("Error on add category", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<QuerySnapshot> getCategories() async {
    var cat = _firestore.collection(DbConstant.CATEGORIES);
    return await cat.get();
  }

  Future<bool> deleteCategory(String uuid) async {
    try {
      var pass = _firestore.collection(DbConstant.CATEGORIES);
      await pass.doc(uuid).delete();
      return true;
    } catch (e, s) {
      Fimber.e("Error on delete category", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<bool> deleteCategoryPasswords(String uuid) async {
    try {
      var pass = _firestore.collection(DbConstant.PASSWORD);
      var list = await pass.where("category", isEqualTo: uuid).get();

      for (QueryDocumentSnapshot doc in list.docs) {
        if (doc.exists) {
          var uuid = doc.data()['uuid'];
          await pass.doc(uuid).delete();
        }
      }

      return true;
    } catch (e, s) {
      Fimber.e("Error on delete category", ex: e, stacktrace: s);
      return false;
    }
  }

  // ***********************************
  // ************CARDS***************
  // ***********************************

  Future<bool> addCard(CardsModel model, {bool update = false}) async {
    try {
      var card = _firestore.collection(DbConstant.CARDS);
      var options = SetOptions(merge: update);

      await card.doc(model.uuid).set(model.toMap(), options);
      return true;
    } catch (e, s) {
      Fimber.e("Error on add card", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<bool> deleteCard(String uuid) async {
    try {
      var card = _firestore.collection(DbConstant.CARDS);
      await card.doc(uuid).delete();
      return true;
    } catch (e, s) {
      Fimber.e("Error on delete card", ex: e, stacktrace: s);
      return false;
    }
  }

  Future<QuerySnapshot> getCards() async {
    var card = _firestore.collection(DbConstant.CARDS);
    return await card.get();
  }

  // ***********************************
  // **********MASTER PASSWORD**********
  // ***********************************

  Future<bool> addMasterPassword(String pass) async {
    try {
      Encrypter encrypter = Get.find(tag: "ENCRYPT");
      var en = pass.encrypt(encrypter);

      var data = Map<String, String>();
      data['psssword'] = en;

      var options = SetOptions(merge: true);

      await _firestore
          .collection(DbConstant.MASTERPASS)
          .doc("MasterPass")
          .set(data, options);

      return true;
    } catch (e, s) {
      Fimber.e("Error on add master pass", ex: e, stacktrace: s);
      //if error then return false
      return false;
    }
  }

  Future<DocumentSnapshot> getMasterPass() async {
    return await _firestore
        .collection(DbConstant.MASTERPASS)
        .doc("MasterPass")
        .get();
  }

  Future<bool> checkMasterPassword() async {
    try {
      var data = await _firestore
          .collection(DbConstant.MASTERPASS)
          .doc("MasterPass")
          .get();

      return data.exists;
    } catch (e, s) {
      Fimber.e("Error on checking master password", ex: e, stacktrace: s);
      return false;
    }
  }

  // ***********************************
  // *********Security Question*********
  // ***********************************

  Future<bool> addMasterSecurityQuestion(String question, String ans) async {
    try {
      Encrypter encrypter = Get.find(tag: "ENCRYPT");
      var en = ans.encrypt(encrypter);

      var data = Map<String, String>();
      data['question'] = question;
      data['answer'] = en;

      var options = SetOptions(merge: true);

      await _firestore
          .collection(DbConstant.SECURITY_QUESTION)
          .doc(DbConstant.SECURITY_QUESTION)
          .set(data, options);

      return true;
    } catch (e, s) {
      Fimber.e("Error on add master pass", ex: e, stacktrace: s);
      //if error then return false
      return false;
    }
  }

  Future<DocumentSnapshot> getSecurityQuestion() async {
    return await _firestore
        .collection(DbConstant.SECURITY_QUESTION)
        .doc(DbConstant.SECURITY_QUESTION)
        .get();
  }
}
