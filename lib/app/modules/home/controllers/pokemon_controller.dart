import 'package:get/get.dart';
import 'package:pokedex/app/models/pokemon_model.dart';
import 'package:pokedex/app/services/api_service.dart';

class PokemonController extends GetxController {
  final ApiService _apiService = ApiService();

  final RxList<Pokemon> pokemonList = <Pokemon>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentOffset = 0.obs;
  final RxBool hasMore = true.obs;
  final Rx<PokemonSpecies?> species = Rx<PokemonSpecies?>(null);
  final Rx<EvolutionChain?> evolutionChain = Rx<EvolutionChain?>(null);

  final int limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchPokemonList();
  }

  Future<void> fetchPokemonList() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.getPokemonList(offset: 0, limit: limit);

      pokemonList.value = result.results;
      currentOffset.value = limit;
      hasMore.value = result.next != null;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMorePokemon() async {
    if (isLoadingMore.value || !hasMore.value) return;

    try {
      isLoadingMore.value = true;

      final result = await _apiService.getPokemonList(
        offset: currentOffset.value,
        limit: limit,
      );

      pokemonList.addAll(result.results);
      currentOffset.value += limit;
      hasMore.value = result.next != null;
    } catch (e) {
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<void> refreshPokemonList() async {
    currentOffset.value = 0;
    hasMore.value = true;
    await fetchPokemonList();
  }

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

