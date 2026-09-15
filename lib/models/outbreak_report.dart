import 'package:flutter/material.dart';

class OutbreakReport {
  final String id;
  final String diseaseName;
  final String cropType;
  final int reportCount;
  final double distanceKm;
  final String timeAgo;
  final double severity; // 0.0 - 1.0
  final Color color;
  final Offset mapPosition; // normalized 0.0–1.0 position on map widget

  const OutbreakReport({
    required this.id,
    required this.diseaseName,
    required this.cropType,
    required this.reportCount,
    required this.distanceKm,
    required this.timeAgo,
    required this.severity,
    required this.color,
    required this.mapPosition,
  });
}

final List<OutbreakReport> mockOutbreaks = [
  OutbreakReport(
    id: 'ob1',
    diseaseName: 'Tomato Early Blight',
    cropType: 'Tomato',
    reportCount: 14,
    distanceKm: 2.3,
    timeAgo: '2h ago',
    severity: 0.9,
    color: const Color(0xFFE07A5F),
    mapPosition: const Offset(0.48, 0.44),
  ),
  OutbreakReport(
    id: 'ob2',
    diseaseName: 'Powdery Mildew',
    cropType: 'Pepper',
    reportCount: 7,
    distanceKm: 5.8,
    timeAgo: '5h ago',
    severity: 0.6,
    color: const Color(0xFFF2A34A),
    mapPosition: const Offset(0.28, 0.35),
  ),
  OutbreakReport(
    id: 'ob3',
    diseaseName: 'Root Rot',
    cropType: 'Cucumber',
    reportCount: 3,
    distanceKm: 9.1,
    timeAgo: '1d ago',
    severity: 0.4,
    color: const Color(0xFF81B29A),
    mapPosition: const Offset(0.70, 0.60),
  ),
  OutbreakReport(
    id: 'ob4',
    diseaseName: 'Leaf Spot',
    cropType: 'Paddy',
    reportCount: 21,
    distanceKm: 12.4,
    timeAgo: '3h ago',
    severity: 0.75,
    color: const Color(0xFFE07A5F),
    mapPosition: const Offset(0.60, 0.25),
  ),
  OutbreakReport(
    id: 'ob5',
    diseaseName: 'Anthracnose',
    cropType: 'Mango',
    reportCount: 5,
    distanceKm: 15.2,
    timeAgo: '2d ago',
    severity: 0.5,
    color: const Color(0xFFF2A34A),
    mapPosition: const Offset(0.20, 0.65),
  ),
];
