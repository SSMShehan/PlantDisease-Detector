import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'camera_capture_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// FarmScreen — Matches Figma FarmScreen.tsx
// ─────────────────────────────────────────────────────────────────────────────
class FarmScreen extends StatefulWidget {
  const FarmScreen({super.key});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  String? _selectedFieldId;

  final List<_FieldBlock> _fields = const [
    _FieldBlock(
      id: "A",
      name: "Field Block A",
      crop: "Tomatoes",
      area: "2.4 acres",
      health: 62,
      status: "At Risk",
      statusColor: Color(0xFFE07A5F),
      img: "https://images.unsplash.com/photo-1508175688576-0c076b47b5b5?w=300&h=200&fit=crop&auto=format",
    ),
    _FieldBlock(
      id: "B",
      name: "Field Block B",
      crop: "Bell Peppers",
      area: "1.8 acres",
      health: 91,
      status: "Healthy",
      statusColor: Color(0xFF81B29A),
      img: "https://images.unsplash.com/photo-1557139582-4206cd15c69a?w=300&h=200&fit=crop&auto=format",
    ),
    _FieldBlock(
      id: "C",
      name: "Field Block C",
      crop: "Cucumbers",
      area: "3.1 acres",
      health: 78,
      status: "Monitor",
      statusColor: Color(0xFFF5A623),
      img: "https://images.unsplash.com/photo-1524553496250-1a722745ae00?w=300&h=200&fit=crop&auto=format",
    ),
    _FieldBlock(
      id: "D",
      name: "Field Block D",
      crop: "Eggplant",
      area: "1.2 acres",
      health: 55,
      status: "At Risk",
      statusColor: Color(0xFFE07A5F),
      img: "https://images.unsplash.com/photo-1508175688576-0c076b47b5b5?w=300&h=200&fit=crop&auto=format",
    ),
  ];

  final List<_FarmTask> _tasks = [
    _FarmTask(label: "Spray Field A with fungicide", due: "Today", priority: "High", color: const Color(0xFFE07A5F)),
    _FarmTask(label: "Irrigate Field B rows 1–6", due: "Yesterday", priority: "Done", color: const Color(0xFF81B29A), done: true),
    _FarmTask(label: "Soil test Field C", due: "Sep 15", priority: "Medium", color: const Color(0xFFF5A623)),
    _FarmTask(label: "Harvest check Field B", due: "Sep 16", priority: "Low", color: const Color(0xFFA8B4C0)),
  ];

  void _onScan() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CameraCaptureScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('My Farm', style: AppTextStyles.headlineMedium.copyWith(letterSpacing: -0.5, fontSize: 24)),
                        const SizedBox(height: 2),
                        Text('8.5 total acres · 4 blocks', style: AppTextStyles.bodySmall.copyWith(color: const Color(0xFF9AA5B4))),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _onScan,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFFE07A5F), Color(0xFFC96A4F)]),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: const Color(0xFFE07A5F).withOpacity(0.35), blurRadius: 16, offset: const Offset(0, 6)),
                        ],
                      ),
                      child: const Text(
                        '+ Scan Field',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Overall Health
                    _buildOverallHealth(),
                    const SizedBox(height: 20),

                    // Field Blocks
                    Text('Field Blocks', style: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    ..._fields.map((f) => _buildFieldCard(f)),

                    const SizedBox(height: 20),

                    // Tasks
                    Text("Today's Tasks", style: AppTextStyles.titleSmall.copyWith(color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    ..._tasks.map((t) => _buildTaskCard(t)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallHealth() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Overall Farm Health', style: AppTextStyles.titleSmall),
              Text('72%', style: AppTextStyles.titleSmall.copyWith(color: const Color(0xFF81B29A), fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: 72,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(colors: [Color(0xFFA8D5BE), Color(0xFF81B29A)]),
                      ),
                    ),
                  ),
                  Expanded(flex: 28, child: Container(color: const Color(0xFFF0EDE8))),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHealthStat('Healthy', '2', const Color(0xFF81B29A)),
              _buildHealthStat('Monitor', '1', const Color(0xFFF5A623)),
              _buildHealthStat('At Risk', '2', const Color(0xFFE07A5F)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHealthStat(String label, String val, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _buildFieldCard(_FieldBlock field) {
    final isExpanded = _selectedFieldId == field.id;

    return GestureDetector(
      onTap: () => setState(() => _selectedFieldId = isExpanded ? null : field.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                        child: Image.network(field.img, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          field.id,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, shadows: [
                            Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 2)),
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(field.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.titleSmall.copyWith(fontSize: 14)),
                                  Text('${field.crop} · ${field.area}', maxLines: 1, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: field.statusColor.withOpacity(0.15), borderRadius: BorderRadius.circular(50)),
                              child: Text(
                                field.status,
                                style: TextStyle(color: field.statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: SizedBox(
                                  height: 5,
                                  child: Row(
                                    children: [
                                      Expanded(flex: field.health, child: Container(color: field.statusColor)),
                                      Expanded(flex: 100 - field.health, child: Container(color: const Color(0xFFF0EDE8))),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text('${field.health}%', style: TextStyle(color: field.statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (isExpanded)
              Container(
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Color(0x0F2D3748))),
                ),
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildFieldDetail('Last Scan', '2 days ago')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildFieldDetail('Next Water', 'Tomorrow')),
                        const SizedBox(width: 8),
                        Expanded(child: _buildFieldDetail('Rows', '18 rows')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _onScan,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFE07A5F), Color(0xFFC96A4F)]),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Scan ${field.name}',
                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFieldDetail(String label, String val) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFFF5F3F0), borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(val, style: AppTextStyles.titleSmall.copyWith(fontSize: 12)),
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontSize: 9, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildTaskCard(_FarmTask task) {
    return GestureDetector(
      onTap: () {
        setState(() => task.done = !task.done);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Opacity(
          opacity: task.done ? 0.6 : 1.0,
          child: Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: task.done ? const Color(0xFF81B29A) : task.color.withOpacity(0.1),
                  border: task.done ? null : Border.all(color: task.color, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: task.done ? const Icon(Icons.check_rounded, color: Colors.white, size: 16) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                        decoration: task.done ? TextDecoration.lineThrough : TextDecoration.none,
                      ),
                    ),
                    Text(task.due, style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: task.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  task.done ? "Done" : task.priority,
                  style: TextStyle(color: task.color, fontSize: 10, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldBlock {
  final String id, name, crop, area, status, img;
  final int health;
  final Color statusColor;
  const _FieldBlock({required this.id, required this.name, required this.crop, required this.area, required this.health, required this.status, required this.statusColor, required this.img});
}

class _FarmTask {
  final String label, due, priority;
  final Color color;
  bool done;
  _FarmTask({required this.label, required this.due, required this.priority, required this.color, this.done = false});
}
