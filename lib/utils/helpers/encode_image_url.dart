String encodeImageUrl(String url) {
  try {
    // Check if URL is already properly formatted for the browser
    if (url.contains('%') && Uri.parse(url).host.isNotEmpty) {
      return url; // URL is already properly formatted
    }

    // First, decode the URL in case it has partial encoding
    var decodedUrl = Uri.decodeFull(url);

    // Parse the decoded URL
    var uri = Uri.parse(decodedUrl);
    final host = uri.host;
    final scheme = uri.scheme;

    if (host.isEmpty) {
      // If URL parsing fails, try manual approach
      //debugPrint('Host empty, using manual URL encoding');
      return url;
    }

    // Rebuild the URL with fully encoded path segments
    var newUrl = StringBuffer('$scheme://$host');

    // Handle port if present
    if (uri.port != 80 && uri.port != 443 && uri.hasPort) {
      newUrl.write(':${uri.port}');
    }

    // Build the path with proper encoding for each segment
    var encodedSegments = <String>[];
    for (var segment in uri.pathSegments) {
      // Decode first in case of partial encoding
      var decodedSegment = Uri.decodeFull(segment);
      // Then encode properly
      encodedSegments.add(Uri.encodeComponent(decodedSegment));
    }

    if (encodedSegments.isNotEmpty) {
      newUrl.write('/${encodedSegments.join('/')}');
    }

    // Add query parameters if any
    if (uri.hasQuery) {
      newUrl.write('?${uri.query}');
    }

    // Add fragment if any
    if (uri.hasFragment) {
      newUrl.write('#${uri.fragment}');
    }

    //s   debugPrint('Original URL: $url');
    // debugPrint('Encoded URL: ${newUrl.toString()}');

    return newUrl.toString();
  } catch (e) {
    // If parsing fails, return original URL
    ///debugPrint('URL encoding error: $e');
    return url;
  }
}
