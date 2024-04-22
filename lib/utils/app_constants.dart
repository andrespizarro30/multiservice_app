class AppConstants{
  static const String APP_NAME = "App Multiservices";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "https://generalwebservicesapi.azurewebsites.net";
  static const String GOOGLE_MAPS_API_BASE_URL = "https://maps.googleapis.com/maps/api";

  static const String SERVICES_LIST_URI = "/api/services/get";
  static const String ADVERTISING_LIST_URI = "/api/advertising/get";
  static const String MY_REGISTERED_JOBS_URI = "/api/jobrequested/get";
  static const String REGISTER_NEW_JOB_URI = "/api/registerNewJob/post";

  static const String GOOGLEMAPSANDROIDKEY = "AIzaSyAkBBvSMGpO4EoLTNjkLr7V-HzvdRlTY14";
  static const String GOOGLEMAPSIOSKEY = "AIzaSyB3gCARPJjOJlVD-HWqHYxUpwC2T-ZnxYg";

  static const String GEOCODINGKEY = "AIzaSyCBDQ2l_f4ksZaSzkCqhNsOhdHfbU5lKqA";
  static const String PLACESCODINGKEY = "AIzaSyCBDQ2l_f4ksZaSzkCqhNsOhdHfbU5lKqA";

  static const String TOKEN = "";

  static const String ADDRESSSAVED = "AddressSaved";

  static const String FIRESTORE_USERS_COLLECTION = "users";
  static const String FIRESTORE_CHAT_COLLECTION = "chat_rooms";
  static const String FIRESTORE_CHAT_MESSAGES_COLLECTION = "messages";
  static const String FIRESTORE_TOKENS = "token";

  static const String FIREBASE_MESSAGING_AUTH_TOKEN = "AAAAL5oC0kA:APA91bEEb8HjTrHOHetu76dafxoeynF-rlfCmV0x259idztXvxB4UtJGlVz_mqu5fSXfdWlhq9ZUPHbxoIX4-wiGghY2kUJaxop2TRbZqCgvoD8o6qoAnnagAb0Bsn2SkYUb98ebid99";

  static const String PENDINGMESSAGESCOUNT = "PendingMessageCount";

  static const String CURRENTPAGE = "CurrentPage";

  static const String CREATEMULTIPORPUSEJOBSDB = "CREATE TABLE MultiporpuseSavedJobs("
      "OrderNumber TEXT PRIMARY KEY,"
      "JobType TEXT,"
      "JobAddress TEXT,"
      "JobLocation TEXT,"
      "JobDescription TEXT,"
      "FilesPath TEXT,"
      "FormType TEXT,"
      "RequestedDate TEXT,"
      "LoadedJob TEXT,"
      "JobUID TEXT,"
      "JobToken TEXT,"
      "TokenTopic TEXT)";

}