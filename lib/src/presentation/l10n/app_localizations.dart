import 'package:flutter/widgets.dart';

class AppLocalizations {
  AppLocalizations(Locale locale)
      : locale = _resolveLocale(locale),
        _localeData = _localizedValues[_resolveLocale(locale).languageCode] ??
            _localizedValues[_defaultLocale]!,
        _fallbackData = _localizedValues[_defaultLocale]!;

  final Locale locale;
  final _AppLocalizationData _localeData;
  final _AppLocalizationData _fallbackData;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
    Locale('nd'),
    Locale('pt'),
    Locale('sn'),
  ];

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Locale _resolveLocale(Locale locale) {
    for (final supported in supportedLocales) {
      if (supported.languageCode == locale.languageCode) {
        return supported;
      }
    }
    return supportedLocales.first;
  }

  String get appTitle => _string('appTitle');
  String get homeOpenSettingsTooltip => _string('homeOpenSettingsTooltip');
  String get homeNavHome => _string('homeNavHome');
  String get homeNavLessons => _string('homeNavLessons');
  String get homeNavTeacher => _string('homeNavTeacher');
  String get homeLogoSemanticLabel => _string('homeLogoSemanticLabel');
  String get homeVerseCardSemanticLabel => _string('homeVerseCardSemanticLabel');
  String get homeVerseLoadError => _string('homeVerseLoadError');
  String get homeVerseOfTheDayTitle => _string('homeVerseOfTheDayTitle');
  String get homeVerseShareTooltip => _string('homeVerseShareTooltip');
  String get homeReadBible => _string('homeReadBible');
  String get homeContinueReading => _string('homeContinueReading');
  String get homeSavedReadingUnavailable => _string('homeSavedReadingUnavailable');
  String get homeBrowseLessons => _string('homeBrowseLessons');
  String get homeVerseShareSubject => _string('homeVerseShareSubject');
  String homeVerseShareText(String verse, String reference) => _format('homeVerseShareText', {'verse': verse, 'reference': reference});
  String get onboardingWelcomeTitle => _string('onboardingWelcomeTitle');
  String get onboardingWelcomeDescription => _string('onboardingWelcomeDescription');
  String onboardingDefaultProfileName(int index) => _format('onboardingDefaultProfileName', {'index': index.toString()});
  String get onboardingNoCohortPreference => _string('onboardingNoCohortPreference');
  String get onboardingUseProfile => _string('onboardingUseProfile');
  String onboardingProfilesLoadError(String error) => _format('onboardingProfilesLoadError', {'error': error});
  String get onboardingConnectCloudAccount => _string('onboardingConnectCloudAccount');
  String get onboardingConnectCloudDescription => _string('onboardingConnectCloudDescription');
  String get actionSignIn => _string('actionSignIn');
  String get onboardingCloudSyncActive => _string('onboardingCloudSyncActive');
  String onboardingCloudSyncVia(String providers) => _format('onboardingCloudSyncVia', {'providers': providers});
  String get onboardingSignedInFallback => _string('onboardingSignedInFallback');
  String get actionSignOut => _string('actionSignOut');
  String get onboardingCloudUnavailable => _string('onboardingCloudUnavailable');
  String onboardingCloudStatusError(String error) => _format('onboardingCloudStatusError', {'error': error});
  String get actionTryAgain => _string('actionTryAgain');
  String get onboardingCreateProfile => _string('onboardingCreateProfile');
  String get onboardingManageProfiles => _string('onboardingManageProfiles');
  String get snackbarProfileCreated => _string('snackbarProfileCreated');
  String snackbarProfileCreateFailed(String error) => _format('snackbarProfileCreateFailed', {'error': error});
  String get snackbarProfileSelected => _string('snackbarProfileSelected');
  String snackbarProfileSelectFailed(String error) => _format('snackbarProfileSelectFailed', {'error': error});
  String get snackbarCloudSignedOut => _string('snackbarCloudSignedOut');
  String get snackbarCloudSignOutFailed => _string('snackbarCloudSignOutFailed');
  String get emptyProfilesTitle => _string('emptyProfilesTitle');
  String get emptyProfilesDescription => _string('emptyProfilesDescription');
  String get emptyProfilesCreate => _string('emptyProfilesCreate');
  String get dialogCreateProfileTitle => _string('dialogCreateProfileTitle');
  String get dialogEditProfileTitle => _string('dialogEditProfileTitle');
  String get formDisplayNameLabel => _string('formDisplayNameLabel');
  String get formDisplayNameValidation => _string('formDisplayNameValidation');
  String get formChooseAvatar => _string('formChooseAvatar');
  String get formAvatarNone => _string('formAvatarNone');
  String get formPreferredCohort => _string('formPreferredCohort');
  String get formPreferredCohortNone => _string('formPreferredCohortNone');
  String get actionCancel => _string('actionCancel');
  String get actionSave => _string('actionSave');
  String appThemeLoadError(String error) => _format('appThemeLoadError', {'error': error});

  String _string(String key) {
    return _localeData.strings[key] ??
        _fallbackData.strings[key] ??
        key;
  }

  String _format(String key, Map<String, String> placeholders) {
    var value = _string(key);
    placeholders.forEach((placeholder, replacement) {
      value = value.replaceAll('{'+placeholder+'}', replacement);
    });
    return value;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return _localizedValues.containsKey(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

class _AppLocalizationData {
  const _AppLocalizationData(this.strings);

  final Map<String, String> strings;
}

const _defaultLocale = 'en';

const _localizedValues = <String, _AppLocalizationData>{
  'en': _AppLocalizationData({
    'appTitle': 'AFC StudyMate',
    'homeOpenSettingsTooltip': 'Open settings',
    'homeNavHome': 'Home',
    'homeNavLessons': 'Lessons',
    'homeNavTeacher': 'Teacher',
    'homeLogoSemanticLabel': 'AFC StudyMate logo',
    'homeVerseCardSemanticLabel': 'Verse of the day card',
    'homeVerseLoadError': 'Failed to load verse of the day',
    'homeVerseOfTheDayTitle': 'Verse of the Day',
    'homeVerseShareTooltip': 'Share Verse',
    'homeReadBible': 'Read Bible',
    'homeContinueReading': 'Continue Reading',
    'homeSavedReadingUnavailable': 'Saved reading location is unavailable.',
    'homeBrowseLessons': 'Browse Lessons',
    'homeVerseShareSubject': 'Verse of the Day',
    'homeVerseShareText': '“{verse}” – {reference}',
    'onboardingWelcomeTitle': 'Welcome to AFC StudyMate',
    'onboardingWelcomeDescription': 'Create or choose a local profile to personalise your study experience.',
    'onboardingDefaultProfileName': 'Profile {index}',
    'onboardingNoCohortPreference': 'No cohort preference',
    'onboardingUseProfile': 'Use profile',
    'onboardingProfilesLoadError': 'Failed to load profiles: {error}',
    'onboardingConnectCloudAccount': 'Connect a cloud account',
    'onboardingConnectCloudDescription': 'Sign in with email, Google or Apple to sync progress across devices.',
    'actionSignIn': 'Sign in',
    'onboardingCloudSyncActive': 'Cloud sync is active.',
    'onboardingCloudSyncVia': 'Cloud sync via {providers}',
    'onboardingSignedInFallback': 'Signed in',
    'actionSignOut': 'Sign out',
    'onboardingCloudUnavailable': 'Cloud sync unavailable',
    'onboardingCloudStatusError': 'Failed to load status: {error}',
    'actionTryAgain': 'Try again',
    'onboardingCreateProfile': 'Create profile',
    'onboardingManageProfiles': 'Manage existing profiles',
    'snackbarProfileCreated': 'Profile created.',
    'snackbarProfileCreateFailed': 'Failed to create profile: {error}',
    'snackbarProfileSelected': 'Profile selected.',
    'snackbarProfileSelectFailed': 'Failed to select profile: {error}',
    'snackbarCloudSignedOut': 'Signed out of cloud account.',
    'snackbarCloudSignOutFailed': 'Unable to sign out. Please try again.',
    'emptyProfilesTitle': 'No profiles yet',
    'emptyProfilesDescription': 'Create your first profile to get started.',
    'emptyProfilesCreate': 'Create profile',
    'dialogCreateProfileTitle': 'Create profile',
    'dialogEditProfileTitle': 'Edit profile',
    'formDisplayNameLabel': 'Display name',
    'formDisplayNameValidation': 'Please enter a name',
    'formChooseAvatar': 'Choose an avatar',
    'formAvatarNone': 'None',
    'formPreferredCohort': 'Preferred cohort',
    'formPreferredCohortNone': 'No preference',
    'actionCancel': 'Cancel',
    'actionSave': 'Save',
    'appThemeLoadError': 'Failed to load theme: {error}',
  }),
  'ar': _AppLocalizationData({
    'appTitle': 'AFC ستادي ميت',
    'homeOpenSettingsTooltip': 'فتح الإعدادات',
    'homeNavHome': 'الرئيسية',
    'homeNavLessons': 'الدروس',
    'homeNavTeacher': 'المعلم',
    'homeLogoSemanticLabel': 'شعار AFC ستادي ميت',
    'homeVerseCardSemanticLabel': 'بطاقة آية اليوم',
    'homeVerseLoadError': 'فشل تحميل آية اليوم',
    'homeVerseOfTheDayTitle': 'آية اليوم',
    'homeVerseShareTooltip': 'مشاركة الآية',
    'homeReadBible': 'قراءة الكتاب المقدس',
    'homeContinueReading': 'متابعة القراءة',
    'homeSavedReadingUnavailable': 'موقع القراءة المحفوظ غير متوفر.',
    'homeBrowseLessons': 'استعراض الدروس',
    'homeVerseShareSubject': 'آية اليوم',
    'homeVerseShareText': '«{verse}» – {reference}',
    'onboardingWelcomeTitle': 'مرحبًا بك في AFC ستادي ميت',
    'onboardingWelcomeDescription': 'أنشئ أو اختر ملفًا محليًا لتخصيص تجربة الدراسة الخاصة بك.',
    'onboardingDefaultProfileName': 'الملف {index}',
    'onboardingNoCohortPreference': 'لا تفضيل للمجموعة',
    'onboardingUseProfile': 'استخدام الملف',
    'onboardingProfilesLoadError': 'فشل تحميل الملفات: {error}',
    'onboardingConnectCloudAccount': 'ربط حساب سحابي',
    'onboardingConnectCloudDescription': 'سجّل الدخول بالبريد الإلكتروني أو Google أو Apple لمزامنة التقدم عبر الأجهزة.',
    'actionSignIn': 'تسجيل الدخول',
    'onboardingCloudSyncActive': 'المزامنة السحابية مفعّلة.',
    'onboardingCloudSyncVia': 'المزامنة السحابية عبر {providers}',
    'onboardingSignedInFallback': 'تم تسجيل الدخول',
    'actionSignOut': 'تسجيل الخروج',
    'onboardingCloudUnavailable': 'المزامنة السحابية غير متاحة',
    'onboardingCloudStatusError': 'فشل تحميل الحالة: {error}',
    'actionTryAgain': 'المحاولة مرة أخرى',
    'onboardingCreateProfile': 'إنشاء ملف',
    'onboardingManageProfiles': 'إدارة الملفات الحالية',
    'snackbarProfileCreated': 'تم إنشاء الملف.',
    'snackbarProfileCreateFailed': 'فشل إنشاء الملف: {error}',
    'snackbarProfileSelected': 'تم اختيار الملف.',
    'snackbarProfileSelectFailed': 'فشل اختيار الملف: {error}',
    'snackbarCloudSignedOut': 'تم تسجيل الخروج من الحساب السحابي.',
    'snackbarCloudSignOutFailed': 'تعذر تسجيل الخروج. يرجى المحاولة مرة أخرى.',
    'emptyProfilesTitle': 'لا توجد ملفات حتى الآن',
    'emptyProfilesDescription': 'أنشئ ملفك الأول للبدء.',
    'emptyProfilesCreate': 'إنشاء ملف',
    'dialogCreateProfileTitle': 'إنشاء ملف',
    'dialogEditProfileTitle': 'تعديل الملف',
    'formDisplayNameLabel': 'اسم العرض',
    'formDisplayNameValidation': 'يرجى إدخال اسم',
    'formChooseAvatar': 'اختر صورة رمزية',
    'formAvatarNone': 'بدون',
    'formPreferredCohort': 'المجموعة المفضلة',
    'formPreferredCohortNone': 'لا يوجد',
    'actionCancel': 'إلغاء',
    'actionSave': 'حفظ',
    'appThemeLoadError': 'فشل تحميل السمة: {error}',
  }),
  'nd': _AppLocalizationData({
    'appTitle': 'AFC StudyMate',
    'homeOpenSettingsTooltip': 'Vula izilungiselelo',
    'homeNavHome': 'Ekhaya',
    'homeNavLessons': 'Izifundo',
    'homeNavTeacher': 'Uthisha',
    'homeLogoSemanticLabel': 'Ilogo ye-AFC StudyMate',
    'homeVerseCardSemanticLabel': 'Ikhadi levesi losuku',
    'homeVerseLoadError': 'Yehlulekile ukulayisha ivesi losuku',
    'homeVerseOfTheDayTitle': 'Ivesi Losuku',
    'homeVerseShareTooltip': 'Yabelana ngavesi',
    'homeReadBible': 'Funda iBhayibhili',
    'homeContinueReading': 'Qhubeka ufunda',
    'homeSavedReadingUnavailable': 'Indawo yokufunda egciniweyo ayitholakali.',
    'homeBrowseLessons': 'Bheka izifundo',
    'homeVerseShareSubject': 'Ivesi Losuku',
    'homeVerseShareText': '“{verse}” – {reference}',
    'onboardingWelcomeTitle': 'Siyakwamukela ku-AFC StudyMate',
    'onboardingWelcomeDescription': 'Dala kumbe ukhethe iprofayela yendawo ukuze ulungise ulwazi lokufunda kwakho.',
    'onboardingDefaultProfileName': 'Iprofayela {index}',
    'onboardingNoCohortPreference': 'Akulanketho yeqembu',
    'onboardingUseProfile': 'Sebenzisa iprofayela',
    'onboardingProfilesLoadError': 'Yehlulekile ukulayisha amaphrofayela: {error}',
    'onboardingConnectCloudAccount': 'Xhuma i-akhawunti ye-cloud',
    'onboardingConnectCloudDescription': 'Ngena nge-imeyili, Google kumbe Apple ukuze uvumelanise inqubekela phambili kuwo wonke amadivayisi.',
    'actionSignIn': 'Ngena',
    'onboardingCloudSyncActive': 'Ukuvumelanisa kwe-cloud kuyasebenza.',
    'onboardingCloudSyncVia': 'Ukuvumelanisa kwe-cloud nge {providers}',
    'onboardingSignedInFallback': 'Ungene',
    'actionSignOut': 'Phuma',
    'onboardingCloudUnavailable': 'Ukuvumelanisa kwe-cloud akutholakali',
    'onboardingCloudStatusError': 'Yehlulekile ukulayisha isimo: {error}',
    'actionTryAgain': 'Zama futhi',
    'onboardingCreateProfile': 'Dala iprofayela',
    'onboardingManageProfiles': 'Lawula amaphrofayela akhona',
    'snackbarProfileCreated': 'Iprofayela idaliwe.',
    'snackbarProfileCreateFailed': 'Yehlulekile ukudala iprofayela: {error}',
    'snackbarProfileSelected': 'Iprofayela ikhethiwe.',
    'snackbarProfileSelectFailed': 'Yehlulekile ukukhetha iprofayela: {error}',
    'snackbarCloudSignedOut': 'Uphumile ku-akhawunti ye-cloud.',
    'snackbarCloudSignOutFailed': 'Ayiphumanga. Sicela uphinde uzame.',
    'emptyProfilesTitle': 'Awekho amaphrofayela okwamanje',
    'emptyProfilesDescription': 'Dala iprofayela yakho yokuqala ukuze uqale.',
    'emptyProfilesCreate': 'Dala iprofayela',
    'dialogCreateProfileTitle': 'Dala iprofayela',
    'dialogEditProfileTitle': 'Lungisa iprofayela',
    'formDisplayNameLabel': 'Igama elibonakalayo',
    'formDisplayNameValidation': 'Sicela ufake igama',
    'formChooseAvatar': 'Khetha i-avatar',
    'formAvatarNone': 'Akukho',
    'formPreferredCohort': 'Iqembu olikhethayo',
    'formPreferredCohortNone': 'Akukho',
    'actionCancel': 'Khansela',
    'actionSave': 'Gcina',
    'appThemeLoadError': 'Yehlulekile ukulayisha itimu: {error}',
  }),
  'pt': _AppLocalizationData({
    'appTitle': 'AFC StudyMate',
    'homeOpenSettingsTooltip': 'Abrir configurações',
    'homeNavHome': 'Início',
    'homeNavLessons': 'Lições',
    'homeNavTeacher': 'Professor',
    'homeLogoSemanticLabel': 'Logotipo do AFC StudyMate',
    'homeVerseCardSemanticLabel': 'Cartão do versículo do dia',
    'homeVerseLoadError': 'Falha ao carregar o versículo do dia',
    'homeVerseOfTheDayTitle': 'Versículo do Dia',
    'homeVerseShareTooltip': 'Compartilhar versículo',
    'homeReadBible': 'Ler a Bíblia',
    'homeContinueReading': 'Continuar lendo',
    'homeSavedReadingUnavailable': 'A localização de leitura salva não está disponível.',
    'homeBrowseLessons': 'Explorar lições',
    'homeVerseShareSubject': 'Versículo do Dia',
    'homeVerseShareText': '“{verse}” – {reference}',
    'onboardingWelcomeTitle': 'Bem-vindo ao AFC StudyMate',
    'onboardingWelcomeDescription': 'Crie ou escolha um perfil local para personalizar sua experiência de estudo.',
    'onboardingDefaultProfileName': 'Perfil {index}',
    'onboardingNoCohortPreference': 'Sem preferência de turma',
    'onboardingUseProfile': 'Usar perfil',
    'onboardingProfilesLoadError': 'Falha ao carregar perfis: {error}',
    'onboardingConnectCloudAccount': 'Conectar uma conta na nuvem',
    'onboardingConnectCloudDescription': 'Faça login com e-mail, Google ou Apple para sincronizar o progresso entre dispositivos.',
    'actionSignIn': 'Entrar',
    'onboardingCloudSyncActive': 'Sincronização na nuvem ativa.',
    'onboardingCloudSyncVia': 'Sincronização na nuvem via {providers}',
    'onboardingSignedInFallback': 'Conectado',
    'actionSignOut': 'Sair',
    'onboardingCloudUnavailable': 'Sincronização na nuvem indisponível',
    'onboardingCloudStatusError': 'Falha ao carregar o status: {error}',
    'actionTryAgain': 'Tentar novamente',
    'onboardingCreateProfile': 'Criar perfil',
    'onboardingManageProfiles': 'Gerenciar perfis existentes',
    'snackbarProfileCreated': 'Perfil criado.',
    'snackbarProfileCreateFailed': 'Falha ao criar perfil: {error}',
    'snackbarProfileSelected': 'Perfil selecionado.',
    'snackbarProfileSelectFailed': 'Falha ao selecionar perfil: {error}',
    'snackbarCloudSignedOut': 'Conta na nuvem desconectada.',
    'snackbarCloudSignOutFailed': 'Não foi possível sair. Tente novamente.',
    'emptyProfilesTitle': 'Ainda não há perfis',
    'emptyProfilesDescription': 'Crie seu primeiro perfil para começar.',
    'emptyProfilesCreate': 'Criar perfil',
    'dialogCreateProfileTitle': 'Criar perfil',
    'dialogEditProfileTitle': 'Editar perfil',
    'formDisplayNameLabel': 'Nome de exibição',
    'formDisplayNameValidation': 'Digite um nome',
    'formChooseAvatar': 'Escolha um avatar',
    'formAvatarNone': 'Nenhum',
    'formPreferredCohort': 'Turma preferida',
    'formPreferredCohortNone': 'Sem preferência',
    'actionCancel': 'Cancelar',
    'actionSave': 'Salvar',
    'appThemeLoadError': 'Falha ao carregar o tema: {error}',
  }),
  'sn': _AppLocalizationData({
    'appTitle': 'AFC StudyMate',
    'homeOpenSettingsTooltip': 'Vhura marongero',
    'homeNavHome': 'Kumba',
    'homeNavLessons': 'Zvidzidzo',
    'homeNavTeacher': 'Mudzidzisi',
    'homeLogoSemanticLabel': 'Chiratidzo cheAFC StudyMate',
    'homeVerseCardSemanticLabel': 'Kadhi rerugwaro rwezuva',
    'homeVerseLoadError': 'Zvakundikana kurodha rugwaro rwezuva',
    'homeVerseOfTheDayTitle': 'Rugwaro rwezuva',
    'homeVerseShareTooltip': 'Govera rugwaro',
    'homeReadBible': 'Verenga Bhaibheri',
    'homeContinueReading': 'Ramba uchiwerenga',
    'homeSavedReadingUnavailable': 'Nzvimbo yekuverenga yakachengetwa haina kuwanikwa.',
    'homeBrowseLessons': 'Tarisa zvidzidzo',
    'homeVerseShareSubject': 'Rugwaro rwezuva',
    'homeVerseShareText': '“{verse}” – {reference}',
    'onboardingWelcomeTitle': 'Gamuchirai kuAFC StudyMate',
    'onboardingWelcomeDescription': 'Gadzira kana sarudza chimiro chemuno kuti ugadzirise ruzivo rwako rwekudzidza.',
    'onboardingDefaultProfileName': 'Chimiro {index}',
    'onboardingNoCohortPreference': 'Hapana zvaunosarudza zvemapoka',
    'onboardingUseProfile': 'Shandisa chimiro',
    'onboardingProfilesLoadError': 'Zvakundikana kurodha zvimiro: {error}',
    'onboardingConnectCloudAccount': 'Batanidza akaunti yegore',
    'onboardingConnectCloudDescription': 'Pinda neemail, Google kana Apple kuti uwiriranise kufambira mberi pamidziyo yose.',
    'actionSignIn': 'Pinda',
    'onboardingCloudSyncActive': 'Kuwiriranisa kegore kuri kushanda.',
    'onboardingCloudSyncVia': 'Kuwiriranisa kegore kuburikidza ne{providers}',
    'onboardingSignedInFallback': 'Mapinda',
    'actionSignOut': 'Buda',
    'onboardingCloudUnavailable': 'Kuwiriranisa kegore hakuwaniki',
    'onboardingCloudStatusError': 'Zvakundikana kurodha mamiriro: {error}',
    'actionTryAgain': 'Edzazve',
    'onboardingCreateProfile': 'Gadzira chimiro',
    'onboardingManageProfiles': 'Tungamira zvimiro zviripo',
    'snackbarProfileCreated': 'Chimiro chagadzirwa.',
    'snackbarProfileCreateFailed': 'Zvakundikana kugadzira chimiro: {error}',
    'snackbarProfileSelected': 'Chimiro chasarudzwa.',
    'snackbarProfileSelectFailed': 'Zvakundikana kusarudza chimiro: {error}',
    'snackbarCloudSignedOut': 'Mabuda muakaunti yegore.',
    'snackbarCloudSignOutFailed': 'Hazvina kubudirira kubuda. Ndokumbira edzazve.',
    'emptyProfilesTitle': 'Hapana zvimiro zvawanikwa',
    'emptyProfilesDescription': 'Gadzira chimiro chako chekutanga kuti utange.',
    'emptyProfilesCreate': 'Gadzira chimiro',
    'dialogCreateProfileTitle': 'Gadzira chimiro',
    'dialogEditProfileTitle': 'Gadzirisa chimiro',
    'formDisplayNameLabel': 'Zita rinoratidzwa',
    'formDisplayNameValidation': 'Ndokumbira isa zita',
    'formChooseAvatar': 'Sarudza mufananidzo',
    'formAvatarNone': 'Hapana',
    'formPreferredCohort': 'Chikamu chaunosarudza',
    'formPreferredCohortNone': 'Hapana',
    'actionCancel': 'Kanzura',
    'actionSave': 'Chengeta',
    'appThemeLoadError': 'Zvakundikana kurodha dingindira: {error}',
  }),
};
