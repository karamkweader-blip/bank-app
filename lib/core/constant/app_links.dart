class AppLink {
  // أنت أرسلتها كـ const String baseURL = "http://192.168.50.143:8000/api/";
  static const String baseUrl = "http://10.42.52.83:8000/api/";
static const String openTicket = "${baseUrl}user/open-ticket";
  
  // يجب أن تكون هذه الدالة قابلة لاستقبال ID التذكرة
  static String addMessage(int ticketId) => "${baseUrl}user/add-message/$ticketId";
  // التوكن الثابت كما طلبته
  static const String staticToken = "1|xI4mgFPegqysexKWaY4m8NUKmQZtpZZFfeP0z5x08c06507a";
  
  // روابط API
  static const String openAccount = "${baseUrl}user/open-account";
  static const String userAccounts = "${baseUrl}user/accounts-user";

  // تعريب أنواع الحسابات
  static String getTranslatedAccountType(String type) {
    switch (type.toLowerCase()) {
      case 'savings':
        return 'حساب توفير';
      case 'checking':
        return 'حساب تجاري';
      case 'loan':
        return 'حساب قرض';
      case 'investment':
        return 'حساب استثماري';
      case 'composite':
        return 'حساب مركب';
      default:
        return type;
    }
  }
}