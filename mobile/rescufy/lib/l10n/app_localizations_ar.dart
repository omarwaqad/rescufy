// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'إنقاذ';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get manageAlerts => 'إدارة التنبيهات';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'الإنجليزية';

  @override
  String get arabic => 'العربية';

  @override
  String get privacySecurity => 'الخصوصية والأمان';

  @override
  String get manageYourData => 'إدارة بياناتك';

  @override
  String get helpSupport => 'المساعدة والدعم';

  @override
  String get faqContactUs => 'الأسئلة الشائعة، اتصل بنا';

  @override
  String get medications => 'الأدوية';

  @override
  String get allergies => 'الحساسية';

  @override
  String get chronicDiseases => 'الأمراض المزمنة';

  @override
  String get pastSurgeries => 'العمليات الجراحية السابقة';

  @override
  String get emergencyContacts => 'جهات الاتصال في حالات الطوارئ';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get chooseYourPreferredLanguage => 'اختر لغتك المفضلة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String helloUser(String name) {
    return 'مرحباً، $name 👋';
  }

  @override
  String get howCanWeHelp => 'كيف يمكننا مساعدتك اليوم؟';

  @override
  String get emergencyServices => 'خدمات الطوارئ';

  @override
  String get requestAmbulance => 'طلب سيارة إسعاف';

  @override
  String get forMyselfOrFamily => 'لنفسي أو لأحد أفراد العائلة';

  @override
  String get reportEmergency => 'الإبلاغ عن حالة طوارئ';

  @override
  String get witnessingEmergency => 'مشاهدة حالة طوارئ';

  @override
  String get quickAccess => 'الوصول السريع';

  @override
  String get firstAid => 'الإسعافات الأولية';

  @override
  String get quickGuides => 'أدلة سريعة';

  @override
  String get hospitals => 'المستشفيات';

  @override
  String get findNearby => 'البحث عن الأقرب';

  @override
  String get history => 'السجل';

  @override
  String get pastRequests => 'الطلبات السابقة';

  @override
  String get safetyTips => 'نصائح السلامة';

  @override
  String get stayPrepared => 'كن مستعداً';

  @override
  String get emergencyHotline => 'خط الطوارئ الساخن';

  @override
  String get support24_7 => 'دعم على مدار الساعة • 123-456-7890';

  @override
  String get home => 'الرئيسية';

  @override
  String get accountLoginForm => 'نموذج تسجيل الدخول';

  @override
  String get signInToAccount => 'تسجيل الدخول إلى حسابك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get password => 'كلمة المرور';

  @override
  String get enterPassword => 'أدخل كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'نسيت كلمة المرور؟';

  @override
  String get logIn => 'تسجيل الدخول';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get pleaseEnterEmail => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get pleaseEnterValidEmail => 'الرجاء إدخال بريد إلكتروني صحيح';

  @override
  String get pleaseEnterPassword => 'الرجاء إدخال كلمة المرور';

  @override
  String get passwordMinLength => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get firstAidGuide => 'دليل الإسعافات الأولية';

  @override
  String get checkSceneSafety => 'تحقق من سلامة المكان';

  @override
  String get callEmergencyServices => 'اتصل بخدمات الطوارئ';

  @override
  String get checkResponsiveness => 'تحقق من الاستجابة';

  @override
  String get performCPR => 'قم بالإنعاش القلبي الرئوي إذا لزم الأمر';

  @override
  String get stopBleeding => 'أوقف النزيف بالضغط';

  @override
  String get keepPersonWarm => 'حافظ على دفء الشخص';

  @override
  String get monitorUntilHelp => 'راقب حتى وصول المساعدة';

  @override
  String get close => 'إغلاق';

  @override
  String get nearbyHospitals => 'المستشفيات القريبة';

  @override
  String get hospitalsSubtitle =>
      'قارن المستشفيات القريبة الجاهزة للطوارئ وتحرك بسرعة.';

  @override
  String get yourLocation => 'موقعك';

  @override
  String get openNow => 'مفتوح الآن';

  @override
  String get limited => 'سعة محدودة';

  @override
  String get unavailable => 'غير متاح';

  @override
  String availableBeds(int count) {
    return '$count سرير متاح';
  }

  @override
  String icuAvailability(int count) {
    return '$count عناية مركزة متاحة';
  }

  @override
  String startingFromPrice(String price) {
    return 'يبدأ من $price';
  }

  @override
  String distanceKm(String distance) {
    return 'يبعد $distance كم';
  }

  @override
  String get call => 'اتصال';

  @override
  String get directions => 'الاتجاهات';

  @override
  String get refresh => 'تحديث';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get locationUnavailable => 'الموقع غير متاح';

  @override
  String get enableLocationToFindHospitals =>
      'فعّل خدمات الموقع لعرض المستشفيات القريبة.';

  @override
  String get noHospitalsNearby => 'لا توجد مستشفيات قريبة';

  @override
  String get noHospitalsNearbyMessage => 'جرّب توسيع نطاق البحث أو حدّث موقعك.';

  @override
  String get hospitalsLoadFailed => 'تعذر تحميل المستشفيات القريبة.';

  @override
  String get liveCapacity => 'السعة الحالية';

  @override
  String get mapPreviewUnavailable => 'معاينة الخريطة غير متاحة';

  @override
  String get mapConfigurationRequired =>
      'أضف مفتاح Google Maps API لتفعيل معاينة الخريطة.';

  @override
  String get hospitalStatusAvailable => 'متاح';

  @override
  String get hospitalStatusUnavailable => 'غير متاح';

  @override
  String get hospitalStatusUnknown => 'الحالة غير معروفة';

  @override
  String get requestHistoryTitle => 'سجل الطلبات';

  @override
  String get requestHistoryDetailsTitle => 'تفاصيل الطلب';

  @override
  String get requestHistoryEmptyTitle => 'لا يوجد سجل طلبات';

  @override
  String get requestHistoryEmptyMessage =>
      'ستظهر طلبات الطوارئ هنا بعد إرسال أول طلب.';

  @override
  String get requestHistoryFirstRequest => 'أنشئ أول طلب';

  @override
  String get requestHistoryLoadFailed => 'تعذر تحميل سجل الطلبات.';

  @override
  String get requestHistoryCompleted => 'مكتمل';

  @override
  String get requestHistoryInProgress => 'قيد التنفيذ';

  @override
  String get requestHistoryCancelled => 'ملغي';

  @override
  String get requestId => 'رقم الطلب';

  @override
  String get requestStatus => 'حالة الطلب';

  @override
  String get createdDate => 'تاريخ الإنشاء';

  @override
  String get assignedAmbulancePlate => 'لوحة سيارة الإسعاف';

  @override
  String get driverName => 'اسم السائق';

  @override
  String get hospitalName => 'اسم المستشفى';

  @override
  String get descriptionLabel => 'الوصف';

  @override
  String get addressLabel => 'العنوان';

  @override
  String get viewDetails => 'عرض التفاصيل';

  @override
  String get unknownRequestStatus => 'غير معروف';

  @override
  String get requestStatusPending => 'قيد الانتظار';

  @override
  String get requestStatusAssigned => 'تم التعيين';

  @override
  String get requestStatusAccepted => 'تم القبول';

  @override
  String get requestStatusOnTheWay => 'في الطريق';

  @override
  String get requestStatusArrived => 'تم الوصول';

  @override
  String get requestStatusPickedUp => 'تم النقل';

  @override
  String get requestStatusUnderExecuting => 'قيد التنفيذ';

  @override
  String get requestStatusDelivered => 'تم التسليم';

  @override
  String get requestStatusNotDelivered => 'لم يتم التسليم';

  @override
  String get requestStatusCanceled => 'ملغي';

  @override
  String get requestStatusFinished => 'منتهي';

  @override
  String get requestStatusClosed => 'مغلق';

  @override
  String get markAllAsRead => 'تحديد الكل مقروء';

  @override
  String get notificationsLoadFailed => 'تعذر تحميل الإشعارات.';

  @override
  String get notificationsEmptyTitle => 'لا توجد إشعارات';

  @override
  String get notificationsEmptyMessage =>
      'ليس لديك أي إشعارات في الوقت الحالي.';

  @override
  String get unread => 'غير مقروء';

  @override
  String get deleteNotification => 'حذف الإشعار';

  @override
  String get deleteNotificationConfirm =>
      'هل أنت متأكد أنك تريد حذف هذا الإشعار؟';

  @override
  String get delete => 'حذف';

  @override
  String get safetyTip1 => 'ابق هادئاً وقيّم الموقف';

  @override
  String get safetyTip2 => 'اتصل بخدمات الطوارئ فوراً';

  @override
  String get safetyTip3 => 'قدم معلومات واضحة عن الموقع';

  @override
  String get safetyTip4 => 'اتبع تعليمات المرسل';

  @override
  String get safetyTip5 => 'احتفظ بجهات الاتصال الطارئة في متناول اليد';

  @override
  String get safetyTip6 => 'اعرف معلوماتك الطبية';
}
