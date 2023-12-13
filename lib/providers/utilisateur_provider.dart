import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:tp1/controleurs/utilisateurs_controleur.dart';
import 'package:tp1/models/utilisateurs.dart';
import 'package:flutter/material.dart';

class UtilisateurProvider extends ChangeNotifier{
  Utilisateurs? _utilisateur;
  Credentials? _informationsIdentification;
  late bool _connection = false;
  late Auth0 _auth0;
  late UtilisateursControleur _utilisateursControleur;

  bool get isLoggedIn => _informationsIdentification != null;
  bool get isAuthenticating => _connection;
  Utilisateurs? get user => _utilisateur;


  UtilisateurProvider(Auth0 auth0, UtilisateursControleur utilisateursControleur){
    _auth0 = auth0;
    _utilisateursControleur = utilisateursControleur;
  }

  Future<void> logoutAction() async {
    await _auth0.webAuthentication(scheme: "tp1").logout();
    _utilisateur = null;
    _informationsIdentification = null;
    notifyListeners();
  }

  Future<void> loginAction() async {
    _connection = true;

    notifyListeners();

      final informationsIdentification = await _auth0.webAuthentication(scheme: "tp1").login();
      Utilisateurs utilisateur = await _utilisateursControleur.getOrInsertUtilisateur(
          informationsIdentification.user.sub
      );
      _connection = false;
      _informationsIdentification = informationsIdentification;
      _utilisateur = utilisateur;



      notifyListeners();
  }

}