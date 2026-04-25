// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Fixora';

  @override
  String get greetingMorning => 'Günaydın';

  @override
  String get greetingAfternoon => 'İyi günler';

  @override
  String get greetingEvening => 'İyi akşamlar';

  @override
  String get alertCritical => '2 makine acil müdahale gerektiriyor.';

  @override
  String get sectionOverview => 'Genel Bakış';

  @override
  String get statTotalMachines => 'Toplam Makine';

  @override
  String get statActive => 'Aktif';

  @override
  String get statWarnings => 'Uyarılar';

  @override
  String get statCritical => 'Kritik';

  @override
  String get btnAddMachine => 'Makine Ekle';

  @override
  String get btnLogFailure => 'Arıza Gir';

  @override
  String get sectionRecentFailures => 'Son Arızalar';

  @override
  String get sectionMaintenanceDue => 'Yaklaşan Bakımlar';

  @override
  String get seeAll => 'Tümünü Gör';

  @override
  String get tooltipNotifications => 'Bildirimler';

  @override
  String get pageMachines => 'Makineler';

  @override
  String get tooltipFilter => 'Filtrele';

  @override
  String get searchHint => 'Makine ara…';

  @override
  String get filterAll => 'Tümü';

  @override
  String get statusActive => 'Aktif';

  @override
  String get statusWarning => 'Uyarı';

  @override
  String get statusCritical => 'Kritik';

  @override
  String get statusOffline => 'Çevrimdışı';

  @override
  String get noMachinesFound => 'Makine bulunamadı';

  @override
  String get tryDifferentFilter => 'Farklı bir arama veya filtre deneyin';

  @override
  String checkedAgo(String time) {
    return 'Kontrol: $time';
  }

  @override
  String get pageAddMachine => 'Makine Ekle';

  @override
  String get save => 'Kaydet';

  @override
  String get sectionBasicInfo => 'Temel Bilgiler';

  @override
  String get fieldMachineName => 'Makine Adı';

  @override
  String get hintMachineName => 'örn. CNC Torna #1';

  @override
  String get fieldMachineType => 'Makine Türü';

  @override
  String get fieldLocation => 'Konum';

  @override
  String get hintLocation => 'örn. Salon A · Hat 3';

  @override
  String get sectionSpecifications => 'Teknik Özellikler';

  @override
  String get fieldManufacturer => 'Üretici';

  @override
  String get hintManufacturer => 'örn. Siemens';

  @override
  String get fieldModel => 'Model / Seri No.';

  @override
  String get hintModel => 'örn. S-7000-X';

  @override
  String get fieldInstallDate => 'Kurulum Tarihi';

  @override
  String get hintSelectDate => 'Tarih seçin';

  @override
  String get sectionNotes => 'Notlar';

  @override
  String get hintNotes => 'Ek notlar…';

  @override
  String get btnSaveMachine => 'Makineyi Kaydet';

  @override
  String validationRequired(String field) {
    return '$field zorunludur';
  }

  @override
  String successMachineAdded(String name) {
    return '$name başarıyla eklendi';
  }

  @override
  String get machineTypeCNC => 'CNC';

  @override
  String get machineTypeHydraulic => 'Hidrolik';

  @override
  String get machineTypeCompressor => 'Kompresör';

  @override
  String get machineTypeConveyor => 'Konveyör';

  @override
  String get machineTypePump => 'Pompa';

  @override
  String get machineTypeMotor => 'Motor';

  @override
  String get machineTypeHVAC => 'HVAC';

  @override
  String get machineTypePress => 'Pres';

  @override
  String get machineTypeOther => 'Diğer';

  @override
  String get pageLogFailure => 'Arıza Kaydı';

  @override
  String get fieldMachine => 'Makine';

  @override
  String get hintSelectMachine => 'Makine seçin';

  @override
  String get sectionFailureType => 'Arıza Türü';

  @override
  String get failureTypeMechanical => 'Mekanik';

  @override
  String get failureTypeElectrical => 'Elektriksel';

  @override
  String get failureTypeHydraulic => 'Hidrolik';

  @override
  String get failureTypeSoftware => 'Yazılım';

  @override
  String get failureTypeStructural => 'Yapısal';

  @override
  String get failureTypeOther => 'Diğer';

  @override
  String get sectionSeverity => 'Ciddiyet Derecesi';

  @override
  String get severityLow => 'Düşük';

  @override
  String get severityMedium => 'Orta';

  @override
  String get severityHigh => 'Yüksek';

  @override
  String get severityCritical => 'Kritik';

  @override
  String get sectionDescription => 'Açıklama';

  @override
  String get hintDescription =>
      'Ne olduğunu ve gözlemlenen belirtileri açıklayın…';

  @override
  String get reportedAt => 'Kayıt Zamanı';

  @override
  String get reportedBy => 'Kaydeden';

  @override
  String get btnSubmitFailure => 'Arıza Raporunu Gönder';

  @override
  String get validationSelectMachine => 'Lütfen bir makine seçin';

  @override
  String get successFailureLogged => 'Arıza başarıyla kaydedildi';

  @override
  String get validationDescriptionRequired => 'Lütfen arızayı açıklayın';

  @override
  String get pagePredictions => 'Tahminler';

  @override
  String get tooltipAboutPredictions => 'Tahminler hakkında';

  @override
  String get labelHealthScore => 'Sağlık Puanı';

  @override
  String get labelNextService => 'Sonraki Bakım';

  @override
  String get labelRiskLevel => 'Risk Seviyesi';

  @override
  String get sectionHealthMetrics => 'Sağlık Metrikleri';

  @override
  String get sectionRecommendations => 'Öneriler';

  @override
  String get sectionAllMachines => 'Tüm Makineler';

  @override
  String get riskLow => 'Düşük';

  @override
  String get riskMedium => 'Orta';

  @override
  String get riskHigh => 'Yüksek';

  @override
  String get riskUnknown => 'Bilinmiyor';

  @override
  String get pageProfile => 'Profil';

  @override
  String get tooltipEditProfile => 'Profili düzenle';

  @override
  String get jobTitle => 'Bakım Mühendisi';

  @override
  String get rankSenior => 'Kıdemli';

  @override
  String get statMachinesLabel => 'Makine';

  @override
  String get statFailuresLabel => 'Kayıtlı\nArıza';

  @override
  String get statAvgResponseLabel => 'Ort.\nYanıt';

  @override
  String get settingNotifications => 'Bildirimler';

  @override
  String get settingNotificationsSubtitle => 'Uygulama, e-posta uyarıları';

  @override
  String get settingLanguage => 'Dil';

  @override
  String get settingLanguageCurrent => 'Türkçe';

  @override
  String get settingAppearance => 'Görünüm';

  @override
  String get settingAppearanceSubtitle => 'Açık tema';

  @override
  String get settingSecurity => 'Güvenlik';

  @override
  String get settingSecuritySubtitle => '2FA aktif';

  @override
  String get settingExportData => 'Veri Dışa Aktar';

  @override
  String get settingExportDataSubtitle => 'CSV, PDF raporlar';

  @override
  String get settingHelpSupport => 'Yardım & Destek';

  @override
  String get settingHelpSupportSubtitle => 'Belgeler, bize ulaşın';

  @override
  String get btnLogOut => 'Çıkış Yap';

  @override
  String get dialogLogOutTitle => 'Çıkış Yap';

  @override
  String get dialogLogOutMessage => 'Çıkış yapmak istediğinizden emin misiniz?';

  @override
  String get btnCancel => 'İptal';

  @override
  String get navHome => 'Ana Sayfa';

  @override
  String get navMachines => 'Makineler';

  @override
  String get navPredictions => 'Tahminler';

  @override
  String get navProfile => 'Profil';

  @override
  String get dialogLanguageTitle => 'Dil Seçin';

  @override
  String get langTurkish => 'Türkçe';

  @override
  String get langEnglish => 'İngilizce';

  @override
  String get pageMachineDetail => 'Makine Detayı';

  @override
  String get sectionMachineInfo => 'Makine Bilgisi';

  @override
  String get labelType => 'Tür';

  @override
  String get labelLastChecked => 'Son Kontrol';

  @override
  String get noFailuresFound => 'Kayıtlı arıza yok';

  @override
  String get noMaintenanceFound => 'Planlanmış bakım yok';

  @override
  String timeSecondsAgo(int n) {
    return '${n}sn önce';
  }

  @override
  String timeMinutesAgo(int n) {
    return '${n}dk önce';
  }

  @override
  String timeHoursAgo(int n) {
    return '${n}sa önce';
  }

  @override
  String timeDaysAgo(int n) {
    return '${n}g önce';
  }

  @override
  String get btnViewPredictions => 'Tahminlerde Gör';

  @override
  String get pageAddMaintenance => 'Bakım Planla';

  @override
  String get btnPlanMaintenance => 'Bakım Planla';

  @override
  String get btnSaveMaintenance => 'Planı Kaydet';

  @override
  String get sectionMaintenanceTask => 'Bakım Görevi';

  @override
  String get fieldMaintenanceTask => 'Görev Açıklaması';

  @override
  String get hintMaintenanceTask =>
      'örn. Rulman değişimi, yağ değişimi, filtre temizliği…';

  @override
  String get fieldScheduledDate => 'Planlanan Tarih';

  @override
  String get hintScheduledDate => 'Tarih seçin';

  @override
  String get successMaintenancePlanned => 'Bakım planı oluşturuldu';

  @override
  String get validationTaskRequired => 'Görev açıklaması zorunludur';

  @override
  String get validationScheduledDateRequired => 'Lütfen bir tarih seçin';
}
