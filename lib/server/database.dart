import 'package:flutter_advance/models/expence.dart';
import 'package:hive/hive.dart';

class DataBase {
  // Create a database reference
  final _mybox = Hive.box("expenceDatabase");

  List<ExpenceModel> expenceList = [];

  // Create the initial expense list function
  void createInitialDatabase() {
    expenceList = [
      ExpenceModel(
        title: "Football",
        amount: 12.5,
        date: DateTime.now(),
        category: Category.leisure,
      ),
      ExpenceModel(
        title: "Carrot",
        amount: 15,
        date: DateTime.now(),
        category: Category.food,
      ),
      ExpenceModel(
        title: "Bag",
        amount: 20,
        date: DateTime.now(),
        category: Category.travel,
      ),
    ];

    // Save the initial data to the database
    updateData();
  }

  // Load data from the database
  void loadData() {
    final dynamic data = _mybox.get("EXP_DATA");
    // Validate the data
    if (data != null && data is List) {
      expenceList = data.cast<ExpenceModel>().toList();
    }
  }

  // Update the data
  Future<void> updateData() async {
    await _mybox.put("EXP_DATA", expenceList);
    print("saved data");
  }
}
