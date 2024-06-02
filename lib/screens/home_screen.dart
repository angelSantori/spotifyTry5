import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spoty_try5/auth/auth_service.dart';
import 'package:spoty_try5/provider/api_provider.dart';
import 'package:spoty_try5/screens/zcreens.dart';
import 'package:spoty_try5/widgets/zwidgets.dart';
//import 'package:spoty_try5/auth/auth_service.dart';
//import 'package:spoty_try5/screens/zcreens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = AuthService();
  final scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;

  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters(page);
    scrollController.addListener(() async {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              "Rick & Morty",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            leading: Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    showSearch(context: context, delegate: SearchCharacter());
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(color: Colors.green[900]),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No es Spotify',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.favorite,
                    color: Colors.green,
                  ),
                  title: const Text(
                    'Favorites',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FavoriteScreen()));
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.red,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  onTap: () async {
                    bool? confirmLogout = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmación'),
                          content:
                              const Text('¿Seguro que quieres cerrar sesión?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); //Cancelar
                              },
                              child: const Text('Cancelar'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); //Confirmar
                              },
                              child: const Text('Cerrar sesión'),
                            )
                          ],
                        );
                      },
                    );
                    if (confirmLogout == true) {
                      await auth.signout();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          'login', (Route<dynamic> route) => false);
                    }
                  },
                ),
              ],
            ),
          ),
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: apiProvider.characters.isNotEmpty
                ? CharacterList(
                    apiProvider: apiProvider,
                    isLoading: isLoading,
                    scrollController: scrollController,
                  )
                : Center(
                    child: CircularProgressIndicator(
                      color: Colors.green[300],
                    ),
                  ),
          )),
    );
  }
}
