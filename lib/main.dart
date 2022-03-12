import 'package:catfact/provider/fetch_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
      create: (context) {
        return FetchData();
      },
      child: const MyApp(),
    ));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<FetchData>(context).getFacts("1");
    return MaterialApp(
      theme: ThemeData(
        textTheme: ThemeData.light().textTheme.copyWith(
              headline1: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
              headline2: TextStyle(
                color: Colors.black.withOpacity(0.8),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              headline3: const TextStyle(color: Colors.grey, fontSize: 23),
            ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          centerTitle: true,
          title: const Text("Cat Facts"),
        ),
        body: const CatFatsListViewScreen(),
      ),
    );
  }
}

class CatFatsListViewScreen extends StatefulWidget {
  const CatFatsListViewScreen({Key? key}) : super(key: key);

  @override
  State<CatFatsListViewScreen> createState() => _CatFatsListViewScreenState();
}

class _CatFatsListViewScreenState extends State<CatFatsListViewScreen> {
  final ScrollController _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(controllScrolling);
  }

  void controllScrolling() async {
    if (_controller.position.maxScrollExtent == _controller.offset) {
      // await Provider.of<FetchData>(context, listen: false).getFacts("3");
      if (page <= 34) {
        setState(() {
          page++;
        });
      } else {
        _controller.removeListener(() {});
      }
    }
  }

  int page = 1;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FetchData>(context, listen: false);
    return FutureBuilder(
        future: provider.getFacts(page.toString()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              page == 1) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
              controller: _controller,
              shrinkWrap: true,
              itemCount: provider.fatcts.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => FactsDetailScreen(
                            imageUrl: provider.fatcts[index].imageUrl,
                            fact: provider.fatcts[index].fact)));
                  },
                  child: CatFactItem(
                    fact: provider.fatcts[index].fact.substring(0, 20) + "...",
                    length: provider.fatcts[index].length,
                    imageUrl: provider.fatcts[index].imageUrl,
                  ),
                );
              });
        });
  }
}

class CatFactItem extends StatelessWidget {
  final String imageUrl;
  final String fact;
  final int length;
  const CatFactItem({
    Key? key,
    required this.fact,
    required this.length,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.3),
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(5, 5), color: Colors.black12, blurRadius: 3),
            ]),
        // width: 30,
        height: 300,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Title: $fact",
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "length: $length",
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FactsDetailScreen extends StatelessWidget {
  const FactsDetailScreen(
      {Key? key, required this.imageUrl, required this.fact})
      : super(key: key);
  final String imageUrl;
  final String fact;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About this fact"),
        backgroundColor: Colors.grey,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Text(
                fact,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          )
        ],
      ),
    );
  }
}
