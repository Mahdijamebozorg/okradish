class HTTPResponseValidator {
  static List<int> errorCode = [
    202,
    203,
  ];
  static bool validate(int statusCode, {String? message}) {
    if (statusCode >= 200 &&
        statusCode < 300 &&
        !errorCode.contains(statusCode)) {
      return true;
    } else {
      throw MyHTTPExeption(statusCode, message);
    }
  }
}

class MyHTTPExeption implements Exception {
  final int statusCode;
  final String? msg;
  MyHTTPExeption(this.statusCode, this.msg);

  @override
  String toString() {
    String message;

    switch (statusCode) {
      case 101:
        message = 'اطلاعات وارد شده صحیح نمی باشد';
        break;
      case -1:
            message ='اتصال برقرار نشد، لطفا دوباره تلاش کنید';
        break;
      case 124:
        message = 'اتصال اینترنت را چک کنید';
        break;
      case 142:
        message = msg!;
        break;
      case 202:
        message = 'حساب کاربری دیگری با این نام وجود دارد';
        break;
      case 203:
        message = 'حساب کاربری دیگری با این ایمیل وجود دارد';
        break;
      case 400:
        message = 'درخواست اشتباه';
        break;
      case 401:
        message = 'Unauthorized';
        break;
      case 403:
        message = 'اجازه دسترسی ندارید';
        break;
      case 409:
        message = 'Conflict';
        break;
      case 500:
      case 501:
      case 502:
      case 503:
      case 504:
      case 505:
        message = 'Internal Server Error';
        break;
      default:
        message = "Unknown Error";
    }
    return 'کد $statusCode, $message';
  }
}
