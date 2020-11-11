import 'package:flutter/material.dart';
import 'package:flutter_assignment/model/match_pattern.dart';

class MyCustomForm extends StatefulWidget {

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

class _MyCustomFormState extends State<MyCustomForm> {
  final pertanyaanController = TextEditingController();
  final jawabanController = TextEditingController();
  final kataKunciController = TextEditingController();
  final pertanyaanFocus = FocusNode();
  final jawabanFocus = FocusNode();
  final kataKunciFocus = FocusNode(); //length na misal 3
  var kKsplit = [];

  List<MatchPattern> matchPattern = [];
  List<String> multiplePattern = [];
  var split;
  //indeks hasil pencarian, misal 101, loop ker di tampil = 101, 102, 103
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    pertanyaanController.dispose();
    jawabanController.dispose();
    kataKunciController.dispose();
  }

  int maxOfAnB(int a, int b) => (a > b) ? a : b;

  List<int> badCharacterHeuristic(String str) {
    int noOfCharacter = 20000;
    List<int> badChar = new List<int>(noOfCharacter);
    int i;

    for (i = 0; i < noOfCharacter; i++) {
      badChar[i] = -1;
    }

    for (i = 0; i < str.length; i++) {
      badChar[str.codeUnitAt(i)] = i;
    }

    return badChar;
  }

  Future<void> search(String text, String pattern) async {
    int m = pattern.length;
    int n = text.length;
    print("Len $pattern = $m");
    List<int> badchar = badCharacterHeuristic(pattern);

    int s = 0;
    while (s <= (n - m)) {
      int j = m - 1;
      while (j >= 0 && pattern[j] == text[s + j]) j--;
      if (j < 0) {
        print("Patterns occur at shift = $s");

        matchPattern.add(MatchPattern(s, m));
        s += (s + m < n) ? m - badchar[text.codeUnitAt(s + m)] : 1;
      } else {
        s += maxOfAnB(1, j - badchar[text.codeUnitAt(s + j)]);
      }
    }
  }

  void submit() {
    setState(() {
      isLoading = true;
      matchPattern.clear();
    });
    split = kataKunciController.text.split(';');
    if (split.length > 1) {
      Future.forEach(split, (element) async {
        return await search(jawabanController.text, element);
      }).then((value) => Future.delayed(Duration(seconds: 1))).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    } else {
      search(jawabanController.text, kataKunciController.text)
          .then((value) async {
        return await Future.delayed(Duration(seconds: 1));
      }).whenComplete(() {
        setState(() {
          isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: Text('Flutter Assignment'),),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  controller: pertanyaanController,
                  focusNode: pertanyaanFocus,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(jawabanFocus);
                  },
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Pertanyaan',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: jawabanController,
                  focusNode: jawabanFocus,
                  onSubmitted: (value) {
                    FocusScope.of(context).requestFocus(kataKunciFocus);
                  },
                  decoration: const InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: 'Jawaban',
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: kataKunciController,
                  focusNode: kataKunciFocus,
                  decoration: const InputDecoration(
                    hintText: 'Pisahkan dengan semicolon (;)',
                    border: const OutlineInputBorder(),
                    labelText: 'Kata Kunci',
                  ),
                ),
                SizedBox(height: 16),
                ButtonTheme(
                  minWidth: double.infinity,
                  padding: const EdgeInsets.all(16),
                  textTheme: ButtonTextTheme.primary,
                  child: RaisedButton(
                    onPressed: () => submit(),
                    child: Text("Submit"),
                  ),
                ),
                SizedBox(height: 40),
                Flexible(
                  child: Card(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading
                          ? Center(child: CircularProgressIndicator())
                          : Center(
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: res(),
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget res() {
    if (matchPattern.length > 0) {
      return Column(
        children: [
          Text("${matchPattern.length} / ${split.length} match pattern"),
          Divider(),
          Text.rich(
            TextSpan(
              children: getResult().toList(),
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      );
    } else {
      return Text("Tidak ada kata kunci yang cocok");
    }
  }

  List<TextSpan> getResult() {
    List<TextSpan> res = [];
    List<String> kata = jawabanController.text.toLowerCase().split('');
    split = kataKunciController.text.toLowerCase().split(';');
    if (split.length > 1) {}
    // int patlen = kataKunciController.text.length;

    for (int i = 0; i < kata.length; i++) {
      if (matchPattern.where((e) => e.startIndex == i).isNotEmpty) {
        var found = matchPattern.singleWhere((e) => e.startIndex == i);
        res.add(
          TextSpan(
            text: jawabanController.text
                .substring(found.startIndex, found.startIndex + found.length),
            style: TextStyle(
              color: Colors.yellow,
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
            ),
          ),
        );
        i += found.length;
        // kata.removeRange(i, i + patlen);
      }
      if (i < kata.length) {
        res.add(
          TextSpan(text: kata[i]),
        );
        // i += patlen;
      }
    }

    return res;
  }
}


