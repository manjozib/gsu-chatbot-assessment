class Endpoint {
  // static String? baseUrl;
  static String? baseUrl = "http://10.0.12.11:8081/api";

  // static void setBaseUrl(String ipAddress, String portNumber) {
  //   baseUrl = "http://$ipAddress:$portNumber";
  // }

  static String? getBaseUrl() {
    return baseUrl;
  }

  static String getAdminApi() {
    return "${getBaseUrl()}/admin";
  }

  static String getFaqsApi() {
    return "${getBaseUrl()}/chat";
  }

  static String getChatApi() {
    return "${getBaseUrl()}/faqs";
  }
}