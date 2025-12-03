import 'package:get/get.dart';
import 'package:pokedex/app/models/pokemon_model.dart';
import 'package:pokedex/app/services/api_service.dart';

class PokemonSpeciesController extends GetxController {
  final ApiService _apiService = ApiService();
  
  final Rx<PokemonSpecies?> species = Rx<PokemonSpecies?>(null);
  final Rx<EvolutionChain?> evolutionChain = Rx<EvolutionChain?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchSpeciesAndEvolution(int id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      final speciesData = await _apiService.getPokemonSpecies(id);
      species.value = speciesData;
      
      if (speciesData.evolutionChain.id != null) {
        final evolutionData = await _apiService.getEvolutionChain(
          speciesData.evolutionChain.id!,
        );
        evolutionChain.value = evolutionData;
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}