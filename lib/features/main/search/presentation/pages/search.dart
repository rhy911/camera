import 'package:Camera/api/connect_api.dart';
import 'package:Camera/models/user_mode.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<UserModel> dataUser = [];
  initData() async {
    Api api = Api();
    await api.getApi();
    dataUser = api.dataUser;
  }

  @override
  void initState() {
    initData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            '  S E A R C H',
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 350,
                height: 40,
                child: TextField(
                    decoration: InputDecoration(
                      hintText: 'What are we searching for today ?',
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.black54,
                              ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      filled: true,
                      fillColor: Colors.white70,
                    ),
                    style: Theme.of(context).textTheme.labelMedium),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(dataUser[index].firstName ?? "0"),
                    subtitle: Text(dataUser[index].address?.country ?? "0"),
                  );
                },
                itemCount: dataUser.length,
              )
            ],
          ),
        ));
  }
}
