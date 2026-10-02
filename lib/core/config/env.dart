// ─────────────────────────────────────────────────────────────────────────────
// env.dart — Supabase credentials & inference URL
//
// TODO: Replace the placeholder values below with your real Supabase project
// credentials (found in Supabase dashboard → Settings → API).
//
// IMPORTANT: Never commit real credentials to a public repo.
// In production, load these from a .env file using flutter_dotenv.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Env {
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  static String get inferenceUrl => dotenv.env['INFERENCE_URL'] ?? '';
}

// ─────────────────────────────────────────────────────────────────────────────
// Confidence thresholds (from crop.md Section 2)
// ─────────────────────────────────────────────────────────────────────────────
class Thresholds {
  /// ≥70% → show result automatically
  static const double autoShow = 0.70;

  /// 40–70% → flag as uncertain, offer cloud inference
  static const double uncertain = 0.40;

  /// <40% → escalate to officer
}
