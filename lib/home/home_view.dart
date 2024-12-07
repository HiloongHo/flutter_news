import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_news/model/home_model.dart';
import 'package:flutter_news/tool/net_manager.dart';
import '../utils/log_util.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with AutomaticKeepAliveClientMixin {
  // 添加 PageController 控制轮播图
  final PageController _pageController = PageController();

  ScrollController _scrollController = ScrollController();

  final NetManager _netManager = NetManager();

  List<HomeData> _dataList = [];

  int _currentPage = 1;

  int _currentBannerIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Log.i('HomeView', '已滚动到底部');
      }
    });
    _requestData(_currentPage);
    super.initState();
  }
  
  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 添加刷新方法
  Future<void> _onRefresh() async {
    // 模拟网络请求延迟
    await Future.delayed(const Duration(seconds: 1));
    
    // TODO: 在这里添加实际的刷新逻辑
    try {
      // 刷新轮播图数据
      Log.i('HomeView', '刷新轮播图数据');
      // await refreshBannerData();

      // 刷新列表数据
      Log.i('HomeView', '刷新列表数据');
      // await refreshListData();

      setState(() {
        // 更新UI
      });
      
      Log.i('HomeView', '刷新完成');
    } catch (e) {
      Log.e('HomeView', '刷新失败', e);
    }
  }

  Future<void> _requestData(int page) async {
    try {
      Log.i('HomeView', '开始请求第 $page 页数据');
      HomeModel data = await _netManager.queryHomeData(page);
      if (mounted) {
        setState(() {
          if (page == 1) {
            _dataList.clear();
          }
          if (data.result.newslist.isNotEmpty) {
            _dataList.addAll(data.result.newslist);
            _currentPage++;
            Log.i('HomeView', '数据加载成功，当前数据条数: ${_dataList.length}');
          }
        });
      }
    } catch (e) {
      Log.e('HomeView', '数据请求失败', e);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('数据加载失败: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (_dataList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: Column(
        children: [
          // 轮播图部分
          Stack(
            children: [
              SizedBox(
                height: 220, // 将高度从 280 调整为 220
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _dataList.length > 3 ? 3 : _dataList.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentBannerIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final imageUrl = _dataList[index].picUrl;
                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // 背景模糊效果
                        if (imageUrl.isNotEmpty)
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(imageUrl),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                              child: Container(
                                color: Colors.black.withOpacity(0.3),
                              ),
                            ),
                          ),
                        // 主图片 - 调整内边距
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,  // 从 20 调整为 16
                            vertical: 8,    // 添加垂直内边距
                          ),
                          child: imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(16), // 从 20 调整为 16
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.error_outline, 
                                          color: Colors.white,
                                          size: 32,  // 从 40 调整为 32
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: Colors.white,
                                      size: 40,
                                    ),
                                  ),
                                ),
                        ),
                        // 渐变遮罩 - 调整内边距和文字大小
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom: 0,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16), // 从 20 调整为 16
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 32,  // 从 40 调整为 32
                                top: 48,    // 从 60 调整为 48
                              ),
                              child: Text(
                                _dataList[index].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,  // 从 24 调整为 20
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              // 页面指示器 - 调整位置
              Positioned(
                bottom: 16,  // 从 20 调整为 16
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _dataList.length > 3 ? 3 : _dataList.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: _currentBannerIndex == index ? 20.0 : 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: _currentBannerIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // 列表部分
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  elevation: 0, // 扁平化设计
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      // TODO: 处理点击事件
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 左侧图片容器
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              width: 120,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                              ),
                              child: _dataList[index].picUrl.isNotEmpty
                                  ? Image.network(
                                      _dataList[index].picUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(
                                          child: Icon(
                                            Icons.error_outline,
                                            color: Colors.grey,
                                          ),
                                        );
                                      },
                                    )
                                  : const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        color: Colors.grey,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // 右侧新闻信息
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 新闻标题
                                Text(
                                  _dataList[index].title,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.5,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                // 底部信息行
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        _dataList[index].source,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w500,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      width: 4,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[400],
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _dataList[index].ctime,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}