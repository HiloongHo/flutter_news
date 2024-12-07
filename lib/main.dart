import 'package:flutter/material.dart';
import 'package:flutter_news/category/category_view.dart'; // 引入分类视图组件
import 'package:flutter_news/home/home_view.dart'; // 引入主页视图组件
import 'package:get/get.dart'; // 引入GetX库，用于状态管理和路由导航

void main() {
  runApp(const MyApp()); // 启动应用并运行MyApp widget
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // MyApp构造函数，接收一个可选的key参数

  @override
  Widget build(BuildContext context) {
    return _containerView(context); // 构建应用的根布局
  }

  Widget _containerView(BuildContext context) {
    return DefaultTabController(
      length: 2, // 设置TabBar的选项卡数量为2
      child: GetMaterialApp( // 使用GetX的MaterialApp替代Flutter原生的MaterialApp
        debugShowCheckedModeBanner: false, // 关闭调试模式下的右上角横幅
        theme: ThemeData(
          primaryColor: Colors.blue, // 设置主题的主要颜色为蓝色
          useMaterial3: true, // 启用Material Design 3
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue), // 根据种子颜色生成颜色方案
        ),
        home: Scaffold( // 创建Scaffold，作为应用的主页框架
          appBar: _buildAppBar(context), // 调用_buildAppBar方法构建应用栏
          body: const TabBarView( // 创建TabBarView，用于显示不同选项卡的内容
            children: [
              HomeView(), // 第一个选项卡显示HomeView
              CategoryView(), // 第二个选项卡显示CategoryView
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0, // 设置应用栏的阴影高度为0，使其看起来更扁平
      bottom: TabBar( // 创建TabBar，用于底部选项卡切换
        tabs: const [ // 定义两个选项卡
          Tab(
            icon: Icon(Icons.trending_up), // 第一个选项卡的图标为上升箭头
            child: Text("热门", style: TextStyle(fontWeight: FontWeight.bold)), // 第一个选项卡的文本为“热门”，加粗显示
          ),
          Tab(
            icon: Icon(Icons.category), // 第二个选项卡的图标为分类图标
            child: Text("分类", style: TextStyle(fontWeight: FontWeight.bold)), // 第二个选项卡的文本为“分类”，加粗显示
          ),
        ],
        indicatorColor: Theme.of(context).primaryColor, // 设置选项卡指示器的颜色为主题的主要颜色
        indicatorWeight: 3, // 设置选项卡指示器的宽度为3
        labelColor: Theme.of(context).primaryColor, // 设置选中选项卡标签的颜色为主题的主要颜色
        unselectedLabelColor: Colors.grey, // 设置未选中选项卡标签的颜色为灰色
      ),
      title: Text( // 设置应用栏的标题
        "新闻资讯",
        style: TextStyle(
          fontWeight: FontWeight.bold, // 标题加粗显示
          color: Theme.of(context).primaryColor, // 标题颜色为主题的主要颜色
        ),
      ),
      centerTitle: true, // 将标题居中显示
      backgroundColor: Colors.white, // 设置应用栏的背景颜色为白色
    );
  }
}