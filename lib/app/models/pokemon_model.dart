class PokemonList {
  final int count;
  final String? next;
  final String? previous;
  final List<Pokemon> results;

  PokemonList({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonList.fromJson(Map<String, dynamic> json) {
    return PokemonList(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results:
          (json['results'] as List)
              .map((pokemon) => Pokemon.fromJson(pokemon))
              .toList(),
    );
  }
}

class Pokemon {
  final String name;
  final String url;
  int? id;

  Pokemon({required this.name, required this.url, this.id}) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      id = int.tryParse(segments[segments.length - 2]);
    }
  }

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class PokemonDetail {
  final int id;
  final String name;
  final int height;
  final int weight;
  final int baseExperience;
  final List<PokemonType> types;
  final List<PokemonAbility> abilities;
  final List<PokemonStat> stats;
  final PokemonSprites sprites;
  final List<PokemonMove> moves;

  PokemonDetail({
    required this.id,
    required this.name,
    required this.height,
    required this.weight,
    required this.baseExperience,
    required this.types,
    required this.abilities,
    required this.stats,
    required this.sprites,
    required this.moves,
  });

  factory PokemonDetail.fromJson(Map<String, dynamic> json) {
    return PokemonDetail(
      id: json['id'],
      name: json['name'],
      height: json['height'],
      weight: json['weight'],
      baseExperience: json['base_experience'] ?? 0,
      types:
          (json['types'] as List)
              .map((type) => PokemonType.fromJson(type))
              .toList(),
      abilities:
          (json['abilities'] as List)
              .map((ability) => PokemonAbility.fromJson(ability))
              .toList(),
      stats:
          (json['stats'] as List)
              .map((stat) => PokemonStat.fromJson(stat))
              .toList(),
      sprites: PokemonSprites.fromJson(json['sprites']),
      moves:
          (json['moves'] as List)
              .map((move) => PokemonMove.fromJson(move))
              .toList(),
    );
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class PokemonType {
  final int slot;
  final TypeInfo type;

  PokemonType({required this.slot, required this.type});

  factory PokemonType.fromJson(Map<String, dynamic> json) {
    return PokemonType(
      slot: json['slot'],
      type: TypeInfo.fromJson(json['type']),
    );
  }
}

class TypeInfo {
  final String name;
  final String url;

  TypeInfo({required this.name, required this.url});

  factory TypeInfo.fromJson(Map<String, dynamic> json) {
    return TypeInfo(name: json['name'], url: json['url']);
  }
}

class PokemonAbility {
  final bool isHidden;
  final int slot;
  final AbilityInfo ability;

  PokemonAbility({
    required this.isHidden,
    required this.slot,
    required this.ability,
  });

  factory PokemonAbility.fromJson(Map<String, dynamic> json) {
    return PokemonAbility(
      isHidden: json['is_hidden'],
      slot: json['slot'],
      ability: AbilityInfo.fromJson(json['ability']),
    );
  }
}

class AbilityInfo {
  final String name;
  final String url;

  AbilityInfo({required this.name, required this.url});

  factory AbilityInfo.fromJson(Map<String, dynamic> json) {
    return AbilityInfo(name: json['name'], url: json['url']);
  }
}

class PokemonStat {
  final int baseStat;
  final int effort;
  final StatInfo stat;

  PokemonStat({
    required this.baseStat,
    required this.effort,
    required this.stat,
  });

  factory PokemonStat.fromJson(Map<String, dynamic> json) {
    return PokemonStat(
      baseStat: json['base_stat'],
      effort: json['effort'],
      stat: StatInfo.fromJson(json['stat']),
    );
  }
}

class StatInfo {
  final String name;
  final String url;

  StatInfo({required this.name, required this.url});

  factory StatInfo.fromJson(Map<String, dynamic> json) {
    return StatInfo(name: json['name'], url: json['url']);
  }
}

class PokemonSprites {
  final String? frontDefault;
  final String? frontShiny;
  final String? backDefault;
  final String? backShiny;

  PokemonSprites({
    this.frontDefault,
    this.frontShiny,
    this.backDefault,
    this.backShiny,
  });

  factory PokemonSprites.fromJson(Map<String, dynamic> json) {
    return PokemonSprites(
      frontDefault: json['front_default'],
      frontShiny: json['front_shiny'],
      backDefault: json['back_default'],
      backShiny: json['back_shiny'],
    );
  }
}

class PokemonSpecies {
  final int id;
  final String name;
  final String flavorText;
  final String category;
  final EvolutionChainInfo evolutionChain;

  PokemonSpecies({
    required this.id,
    required this.name,
    required this.flavorText,
    required this.category,
    required this.evolutionChain,
  });

  factory PokemonSpecies.fromJson(Map<String, dynamic> json) {
    String flavorText = '';
    final flavorTextEntries = json['flavor_text_entries'] as List?;
    if (flavorTextEntries != null && flavorTextEntries.isNotEmpty) {
      final englishEntry = flavorTextEntries.firstWhere(
        (entry) => entry['language']['name'] == 'en',
        orElse: () => flavorTextEntries[0],
      );
      flavorText =
          englishEntry['flavor_text']?.toString().replaceAll('\n', ' ') ?? '';
    }

    String category = '';
    final genera = json['genera'] as List?;
    if (genera != null && genera.isNotEmpty) {
      final englishGenus = genera.firstWhere(
        (entry) => entry['language']['name'] == 'en',
        orElse: () => genera[0],
      );
      category = englishGenus['genus']?.toString() ?? '';
    }

    return PokemonSpecies(
      id: json['id'],
      name: json['name'],
      flavorText: flavorText,
      category: category,
      evolutionChain: EvolutionChainInfo.fromJson(json['evolution_chain']),
    );
  }
}

class EvolutionChainInfo {
  final String url;
  int? id;

  EvolutionChainInfo({required this.url, this.id}) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      id = int.tryParse(segments[segments.length - 2]);
    }
  }

  factory EvolutionChainInfo.fromJson(Map<String, dynamic> json) {
    return EvolutionChainInfo(url: json['url']);
  }
}

class EvolutionChain {
  final ChainLink chain;

  EvolutionChain({required this.chain});

  factory EvolutionChain.fromJson(Map<String, dynamic> json) {
    return EvolutionChain(chain: ChainLink.fromJson(json['chain']));
  }

  List<EvolutionData> getEvolutions() {
    List<EvolutionData> evolutions = [];
    _extractEvolutions(chain, evolutions);
    return evolutions;
  }

  void _extractEvolutions(ChainLink link, List<EvolutionData> evolutions) {
    evolutions.add(
      EvolutionData(name: link.species.name, url: link.species.url),
    );

    for (var evolution in link.evolvesTo) {
      _extractEvolutions(evolution, evolutions);
    }
  }
}

class ChainLink {
  final SpeciesInfo species;
  final List<ChainLink> evolvesTo;

  ChainLink({required this.species, required this.evolvesTo});

  factory ChainLink.fromJson(Map<String, dynamic> json) {
    return ChainLink(
      species: SpeciesInfo.fromJson(json['species']),
      evolvesTo:
          (json['evolves_to'] as List)
              .map((e) => ChainLink.fromJson(e))
              .toList(),
    );
  }
}

class SpeciesInfo {
  final String name;
  final String url;
  int? id;

  SpeciesInfo({required this.name, required this.url, this.id}) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      id = int.tryParse(segments[segments.length - 2]);
    }
  }

  factory SpeciesInfo.fromJson(Map<String, dynamic> json) {
    return SpeciesInfo(name: json['name'], url: json['url']);
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class EvolutionData {
  final String name;
  final String url;
  int? id;

  EvolutionData({required this.name, required this.url, this.id}) {
    final uri = Uri.parse(url);
    final segments = uri.pathSegments;
    if (segments.length >= 2) {
      id = int.tryParse(segments[segments.length - 2]);
    }
  }

  String get imageUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
}

class PokemonMove {
  final MoveInfo move;
  final List<VersionGroupDetail> versionGroupDetails;

  PokemonMove({required this.move, required this.versionGroupDetails});

  factory PokemonMove.fromJson(Map<String, dynamic> json) {
    return PokemonMove(
      move: MoveInfo.fromJson(json['move']),
      versionGroupDetails:
          (json['version_group_details'] as List)
              .map((detail) => VersionGroupDetail.fromJson(detail))
              .toList(),
    );
  }
}

class MoveInfo {
  final String name;
  final String url;

  MoveInfo({required this.name, required this.url});

  factory MoveInfo.fromJson(Map<String, dynamic> json) {
    return MoveInfo(name: json['name'], url: json['url']);
  }
}

class VersionGroupDetail {
  final int levelLearnedAt;
  final MoveLearnMethodInfo moveLearnMethod;
  final VersionGroupInfo versionGroup;

  VersionGroupDetail({
    required this.levelLearnedAt,
    required this.moveLearnMethod,
    required this.versionGroup,
  });

  factory VersionGroupDetail.fromJson(Map<String, dynamic> json) {
    return VersionGroupDetail(
      levelLearnedAt: json['level_learned_at'],
      moveLearnMethod: MoveLearnMethodInfo.fromJson(json['move_learn_method']),
      versionGroup: VersionGroupInfo.fromJson(json['version_group']),
    );
  }
}

class MoveLearnMethodInfo {
  final String name;
  final String url;

  MoveLearnMethodInfo({required this.name, required this.url});

  factory MoveLearnMethodInfo.fromJson(Map<String, dynamic> json) {
    return MoveLearnMethodInfo(name: json['name'], url: json['url']);
  }
}

class VersionGroupInfo {
  final String name;
  final String url;

  VersionGroupInfo({required this.name, required this.url});

  factory VersionGroupInfo.fromJson(Map<String, dynamic> json) {
    return VersionGroupInfo(name: json['name'], url: json['url']);
  }
}
