import 'package:flutter/material.dart';
import 'package:mvvm_task_management/app/app_colors.dart';
import 'package:mvvm_task_management/views/add_todo_screen.dart';
import 'package:mvvm_task_management/widgets/appbar_status_card_widget.dart';
import 'package:mvvm_task_management/widgets/todo_card_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String name = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              leading: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
              floating: true,
              expandedHeight: 240,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'What To Do 👀❗',
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,

                background: Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: GridView.count(
                    crossAxisCount: 3,
                    children: [
                      AppbarStatusCardWidget(
                        title: 'In Progress',
                        icon: Icons.timelapse,
                        quantity: 10,
                      ),
                      AppbarStatusCardWidget(
                        title: 'Completed',
                        icon: Icons.done_all,
                        quantity: 1,
                      ),
                      AppbarStatusCardWidget(
                        title: 'Canceled',
                        icon: Icons.cancel_outlined,
                        quantity: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 30,
                    ),
                    child: ListView.separated(
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 15),
                      itemCount: 11,
                      shrinkWrap: true,

                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) => ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 100),
                        child: index == 10 ? SizedBox() : TodoCardWidget(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, AddTodoScreen.name);
          },
          backgroundColor: AppColors.themeColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
