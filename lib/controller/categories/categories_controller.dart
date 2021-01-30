import 'package:get/get.dart';
import 'package:injectable/injectable.dart';
import 'package:hidden_box/controller/DataStatus.dart';
import 'package:hidden_box/db/model/password_model.dart';
import 'package:hidden_box/db/store.dart';

@lazySingleton
class CategoriesController extends GetxController {
  static CategoriesController get to => Get.find();

  Store _store;

  CategoriesController(this._store);

  var passwordModelStatus =
      DataStatus<List<PasswordModel>>(null, DataState.INIT).obs;

  void getAllData(String categoryID) async {
    var cats = await _store.getCategoryPassword(categoryID);
    var models = cats.docs.map((e) {
      return PasswordModel.fromMap(e.data());
    }).toList();

    //now update
    passwordModelStatus.update((val) {
      val.data = models;
      val.state = DataState.LOADED;
    });
  }
}
