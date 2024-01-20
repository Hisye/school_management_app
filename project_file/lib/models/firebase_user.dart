import 'package:firebase_auth/firebase_auth.dart';

class FirebaseHelper {
  static String getAdminPrefix() {
    final user = FirebaseAuth.instance.currentUser!;
    String school = 'admin01';

    if (user.email == 'skbg123@gmail.com') {
      school = 'admin01';
      return school;
    } else if (user.email == 'skkk123@gmail.com') {
      school = 'admin02';
      return school;
    }

    return school;
  }
}
