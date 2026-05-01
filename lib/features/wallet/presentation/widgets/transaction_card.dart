// lib/features/wallet/presentation/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_widgets.dart';
import '../../domain/models/transaction_model.dart';

class TransactionCard extends StatelessWidget {
  final TransactionModel transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 10),
      borderRadius: BorderRadius.circular(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: transaction.typeColor.withAlpha(38),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              transaction.typeIcon,
              color: transaction.typeColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    color: VirooColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    fontFamily: 'Cairo',
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(transaction.createdAt),
                  style: const TextStyle(
                    color: VirooColors.textTertiary,
                    fontSize: 11,
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${transaction.type == 'deposit' ? '+' : '-'}${transaction.amount.toStringAsFixed(0)} ج',
                style: TextStyle(
                  color: transaction.typeColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  fontFamily: 'Orbitron',
                ),
              ),
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: transaction.statusColor.withAlpha(38),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  transaction.statusLabel,
                  style: TextStyle(
                    color: transaction.statusColor,
                    fontSize: 9,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
