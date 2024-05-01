import 'package:get/get.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          //login page
          'emailHint': 'email',
          'passwordHint': 'password',
          'forgotPassword': 'Forgot your password?',
          'createAccount': 'Don"t have an account?',
          'signIn': 'Sign In',
          'create': 'Create!',
          //register page

          'userName': 'user name',
          'signUp': 'Sign Up',
          'accountText': 'Already have an account. ',
          'loginText': 'Login Now',

          //profile page

          'follow': 'Follow',
          'unfollow': 'Unfollow',
          'posts': 'Posts',
          'followers': 'Followers',
          'follows': 'Follows',
          'noPost': 'There is no post yet!',

          //add post page

          'private': 'Private',
          'public': 'Public',
          'addPostHint': 'Write something...',
          'share': 'Share',

          //Comment Page

          'commentHeader': 'C O M M E N T S',
          'noComment': 'Thereis no comment yet.',
          'commentHint': 'Write Something...',
          'send': 'Send',

          //Post Card
          //popup menü items

          'delete': 'Delete',
          'about': 'About',
          'copyLink': 'Copy Link'
        },
        'tr_TR': {
          //login page
          'emailHint': 'email',
          'passwordHint': 'şifre',
          'forgotPassword': 'Şifreni mi unuttun?',
          'createAccount': 'Hesabın yok mu?',
          'signIn': 'Giriş yap',
          'create': 'Hesap Oluştur!',
          //register page

          'userName': 'Kullanıcı Adı',
          'signUp': 'Kayıt Ol',
          'accountText': 'Zaten Hesabın Var mı?. ',
          'loginText': 'Şimdi Giriş Yap',

          //profile page

          'follow': 'Takip Et',
          'unfollow': 'Takibi Bırak',
          'posts': 'Gönderiler',
          'followers': 'Takipçi',
          'follows': 'Takip edilen',
          'noPost': 'Henüz gönderi yok!',

          //add post page

          'private': 'Gizli',
          'public': 'Açık',
          'addPostHint': 'Bir şeyler yaz...',
          'share': 'Paylaş',

          //Comment Page

          'commentHeader': 'Y O R U M L A R',
          'noComment': 'Henüz bir yorum yok.',
          'commentHint': 'Bir şeyler yaz...',
          'send': 'Gönder',

          //Post Card
          //popup menü items

          'delete': 'Sil',
          'about': 'Hakkında',
          'copyLink': 'Linki Kopyala'
        },
      };
}
