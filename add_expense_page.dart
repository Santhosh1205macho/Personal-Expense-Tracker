import 'package:flutter/material.dart';
import 'expense_model.dart';

class AddExpensePage extends StatefulWidget {
  final Expense? expense;

  const AddExpensePage({super.key, this.expense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  // ====================================================
  // CONTROLLERS
  // ====================================================

  final TextEditingController titleController = TextEditingController();

  final TextEditingController amountController = TextEditingController();

  // ====================================================
  // FORM KEY
  // ====================================================

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // ====================================================
  // CATEGORY
  // ====================================================

  String selectedCategory = "Food";

  final List<String> categoryList = ["Food", "Travel", "Shopping", "Bills"];

  // ====================================================
  // DATE
  // ====================================================

  DateTime selectedDate = DateTime.now();

  // ====================================================
  // INIT
  // ====================================================

  @override
  void initState() {
    super.initState();

    if (widget.expense != null) {
      titleController.text = widget.expense!.title;

      amountController.text = widget.expense!.amount.toString();

      selectedCategory = widget.expense!.category;

      selectedDate = widget.expense!.date;
    }
  }

  // ====================================================
  // DISPOSE
  // ====================================================

  @override
  void dispose() {
    titleController.dispose();

    amountController.dispose();

    super.dispose();
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
  // DATE PICKER
  // ====================================================

  Future<void> selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,

      initialDate: selectedDate,

      firstDate: DateTime(2020),

      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  // ====================================================
  // SAVE
  // ====================================================

  void saveExpense() {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final String title = titleController.text.trim();

    final double amount = double.parse(amountController.text.trim());

    final Expense expense = Expense(
      title: title,

      amount: amount,

      category: selectedCategory,

      date: selectedDate,
    );

    Navigator.pop(context, expense);
  }

  // ====================================================
  // BUILD
  // ====================================================

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.expense != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? "Edit Expense" : "Add Expense")),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ========================================
                // EXPENSE NAME
                // ========================================

                const Text(
                  "Expense Name",

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: titleController,

                  decoration: const InputDecoration(
                    hintText: "Example: Lunch",
                    prefixIcon: Icon(Icons.edit),
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter expense name";
                    }

                    if (value.trim().length < 2) {
                      return "Name is too short";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================
                // AMOUNT
                // ========================================
                const Text(
                  "Amount",

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                TextFormField(
                  controller: amountController,

                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),

                  decoration: const InputDecoration(
                    hintText: "Example: 500",
                    prefixIcon: Icon(Icons.currency_rupee),
                    border: OutlineInputBorder(),
                  ),

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter amount";
                    }

                    final double? amount = double.tryParse(value.trim());

                    if (amount == null) {
                      return "Enter a valid number";
                    }

                    if (amount <= 0) {
                      return "Amount must be greater than 0";
                    }

                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // ========================================
                // CATEGORY
                // ========================================
                const Text(
                  "Category",

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                DropdownButtonFormField<String>(
                  initialValue: selectedCategory,

                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),

                  items: categoryList.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),

                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),

                const SizedBox(height: 20),

                // ========================================
                // DATE
                // ========================================
                const Text(
                  "Date",

                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 5,
                  ),

                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),

                    borderRadius: BorderRadius.circular(5),
                  ),

                  child: Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.indigo),

                      const SizedBox(width: 15),

                      Expanded(child: Text(formatDate(selectedDate))),

                      TextButton(
                        onPressed: selectDate,
                        child: const Text("Select"),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                // ========================================
                // SAVE BUTTON
                // ========================================
                SizedBox(
                  width: double.infinity,

                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: saveExpense,

                    icon: Icon(isEditing ? Icons.update : Icons.save),

                    label: Text(isEditing ? "Update Expense" : "Save Expense"),
                  ),
                ),

                const SizedBox(height: 15),

                // ========================================
                // CANCEL
                // ========================================
                SizedBox(
                  width: double.infinity,

                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
