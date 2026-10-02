import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_disease_detector/models/market_price.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final marketProvider = FutureProvider<NearestMarket?>((ref) async {
  final client = Supabase.instance.client;
  
  // Fetch markets
  final marketResponse = await client.from('markets').select().limit(1).maybeSingle();
  
  if (marketResponse == null) return null;

  // Fetch prices for this market
  final pricesResponse = await client
      .from('market_prices')
      .select()
      .eq('market_id', marketResponse['id']);

  marketResponse['prices'] = pricesResponse;
  
  return NearestMarket.fromJson(marketResponse);
});
