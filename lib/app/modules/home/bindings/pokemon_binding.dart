import 'package:get/get.dart';
import 'package:pokedex/app/modules/home/controllers/pokemon_detail_controller.dart';
import 'package:pokedex/app/modules/home/controllers/pokemon_species_controller.dart';

import '../controllers/pokemon_controller.dart';

class PokemonBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<PokemonController>(PokemonController());
    Get.put<PokemonDetailController>(PokemonDetailController());
    Get.put<PokemonSpeciesController>(PokemonSpeciesController());
  }
}
