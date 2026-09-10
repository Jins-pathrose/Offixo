import 'package:flutter/material.dart';
import 'package:offixoadmin/features/settings/presentation/widgets/menuitem.dart';

class MenuCard extends StatelessWidget {
  final List<MenuItem> items;
  const MenuCard({required this.items});
 
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final isActualLast = e.key == items.length - 1;
          return Column(
            children: [
              e.value,
              if (!isActualLast)
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: 52,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}