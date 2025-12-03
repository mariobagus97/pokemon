import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pokedex/app/models/pokemon_model.dart';
import 'package:pokedex/app/modules/home/controllers/pokemon_detail_controller.dart';
import 'package:pokedex/app/modules/home/controllers/pokemon_species_controller.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;
  final Color backgroundColor;

  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
    required this.backgroundColor,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final PokemonDetailController detailController = Get.find();
    final PokemonSpeciesController speciesController = Get.find();

    detailController.fetchPokemonDetail(widget.pokemon.id);
    speciesController.fetchSpeciesAndEvolution(widget.pokemon.id!);

    return Scaffold(
      body: Obx(() {
        if (detailController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.red),
          );
        }

        if (detailController.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                Text(detailController.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed:
                      () => detailController.fetchPokemonDetail(
                        widget.pokemon.id,
                      ),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final detail = detailController.pokemonDetail.value;
        if (detail == null) return const SizedBox();

        return OrientationBuilder(
          builder: (context, orientation) {
            if (orientation == Orientation.landscape) {
              // LANDSCAPE: Seluruh content scrollable
              return SingleChildScrollView(
                child: Container(
                  color: widget.backgroundColor,
                  child: Column(
                    children: [
                      _buildHeader(detail),
                      Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        width: double.maxFinite,
                        height: 40,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: TabBar(
                            labelColor: Colors.black,
                            dividerColor: Colors.transparent,
                            tabs: const [
                              Tab(text: "About"),
                              Tab(text: "Base Stats"),
                              Tab(text: "Evolution"),
                              Tab(text: "Moves"),
                            ],
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(
                                width: 4,
                                color: widget.backgroundColor,
                              ),
                            ),
                            controller: _tabController,
                          ),
                        ),
                      ),
                      // TabBarView dengan tinggi fixed untuk landscape
                      Container(
                        color: Colors.white,
                        height: 600, // Tinggi cukup untuk konten
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAboutTab(detail, speciesController),
                            _buildStatsTab(detail),
                            _buildEvolutionTab(speciesController),
                            _buildMovesTab(detail),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              // PORTRAIT: Layout normal dengan Expanded
              return Container(
                color: widget.backgroundColor,
                width: double.infinity,
                height: double.infinity,
                child: Column(
                  children: [
                    _buildHeader(detail),
                    Container(
                      padding: const EdgeInsets.all(4.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      width: double.maxFinite,
                      height: 40,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: TabBar(
                          labelColor: Colors.black,
                          dividerColor: Colors.transparent,
                          tabs: const [
                            Tab(text: "About"),
                            Tab(text: "Base Stats"),
                            Tab(text: "Evolution"),
                            Tab(text: "Moves"),
                          ],
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: 4,
                              color: widget.backgroundColor,
                            ),
                          ),
                          controller: _tabController,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            _buildAboutTab(detail, speciesController),
                            _buildStatsTab(detail),
                            _buildEvolutionTab(speciesController),
                            _buildMovesTab(detail),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        );
      }),
    );
  }

  Widget _buildHeader(PokemonDetail detail) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final orientation = MediaQuery.of(context).orientation;
        final isLandscape = orientation == Orientation.landscape;

        return Container(
          height: isLandscape ? 200 : 400, // Lebih kecil di landscape
          decoration: BoxDecoration(color: widget.backgroundColor),
          child: Stack(
            children: [
              Positioned(
                top: 50,
                left: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () => Get.back(),
                ),
              ),

              Positioned(
                top: 50,
                right: 16,
                child: IconButton(
                  icon: const Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                    size: 28,
                  ),
                  onPressed: () {},
                ),
              ),

              Positioned(
                top: isLandscape ? 100 : 110,
                left: 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          _capitalize(detail.name),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isLandscape ? 24 : 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: isLandscape ? 50 : 100),
                        Text(
                          '#${detail.id.toString().padLeft(3, '0')}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isLandscape ? 14 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children:
                          detail.types.map((type) {
                            return Container(
                              margin: const EdgeInsets.only(right: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    _getTypeIcon(type.type.name),
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    type.type.name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                    ),
                  ],
                ),
              ),

              Positioned(
                bottom: 20,
                right: 20,
                child: Hero(
                  tag: 'pokemon-${detail.id}',
                  child: CachedNetworkImage(
                    imageUrl: detail.imageUrl,
                    height: isLandscape ? 120 : 200,
                    width: isLandscape ? 120 : 200,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                    errorWidget:
                        (context, url, error) => Icon(
                          Icons.catching_pokemon,
                          size: isLandscape ? 60 : 100,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAboutTab(
    PokemonDetail detail,
    PokemonSpeciesController speciesController,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final species = speciesController.species.value;
            if (species != null && species.flavorText.isNotEmpty) {
              return Text(
                species.flavorText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              );
            }
            return const SizedBox();
          }),
          const SizedBox(height: 24),
          const Text(
            'Pokédex Data',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF81C784),
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            final species = speciesController.species.value;
            return Column(
              children: [
                _buildDataRow('Category', species?.category ?? '-'),
                _buildDataRow(
                  'Height',
                  '${(detail.height / 10).toStringAsFixed(1)} m',
                ),
                _buildDataRow(
                  'Weight',
                  '${(detail.weight / 10).toStringAsFixed(1)} kg',
                ),
                _buildDataRow('Capture Rate', '45'),
                _buildDataRow('Weaknesses', ''),
              ],
            );
          }),
          const SizedBox(height: 24),
          const Text(
            'Abilities',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF81C784),
            ),
          ),
          const SizedBox(height: 16),
          ...detail.abilities.map((ability) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_capitalize(ability.ability.name.replaceAll('-', ' '))),
                  if (ability.isHidden)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Hidden',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                ],
              ),
            );
          }).toList(),
          const SizedBox(height: 24),
          const Text(
            'Training',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF81C784),
            ),
          ),
          const SizedBox(height: 16),
          _buildDataRow('Catch Rate', '45'),
          _buildDataRow('Base Happiness', '50'),
          _buildDataRow('Base Experience', detail.baseExperience.toString()),
          _buildDataRow('Growth Rate', 'medium-slow'),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black54, fontSize: 14),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab(PokemonDetail detail) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children:
            detail.stats.map((stat) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        _capitalize(stat.stat.name.replaceAll('-', ' ')),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 40,
                      child: Text(
                        stat.baseStat.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: stat.baseStat / 255,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(
                          stat.baseStat > 100
                              ? Colors.green
                              : stat.baseStat > 50
                              ? Colors.orange
                              : Colors.red,
                        ),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildEvolutionTab(PokemonSpeciesController speciesController) {
    return Obx(() {
      if (speciesController.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFF81C784)),
        );
      }

      final evolutionChain = speciesController.evolutionChain.value;
      if (evolutionChain == null) {
        return const Center(child: Text('No evolution data available'));
      }

      final evolutions = evolutionChain.getEvolutions();

      return OrientationBuilder(
        builder: (context, orientation) {
          if (orientation == Orientation.portrait) {
            return _buildEvolutionPortrait(evolutions);
          } else {
            return _buildEvolutionLandscape(evolutions);
          }
        },
      );
    });
  }

  Widget _buildEvolutionPortrait(List<EvolutionData> evolutions) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: evolutions.length,
      separatorBuilder:
          (context, index) => Column(
            children: [
              const SizedBox(height: 16),
              Icon(Icons.arrow_downward, color: Colors.grey[400], size: 32),
              const SizedBox(height: 16),
            ],
          ),
      itemBuilder: (context, index) {
        final evolution = evolutions[index];
        return _buildEvolutionCard(evolution);
      },
    );
  }

  Widget _buildEvolutionLandscape(List<EvolutionData> evolutions) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < evolutions.length; i++) ...[
              _buildEvolutionCard(evolutions[i]),
              if (i < evolutions.length - 1) ...[
                const SizedBox(width: 16),
                Icon(Icons.arrow_forward, color: Colors.grey[400], size: 32),
                const SizedBox(width: 16),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEvolutionCard(EvolutionData evolution) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF81C784).withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF81C784).withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: evolution.imageUrl,
              fit: BoxFit.contain,
              placeholder:
                  (context, url) => const Center(
                    child: CircularProgressIndicator(color: Color(0xFF81C784)),
                  ),
              errorWidget:
                  (context, url, error) => const Icon(
                    Icons.catching_pokemon,
                    size: 50,
                    color: Colors.grey,
                  ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '#${evolution.id?.toString().padLeft(3, '0')}',
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _capitalize(evolution.name),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMovesTab(PokemonDetail detail) {
    Map<String, List<PokemonMove>> groupedMoves = {};

    for (var move in detail.moves) {
      for (var versionGroupDetail in move.versionGroupDetails) {
        String method = versionGroupDetail.moveLearnMethod.name;
        if (!groupedMoves.containsKey(method)) {
          groupedMoves[method] = [];
        }

        bool exists = groupedMoves[method]!.any(
          (m) => m.move.name == move.move.name,
        );
        if (!exists) {
          groupedMoves[method]!.add(move);
        }
      }
    }

    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          return _buildMovesPortrait(groupedMoves);
        } else {
          return _buildMovesLandscape(groupedMoves);
        }
      },
    );
  }

  Widget _buildMovesPortrait(Map<String, List<PokemonMove>> groupedMoves) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            groupedMoves.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          _getMoveMethodIcon(entry.key),
                          color: const Color(0xFF81C784),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _capitalize(entry.key.replaceAll('-', ' ')),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF81C784),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            '${entry.value.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: const Color(0xFF81C784),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                  ...entry.value.map((move) {
                    return _buildMoveCard(move);
                  }).toList(),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMovesLandscape(Map<String, List<PokemonMove>> groupedMoves) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            groupedMoves.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(
                          _getMoveMethodIcon(entry.key),
                          color: const Color(0xFF81C784),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _capitalize(entry.key.replaceAll('-', ' ')),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF81C784),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Chip(
                          label: Text(
                            '${entry.value.length}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                          backgroundColor: const Color(0xFF81C784),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                      ],
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 4,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      return _buildMoveCard(entry.value[index]);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }).toList(),
      ),
    );
  }

  Widget _buildMoveCard(PokemonMove move) {
    int? level;
    for (var detail in move.versionGroupDetails) {
      if (detail.levelLearnedAt > 0) {
        level = detail.levelLearnedAt;
        break;
      }
    }

    return Card(
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (level != null)
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF81C784).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Lv.',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                    Text(
                      level.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF81C784),
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.star, color: Colors.grey, size: 24),
              ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                _capitalize(move.move.name.replaceAll('-', ' ')),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }

  IconData _getMoveMethodIcon(String method) {
    switch (method.toLowerCase()) {
      case 'level-up':
        return Icons.trending_up;
      case 'machine':
      case 'tm':
        return Icons.album;
      case 'egg':
        return Icons.egg;
      case 'tutor':
        return Icons.school;
      default:
        return Icons.auto_awesome;
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'grass':
        return Icons.eco;
      case 'fire':
        return Icons.local_fire_department;
      case 'water':
        return Icons.water_drop;
      case 'electric':
        return Icons.flash_on;
      case 'poison':
        return Icons.science;
      default:
        return Icons.catching_pokemon;
    }
  }
}
