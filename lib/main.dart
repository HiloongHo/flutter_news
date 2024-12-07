import 'package:flutter/material.dart';
import 'package:flutter_news/category/category_view.dart';
import 'package:flutter_news/home/home_view.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return _containerView(context);
  }

  Widget _containerView(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: GetMaterialApp(
        
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.blue,
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        ),
        home: Scaffold(
          appBar: _buildAppBar(context),
          body: const TabBarView(
            children: [
              HomeView(),
              CategoryView(),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
  return AppBar(
    elevation: 0,
    bottom: TabBar(
      tabs: const [
        Tab(
          icon: Icon(Icons.trending_up),
          child: Text("热门", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Tab(
          icon: Icon(Icons.category),
          child: Text("分类", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
      indicatorColor: Theme.of(context).primaryColor,
      indicatorWeight: 3,
      labelColor: Theme.of(context).primaryColor,
      unselectedLabelColor: Colors.grey,
    ),
    title: Text(
      "新闻资讯",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
  );
}

}
