import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';

class StatCardWidget extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final double changePercent;
  final bool isPositive;
  final Widget? chart;
  final Widget? extraContent;

  const StatCardWidget({super.key, required this.title, required this.value, required this.subtitle, required this.changePercent, required this.isPositive, this.chart, this.extraContent});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.darkGreen.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 12, offset: const Offset(0, 4))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
        Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title.toUpperCase(), style: TextStyle(color: AppColors.darkGreen.withValues(alpha: 0.5), fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1.1)),
          const SizedBox(height: 8),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(child: Text(value, style: const TextStyle(color: AppColors.darkBg, fontSize: 34, fontWeight: FontWeight.bold, letterSpacing: -1), overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 10), _buildBadge(),
          ]),
          const SizedBox(height: 6),
          Text(subtitle, style: TextStyle(color: AppColors.darkGreen.withValues(alpha: 0.45), fontSize: 12), overflow: TextOverflow.ellipsis),
        ])),
        if (extraContent != null) ...[const SizedBox(height: 12), Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: extraContent!)],
        if (chart != null) ...[const SizedBox(height: 16),
          ClipRRect(borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            child: SizedBox(height: 80, width: double.infinity, child: chart!))],
      ]),
    );
  }

  Widget _buildBadge() {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: isPositive ? AppColors.primary.withValues(alpha: 0.12) : AppColors.error.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(isPositive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded, color: isPositive ? AppColors.primary : AppColors.error, size: 11),
        const SizedBox(width: 2),
        Text('${changePercent.abs().toStringAsFixed(0)}%', style: TextStyle(color: isPositive ? AppColors.primary : AppColors.error, fontSize: 11, fontWeight: FontWeight.w700)),
      ]));
  }
}
