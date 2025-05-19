import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'tr': {
          'welcome': 'Hoşgeldiniz',
          'fill_fields': 'Lütfen aşağıdaki bilgileri doldurun:',
          'phone_number': 'Telefon Numarası',
          'phone_number_hint': '123 456 7890',
          'first_name': 'Ad',
          'first_name_hint': 'Adınızı girin',
          'last_name': 'Soyad',
          'last_name_hint': 'Soyadınızı girin',
          'continue': 'Devam Et',
        },
        'en': {
          'welcome': 'Welcome',
          'fill_fields': 'Please fill in the fields below:',
          'phone_number': 'Phone Number',
          'phone_number_hint': '123 456 7890',
          'first_name': 'First Name',
          'first_name_hint': 'Enter your first name',
          'last_name': 'Last Name',
          'last_name_hint': 'Enter your last name',
          'continue': 'Continue',
        },
        'ar': {
          'welcome': 'مرحبا',
          'fill_fields': 'يرجى ملء الحقول أدناه:',
          'phone_number': 'رقم الهاتف',
          'phone_number_hint': '123 456 7890',
          'first_name': 'الاسم الأول',
          'first_name_hint': 'أدخل اسمك الأول',
          'last_name': 'اسم العائلة',
          'last_name_hint': 'أدخل اسم العائلة',
          'continue': 'استمر',
        },
        'es': {
          'welcome': 'Bienvenido',
          'fill_fields': 'Por favor complete los siguientes campos:',
          'phone_number': 'Número de teléfono',
          'phone_number_hint': '123 456 7890',
          'first_name': 'Nombre',
          'first_name_hint': 'Ingrese su nombre',
          'last_name': 'Apellido',
          'last_name_hint': 'Ingrese su apellido',
          'continue': 'Continuar',
        },
        'ja': {
          'welcome': 'ようこそ',
          'fill_fields': '以下の項目を入力してください:',
          'phone_number': '電話番号',
          'phone_number_hint': '123 456 7890',
          'first_name': '名',
          'first_name_hint': '名を入力してください',
          'last_name': '姓',
          'last_name_hint': '姓を入力してください',
          'continue': '続行',
        },
      };
}
