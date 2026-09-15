class MarketPrice {
  final String cropName;
  final String emoji;
  final double pricePerKg;
  final double changePercent; // positive = up, negative = down
  final bool isBestPrice;

  const MarketPrice({
    required this.cropName,
    required this.emoji,
    required this.pricePerKg,
    required this.changePercent,
    this.isBestPrice = false,
  });
}

class NearestMarket {
  final String name;
  final double distanceKm;
  final List<MarketPrice> prices;
  final String lastUpdated;

  const NearestMarket({
    required this.name,
    required this.distanceKm,
    required this.prices,
    required this.lastUpdated,
  });
}

final NearestMarket nearestMarket = NearestMarket(
  name: 'Dambulla Economic Center',
  distanceKm: 3.2,
  lastUpdated: 'Today, 6:00 AM',
  prices: [
    MarketPrice(cropName: 'Tomato', emoji: '🍅', pricePerKg: 185, changePercent: 12.4, isBestPrice: true),
    MarketPrice(cropName: 'Pepper', emoji: '🌶️', pricePerKg: 620, changePercent: -3.1),
    MarketPrice(cropName: 'Cucumber', emoji: '🥒', pricePerKg: 95, changePercent: 5.7),
    MarketPrice(cropName: 'Brinjal', emoji: '🍆', pricePerKg: 140, changePercent: -8.2),
  ],
);
