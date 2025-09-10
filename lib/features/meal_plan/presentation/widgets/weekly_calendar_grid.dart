import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meal_generator_planner/data/models/daily_meals.dart';
import 'package:meal_generator_planner/data/models/meal.dart';
import 'package:meal_generator_planner/data/models/meal_plan.dart';
import 'package:meal_generator_planner/widgets/meal_card.dart';

class WeeklyCalendarGrid extends StatelessWidget {
  final MealPlan mealPlan;

  const WeeklyCalendarGrid({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context) {
    final sortedDays = mealPlan.dailyMeals.entries.toList()
      ..sort((a, b) => DateTime.parse(a.key).compareTo(DateTime.parse(b.key)));

    return SingleChildScrollView(
      child: Table(
        border: TableBorder.all(color: Colors.grey[300]!),
        children: [
          _buildHeaderRow(),
          _buildMealRow('B', sortedDays.map((d) => d.value.breakfast).toList()),
          _buildMealRow('L', sortedDays.map((d) => d.value.lunch).toList()),
          _buildMealRow('D', sortedDays.map((d) => d.value.dinner).toList()),
          _buildSnackRow(sortedDays),
        ],
      ),
    );
  }

  TableRow _buildHeaderRow() {
    final headers = [''].followedBy(
        List.generate(7, (index) {
          final day = mealPlan.weekStartDate.add(Duration(days: index));
          return DateFormat('E\ndd').format(day);
        }),
    );

    return TableRow(
      children: headers.map((header) {
        return TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              header,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      }).toList(),
    );
  }

  TableRow _buildMealRow(String mealType, List<Meal> meals) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(child: Text(mealType, style: const TextStyle(fontWeight: FontWeight.bold))),
        ),
        ...meals.map((meal) => MealCard(meal: meal)),
      ],
    );
  }

  TableRow _buildSnackRow(List<MapEntry<String, DailyMeals>> sortedDays) {
    return TableRow(
      children: [
        const TableCell(
          verticalAlignment: TableCellVerticalAlignment.middle,
          child: Center(child: Text('S', style: TextStyle(fontWeight: FontWeight.bold))),
        ),
        ...sortedDays.map((day) {
          if (day.value.snacks.isEmpty) {
            return const SizedBox.shrink();
          }
          return Column(
            children: day.value.snacks.map((snack) => MealCard(meal: snack)).toList(),
          );
        }),
      ],
    );
  }
}
