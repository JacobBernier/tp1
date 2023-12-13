import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:tp1/controleurs/utilisateurs_controleur.dart';
import 'package:tp1/models/utilisateurs.dart';
import 'package:hive/hive.dart' as hive;

import 'utilisateurs_controleur_test.mocks.dart';
@GenerateMocks([hive.Box<dynamic>])
void main(){

  group('getOrInsertUtilisateur', (){
    test('tester getOrInsertUtilisateur', () async{
      final box = MockBox<Utilisateurs>();

      late Utilisateurs user;
      final utilisateursControleur = UtilisateursControleur(box);

      List<Utilisateurs> listeUtilisateurs = [];

      listeUtilisateurs.add(Utilisateurs(idUtilisateur: "userId2", role: "admin"));
      when(box.values).thenReturn(listeUtilisateurs);

      when(box.put("userId2", any)
          .then((_) async => Utilisateurs(idUtilisateur: "userId", role: '')));


      //Test si la liste est vide
      user = await utilisateursControleur.getOrInsertUtilisateur("userId");

      expect(user.idUtilisateur, equals("userId"));
      expect(user.role, equals(''));

      //Test si la liste n'est pas vide

      user = await utilisateursControleur.getOrInsertUtilisateur("userId2");

      expect(user.idUtilisateur, equals("userId2"));
      expect(user.role, equals("admin"));


    });
  });
}