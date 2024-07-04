import 'package:flutter/material.dart';
import 'package:flutter_advance/models/expence.dart';

class addNewExpences extends StatefulWidget {
  final void Function(ExpenceModel expence) onAddExpences;
  const addNewExpences({super.key, required this.onAddExpences});

  @override
  State<addNewExpences> createState() => _addNewExpencesState();
}

class _addNewExpencesState extends State<addNewExpences> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();

  Category _selectedCategory = Category.leisure;

  //date variable
  final DateTime initialDate = DateTime.now();
  final DateTime firstDate = DateTime(
      DateTime.now().year - 1, DateTime.now().month, DateTime.now().day);
  final DateTime lastDate = DateTime(
      DateTime.now().year + 1, DateTime.now().month, DateTime.now().day);
  DateTime _selectedDate = DateTime.now();

  //date picker
  Future<void> _openDataModal() async {
    try {
      //show the date model then store the user selected date
      final pickedDate = await showDatePicker(
          context: context, firstDate: firstDate, lastDate: lastDate);

      setState(() {
        _selectedDate = pickedDate!;
      });
    } catch (err) {
      print(err.toString());
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
  }

  //handle form submit
  void _handleFormSubmit() {
    //form validations
    //convert the amount into a double
    final userAmount = double.parse(_amountController.text.trim());
    if (_titleController.text.trim().isEmpty || userAmount <= 0) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Enter Valid Data"),
            content: const Text(
                "Please enter a valid data for the title an the amount here the title cant be empty and the amount cant be less than zero"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Close"),
              ),
            ],
          );
        },
      );
    } else {
      //create the new expence
      ExpenceModel newExpence = ExpenceModel(
          title: _titleController.text.trim(),
          amount: userAmount,
          date: _selectedDate,
          category: _selectedCategory);
      //save the data
      widget.onAddExpences(newExpence);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          //title text
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Add a new expence title",
              label: Text("Title"),
            ),
            keyboardType: TextInputType.text,
            maxLength: 50,
          ),
          Row(
            children: [
              //amount
              Expanded(
                child: TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: ("Enter the amount"),
                    label: Text("Amount"),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              //datepicker
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    famattedDate.format(_selectedDate),
                  ),
                  IconButton(
                    onPressed: _openDataModal,
                    icon: const Icon(Icons.date_range_outlined),
                  ),
                ],
              ))
            ],
          ),
          Row(
            children: [
              DropdownButton(
                value: _selectedCategory,
                items: Category.values
                    .map(
                      (Category) => DropdownMenuItem(
                        value: Category,
                        child: Text(Category.name),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    //close the model button
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.redAccent),
                      ),
                      child: const Text("Close"),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _handleFormSubmit,
                      style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.greenAccent),
                      ),
                      child: const Text("Save"),
                    ),
                    //save the data & close the model button
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
