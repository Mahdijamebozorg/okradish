class Food {
  final String id;
  final String name;
  final double carboPerGram;
  final double proteinPerGram;
  final double fatPerGram;
  final double fibersPerGram;

  const Food({
    required this.id,
    required this.name,
    required this.carboPerGram,
    required this.proteinPerGram,
    required this.fatPerGram,
    required this.fibersPerGram,
  });

  factory Food.dummy() {
    return const Food(
      id: 'id',
      name: 'name',
      carboPerGram: 0,
      fatPerGram: 0,
      fibersPerGram: 0,
      proteinPerGram: 0,
    );
  }
}
