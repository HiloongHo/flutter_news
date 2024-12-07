import 'package:json_annotation/json_annotation.dart';

part 'home_model.g.dart';

@JsonSerializable()
class HomeModel {
  final int code;
  final String msg;
  final HomeResult result;

  HomeModel({
    required this.code,
    required this.msg,
    required this.result,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) => _$HomeModelFromJson(json);
  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}

@JsonSerializable()
class HomeResult {
  final int curpage;
  final int allnum;
  final List<HomeData> newslist;

  HomeResult({
    required this.curpage,
    required this.allnum,
    required this.newslist,
  });

  factory HomeResult.fromJson(Map<String, dynamic> json) => _$HomeResultFromJson(json);
  Map<String, dynamic> toJson() => _$HomeResultToJson(this);
}

@JsonSerializable()
class HomeData {
  final String id;
  final String ctime;
  final String title;
  final String description;
  final String source;
  final String picUrl;
  final String url;

  HomeData({
    required this.id,
    required this.ctime,
    required this.title,
    required this.description,
    required this.source,
    required this.picUrl,
    required this.url,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => _$HomeDataFromJson(json);
  Map<String, dynamic> toJson() => _$HomeDataToJson(this);
}