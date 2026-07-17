import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:offixoadmin/core/utils/globals.dart';
import 'package:offixoadmin/core/network/connectivity_service.dart';

export 'package:http/http.dart' hide get, post, put, delete, patch, head, read, readBytes, MultipartRequest;

bool _isSnackbarShowing = false;

Future<void> _checkConnectivity() async {
  bool isConnected = await ConnectivityService.instance.isConnected;
  if (!isConnected) {
    _handleNetworkError();
    throw const SocketException("No Internet Connection");
  }
}

void _handleNetworkError() {
  if (!_isSnackbarShowing) {
    _isSnackbarShowing = true;
    scaffoldMessengerKey.currentState?.showSnackBar(
      const SnackBar(
        content: Text("No Internet Connection. Please check your network and try again."),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 3),
      ),
    );
    Timer(const Duration(seconds: 3), () {
      _isSnackbarShowing = false;
    });
  }
}

Future<http.Response> _wrapRequest(Future<http.Response> Function() request) async {
  await _checkConnectivity();
  try {
    return await request();
  } on SocketException {
    _handleNetworkError();
    rethrow;
  } on TimeoutException {
    _handleNetworkError();
    rethrow;
  }
}

Future<http.Response> get(Uri url, {Map<String, String>? headers}) =>
    _wrapRequest(() => http.get(url, headers: headers));

Future<http.Response> post(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _wrapRequest(() => http.post(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> put(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _wrapRequest(() => http.put(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> patch(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _wrapRequest(() => http.patch(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> delete(Uri url, {Map<String, String>? headers, Object? body, Encoding? encoding}) =>
    _wrapRequest(() => http.delete(url, headers: headers, body: body, encoding: encoding));

Future<http.Response> head(Uri url, {Map<String, String>? headers}) =>
    _wrapRequest(() => http.head(url, headers: headers));

Future<String> read(Uri url, {Map<String, String>? headers}) async {
  await _checkConnectivity();
  try {
    return await http.read(url, headers: headers);
  } on SocketException {
    _handleNetworkError();
    rethrow;
  } on TimeoutException {
    _handleNetworkError();
    rethrow;
  }
}

Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) async {
  await _checkConnectivity();
  try {
    return await http.readBytes(url, headers: headers);
  } on SocketException {
    _handleNetworkError();
    rethrow;
  } on TimeoutException {
    _handleNetworkError();
    rethrow;
  }
}

class MultipartRequest extends http.MultipartRequest {
  MultipartRequest(String method, Uri url) : super(method, url);

  @override
  Future<http.StreamedResponse> send() async {
    await _checkConnectivity();
    try {
      return await super.send();
    } on SocketException {
      _handleNetworkError();
      rethrow;
    } on TimeoutException {
      _handleNetworkError();
      rethrow;
    }
  }
}
