enum AppInterface {
  visitAmman,
  ammanFestival,
}

enum AppRole {
  user,
  vendor,
  advertiser,
}

enum TextSizes {
  small,
  medium,
  large,
}

enum ImageType {
  asset,
  network,
  memory,
  file,
}

enum RequestType {
  get,
  post,
  put,
  delete,
  patch,
  multipart,
}

enum ApiErrorType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  validation,
  rateLimited,
  server,
  network,
  timeout,
  cancelled,
  unknown,
}
