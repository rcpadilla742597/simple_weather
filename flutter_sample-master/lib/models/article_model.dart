import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ArticleModel {
  int id;
  bool featured;
  String title;
  String url;
  NetworkImage image;
  String newsSite;
  String summary;
  String publishedAt;
//This is the default constructor this is equivelent to :

/*
 * ArticleModel({  String id,
  String title,String url,String imageurl,String newsSite,String summary,String publishedAt,String updatedAt,}){
  this.id = id
  this.title = title
  this.url = url
  this.imageurl = imageurl
  this.newsSite = newsSite
  this.summary = summary
  this.publishedAt = publishedAt
  this.updatedAt = updatedAt
  }
 */
  ArticleModel({
    this.id,
    this.featured,
    this.title,
    this.url,
    this.image,
    this.newsSite,
    this.summary,
    this.publishedAt,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
        id: json['id'],
        featured: json['featured'],
        title: json['title'],
        url: json['url'],
        //Proxy for web because of cors-policy
        image: NetworkImage(
            "${kIsWeb ? 'https://api.codetabs.com/v1/proxy?quest=' : ''}${json['imageUrl']}"),
        newsSite: json['newsSite'],
        summary: json['summary'],
        publishedAt: json['publishedAt']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['featured'] = this.featured;
    data['title'] = this.title;
    data['url'] = this.url;
    data['imageUrl'] = this.image.url;
    data['newsSite'] = this.newsSite;
    data['summary'] = this.summary;

    return data;
  }
}
