import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:hidden_box/di/config_inject.config.dart';

final getIt = GetIt.instance;

@InjectableInit(generateForDir: ["lib/di", "lib"])
void configureDependencies() => $initGetIt(getIt);
