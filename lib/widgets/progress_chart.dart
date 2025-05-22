import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mathscool/utils/colors.dart';

class ProgressChart extends StatelessWidget {
  final Map<String, double> progressData;
  final String title;

  const ProgressChart({
    required this.progressData,
    this.title = 'Ma progression',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.insights,
                  color: AppColors.primary,
                  size: 28,
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontFamily: 'Comic Sans MS',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ...progressData.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            _getIconOrBadge(entry.key, entry.value),
                            const SizedBox(width: 8),
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Comic Sans MS',
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: _getProgressColor(entry.value).withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${(entry.value * 100).toInt()}%',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _getProgressColor(entry.value),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 1,
                                blurRadius: 3,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            height: 18,
                            width: MediaQuery.of(context).size.width * 0.7 * entry.value,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _getProgressGradient(entry.value),
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        if (entry.value > 0.5)
                          ...List.generate(
                            (entry.value * 5).toInt().clamp(0, 5),
                                (index) => Positioned(
                              left: MediaQuery.of(context).size.width * 0.7 * entry.value * (index / 5),
                              top: 2,
                              child: Icon(
                                Icons.star,
                                size: 14,
                                color: Colors.yellow[700],
                              ),
                            ),
                          ),
                        if (entry.value > 0)
                          Positioned(
                            left: (MediaQuery.of(context).size.width * 0.7 * entry.value) - 15,
                            top: -2,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _getProgressColor(entry.value),
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  _getProgressIcon(entry.value),
                                  size: 12,
                                  color: _getProgressColor(entry.value),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(double value) {
    if (value < 0.4) return Colors.red[400]!;
    if (value < 0.7) return Colors.orange[400]!;
    return Colors.green[400]!;
  }

  List<Color> _getProgressGradient(double value) {
    if (value < 0.4) return [Colors.red[300]!, Colors.red[500]!];
    if (value < 0.7) return [Colors.orange[300]!, Colors.orange[500]!];
    return [Colors.green[300]!, Colors.green[500]!];
  }

  IconData _getProgressIcon(double value) {
    if (value < 0.4) return Icons.sentiment_dissatisfied;
    if (value < 0.7) return Icons.sentiment_satisfied;
    return Icons.sentiment_very_satisfied;
  }

  Widget _getIconOrBadge(String category, double value) {
    const levels = ['ci', 'cp', 'ce1', 'ce2', 'cm1', 'cm2'];

    if (levels.contains(category.toLowerCase())) {
      return CircleAvatar(
        radius: 12,
        backgroundColor: _getProgressColor(value).withOpacity(0.2),
        child: Text(
          category.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: _getProgressColor(value),
          ),
        ),
      );
    }

    // FontAwesome icons for subjects
    IconData icon;
    switch (category.toLowerCase()) {
      case 'addition':
        icon = FontAwesomeIcons.plus;
        break;
      case 'soustraction':
        icon = FontAwesomeIcons.minus;
        break;
      case 'multiplication':
        icon = FontAwesomeIcons.xmark;
        break;
      case 'division':
        icon = FontAwesomeIcons.divide;
        break;
      case 'géométrie':
        icon = Icons.square_foot;
        break;
      default:
        icon = FontAwesomeIcons.book;
    }

    return FaIcon(
      icon,
      color: _getProgressColor(value),
      size: 18,
    );
  }
}
