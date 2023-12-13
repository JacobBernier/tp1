import 'package:tp1/models/utilisateurs.dart';
import 'package:tp1/providers/utilisateur_provider.dart';
import 'package:tp1/controleurs/utilisateurs_controleur.dart' as co;
import 'package:mockito/annotations.dart';
import 'package:auth0_flutter/auth0_flutter.dart' as auth;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'utilisateur_provider_test.mocks.dart';
@GenerateMocks([auth.Auth0, auth.WebAuthentication, co.UtilisateursControleur])
void main(){

  group('loginaction', (){
    test('tester le login', () async{
      final auth0 = MockAuth0();
      final webAuthentication = MockWebAuthentication();
      final utilisateurControleur = MockUtilisateursControleur();


      when(auth0.webAuthentication(scheme: "tp1"))
          .thenReturn(webAuthentication);

      when(webAuthentication.login())
          .thenAnswer((_) async => auth.Credentials(
          idToken: "idToken",
          accessToken: "accessToken",
          expiresAt: DateTime.now(),
          user:auth.UserProfile(sub:"idUnique",name:"nom"),
          tokenType: "tokenType"));


      when(utilisateurControleur.getOrInsertUtilisateur("idUnique"))
          .thenAnswer((_) async => Utilisateurs(idUtilisateur: "idUnique", role: "admin"));

      final utilisateurProvider = UtilisateurProvider(auth0, utilisateurControleur);

      expect(utilisateurProvider.isAuthenticating, false);

      expect(utilisateurProvider.isLoggedIn, false);

      expect(utilisateurProvider.user, null);

      await utilisateurProvider.loginAction();

      expect(utilisateurProvider.isLoggedIn, true);
      expect(utilisateurProvider.isAuthenticating, false);
      expect(utilisateurProvider.user?.idUtilisateur, equals("idUnique"));
      expect(utilisateurProvider.user?.role, equals("admin"));

    });
  });

  group('logoutaction', (){
    test('tester le logout', () async{
      final auth0 = MockAuth0();
      final webAuthentication = MockWebAuthentication();
      final utilisateurControleur = MockUtilisateursControleur();

      when(auth0.webAuthentication(scheme: "tp1"))
          .thenReturn(webAuthentication);

      when(webAuthentication.login())
          .thenAnswer((_) async => auth.Credentials(
          idToken: "idToken",
          accessToken: "accessToken",
          expiresAt: DateTime.now(),
          user:auth.UserProfile(sub:"idUnique",name:"nom"),
          tokenType: "tokenType"));


      when(utilisateurControleur.getOrInsertUtilisateur("idUnique"))
          .thenAnswer((_) async => Utilisateurs(idUtilisateur: "idUnique", role: "admin"));

      final utilisateurProvider = UtilisateurProvider(auth0, utilisateurControleur);

      expect(utilisateurProvider.isLoggedIn, false);

      await utilisateurProvider.loginAction();

      expect(utilisateurProvider.user?.idUtilisateur, equals("idUnique"));
      expect(utilisateurProvider.user?.role, equals("admin"));

      expect(utilisateurProvider.isLoggedIn, true);

      await utilisateurProvider.logoutAction();

      expect(utilisateurProvider.user, null);
      expect(utilisateurProvider.isLoggedIn, false);

    });
  });

}