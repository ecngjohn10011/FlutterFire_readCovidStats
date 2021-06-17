import 'dart:async'; // new
import 'package:cloud_firestore/cloud_firestore.dart'; // new
import 'package:flutter/material.dart';
import 'src/widgets.dart';
import 'package:firebase_core/firebase_core.dart'; // new

// import 'package:firebase_auth/firebase_auth.dart'; // new

FirebaseFirestore firestore = FirebaseFirestore.instance;

void main() async {
  // wait until firebase app has been created to use firestore
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: MyHomePage(title: 'Flutter Fire Demo using firestore'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: covidStatsdoc()
        // GetCovidStats("btVIJqwCO3pbtyquYKa0")
        // CovidStats(),
        );
  }
}

// get one-time updates
class GetCovidStats extends StatelessWidget {
  GetCovidStats(this.documentId) {}

  // accepts the id for the document we want to get data from
  final String documentId;

  @override
  Widget build(BuildContext context) {
    // makes a reference to the collection "CovidStats"
    CollectionReference covidStats =
        FirebaseFirestore.instance.collection('CovidStats');

    // FutureBuilder gets the current state of a Future and choose what to show as the result
    return FutureBuilder<DocumentSnapshot>(
      future: covidStats.doc(documentId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return _displayStats(snapshot.data);
        }

        return Text("loading");
      },
    );
  }
}

// get updates in real-time using a QuerySnapshot
class CovidStats extends StatefulWidget {
  @override
  _CovidStatsState createState() => _CovidStatsState();
}

class _CovidStatsState extends State<CovidStats> {
  // using a generic stream class for use with a QuerySnapshot
  final Stream<QuerySnapshot> _covidStatsStream =
      FirebaseFirestore.instance.collection('CovidStats').snapshots();

  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens for events flowing from the stream and rebuilds its descendants for any new event therefore giving the decendants the latest updates
    return StreamBuilder<QuerySnapshot>(
      stream: _covidStatsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (!snapshot.hasData) {
          return const Text("no data received");
        }

        return _displayStats(snapshot.data.docs[0]);
        // only one document in the CovidStats colllection that contains all the stats and its the first
      },
    );
  }
}

// get updates in real-time using a DocumentSnapshot
class covidStatsdoc extends StatefulWidget {
  const covidStatsdoc({Key? key}) : super(key: key);

  @override
  _covidStatsdocState createState() => _covidStatsdocState();
}

class _covidStatsdocState extends State<covidStatsdoc> {
  // using a generic stream class for use with a DocumentSnapshot
  final Stream<DocumentSnapshot> _documentStream = FirebaseFirestore.instance
      .collection('CovidStats')
      .doc('btVIJqwCO3pbtyquYKa0')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    // StreamBuilder listens for events flowing from the stream and rebuilds its descendants for any new event therefore giving the decendants the latest updates
    return StreamBuilder<DocumentSnapshot>(
      stream: _documentStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (!snapshot.hasData) {
          return const Text("no data received");
        }

        return _displayStats(snapshot.data);
      },
    );
  }
}

_displayStats(DocumentSnapshot document) {
  return Column(
    children: [
      Header("Covid Stats"),
      Stats("Population tested: ${document['population_tested']}%"),
      divider(),
      Stats("Number of cases: ${document['cases']}"),
      divider(),
      Stats("Number of deaths: ${document['deaths']}"),
      divider(),
      Stats("Number of vaccinations: ${document['vaccinations']}"),
      divider(),
      Stats("Number of recoveries: ${document['recovered']}"),
      divider(),
      Stats("1st dose: ${document['1st_dose']}"),
      divider(),
      Stats("Mortality rate: ${document['mortality_rate']}%"),
    ],
  );
}
