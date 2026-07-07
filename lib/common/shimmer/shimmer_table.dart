import 'package:flutter/material.dart';
import 'shimmer_container.dart';

class ShimmerTable extends StatelessWidget {
  final int rows;
  final int columns;

  const ShimmerTable({
    super.key,
    this.rows = 5,
    this.columns = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: List.generate(rows, (rowIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Row(
              children: List.generate(columns, (colIndex) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ShimmerContainer(
                      width: double.infinity,
                      height: rowIndex == 0 ? 30 : 20, // Header is slightly taller
                      borderRadius: 4,
                    ),
                  ),
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
