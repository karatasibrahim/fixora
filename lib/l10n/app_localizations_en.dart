// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Fixora';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get alertCritical => '2 machines require immediate attention.';

  @override
  String get sectionOverview => 'Overview';

  @override
  String get statTotalMachines => 'Total Machines';

  @override
  String get statActive => 'Active';

  @override
  String get statWarnings => 'Warnings';

  @override
  String get statCritical => 'Critical';

  @override
  String get btnAddMachine => 'Add Machine';

  @override
  String get btnLogFailure => 'Log Failure';

  @override
  String get sectionRecentFailures => 'Recent Failures';

  @override
  String get sectionMaintenanceDue => 'Maintenance Due';

  @override
  String get seeAll => 'See all';

  @override
  String get tooltipNotifications => 'Notifications';

  @override
  String get pageMachines => 'Machines';

  @override
  String get tooltipFilter => 'Filter';

  @override
  String get searchHint => 'Search machines…';

  @override
  String get filterAll => 'All';

  @override
  String get statusActive => 'Active';

  @override
  String get statusWarning => 'Warning';

  @override
  String get statusCritical => 'Critical';

  @override
  String get statusOffline => 'Offline';

  @override
  String get noMachinesFound => 'No machines found';

  @override
  String get tryDifferentFilter => 'Try a different search or filter';

  @override
  String checkedAgo(String time) {
    return 'Checked $time';
  }

  @override
  String get pageAddMachine => 'Add Machine';

  @override
  String get save => 'Save';

  @override
  String get sectionBasicInfo => 'Basic Info';

  @override
  String get fieldMachineName => 'Machine Name';

  @override
  String get hintMachineName => 'e.g. CNC Lathe #1';

  @override
  String get fieldMachineType => 'Machine Type';

  @override
  String get fieldLocation => 'Location';

  @override
  String get hintLocation => 'e.g. Hall A · Bay 3';

  @override
  String get sectionSpecifications => 'Specifications';

  @override
  String get fieldManufacturer => 'Manufacturer';

  @override
  String get hintManufacturer => 'e.g. Siemens';

  @override
  String get fieldModel => 'Model / Serial No.';

  @override
  String get hintModel => 'e.g. S-7000-X';

  @override
  String get fieldInstallDate => 'Installation Date';

  @override
  String get hintSelectDate => 'Select date';

  @override
  String get sectionNotes => 'Notes';

  @override
  String get hintNotes => 'Additional notes…';

  @override
  String get btnSaveMachine => 'Save Machine';

  @override
  String validationRequired(String field) {
    return '$field is required';
  }

  @override
  String successMachineAdded(String name) {
    return '$name added successfully';
  }

  @override
  String get machineTypeCNC => 'CNC';

  @override
  String get machineTypeHydraulic => 'Hydraulic';

  @override
  String get machineTypeCompressor => 'Compressor';

  @override
  String get machineTypeConveyor => 'Conveyor';

  @override
  String get machineTypePump => 'Pump';

  @override
  String get machineTypeMotor => 'Motor';

  @override
  String get machineTypeHVAC => 'HVAC';

  @override
  String get machineTypePress => 'Press';

  @override
  String get machineTypeOther => 'Other';

  @override
  String get pageLogFailure => 'Log Failure';

  @override
  String get fieldMachine => 'Machine';

  @override
  String get hintSelectMachine => 'Select machine';

  @override
  String get sectionFailureType => 'Failure Type';

  @override
  String get failureTypeMechanical => 'Mechanical';

  @override
  String get failureTypeElectrical => 'Electrical';

  @override
  String get failureTypeHydraulic => 'Hydraulic';

  @override
  String get failureTypeSoftware => 'Software';

  @override
  String get failureTypeStructural => 'Structural';

  @override
  String get failureTypeOther => 'Other';

  @override
  String get sectionSeverity => 'Severity';

  @override
  String get severityLow => 'Low';

  @override
  String get severityMedium => 'Medium';

  @override
  String get severityHigh => 'High';

  @override
  String get severityCritical => 'Critical';

  @override
  String get sectionDescription => 'Description';

  @override
  String get hintDescription => 'Describe what happened, symptoms observed…';

  @override
  String get reportedAt => 'Reported at';

  @override
  String get reportedBy => 'Reported by';

  @override
  String get btnSubmitFailure => 'Submit Failure Report';

  @override
  String get validationSelectMachine => 'Please select a machine';

  @override
  String get successFailureLogged => 'Failure logged successfully';

  @override
  String get validationDescriptionRequired => 'Please describe the failure';

  @override
  String get pagePredictions => 'Predictions';

  @override
  String get tooltipAboutPredictions => 'About predictions';

  @override
  String get labelHealthScore => 'Health Score';

  @override
  String get labelNextService => 'Next Service';

  @override
  String get labelRiskLevel => 'Risk Level';

  @override
  String get sectionHealthMetrics => 'Health Metrics';

  @override
  String get sectionRecommendations => 'Recommendations';

  @override
  String get sectionAllMachines => 'All Machines';

  @override
  String get riskLow => 'Low';

  @override
  String get riskMedium => 'Medium';

  @override
  String get riskHigh => 'High';

  @override
  String get riskUnknown => 'Unknown';

  @override
  String get pageProfile => 'Profile';

  @override
  String get tooltipEditProfile => 'Edit profile';

  @override
  String get jobTitle => 'Maintenance Engineer';

  @override
  String get rankSenior => 'Senior';

  @override
  String get statMachinesLabel => 'Machines';

  @override
  String get statFailuresLabel => 'Failures\nLogged';

  @override
  String get statAvgResponseLabel => 'Avg\nResponse';

  @override
  String get settingNotifications => 'Notifications';

  @override
  String get settingNotificationsSubtitle => 'Push, email alerts';

  @override
  String get settingLanguage => 'Language';

  @override
  String get settingLanguageCurrent => 'English';

  @override
  String get settingAppearance => 'Appearance';

  @override
  String get settingAppearanceSubtitle => 'Light mode';

  @override
  String get settingSecurity => 'Security';

  @override
  String get settingSecuritySubtitle => '2FA enabled';

  @override
  String get settingExportData => 'Export Data';

  @override
  String get settingExportDataSubtitle => 'CSV, PDF reports';

  @override
  String get settingHelpSupport => 'Help & Support';

  @override
  String get settingHelpSupportSubtitle => 'Docs, contact us';

  @override
  String get btnLogOut => 'Log Out';

  @override
  String get dialogLogOutTitle => 'Log Out';

  @override
  String get dialogLogOutMessage => 'Are you sure you want to log out?';

  @override
  String get btnCancel => 'Cancel';

  @override
  String get navHome => 'Home';

  @override
  String get navMachines => 'Machines';

  @override
  String get navPredictions => 'Predictions';

  @override
  String get navProfile => 'Profile';

  @override
  String get dialogLanguageTitle => 'Select Language';

  @override
  String get langTurkish => 'Turkish';

  @override
  String get langEnglish => 'English';

  @override
  String get pageMachineDetail => 'Machine Detail';

  @override
  String get sectionMachineInfo => 'Machine Info';

  @override
  String get labelType => 'Type';

  @override
  String get labelLastChecked => 'Last Checked';

  @override
  String get noFailuresFound => 'No failures recorded';

  @override
  String get noMaintenanceFound => 'No maintenance scheduled';

  @override
  String timeSecondsAgo(int n) {
    return '${n}s ago';
  }

  @override
  String timeMinutesAgo(int n) {
    return '${n}m ago';
  }

  @override
  String timeHoursAgo(int n) {
    return '${n}h ago';
  }

  @override
  String timeDaysAgo(int n) {
    return '${n}d ago';
  }

  @override
  String get btnViewPredictions => 'View in Predictions';

  @override
  String get pageAddMaintenance => 'Plan Maintenance';

  @override
  String get btnPlanMaintenance => 'Plan Maintenance';

  @override
  String get btnSaveMaintenance => 'Save Plan';

  @override
  String get sectionMaintenanceTask => 'Maintenance Task';

  @override
  String get fieldMaintenanceTask => 'Task Description';

  @override
  String get hintMaintenanceTask =>
      'e.g. Bearing replacement, oil change, filter cleaning…';

  @override
  String get fieldScheduledDate => 'Scheduled Date';

  @override
  String get hintScheduledDate => 'Select date';

  @override
  String get successMaintenancePlanned => 'Maintenance plan created';

  @override
  String get validationTaskRequired => 'Task description is required';

  @override
  String get validationScheduledDateRequired => 'Please select a date';
}
