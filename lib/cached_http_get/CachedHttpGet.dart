// Package imports:
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:supercharged/supercharged.dart';

// A shitty cacher for http requests, works perfect for this project
class CachedHttpGet {
  static Map<Request, String> cache = {};

  static Future<String> get(Request req) async {
    if (cache.keys.contains(req)) return cache[req];

    var response = await retry(
      () => http.get(
        req.url,
        headers: req.header,
      ),
      maxAttempts: 100,
      maxDelay: 1000.milliseconds,
      delayFactor: 100.milliseconds,
    );

    cache[req] = response.body;

    return response.body;
  }
}

class Request {
  final String url;
  final Map<String, String> header;

  Request({this.url, this.header});

  @override
  bool operator ==(covariant Request req) {
    if (identical(this, req)) return true;

    return (req.url == this.url &&
        req.header.toString() == this.header.toString());
  }

  @override
  int get hashCode => url.hashCode;
}
