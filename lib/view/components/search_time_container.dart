import 'package:esteladevega_tfg_cubex/view/components/Icon/icon.dart';
import 'package:esteladevega_tfg_cubex/utilities/app_color.dart';
import 'package:flutter/material.dart';

class SearchTimeContainer extends StatefulWidget {
  const SearchTimeContainer({super.key});

  @override
  State<SearchTimeContainer> createState() => _SearchTimeContainerState();
}

class _SearchTimeContainerState extends State<SearchTimeContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.lightVioletColor.withOpacity(0.7),
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            IconClass.iconButton((){}, "Add new time", Icons.add_alarm),

            Text(
              "Search time",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),

            IconClass.iconButton((){}, "More options", Icons.more_vert)
          ],
        ),
    );

  }
}
