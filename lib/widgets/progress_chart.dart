import 'package:flutter/material.dart';
import 'package:mathscool/utils/colors.dart';

class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  // Données factices pour l'exemple
  // En réalité, vous devriez récupérer ces données depuis une base de données
  final Map<String, double> progressData = const {
    'Additions': 0.8,
    'Soustractions': 0.6,
    'Multiplications': 0.3,
    'Divisions': 0.2,
    'Géométrie': 0.5,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ma progression',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Voici comment tu progresses dans les différents thèmes :',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 20),
            ...progressData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          entry.key,
                          style: const TextStyle(fontSize: 14),
                        ),
                        Text(
                          '${(entry.value * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: entry.value,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _getProgressColor(entry.value),
                      ),
                      minHeight: 12,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 10),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('0-40%', Colors.red),
        _buildLegendItem('40-70%', Colors.orange),
        _buildLegendItem('70-100%', Colors.green),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  Color _getProgressColor(double value) {
    if (value < 0.4) return Colors.red;
    if (value < 0.7) return Colors.orange;
    return Colors.green;
  }
}