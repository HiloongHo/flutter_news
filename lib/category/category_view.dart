import 'package:flutter/material.dart';
import 'package:flutter_news/category/category_list_view.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({super.key});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  final List<Map<String, dynamic>> _categories = [
    {"name": "综合新闻", "path": "generalnews", "icon": Icons.public},
    {"name": "汽车新闻", "path": "auto", "icon": Icons.directions_car},
    {"name": "国内新闻", "path": "guonei", "icon": Icons.location_city},
    {"name": "女性新闻", "path": "woman", "icon": Icons.woman},
    {"name": "财经新闻", "path": "caijing", "icon": Icons.attach_money},
    {"name": "游戏新闻", "path": "game", "icon": Icons.games},
    {"name": "国际新闻", "path": "world", "icon": Icons.language},
    {"name": "人工智能", "path": "ai", "icon": Icons.psychology},
    {"name": "军事新闻", "path": "military", "icon": Icons.security},
    {"name": "体育新闻", "path": "tiyu", "icon": Icons.sports_soccer},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) => _buildCategoryCard(context, index),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, int index) {
    final category = _categories[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => CategoryListView(
                path: category['path'],
                title: category['name'],
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              category['icon'],
              size: 40,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              category['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
