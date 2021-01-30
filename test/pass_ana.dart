import 'package:hidden_box/utils/utils.dart';

void main() {
  var pass = "Az0@";
  int res = Utils.analysisPassword(pass);

  assert(res == 80);
}
