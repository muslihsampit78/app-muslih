import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In id, this message translates to:
  /// **'Muslih'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In id, this message translates to:
  /// **'Beranda'**
  String get home;

  /// No description provided for @articles.
  ///
  /// In id, this message translates to:
  /// **'Artikel'**
  String get articles;

  /// No description provided for @categories.
  ///
  /// In id, this message translates to:
  /// **'Kategori'**
  String get categories;

  /// No description provided for @faq.
  ///
  /// In id, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @questions.
  ///
  /// In id, this message translates to:
  /// **'Tanya Jawab'**
  String get questions;

  /// No description provided for @askQuestion.
  ///
  /// In id, this message translates to:
  /// **'Ajukan Pertanyaan'**
  String get askQuestion;

  /// No description provided for @searchPlaceholder.
  ///
  /// In id, this message translates to:
  /// **'Cari artikel, topik, atau informasi...'**
  String get searchPlaceholder;

  /// No description provided for @latestPosts.
  ///
  /// In id, this message translates to:
  /// **'Berita & Artikel Terbaru'**
  String get latestPosts;

  /// No description provided for @featuredPosts.
  ///
  /// In id, this message translates to:
  /// **'Artikel Pilihan'**
  String get featuredPosts;

  /// No description provided for @readMore.
  ///
  /// In id, this message translates to:
  /// **'Baca Selengkapnya'**
  String get readMore;

  /// No description provided for @viewAll.
  ///
  /// In id, this message translates to:
  /// **'Lihat Semua'**
  String get viewAll;

  /// No description provided for @noPostsFound.
  ///
  /// In id, this message translates to:
  /// **'Belum ada artikel ditemukan.'**
  String get noPostsFound;

  /// No description provided for @noCategoriesFound.
  ///
  /// In id, this message translates to:
  /// **'Belum ada kategori.'**
  String get noCategoriesFound;

  /// No description provided for @noFaqsFound.
  ///
  /// In id, this message translates to:
  /// **'Belum ada FAQ ditemukan.'**
  String get noFaqsFound;

  /// No description provided for @noQuestionsFound.
  ///
  /// In id, this message translates to:
  /// **'Belum ada pertanyaan ditemukan.'**
  String get noQuestionsFound;

  /// No description provided for @loading.
  ///
  /// In id, this message translates to:
  /// **'Memuat...'**
  String get loading;

  /// No description provided for @errorLoading.
  ///
  /// In id, this message translates to:
  /// **'Terjadi kesalahan saat memuat data.'**
  String get errorLoading;

  /// No description provided for @retry.
  ///
  /// In id, this message translates to:
  /// **'Coba Lagi'**
  String get retry;

  /// No description provided for @publishedAt.
  ///
  /// In id, this message translates to:
  /// **'Dipublikasikan'**
  String get publishedAt;

  /// No description provided for @byAuthor.
  ///
  /// In id, this message translates to:
  /// **'Oleh'**
  String get byAuthor;

  /// No description provided for @views.
  ///
  /// In id, this message translates to:
  /// **'kali dibaca'**
  String get views;

  /// No description provided for @formName.
  ///
  /// In id, this message translates to:
  /// **'Nama Lengkap'**
  String get formName;

  /// No description provided for @formEmail.
  ///
  /// In id, this message translates to:
  /// **'Alamat Email'**
  String get formEmail;

  /// No description provided for @formPhone.
  ///
  /// In id, this message translates to:
  /// **'Nomor Telepon'**
  String get formPhone;

  /// No description provided for @formTopic.
  ///
  /// In id, this message translates to:
  /// **'Pilih Topik'**
  String get formTopic;

  /// No description provided for @formQuestion.
  ///
  /// In id, this message translates to:
  /// **'Tuliskan Pertanyaan Anda'**
  String get formQuestion;

  /// No description provided for @formSubmit.
  ///
  /// In id, this message translates to:
  /// **'Kirim Pertanyaan'**
  String get formSubmit;

  /// No description provided for @formSubmitting.
  ///
  /// In id, this message translates to:
  /// **'Mengirim...'**
  String get formSubmitting;

  /// No description provided for @formSuccessTitle.
  ///
  /// In id, this message translates to:
  /// **'Pertanyaan Terkirim!'**
  String get formSuccessTitle;

  /// No description provided for @formSuccessMsg.
  ///
  /// In id, this message translates to:
  /// **'Terima kasih, pertanyaan Anda telah kami terima dan akan ditinjau oleh tim kami.'**
  String get formSuccessMsg;

  /// No description provided for @formValidationRequired.
  ///
  /// In id, this message translates to:
  /// **'Bidang ini wajib diisi'**
  String get formValidationRequired;

  /// No description provided for @formValidationEmail.
  ///
  /// In id, this message translates to:
  /// **'Format email tidak valid'**
  String get formValidationEmail;

  /// No description provided for @answered.
  ///
  /// In id, this message translates to:
  /// **'Sudah Dijawab'**
  String get answered;

  /// No description provided for @pending.
  ///
  /// In id, this message translates to:
  /// **'Menunggu Jawaban'**
  String get pending;

  /// No description provided for @answer.
  ///
  /// In id, this message translates to:
  /// **'Jawaban:'**
  String get answer;

  /// No description provided for @answeredBy.
  ///
  /// In id, this message translates to:
  /// **'Dijawab oleh'**
  String get answeredBy;

  /// No description provided for @answeredAt.
  ///
  /// In id, this message translates to:
  /// **'pada tanggal'**
  String get answeredAt;

  /// No description provided for @search.
  ///
  /// In id, this message translates to:
  /// **'Cari'**
  String get search;

  /// No description provided for @allCategories.
  ///
  /// In id, this message translates to:
  /// **'Semua Kategori'**
  String get allCategories;

  /// No description provided for @allTopics.
  ///
  /// In id, this message translates to:
  /// **'Semua Topik'**
  String get allTopics;

  /// No description provided for @backToHome.
  ///
  /// In id, this message translates to:
  /// **'Kembali ke Beranda'**
  String get backToHome;

  /// No description provided for @footerDescription.
  ///
  /// In id, this message translates to:
  /// **'Portal informasi resmi dan layanan interaksi tanya jawab masyarakat.'**
  String get footerDescription;

  /// No description provided for @copyright.
  ///
  /// In id, this message translates to:
  /// **'Hak Cipta Dilindungi Undang-Undang.'**
  String get copyright;

  /// No description provided for @language.
  ///
  /// In id, this message translates to:
  /// **'Bahasa'**
  String get language;

  /// No description provided for @contactUs.
  ///
  /// In id, this message translates to:
  /// **'Hubungi Kami'**
  String get contactUs;

  /// No description provided for @address.
  ///
  /// In id, this message translates to:
  /// **'Alamat'**
  String get address;

  /// No description provided for @email.
  ///
  /// In id, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In id, this message translates to:
  /// **'Telepon'**
  String get phone;

  /// No description provided for @quickLinks.
  ///
  /// In id, this message translates to:
  /// **'Tautan Cepat'**
  String get quickLinks;

  /// No description provided for @pageNotFound.
  ///
  /// In id, this message translates to:
  /// **'Halaman Tidak Ditemukan'**
  String get pageNotFound;

  /// No description provided for @pageNotFoundDesc.
  ///
  /// In id, this message translates to:
  /// **'Halaman yang Anda tuju tidak ditemukan atau telah dipindahkan.'**
  String get pageNotFoundDesc;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
