import 'package:get/get.dart';
import 'package:pokedex/app/modules/home/views/pokemon_list_screen.dart';

import '../modules/home/bindings/pokemon_binding.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const PokemonListScreen(),
      binding: PokemonBinding(),
    ),
  ];
}
