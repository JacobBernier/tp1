import 'package:flutter/material.dart';
import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:provider/provider.dart';

import '../providers/utilisateur_provider.dart';

class Profile extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<UtilisateurProvider> (
        builder: (context, utilisateurProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: () async {
                await Provider.of<UtilisateurProvider>(context, listen: false).logoutAction();
              },
                  child: const Text('Logout'))
            ],
          );
        }
    );
  }

}