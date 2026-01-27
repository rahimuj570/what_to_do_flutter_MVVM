import 'package:flutter/material.dart';

class TodoCardWidget extends StatelessWidget {
  const TodoCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'data df s fs f f sd fsd fdffffff  f f ffffff eewgergregre ergegerregreg regergregreg rgregergeg dfgdfgfdg ddsfsfsfsfdsf sdfsfsd dg fg d fg dg  dsdddd d d d fs f sfsssssd f fsd fs dfs fs ',
              ),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(child: Text('Complete')),
                    PopupMenuItem(child: Text('Cancel')),
                  ],
                ),
                Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(100),
                  ),
                  label: Text('Completed'),
                ),
                Text('Remain : 2days'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
