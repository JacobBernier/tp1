import 'package:hive/hive.dart';
import 'package:tp1/models/utilisateurs.dart';


class UtilisateursControleur {

  late Box<Utilisateurs> _box;

  UtilisateursControleur(Box<Utilisateurs> box){
      _box = box;
  }

  Future<Utilisateurs> getOrInsertUtilisateur(String userId) async{
    List<Utilisateurs> listUtilisateurs = [];
    listUtilisateurs = _box.values.toList();
    if(listUtilisateurs.where((u) => u.idUtilisateur == userId).isEmpty){

      var newUtilisateur = Utilisateurs(idUtilisateur: userId, role: '');
      await _box.put(userId, newUtilisateur);
      return newUtilisateur;
    }

    return listUtilisateurs.firstWhere((u) => u.idUtilisateur == userId);

  }

}