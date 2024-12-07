// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeModel _$HomeModelFromJson(Map<String, dynamic> json) => HomeModel(
      code: (json['code'] as num).toInt(),
      msg: json['msg'] as String,
      result: HomeResult.fromJson(json['result'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeModelToJson(HomeModel instance) => <String, dynamic>{
      'code': instance.code,
      'msg': instance.msg,
      'result': instance.result,
    };

HomeResult _$HomeResultFromJson(Map<String, dynamic> json) => HomeResult(
      curpage: (json['curpage'] as num).toInt(),
      allnum: (json['allnum'] as num).toInt(),
      newslist: (json['newslist'] as List<dynamic>)
          .map((e) => HomeData.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HomeResultToJson(HomeResult instance) =>
    <String, dynamic>{
      'curpage': instance.curpage,
      'allnum': instance.allnum,
      'newslist': instance.newslist,
    };

HomeData _$HomeDataFromJson(Map<String, dynamic> json) => HomeData(
      id: json['id'] as String,
      ctime: json['ctime'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      source: json['source'] as String,
      picUrl: json['picUrl'] as String,
      url: json['url'] as String,
    );

Map<String, dynamic> _$HomeDataToJson(HomeData instance) => <String, dynamic>{
      'id': instance.id,
      'ctime': instance.ctime,
      'title': instance.title,
      'description': instance.description,
      'source': instance.source,
      'picUrl': instance.picUrl,
      'url': instance.url,
    };
