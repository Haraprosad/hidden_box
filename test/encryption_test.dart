import 'package:hidden_box/utils/encrtypt.dart';

void main() {
  var start = DateTime.now();
  print(start);
  var encryptor = initEncryptor("DATA" * 4);
  var pass = encryptString(encryptor, "Niloy" * 4);
  print(pass);

  var out = decryptString(encryptor, pass);
  print(out);
  print(DateTime.now());
  print(DateTime.now().difference(start));
}
