import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum ActivityType {
  swimming(1, "Swimming Pool", "swimming.svg"),
  hiking(2, 'Hiking', "hiking.svg"),
  campfire(3, 'Campfire', 'bonefire.svg'),
  kayaking(4, "Kayaking", "kayak.svg"),
  hotAirBalloon(5, "Hot Air Balloon", "hot_air_balloon.svg"),
  tent(6, "Tent", "tent.svg");
  // running(7, 'Running', ""),
  // climbing(8, 'Climbing', ""),
  // cycling(9, 'Cycling', ""),
  // ski(10, 'Skiing', ""),

  const ActivityType(this.id, this.value, this.imagePath);

  final int id;
  final String value;
  final String imagePath;

  static ActivityType getTypeByValue(String value) =>
      ActivityType.values.firstWhere((activity) => activity.value == value);
  static ActivityType getType(int id) =>
      ActivityType.values.firstWhere((activity) => activity.id == id);
  static String getValue(int id) =>
      ActivityType.values.firstWhere((activity) => activity.id == id).value;
}

class Activities extends StatefulWidget {
  const Activities({
    Key? key,
    required this.size,
    required this.activities,
    this.onChangeActivity,
    this.isEditable = false,
  }) : super(key: key);

  final double size;
  final Set<ActivityType> activities;
  final void Function(
    bool changeType, // true for adding and false for removing
    ActivityType activityType,
    Set<ActivityType> allActivities,
  )? onChangeActivity;
  final bool isEditable;

  @override
  State<Activities> createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...widget.activities.map((activity) {
            Widget activityTile = SizedBox(
              width: widget.size,
              child: Card(
                  elevation: 6,
                  child: SvgPicture.asset(
                    'images/svg/${activity.imagePath}',
                    width: widget.size,
                    height: widget.size,
                  )),
            );

            // trigger Activity deletion if admin or show only a toop tip
            return widget.isEditable
                ? GestureDetector(
                    onLongPress: () => showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                              title: Text(activity.value),
                              content: Text("Delete ${activity.value} ?"),
                              actions: [
                                TextButton(
                                    onPressed: () => {
                                          Navigator.pop(context),
                                          setState(() => widget.activities
                                              .remove(activity)),
                                          widget.onChangeActivity!(true,
                                              activity, widget.activities),
                                        },
                                    child: const Text("Yes")),
                                ElevatedButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("NO, don't Delete"))
                              ],
                            )),
                    child: activityTile,
                  )
                : Tooltip(
                    message: activity.value,
                    child: activityTile,
                  );
          }),
          widget.isEditable &&
                  widget.activities.length < ActivityType.values.length
              // Select more activities available for the resort
              ? SizedBox(
                  width: widget.size,
                  child: PopupMenuButton(
                    padding: const EdgeInsets.all(0),
                    tooltip: "Add new Activity",
                    icon: SizedBox(
                      width: widget.size,
                      height: widget.size,
                      child: const Card(
                        elevation: 6,
                        child: Icon(
                          Icons.add,
                        ),
                      ),
                    ),
                    itemBuilder: (context) {
                      return [
                        ...ActivityType.values
                            .toSet()
                            .difference(widget.activities)
                            .map((e) =>
                                // ...ActivityType.values.map((e) =>
                                PopupMenuItem(value: e, child: Text(e.value)))
                      ];
                    },
                    onSelected: (value) => setState(() {
                          widget.activities.add(value);
                          widget.onChangeActivity!(
                              true, value, widget.activities);
                        }),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
