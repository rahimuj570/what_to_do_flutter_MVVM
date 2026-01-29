import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mvvm_task_management/app/app_colors.dart';
import 'package:mvvm_task_management/view_models/todo_provider.dart';
import 'package:mvvm_task_management/views/add_todo_screen.dart';
import 'package:mvvm_task_management/widgets/appbar_status_card_widget.dart';
import 'package:mvvm_task_management/widgets/full_page_loading_widget.dart';
import 'package:mvvm_task_management/widgets/todo_card_widget.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static String name = 'homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TodoProvider>().fetchTodo();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Consumer<TodoProvider>(
          builder: (context, todoProvider, child) => SlidableAutoCloseBehavior(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.search),
                  ),
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
                      padding: const EdgeInsets.only(
                        top: 50,
                        left: 20,
                        right: 20,
                      ),
                      child: GridView.count(
                        crossAxisCount: 3,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(), // important!
                        children: [
                          AppbarStatusCardWidget(
                            status: 0,

                            title: 'In Progress',
                            icon: Icons.timelapse,
                            quantity: todoProvider.getTodoList(0).length,
                          ),
                          AppbarStatusCardWidget(
                            status: 1,
                            title: 'Completed',
                            icon: Icons.done_all,
                            quantity: todoProvider.getTodoList(1).length,
                          ),
                          AppbarStatusCardWidget(
                            status: 2,
                            title: 'Canceled',
                            icon: Icons.cancel_outlined,
                            quantity: todoProvider.getTodoList(2).length,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                todoProvider.getIsFetching
                    ? SliverToBoxAdapter(child: FullPageLoadingWidget())
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 30,
                        ),
                        sliver: SliverList.separated(
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 20),
                          itemCount:
                              todoProvider
                                  .getTodoList(todoProvider.currentStatusTab)
                                  .length +
                              1,
                          itemBuilder: (context, index) {
                            if (index ==
                                todoProvider
                                    .getTodoList(todoProvider.currentStatusTab)
                                    .length) {
                              return todoProvider
                                      .getTodoList(
                                        todoProvider.currentStatusTab,
                                      )
                                      .isNotEmpty
                                  ? const SizedBox(height: 100)
                                  : Center(
                                      child: Column(
                                        children: [
                                          const Icon(
                                            Icons.folder_open_sharp,
                                            size: 50,
                                          ),
                                          Text(
                                            'Nothing to do 👀',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.headlineSmall,
                                          ),
                                        ],
                                      ),
                                    );
                            }
                            // Wrap each item with Slidable here
                            return TodoCardWidget(
                              todoProvider.getTodoList(
                                todoProvider.currentStatusTab,
                              )[index],
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
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
