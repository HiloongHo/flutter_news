import 'package:flutter/material.dart';
import 'package:flutter_news/model/home_model.dart';
import 'package:flutter_news/tool/net_manager.dart';

// ignore: must_be_immutable
class CategoryListView extends StatefulWidget {
  final String path;
  final String title;
  const CategoryListView({super.key, required this.path, required this.title});

  @override
  State<CategoryListView> createState() => _CategoryListViewState(path, title);
}

class _CategoryListViewState extends State<CategoryListView> {
  late String path;
  late String title;
  late ScrollController _scrollController;
  NetManager _netManager = NetManager();
  List<HomeData> _dataList = [];
  int _currentPage = 1;
  _CategoryListViewState(this.path,this.title);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          _requestData(_currentPage);
        }
      });
    _requestData(_currentPage);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(title: Text(title));
    
    if (_dataList.isEmpty) {
      return Scaffold(
        appBar: appBar,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - appBar.preferredSize.height,
        child: RefreshIndicator(
          child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return _buildItem(context, index);
            },
            itemCount: _dataList.length,
            controller: _scrollController,
          ),
          onRefresh: _onRefresh,
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    _currentPage = 1;
    await _requestData(_currentPage);
  }

  Future _requestData(int page) async {
    try {
      HomeModel data = await _netManager.queryHomeData(page, path: path);
      if (mounted) {
        setState(() {
          if (page == 1) {
            _dataList.clear();
          }
          if (data.result.newslist.isNotEmpty) {
            _dataList.addAll(data.result.newslist);
            _currentPage++;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('数据加载失败: $e')),
        );
      }
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: 处理点击事件
        },
        child: SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: SizedBox(
                  width: 140,
                  height: 120,
                  child: _dataList[index].picUrl.isNotEmpty
                      ? Image.network(
                          _dataList[index].picUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.error_outline,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _dataList[index].title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _dataList[index].description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.2,
                          color: Colors.grey[600],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 14,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _dataList[index].ctime,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}