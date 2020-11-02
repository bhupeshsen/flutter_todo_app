import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_appointy_todo_task/model/todos.dart';


const base_url = 'http://192.168.43.56:8080';



Future<List<Todos>> getTodos() async {
  try {
    Dio dio = new Dio();
    Response<String> response = await dio.get('$base_url/todos');


    dynamic data = json.decode(response.data);
    List responseJson = data['data']['Todos'];
    return responseJson.map((m) => new Todos.fromJson(m)).toList();
  } on DioError catch (e) {
    print(e.response);
    return [];
  }
}

Future<List<Todos>> addTodo(body) async {
  try {
    Response<String> response =
        await Dio().post('$base_url/create-todo', data: body);
    dynamic data = json.decode(response.data);
    print(data);
    List responseJson = data['data']['Todos'];
    return responseJson.map((m) => new Todos.fromJson(m)).toList();
  } on DioError catch (e) {
    print(e.response);
    return [];
  }
}

Future<List<Todos>> editTodo(id, body) async {
  try {
    Response<String> response =
        await Dio().patch('$base_url/todos/$id/edit', data: body);
    dynamic data = json.decode(response.data);
    print(data);
    List responseJson = data['data']['Todos'];
    return responseJson.map((m) => new Todos.fromJson(m)).toList();
  } on DioError catch (e) {
    print(e.response);
    return [];
  }
}

Future<List<Todos>> deleteTodo(id) async {
  try {
    Response<String> response = await Dio().delete('$base_url/todos/$id');
    dynamic data = json.decode(response.data);
    print(data);
    List responseJson = data['data']['Todos'];
    return responseJson.map((m) => new Todos.fromJson(m)).toList();
  } on DioError catch (e) {
    print(e.response);
    return [];
  }
}

Future<List<Todos>> markTodo(id,body) async {
  try {
    Response<String> response = await Dio().patch('$base_url/todos/$id', data: body);
    dynamic data = json.decode(response.data);
    print(data);
    List responseJson = data['data']['Todos'];
    return responseJson.map((m) => new Todos.fromJson(m)).toList();
  } on DioError catch (e) {
    print(e.response);
    return [];
  }
}
