import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokedex/app/modules/home/views/widgets/pokemon_card.dart';
import '../controllers/pokemon_controller.dart';
import 'pokemon_detail_screen.dart';

class PokemonListScreen extends StatelessWidget {
  const PokemonListScreen({super.key});

  Color _getTypeColor(int index) {
    final colors = [
      const Color(0xFF81C784),
      const Color(0xFF81C784),
      const Color(0xFF81C784),
      const Color(0xFFFF8A65),
      const Color(0xFF64B5F6),
      const Color(0xFFBA68C8),
      const Color(0xFFFFD54F),
      const Color(0xFFE57373),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final PokemonController controller = Get.find();
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        controller.loadMorePokemon();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/items/poke-ball.png',
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.catching_pokemon,
                  color: Colors.red,
                  size: 32,
                );
              },
            ),
            const SizedBox(width: 8),
            const Text(
              'Pokédex',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black),
            onPressed: () {
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.red),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.pokemonList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        if (controller.errorMessage.isNotEmpty &&
            controller.pokemonList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => controller.fetchPokemonList(),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        return OrientationBuilder(
          builder: (context, orientation) {
            final crossAxisCount = orientation == Orientation.portrait ? 2 : 4;
            return RefreshIndicator(
              onRefresh: () => controller.refreshPokemonList(),
              color: Colors.red,
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: crossAxisCount),
                controller: scrollController,
                padding: const EdgeInsets.all(16),
                itemCount:
                    controller.pokemonList.length +
                    (controller.isLoadingMore.value ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == controller.pokemonList.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(color: Colors.red),
                      ),
                    );
                  }

                  final pokemon = controller.pokemonList[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PokemonCard(
                      pokemon: pokemon,
                      backgroundColor: _getTypeColor(index),
                      onTap: () {
                        Get.to(
                          () => PokemonDetailScreen(
                            pokemon: pokemon,
                            backgroundColor: _getTypeColor(index),
                          ),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 300),
                        );
                      },
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }
}
