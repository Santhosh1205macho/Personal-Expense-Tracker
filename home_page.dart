import 'package:flutter/material.dart';
import 'expense_model.dart';
import 'category_page.dart';
import 'add_expense_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ====================================================
  // EXPENSE LIST
  // ====================================================

  List<Expense> expenses = [
    Expense(
      title: "Lunch",
      amount: 250,
      category: "Food",
      date: DateTime.now(),
    ),

    Expense(
      title: "Pizza",
      amount: 400,
      category: "Food",
      date: DateTime.now(),
    ),

    Expense(
      title: "Bus Ticket",
      amount: 100,
      category: "Travel",
      date: DateTime.now(),
    ),

    Expense(
      title: "Train Ticket",
      amount: 500,
      category: "Travel",
      date: DateTime.now(),
    ),

    Expense(
      title: "T-Shirt",
      amount: 800,
      category: "Shopping",
      date: DateTime.now(),
    ),

    Expense(
      title: "Shoes",
      amount: 1500,
      category: "Shopping",
      date: DateTime.now(),
    ),

    Expense(
      title: "Electricity Bill",
      amount: 1200,
      category: "Bills",
      date: DateTime.now(),
    ),

    Expense(
      title: "Internet Bill",
      amount: 700,
      category: "Bills",
      date: DateTime.now(),
    ),
  ];

  // ====================================================
  // CATEGORY LIST
  // ====================================================

  final List<Map<String, dynamic>> categories = [
    {"name": "Food", "icon": Icons.restaurant, "color": Colors.orange},
    {"name": "Travel", "icon": Icons.directions_car, "color": Colors.blue},
    {"name": "Shopping", "icon": Icons.shopping_bag, "color": Colors.pink},
    {"name": "Bills", "icon": Icons.receipt_long, "color": Colors.green},
  ];

  // ====================================================
  // TOTAL SPENDING
  // ====================================================

  double get totalSpending {
    double total = 0;

    for (var expense in expenses) {
      total += expense.amount;
    }

    return total;
  }

  // ====================================================
  // CATEGORY TOTAL
  // ====================================================

  double categoryTotal(String category) {
    double total = 0;

    for (var expense in expenses) {
      if (expense.category == category) {
        total += expense.amount;
      }
    }

    return total;
  }

  // ====================================================
  // CATEGORY NAVIGATION
  // ====================================================

  void openCategory(String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CategoryPage(category: category, expenses: expenses),
      ),
    );
  }

  // ====================================================
  // ADD EXPENSE
  // ====================================================

  void addExpense() async {
    final Expense? newExpense = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    );

    if (newExpense != null) {
      setState(() {
        expenses.add(newExpense);
      });
    }
  }

  // ====================================================
  // EDIT EXPENSE
  // ====================================================

  void editExpense(int index) async {
    final Expense? updatedExpense = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpensePage(expense: expenses[index]),
      ),
    );

    if (updatedExpense != null) {
      setState(() {
        expenses[index] = updatedExpense;
      });
    }
  }

  // ====================================================
  // DELETE EXPENSE
  // ====================================================

  void deleteExpense(int index) {
    setState(() {
      expenses.removeAt(index);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Expense deleted")));
  }

  // ====================================================
  // DATE FORMAT
  // ====================================================

  String formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  // ====================================================
  // CATEGORY ICON
  // ====================================================

  IconData getCategoryIcon(String category) {
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
  // HOME UI
  // ====================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ==================================================
      // APP BAR
      // ==================================================

      appBar: AppBar(
        title: const Text(
          "Personal Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      // ==================================================
      // ADD BUTTON
      // ==================================================
      floatingActionButton: FloatingActionButton(
        onPressed: addExpense,
        child: const Icon(Icons.add),
      ),

      // ==================================================
      // BODY
      // ==================================================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ==========================================
              // TOTAL CARD
              // ==========================================

              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: 30,
                        ),

                        SizedBox(width: 10),

                        Text(
                          "Total Spending",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text(
                      "₹ ${totalSpending.toStringAsFixed(2)}",

                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // ==========================================
              // CATEGORY TITLE
              // ==========================================
              const Text(
                "Spending by Category",

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              // ==========================================
              // GRID VIEW
              // ==========================================
              GridView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: categories.length,

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                ),

                itemBuilder: (context, index) {
                  final category = categories[index];

                  // ====================================
                  // CLICKABLE CATEGORY CARD
                  // ====================================

                  return InkWell(
                    onTap: () {
                      openCategory(category["name"]);
                    },

                    borderRadius: BorderRadius.circular(15),

                    child: Card(
                      elevation: 4,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            category["icon"],
                            color: category["color"],
                            size: 35,
                          ),

                          const SizedBox(height: 8),

                          Text(
                            category["name"],

                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            "₹ ${categoryTotal(category["name"]).toStringAsFixed(0)}",

                            style: TextStyle(
                              color: category["color"],
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 5),

                          const Text(
                            "Tap to view",
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 25),

              // ==========================================
              // RECENT EXPENSES
              // ==========================================
              const Text(
                "Recent Expenses",

                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              // ==========================================
              // EMPTY STATE
              // ==========================================
              if (expenses.isEmpty)
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(30),

                  child: const Column(
                    children: [
                      Icon(Icons.receipt_long, size: 60, color: Colors.grey),

                      SizedBox(height: 10),

                      Text(
                        "No expenses added yet",

                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

              // ==========================================
              // LIST VIEW
              // ==========================================
              ListView.builder(
                shrinkWrap: true,

                physics: const NeverScrollableScrollPhysics(),

                itemCount: expenses.length,

                itemBuilder: (context, index) {
                  final expense = expenses[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),

                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo.shade100,

                        child: Icon(
                          getCategoryIcon(expense.category),

                          color: Colors.indigo,
                        ),
                      ),

                      title: Text(
                        expense.title,

                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),

                      subtitle: Text(
                        "${expense.category} • "
                        "${formatDate(expense.date)}",
                      ),

                      trailing: SizedBox(
                        width: 110,

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            Text(
                              "₹${expense.amount.toStringAsFixed(0)}",

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo,
                              ),
                            ),

                            // =========================
                            // MENU
                            // =========================
                            PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == "edit") {
                                  editExpense(index);
                                }

                                if (value == "delete") {
                                  deleteExpense(index);
                                }
                              },

                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: "edit",

                                  child: Row(
                                    children: [
                                      Icon(Icons.edit),

                                      SizedBox(width: 10),

                                      Text("Edit"),
                                    ],
                                  ),
                                ),

                                const PopupMenuItem(
                                  value: "delete",

                                  child: Row(
                                    children: [
                                      Icon(Icons.delete),

                                      SizedBox(width: 10),

                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
