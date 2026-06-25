import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:offixoadmin/core/appstyle/appstyle.dart';
import 'package:offixoadmin/features/home/data/statcardmodel.dart';

class StatCardsRow extends StatelessWidget {
  final List<StatCardData> stats;
  const StatCardsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: stats
          .map(
            (s) => Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: s != stats.last ? 10 : 0),
                child: _StatCard(data: s),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final StatCardData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [data.startColor, data.endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            data.icon,
            width: 18,
            height: 18,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          const SizedBox(height: 12),
          Text(
            data.count,
            style: AppStyle.text(
              size: 26,
              color: Colors.white,
              weight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            data.label,
            style: AppStyle.text(
              size: 11,
              color: Colors.white.withOpacity(0.9),
              weight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
