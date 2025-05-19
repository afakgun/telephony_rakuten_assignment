class CountryCodeUtils {
  String countryPhoneCodeToNameMap(String? countryCode) {
    switch (countryCode) {
      case '+90':
        return 'tr';
      case '+1':
        return 'us';
      case '+44':
        return 'gb';
      case '+33':
        return 'fr';
      case '+49':
        return 'de';
      case '+81':
        return 'jp';
      case '+34':
        return 'es';
      case '+39':
        return 'it';
      case '+7':
        return 'ru';
      case '+86':
        return 'cn';
      case '+61':
        return 'au';
      case '+82': 
        return 'kr';
      case '+55':
        return 'br';
      case '+91':
        return 'in';
      case '+41':
        return 'ch';
      case '+46':
        return 'se';
      case '+31':
        return 'nl';
      case '+45':
        return 'dk';
      case '+47':
        return 'no';
      case '+358':
        return 'fi';
      case '+351':
        return 'pt';
      case '+353':
        return 'ie';
      case '+36':
        return 'hu';
      case '+421':
        return 'sk';
      case '+420':
        return 'cz';
      case '+372':
        return 'ee';
      case '+371':
        return 'lv';
      case '+370':
        return 'lt';
      case '+381':
        return 'rs';
      case '+386':
        return 'si';
      case '+359':
        return 'bg';
      case '+30':
        return 'gr';
      default:
        return 'us';
    }
  
  }
}
