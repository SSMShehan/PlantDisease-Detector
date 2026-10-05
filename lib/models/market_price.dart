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

  factory MarketPrice.fromJson(Map<String, dynamic> json) {
    return MarketPrice(
      cropName: json['crop_name'] ?? '',
      emoji: json['emoji'] ?? '',
      pricePerKg: (json['price_per_kg'] ?? 0.0).toDouble(),
      changePercent: (json['change_percent'] ?? 0.0).toDouble(),
      isBestPrice: json['is_best_price'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'crop_name': cropName,
      'emoji': emoji,
      'price_per_kg': pricePerKg,
      'change_percent': changePercent,
      'is_best_price': isBestPrice,
    };
  }
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

  factory NearestMarket.fromJson(Map<String, dynamic> json) {
    var pricesList = json['prices'] as List?;
    return NearestMarket(
      name: json['name'] ?? '',
      distanceKm: (json['distance_km'] ?? 0.0).toDouble(),
      lastUpdated: json['last_updated'] ?? '',
      prices: pricesList != null
          ? pricesList.map((e) => MarketPrice.fromJson(e)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'distance_km': distanceKm,
      'last_updated': lastUpdated,
      'prices': prices.map((e) => e.toJson()).toList(),
    };
  }
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
