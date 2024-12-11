import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ApiHandler {

  static final ApiHandler _instance = ApiHandler._internal();
  final http.Client _client = http.Client();

  // Private constructor
  ApiHandler._internal();

  // Factory constructor to return the same instance
  factory ApiHandler() => _instance;


  var restHeader = {
    'Accept': 'application/json',
    'Content-type': 'application/json',
  };



  // Function to send HTTP requests (GET, POST, PUT, DELETE)
  Future<http.Response> _sendRequest(MethodType methodType, String url, Map<String, dynamic> params) async {
    try {
      switch (methodType) {
        case MethodType.post:
          return await _client.post(
            Uri.parse(url),
            headers: restHeader,
            body: json.encode(params),
          );
        case MethodType.put:
          return await _client.put(
            Uri.parse(url),
            headers: restHeader,
            body: json.encode(params),
          );
        case MethodType.delete:
          return await _client.delete(
            Uri.parse(url),
            headers: restHeader,
            body: json.encode(params), // Optional body for DELETE requests
          );
        case MethodType.get:
        default:
          return await _client.get(
            Uri.parse(url),
            headers: restHeader,
          );
      }
    } catch (e) {
      throw Exception('Error during HTTP request: $e');
    }
  }


  // Function to handle HTTP responses and error handling
   _handleResponse(http.Response response) async {
    try {
      // Handle different status codes
      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.body;
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: ${response.body}');
      } else if (response.statusCode == 404) {
        throw Exception('Not Found: ${response.body}');
      } else if (response.statusCode == 500) {
        throw Exception('Server Error: ${response.body}');
      } else {
        throw Exception('Unexpected Error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to parse response: $e');
    }
  }

  /*requestRestApi(BuildContext context, Map<String, dynamic> params,
      {MethodType methodType = MethodType.post,
        String nameSpace = alphaUrl, bool isForeground = true}) async {
    http.Response response;
    try
    {
      response = methodType == MethodType.post
           ? await http.post(Uri.parse(nameSpace), body: json.encode(params), headers: restHeader)
           : await http.get(Uri.parse(nameSpace), headers: restHeader);
      showLog('REST Response Body: STATUS => ${response.statusCode} :: BODY => ${json.decode(response.body)}');
      if (response.statusCode == 200 || response.statusCode == 201)
      {
        return response.body;
      }
      else if (response.statusCode == 400 || response.statusCode == 500)
      {
        throw response.body;
      }
      else if (response.statusCode == 404)
      {
        throw response.body;
      }
    }
    catch (e)
    {
      if (isForeground)
      {
        throw e.toString();
      }
    }
  }*/


  // Public method to send the API request and handle response
 requestRestApi(BuildContext context, Map<String, dynamic> params, {
    required MethodType methodType,
    required String nameSpace,
    bool isForeground = true,
  }) async {
    try {
      final response = await _sendRequest(methodType, nameSpace, params);

      // Handle and return the parsed response body
      return await _handleResponse(response);
    } catch (e) {
      if (isForeground)
      {
        _showError(context, e.toString());
      }
      rethrow;
    }
  }

  // Helper method to show error messages (in case of foreground requests)
  void _showError(BuildContext context, String message) {
    // Show the error message in a dialog or toast, for example
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Dispose the client when not needed anymore
  void dispose() {
    _client.close();
  }

}



// Enum for HTTP methods
enum MethodType { post, get, put, delete }