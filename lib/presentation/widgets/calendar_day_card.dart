import 'package:flutter/material.dart';

class CalendarDayCard extends StatelessWidget {
  final String day; // Day name (e.g., "Monday")
  final String date; // Day number (e.g., "1")
  final VoidCallback onAddTask; // Callback for adding tasks
  final List<String> tasks; // List of tasks for this day

  const CalendarDayCard({
    required this.day,
    required this.date,
    required this.onAddTask,
    required this.tasks,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 147, 139, 174), // Background color
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day and Date Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$day, $date', // e.g., "Monday, 1"
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: onAddTask,
                icon: const Icon(
                  Icons.add, // Add task icon
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Display Tasks
          ...tasks.map((task) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
              '- $task', // Show each task with a dash
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          )),
        ],
      ),
    );
  }
}
