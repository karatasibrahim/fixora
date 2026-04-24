import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In tr, this message translates to:
  /// **'Fixora'**
  String get appTitle;

  /// No description provided for @greetingMorning.
  ///
  /// In tr, this message translates to:
  /// **'Günaydın'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In tr, this message translates to:
  /// **'İyi günler'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In tr, this message translates to:
  /// **'İyi akşamlar'**
  String get greetingEvening;

  /// No description provided for @alertCritical.
  ///
  /// In tr, this message translates to:
  /// **'2 makine acil müdahale gerektiriyor.'**
  String get alertCritical;

  /// No description provided for @sectionOverview.
  ///
  /// In tr, this message translates to:
  /// **'Genel Bakış'**
  String get sectionOverview;

  /// No description provided for @statTotalMachines.
  ///
  /// In tr, this message translates to:
  /// **'Toplam Makine'**
  String get statTotalMachines;

  /// No description provided for @statActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get statActive;

  /// No description provided for @statWarnings.
  ///
  /// In tr, this message translates to:
  /// **'Uyarılar'**
  String get statWarnings;

  /// No description provided for @statCritical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik'**
  String get statCritical;

  /// No description provided for @btnAddMachine.
  ///
  /// In tr, this message translates to:
  /// **'Makine Ekle'**
  String get btnAddMachine;

  /// No description provided for @btnLogFailure.
  ///
  /// In tr, this message translates to:
  /// **'Arıza Gir'**
  String get btnLogFailure;

  /// No description provided for @sectionRecentFailures.
  ///
  /// In tr, this message translates to:
  /// **'Son Arızalar'**
  String get sectionRecentFailures;

  /// No description provided for @sectionMaintenanceDue.
  ///
  /// In tr, this message translates to:
  /// **'Yaklaşan Bakımlar'**
  String get sectionMaintenanceDue;

  /// No description provided for @seeAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümünü Gör'**
  String get seeAll;

  /// No description provided for @tooltipNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get tooltipNotifications;

  /// No description provided for @pageMachines.
  ///
  /// In tr, this message translates to:
  /// **'Makineler'**
  String get pageMachines;

  /// No description provided for @tooltipFilter.
  ///
  /// In tr, this message translates to:
  /// **'Filtrele'**
  String get tooltipFilter;

  /// No description provided for @searchHint.
  ///
  /// In tr, this message translates to:
  /// **'Makine ara…'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In tr, this message translates to:
  /// **'Tümü'**
  String get filterAll;

  /// No description provided for @statusActive.
  ///
  /// In tr, this message translates to:
  /// **'Aktif'**
  String get statusActive;

  /// No description provided for @statusWarning.
  ///
  /// In tr, this message translates to:
  /// **'Uyarı'**
  String get statusWarning;

  /// No description provided for @statusCritical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik'**
  String get statusCritical;

  /// No description provided for @statusOffline.
  ///
  /// In tr, this message translates to:
  /// **'Çevrimdışı'**
  String get statusOffline;

  /// No description provided for @noMachinesFound.
  ///
  /// In tr, this message translates to:
  /// **'Makine bulunamadı'**
  String get noMachinesFound;

  /// No description provided for @tryDifferentFilter.
  ///
  /// In tr, this message translates to:
  /// **'Farklı bir arama veya filtre deneyin'**
  String get tryDifferentFilter;

  /// No description provided for @checkedAgo.
  ///
  /// In tr, this message translates to:
  /// **'Kontrol: {time}'**
  String checkedAgo(String time);

  /// No description provided for @pageAddMachine.
  ///
  /// In tr, this message translates to:
  /// **'Makine Ekle'**
  String get pageAddMachine;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @sectionBasicInfo.
  ///
  /// In tr, this message translates to:
  /// **'Temel Bilgiler'**
  String get sectionBasicInfo;

  /// No description provided for @fieldMachineName.
  ///
  /// In tr, this message translates to:
  /// **'Makine Adı'**
  String get fieldMachineName;

  /// No description provided for @hintMachineName.
  ///
  /// In tr, this message translates to:
  /// **'örn. CNC Torna #1'**
  String get hintMachineName;

  /// No description provided for @fieldMachineType.
  ///
  /// In tr, this message translates to:
  /// **'Makine Türü'**
  String get fieldMachineType;

  /// No description provided for @fieldLocation.
  ///
  /// In tr, this message translates to:
  /// **'Konum'**
  String get fieldLocation;

  /// No description provided for @hintLocation.
  ///
  /// In tr, this message translates to:
  /// **'örn. Salon A · Hat 3'**
  String get hintLocation;

  /// No description provided for @sectionSpecifications.
  ///
  /// In tr, this message translates to:
  /// **'Teknik Özellikler'**
  String get sectionSpecifications;

  /// No description provided for @fieldManufacturer.
  ///
  /// In tr, this message translates to:
  /// **'Üretici'**
  String get fieldManufacturer;

  /// No description provided for @hintManufacturer.
  ///
  /// In tr, this message translates to:
  /// **'örn. Siemens'**
  String get hintManufacturer;

  /// No description provided for @fieldModel.
  ///
  /// In tr, this message translates to:
  /// **'Model / Seri No.'**
  String get fieldModel;

  /// No description provided for @hintModel.
  ///
  /// In tr, this message translates to:
  /// **'örn. S-7000-X'**
  String get hintModel;

  /// No description provided for @fieldInstallDate.
  ///
  /// In tr, this message translates to:
  /// **'Kurulum Tarihi'**
  String get fieldInstallDate;

  /// No description provided for @hintSelectDate.
  ///
  /// In tr, this message translates to:
  /// **'Tarih seçin'**
  String get hintSelectDate;

  /// No description provided for @sectionNotes.
  ///
  /// In tr, this message translates to:
  /// **'Notlar'**
  String get sectionNotes;

  /// No description provided for @hintNotes.
  ///
  /// In tr, this message translates to:
  /// **'Ek notlar…'**
  String get hintNotes;

  /// No description provided for @btnSaveMachine.
  ///
  /// In tr, this message translates to:
  /// **'Makineyi Kaydet'**
  String get btnSaveMachine;

  /// No description provided for @validationRequired.
  ///
  /// In tr, this message translates to:
  /// **'{field} zorunludur'**
  String validationRequired(String field);

  /// No description provided for @successMachineAdded.
  ///
  /// In tr, this message translates to:
  /// **'{name} başarıyla eklendi'**
  String successMachineAdded(String name);

  /// No description provided for @machineTypeCNC.
  ///
  /// In tr, this message translates to:
  /// **'CNC'**
  String get machineTypeCNC;

  /// No description provided for @machineTypeHydraulic.
  ///
  /// In tr, this message translates to:
  /// **'Hidrolik'**
  String get machineTypeHydraulic;

  /// No description provided for @machineTypeCompressor.
  ///
  /// In tr, this message translates to:
  /// **'Kompresör'**
  String get machineTypeCompressor;

  /// No description provided for @machineTypeConveyor.
  ///
  /// In tr, this message translates to:
  /// **'Konveyör'**
  String get machineTypeConveyor;

  /// No description provided for @machineTypePump.
  ///
  /// In tr, this message translates to:
  /// **'Pompa'**
  String get machineTypePump;

  /// No description provided for @machineTypeMotor.
  ///
  /// In tr, this message translates to:
  /// **'Motor'**
  String get machineTypeMotor;

  /// No description provided for @machineTypeHVAC.
  ///
  /// In tr, this message translates to:
  /// **'HVAC'**
  String get machineTypeHVAC;

  /// No description provided for @machineTypePress.
  ///
  /// In tr, this message translates to:
  /// **'Pres'**
  String get machineTypePress;

  /// No description provided for @machineTypeOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get machineTypeOther;

  /// No description provided for @pageLogFailure.
  ///
  /// In tr, this message translates to:
  /// **'Arıza Kaydı'**
  String get pageLogFailure;

  /// No description provided for @fieldMachine.
  ///
  /// In tr, this message translates to:
  /// **'Makine'**
  String get fieldMachine;

  /// No description provided for @hintSelectMachine.
  ///
  /// In tr, this message translates to:
  /// **'Makine seçin'**
  String get hintSelectMachine;

  /// No description provided for @sectionFailureType.
  ///
  /// In tr, this message translates to:
  /// **'Arıza Türü'**
  String get sectionFailureType;

  /// No description provided for @failureTypeMechanical.
  ///
  /// In tr, this message translates to:
  /// **'Mekanik'**
  String get failureTypeMechanical;

  /// No description provided for @failureTypeElectrical.
  ///
  /// In tr, this message translates to:
  /// **'Elektriksel'**
  String get failureTypeElectrical;

  /// No description provided for @failureTypeHydraulic.
  ///
  /// In tr, this message translates to:
  /// **'Hidrolik'**
  String get failureTypeHydraulic;

  /// No description provided for @failureTypeSoftware.
  ///
  /// In tr, this message translates to:
  /// **'Yazılım'**
  String get failureTypeSoftware;

  /// No description provided for @failureTypeStructural.
  ///
  /// In tr, this message translates to:
  /// **'Yapısal'**
  String get failureTypeStructural;

  /// No description provided for @failureTypeOther.
  ///
  /// In tr, this message translates to:
  /// **'Diğer'**
  String get failureTypeOther;

  /// No description provided for @sectionSeverity.
  ///
  /// In tr, this message translates to:
  /// **'Ciddiyet Derecesi'**
  String get sectionSeverity;

  /// No description provided for @severityLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get severityLow;

  /// No description provided for @severityMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get severityMedium;

  /// No description provided for @severityHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get severityHigh;

  /// No description provided for @severityCritical.
  ///
  /// In tr, this message translates to:
  /// **'Kritik'**
  String get severityCritical;

  /// No description provided for @sectionDescription.
  ///
  /// In tr, this message translates to:
  /// **'Açıklama'**
  String get sectionDescription;

  /// No description provided for @hintDescription.
  ///
  /// In tr, this message translates to:
  /// **'Ne olduğunu ve gözlemlenen belirtileri açıklayın…'**
  String get hintDescription;

  /// No description provided for @reportedAt.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Zamanı'**
  String get reportedAt;

  /// No description provided for @reportedBy.
  ///
  /// In tr, this message translates to:
  /// **'Kaydeden'**
  String get reportedBy;

  /// No description provided for @btnSubmitFailure.
  ///
  /// In tr, this message translates to:
  /// **'Arıza Raporunu Gönder'**
  String get btnSubmitFailure;

  /// No description provided for @validationSelectMachine.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir makine seçin'**
  String get validationSelectMachine;

  /// No description provided for @successFailureLogged.
  ///
  /// In tr, this message translates to:
  /// **'Arıza başarıyla kaydedildi'**
  String get successFailureLogged;

  /// No description provided for @validationDescriptionRequired.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen arızayı açıklayın'**
  String get validationDescriptionRequired;

  /// No description provided for @pagePredictions.
  ///
  /// In tr, this message translates to:
  /// **'Tahminler'**
  String get pagePredictions;

  /// No description provided for @tooltipAboutPredictions.
  ///
  /// In tr, this message translates to:
  /// **'Tahminler hakkında'**
  String get tooltipAboutPredictions;

  /// No description provided for @labelHealthScore.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık Puanı'**
  String get labelHealthScore;

  /// No description provided for @labelNextService.
  ///
  /// In tr, this message translates to:
  /// **'Sonraki Bakım'**
  String get labelNextService;

  /// No description provided for @labelRiskLevel.
  ///
  /// In tr, this message translates to:
  /// **'Risk Seviyesi'**
  String get labelRiskLevel;

  /// No description provided for @sectionHealthMetrics.
  ///
  /// In tr, this message translates to:
  /// **'Sağlık Metrikleri'**
  String get sectionHealthMetrics;

  /// No description provided for @sectionRecommendations.
  ///
  /// In tr, this message translates to:
  /// **'Öneriler'**
  String get sectionRecommendations;

  /// No description provided for @sectionAllMachines.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Makineler'**
  String get sectionAllMachines;

  /// No description provided for @riskLow.
  ///
  /// In tr, this message translates to:
  /// **'Düşük'**
  String get riskLow;

  /// No description provided for @riskMedium.
  ///
  /// In tr, this message translates to:
  /// **'Orta'**
  String get riskMedium;

  /// No description provided for @riskHigh.
  ///
  /// In tr, this message translates to:
  /// **'Yüksek'**
  String get riskHigh;

  /// No description provided for @riskUnknown.
  ///
  /// In tr, this message translates to:
  /// **'Bilinmiyor'**
  String get riskUnknown;

  /// No description provided for @pageProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get pageProfile;

  /// No description provided for @tooltipEditProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profili düzenle'**
  String get tooltipEditProfile;

  /// No description provided for @jobTitle.
  ///
  /// In tr, this message translates to:
  /// **'Bakım Mühendisi'**
  String get jobTitle;

  /// No description provided for @rankSenior.
  ///
  /// In tr, this message translates to:
  /// **'Kıdemli'**
  String get rankSenior;

  /// No description provided for @statMachinesLabel.
  ///
  /// In tr, this message translates to:
  /// **'Makine'**
  String get statMachinesLabel;

  /// No description provided for @statFailuresLabel.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı\nArıza'**
  String get statFailuresLabel;

  /// No description provided for @statAvgResponseLabel.
  ///
  /// In tr, this message translates to:
  /// **'Ort.\nYanıt'**
  String get statAvgResponseLabel;

  /// No description provided for @settingNotifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get settingNotifications;

  /// No description provided for @settingNotificationsSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Uygulama, e-posta uyarıları'**
  String get settingNotificationsSubtitle;

  /// No description provided for @settingLanguage.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get settingLanguage;

  /// No description provided for @settingLanguageCurrent.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get settingLanguageCurrent;

  /// No description provided for @settingAppearance.
  ///
  /// In tr, this message translates to:
  /// **'Görünüm'**
  String get settingAppearance;

  /// No description provided for @settingAppearanceSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Açık tema'**
  String get settingAppearanceSubtitle;

  /// No description provided for @settingSecurity.
  ///
  /// In tr, this message translates to:
  /// **'Güvenlik'**
  String get settingSecurity;

  /// No description provided for @settingSecuritySubtitle.
  ///
  /// In tr, this message translates to:
  /// **'2FA aktif'**
  String get settingSecuritySubtitle;

  /// No description provided for @settingExportData.
  ///
  /// In tr, this message translates to:
  /// **'Veri Dışa Aktar'**
  String get settingExportData;

  /// No description provided for @settingExportDataSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'CSV, PDF raporlar'**
  String get settingExportDataSubtitle;

  /// No description provided for @settingHelpSupport.
  ///
  /// In tr, this message translates to:
  /// **'Yardım & Destek'**
  String get settingHelpSupport;

  /// No description provided for @settingHelpSupportSubtitle.
  ///
  /// In tr, this message translates to:
  /// **'Belgeler, bize ulaşın'**
  String get settingHelpSupportSubtitle;

  /// No description provided for @btnLogOut.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get btnLogOut;

  /// No description provided for @dialogLogOutTitle.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get dialogLogOutTitle;

  /// No description provided for @dialogLogOutMessage.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış yapmak istediğinizden emin misiniz?'**
  String get dialogLogOutMessage;

  /// No description provided for @btnCancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get btnCancel;

  /// No description provided for @navHome.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get navHome;

  /// No description provided for @navMachines.
  ///
  /// In tr, this message translates to:
  /// **'Makineler'**
  String get navMachines;

  /// No description provided for @navPredictions.
  ///
  /// In tr, this message translates to:
  /// **'Tahminler'**
  String get navPredictions;

  /// No description provided for @navProfile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get navProfile;

  /// No description provided for @dialogLanguageTitle.
  ///
  /// In tr, this message translates to:
  /// **'Dil Seçin'**
  String get dialogLanguageTitle;

  /// No description provided for @langTurkish.
  ///
  /// In tr, this message translates to:
  /// **'Türkçe'**
  String get langTurkish;

  /// No description provided for @langEnglish.
  ///
  /// In tr, this message translates to:
  /// **'İngilizce'**
  String get langEnglish;

  /// No description provided for @pageMachineDetail.
  ///
  /// In tr, this message translates to:
  /// **'Makine Detayı'**
  String get pageMachineDetail;

  /// No description provided for @sectionMachineInfo.
  ///
  /// In tr, this message translates to:
  /// **'Makine Bilgisi'**
  String get sectionMachineInfo;

  /// No description provided for @labelType.
  ///
  /// In tr, this message translates to:
  /// **'Tür'**
  String get labelType;

  /// No description provided for @labelLastChecked.
  ///
  /// In tr, this message translates to:
  /// **'Son Kontrol'**
  String get labelLastChecked;

  /// No description provided for @noFailuresFound.
  ///
  /// In tr, this message translates to:
  /// **'Kayıtlı arıza yok'**
  String get noFailuresFound;

  /// No description provided for @noMaintenanceFound.
  ///
  /// In tr, this message translates to:
  /// **'Planlanmış bakım yok'**
  String get noMaintenanceFound;

  /// No description provided for @timeSecondsAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n}sn önce'**
  String timeSecondsAgo(int n);

  /// No description provided for @timeMinutesAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n}dk önce'**
  String timeMinutesAgo(int n);

  /// No description provided for @timeHoursAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n}sa önce'**
  String timeHoursAgo(int n);

  /// No description provided for @timeDaysAgo.
  ///
  /// In tr, this message translates to:
  /// **'{n}g önce'**
  String timeDaysAgo(int n);

  /// No description provided for @btnViewPredictions.
  ///
  /// In tr, this message translates to:
  /// **'Tahminlerde Gör'**
  String get btnViewPredictions;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
