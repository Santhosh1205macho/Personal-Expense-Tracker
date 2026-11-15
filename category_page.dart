import 'package:flutter/material.dart';
import 'expense_model.dart';

class CategoryPage extends StatelessWidget {
  final String category;

  final List<Expense> expenses;

  const CategoryPage({
    super.key,
    required this.category,
    required this.expenses,
  });

  // ====================================================
  // CATEGORY ICON
  // ====================================================

  IconData getCategoryIcon() {
    if (category == "Food") {
      return Icons.restaurant;
    }

    if (category == "Travel") {
      return Icons.directions_car;
    }

    if (category == "Shopping") {
      return Icons.shopping_bag;
    }

    if (category == "Bills") {
      return Icons.receipt_long;
    }

    return Icons.money;
  }

  // ====================================================
  // CATEGORY COLOR
  // ====================================================

  Color getCategoryColor() {
    if (category == "Food") {
      return Colors.orange;
    }

    if (category == "Travel") {
      return Colors.blue;
    }

    if (category == "Shopping") {
      return Colors.pink;
    }

    if (category == "Bills") {
      return Colors.green;
    }

    return Colors.indigo;
  }

  // ====================================================
  // DATE
  // ====================================================

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // ====================================================
  // BUILD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    // Get only selected category expenses

    final List<Expense> categoryExpenses = expenses
        .where((expense) => expense.category == category)
        .toList();

    // Calculate category total

    double total = 0;

    for (var expense in categoryExpenses) {
      total += expense.amount;
    }

    return Scaffold(
      // ==================================================
      // APP BAR
      // ==================================================

      appBar: AppBar(title: Text("$category Expenses")),

      // ==================================================
      // BODY
      // ==================================================
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ============================================
            // CATEGORY HEADER
            // ============================================

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: getCategoryColor(),

                borderRadius: BorderRadius.circular(20),
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    children: [
                      Icon(getCategoryIcon(), color: Colors.white, size: 35),

                      const SizedBox(width: 12),

                      Text(
                        "$category Spending",

                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  Text(
                    "Total: ₹${total.toStringAsFixed(2)}",

                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ============================================
            // EXPENSE TITLE
            // ============================================
            Text(
              "$category Spending Details",

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // ============================================
            // EMPTY CATEGORY
            // ============================================
            if (categoryExpenses.isEmpty)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,

                    children: [
                      Icon(getCategoryIcon(), size: 70, color: Colors.grey),

                      const SizedBox(height: 15),

                      Text(
                        "No $category expenses",

                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            // ============================================
            // CATEGORY EXPENSE LIST
            // ============================================
            else
              Expanded(
                child: ListView.builder(
                  itemCount: categoryExpenses.length,

                  itemBuilder: (context, index) {
                    final expense = categoryExpenses[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),

                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: getCategoryColor().withValues(
                            alpha: 0.2,
                          ),

                          child: Icon(
                            getCategoryIcon(),
                            color: getCategoryColor(),
                          ),
                        ),

                        title: Text(
                          expense.title,

                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),

                        subtitle: Text(formatDate(expense.date)),

                        trailing: Text(
                          "₹${expense.amount.toStringAsFixed(2)}",

                          style: TextStyle(
                            color: getCategoryColor(),

                            fontWeight: FontWeight.bold,

                            fontSize: 16,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
