import 'package:flutter/material.dart';
import 'package:flutter_advance/models/expence.dart';
import 'package:flutter_advance/server/database.dart';
import 'package:flutter_advance/widgets/add_new_expence.dart';
import 'package:flutter_advance/widgets/expence_list.dart';
import 'package:hive/hive.dart';
import 'package:pie_chart/pie_chart.dart';

class Expences extends StatefulWidget {
  const Expences({super.key});

  @override
  State<Expences> createState() => _ExpencesState();
}

class _ExpencesState extends State<Expences> {
  final _myBox = Hive.box("expenceDatabase");
  DataBase db = DataBase();

  // //expencesList
  // final List<ExpenceModel> _expenceList = [
  //   ExpenceModel(
  //       title: "Football",
  //       amount: 12.5,
  //       date: DateTime.now(),
  //       category: Category.leisure),
  //   ExpenceModel(
  //       title: "Carrot",
  //       amount: 15,
  //       date: DateTime.now(),
  //       category: Category.food),
  //   ExpenceModel(
  //       title: "Bag",
  //       amount: 20,
  //       date: DateTime.now(),
  //       category: Category.travel)
  // ];
  Map<String, double> dataMap = {
    "Food": 0,
    "Travel": 0,
    "Leasure": 0,
    "Work": 0,
  };

  //add new expence
  void onAddNewExpence(ExpenceModel expence) {
    setState(() {
      db.expenceList.add(expence);
      calCategoryValues();
    });
    db.updateData();
  }

  //remove a expence
  void onDeleteExpence(ExpenceModel expence) {
    //store the deleting expence
    ExpenceModel deletingExpence = expence;
    //get the index of removing expences
    final int removingIndex = db.expenceList.indexOf(expence);
    setState(() {
      db.expenceList.remove(expence);
      db.updateData();
      calCategoryValues();
    });

    //show snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("Delete Successful"),
        action: SnackBarAction(
          label: "Undo",
          onPressed: () {
            setState(() {
              db.expenceList.insert(removingIndex, deletingExpence);
              db.updateData();
              calCategoryValues();
            });
          },
        ),
      ),
    );
  }

  //function to open a modal overlay
  void _openAddExpencesOverlay() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return addNewExpences(onAddExpences: onAddNewExpence);
      },
    );
  }

  //pie chart
  double foodVal = 0;
  double travelVal = 0;
  double leasureVal = 0;
  double workVal = 0;

  //calculate category values
  void calCategoryValues() {
    double foodValTotal = 0;
    double travelValTotal = 0;
    double leasureValTotal = 0;
    double workValTotal = 0;

    for (final expence in db.expenceList) {
      if (expence.category == Category.food) {
        foodValTotal += expence.amount;
      }
      if (expence.category == Category.leisure) {
        leasureValTotal += expence.amount;
      }
      if (expence.category == Category.work) {
        workValTotal += expence.amount;
      }
      if (expence.category == Category.travel) {
        travelValTotal += expence.amount;
      }
    }

    setState(() {
      foodVal = foodValTotal;
      leasureVal = leasureValTotal;
      workVal = workValTotal;
      travelVal = travelVal;
    });

    //update a datamap
    dataMap = {
      "Food": foodVal,
      "Travel": travelVal,
      "Leasure": leasureVal,
      "Work": workVal,
    };
  }

  @override
  void initState() {
    super.initState();

    //if this is the first time create the initial data
    if (_myBox.get("Exp_DATA") == null) {
      db.createInitialDatabase();
      calCategoryValues();
    } else {
      db.loadData();
      calCategoryValues();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Master",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 77, 4, 195),
        elevation: 0,
        actions: [
          Container(
            color: Colors.yellow,
            child: IconButton(
              onPressed: _openAddExpencesOverlay,
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          PieChart(dataMap: dataMap),
          ExpenceList(
            expenceList: db.expenceList,
            onDeleteExpence: onDeleteExpence,
          ),
        ],
      ),
    );
  }
}
