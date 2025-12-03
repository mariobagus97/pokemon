import 'package:get/get.dart';
import 'package:pokedex/app/models/pokemon_model.dart';
import 'package:pokedex/app/services/api_service.dart';

class PokemonDetailController extends GetxController {
  final ApiService _apiService = ApiService();

  final Rx<PokemonDetail?> pokemonDetail = Rx<PokemonDetail?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  Future<void> fetchPokemonDetail(dynamic idOrName) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _apiService.getPokemonDetail(idOrName);
      pokemonDetail.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
