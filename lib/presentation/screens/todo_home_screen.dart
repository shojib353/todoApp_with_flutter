
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:intl/intl.dart';

import '../widgets/calendar_day_card.dart';

import 'package:firebase_database/firebase_database.dart';


class TodoHomeScreen extends StatefulWidget {
   TodoHomeScreen({super.key});

  @override
  State<TodoHomeScreen> createState() => _TodoHomeScreenState();
}

class _TodoHomeScreenState extends State<TodoHomeScreen> {
   // final TextEditingController _bodyController = TextEditingController();

   final Rx<DateTime> currentMonth = DateTime.now().obs;

   final DatabaseReference _databaseRef =
   FirebaseDatabase.instance.ref('tasks'); // Reference to "tasks" node
   Map<String, List<String>> tasks = {};

   DateTime get previousMonth => DateTime(currentMonth.value.year, currentMonth.value.month - 1);

   DateTime get nextMonth => DateTime(currentMonth.value.year, currentMonth.value.month + 1);

   String get formattedPreviousMonth => DateFormat('MMM').format(previousMonth).toUpperCase();

   String get formattedCurrentMonth => DateFormat('MMM').format(currentMonth.value).toUpperCase();

   String get formattedNextMonth => DateFormat('MMM').format(nextMonth).toUpperCase();

   String get currentYear => currentMonth.value.year.toString();

   // Function to get all dates in the current month
  // void updateTasks(String key, List<String> newTasks) async {
  //   final databaseRef = FirebaseDatabase.instance.ref("tasks/$key");
  //
  //   try {
  //     // Replace the list at the specified key
  //     await databaseRef.set(newTasks);
  //     print("Tasks for $key updated successfully.");
  //   } catch (e) {
  //     print("Failed to update tasks: $e");
  //   }
  // }


   void addTaskForDate(DateTime date) {
     String formattedDate = DateFormat('yyyy-MM-dd').format(date);

     showDialog(
       context: context,
       builder: (context) {
         TextEditingController taskController = TextEditingController();

         return AlertDialog(
           title: const Text('Add Task'),
           content: TextField(
             controller: taskController,
             decoration: const InputDecoration(
               hintText: 'Enter task',
             ),
           ),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop(); // Close the dialog
               },
               child: const Text('Cancel'),
             ),
             TextButton(
               onPressed: () async{

                 if (tasks.containsKey(formattedDate)) {
                   tasks[formattedDate]?.add(taskController.text);
                 } else {
                   tasks[formattedDate] = [taskController.text];
                 }

                 // Update Firebase
                 await _databaseRef.set(tasks);
                 setState(() {});
                 Navigator.of(context).pop();


               },

               // {
               //   setState(() {
               //     // Add task to the date
               //     if (tasks.containsKey(formattedDate)) {
               //       tasks[formattedDate]?.add(taskController.text);
               //       saveTasksToFirebase();
               //
               //       print("@@@$tasks");
               //     } else {
               //      tasks[formattedDate] = [taskController.text];
               //
               //       saveTasksToFirebase();
               //       print("##$tasks");
               //     }
               //   });
               //   Navigator.of(context).pop(); // Close the dialog
               // },
               child: const Text('Add'),
             ),
           ],
         );
       },
     );
   }


  // void addTask(String key, String newTask) async {
  //   final databaseRef = FirebaseDatabase.instance.ref("tasks/$key");
  //
  //   try {
  //     DatabaseEvent event = await databaseRef.once();
  //
  //     if (event.snapshot.value != null) {
  //       // Get the current list
  //       List<String> currentTasks =
  //       List<String>.from(event.snapshot.value as List);
  //
  //       // Add the new task
  //       currentTasks.add(newTask);
  //
  //       // Update the list in Firebase
  //       await databaseRef.set(currentTasks);
  //       print("Task added successfully to $key.");
  //     } else {
  //       print("No data found for $key. Creating a new list.");
  //       await databaseRef.set([newTask]);
  //     }
  //   } catch (e) {
  //     print("Error adding task: $e");
  //   }
  // }
  //
  // void addSpecificItem(String key, String newItem) async {
  //   final databaseRef = FirebaseDatabase.instance.ref("tasks/$key");
  //
  //   try {
  //     // Fetch the current list
  //     DatabaseEvent event = await databaseRef.once();
  //
  //     if (event.snapshot.value != null) {
  //       // Parse the current list from the database
  //       List<String> currentList =
  //       List<String>.from(event.snapshot.value as List);
  //
  //       // Add the new item if it doesn't already exist
  //       if (!currentList.contains(newItem)) {
  //         currentList.add(newItem);
  //
  //         // Update the modified list in Firebase
  //         await databaseRef.set(currentList);
  //         print("Item '$newItem' added successfully to $key.");
  //       } else {
  //         print("Item '$newItem' already exists in the list for $key.");
  //       }
  //     } else {
  //       // If no list exists, create a new list with the new item
  //       await databaseRef.set([newItem]);
  //       print("New list created with item '$newItem' for $key.");
  //     }
  //   } catch (e) {
  //     print("Error adding item: $e");
  //   }
  // }
  //
   void showPreviousMonth() {

     currentMonth.value=previousMonth;

     print(getAllDatesInCurrentMonth(currentMonth.value));


   }

     /// Method to change to the next month
     void showNextMonth() {

       currentMonth.value = nextMonth;
       print("${currentMonth.value.year}");



     }

   // Getters for formatted months
  RxList<DateTime> getAllDatesInCurrentMonth(DateTime currentDate) {
    RxList<DateTime> allDates = RxList<DateTime>();


    // Get the first day of the current month
    DateTime firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);

    // Get the last day of the current month
    DateTime lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    // Loop through each day of the month
    for (int i = 0; i <= lastDayOfMonth.day - firstDayOfMonth.day; i++) {
      allDates.add(firstDayOfMonth.add(Duration(days: i)));
    }

    return allDates;
  }




//function end


  @override
  void initState() {
    super.initState();
    _fetchTasks(); // Fetch tasks on start
  }

  // Fetch tasks from Firebase
  Future<void> _fetchTasks() async {
    final snapshot = await _databaseRef.get();
    if (snapshot.exists) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      // Convert Firebase data to Map<String, List<String>>
      setState(() {
        tasks = data.map((key, value) =>
            MapEntry(key as String, List<String>.from(value as List)));
      });

      print("Fetched Tasks: $tasks");
    } else {
      print("No data found in Firebase.");
    }
  }

  // Add task to Firebase and local map
  Future<void> _addTask(String date, String task) async {
    if (tasks.containsKey(date)) {
      tasks[date]?.add(task);
    } else {
      tasks[date] = [task];
    }

    // Update Firebase
    await _databaseRef.set(tasks);
    setState(() {});
  }


   @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:  Obx(() => Text('$currentYear Calendar')),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10 , vertical: 5),
            height: 100,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(22)
            ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 20,),
          GestureDetector(
            onTap: showPreviousMonth,
            child: Obx(()=>
                Text(
                  formattedPreviousMonth,
                  style: const TextStyle(
                      fontSize: 40,
                      color: Colors.black26

                  ),
                ),),
          ),

          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: showPreviousMonth, // Go to the previous month
          ),
            Obx(()=>Text(
            formattedCurrentMonth,
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: showNextMonth, // Go to the next month
            color: Colors.black,

          ),
          GestureDetector(
            onTap: showNextMonth,
            child:Obx(()=> Text(
              formattedNextMonth,
              style: const TextStyle(
                  fontSize: 40,
                  color: Colors.black26

              ),
            ),),
          ),
          SizedBox(width: 20,),
        ],
      ),
          ),
          Expanded(  //start days
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
                  child: Obx(
              () => Column(
            children: getAllDatesInCurrentMonth(currentMonth.value).map((date) {
              String formattedDate = DateFormat('yyyy-MM-dd').format(date); // e.g., "2025-10-01"
              String dayName = DateFormat('EEEE').format(date); // e.g., "Monday"
              String dayNumber = DateFormat('d').format(date); // e.g., "1"

              return CalendarDayCard(
                day: dayName,
                date: dayNumber,
                onAddTask: () => addTaskForDate(date),
                tasks: tasks[formattedDate] ?? [], // Get tasks for this date
              );}).toList(),
              ),
                  ),
            ),
          )    //end days

        ],
      ),
    );


  }
}





/*
*
* {
                  showModalBottomSheet(


                      context: context, builder: (context)=>


                Padding(padding: EdgeInsets.all(20
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[ TextFormField(
                    controller: _bodyController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      labelText: 'Post Description',
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                    ElevatedButton(




                        onPressed: () async{
                          Navigator.pop(context);


                          if (tasks.containsKey(formattedDate)) {
                            tasks[formattedDate]?.add(_bodyController.text);

                            print("@@@$tasks");
                          } else {
                            tasks[formattedDate] = [_bodyController.text];
                            print("##$tasks");
                          }


                        },


     child: Text("ADD"),
     )


                ]),



                )
                  );

                  }
*
* */