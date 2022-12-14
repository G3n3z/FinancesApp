import 'package:finances/route_generator/RouteGenerator.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finances',
      /*
      theme: ThemeData(
        backgroundColor: Colors.white,
      ),*/
      theme: ThemeData(
        dividerTheme: DividerThemeData(
          space: 30,
          thickness: 10,
          color: Colors.purple,
          indent: 20,
          endIndent: 20
        )
      ),
      initialRoute: '/notLogged',
      onGenerateRoute: RouteGenerator.generateRoute
    );
  }
}

// class MyInitialPage extends StatefulWidget {
//   const MyInitialPage({Key? key, required this.title}) : super(key: key);

//   final String title;

//   @override
//   State<MyInitialPage> createState() => _MyInitialPage();
// }

// class _MyInitialPage extends State<MyInitialPage> {
//   int _counter = 0;

//   void _incrementCounter() {
//     setState(() {

//       _counter++;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
       
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
