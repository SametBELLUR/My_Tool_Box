import 'package:math_expressions/math_expressions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_tool_box/pages/calculator/calcButton.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Calculator extends StatefulWidget {
  _calculatorState createState() => _calculatorState();
}

class _calculatorState extends State<Calculator> {
  String _history = '';
  String _expression = '';

  void numClick(String text) {
    setState(() => _expression += text);
    _scrollController.animateTo(0.0,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
  }

  void allClear(String text) {
    setState(() {
      _history = '';
      _expression = '';
    });
  }

  void clear(String text) {
    setState(() {
      _expression = '';
    });
  }

  void evaluate(String text) {
    Parser p = Parser();
    Expression exp = p.parse(_expression);
    ContextModel cm = ContextModel();

    setState(() {
      _history = _expression;
      _expression = exp.evaluate(EvaluationType.REAL, cm).toString();
    });
    _scrollController.animateTo(0.0,
        curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
  }

  ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 15,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.calculator,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ]),
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: AppLocalizations.of(context)!.calculator,
                  home: Scaffold(
                    backgroundColor: Colors.white,
                    body: Container(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    _history,
                                    style: GoogleFonts.rubik(
                                      textStyle: TextStyle(
                                        fontSize: 18,
                                        color: Color(0xFF545F61),
                                      ),
                                    ),
                                  ),
                                )),
                            alignment: Alignment(1.0, 1.0),
                          ),
                          Container(
                            child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: SingleChildScrollView(
                                  reverse: true,
                                  controller: _scrollController,
                                  scrollDirection: Axis.horizontal,
                                  child: Text(_expression,
                                      style: GoogleFonts.rubik(
                                        textStyle: TextStyle(
                                          fontSize: 30,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      maxLines: 1),
                                )),
                            alignment: Alignment(1.0, 1.0),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CalcButton(
                                text: 'AC',
                                fillColor: 0xFF6C807F,
                                textSize: 12,
                                callback: allClear,
                              ),
                              CalcButton(
                                text: 'C',
                                fillColor: 0xFF6C807F,
                                callback: clear,
                              ),
                              CalcButton(
                                text: '%',
                                fillColor: 0xFF6C807F,
                                callback: numClick,
                              ),
                              CalcButton(
                                text: '/',
                                fillColor: 0xFF6C807F,
                                callback: numClick,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CalcButton(
                                text: '7',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '8',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '9',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '*',
                                fillColor: 0xFF6C807F,
                                textSize: 24,
                                callback: numClick,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CalcButton(
                                text: '4',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '5',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '6',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '-',
                                fillColor: 0xFF6C807F,
                                textSize: 38,
                                callback: numClick,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CalcButton(
                                text: '1',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '2',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '3',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '+',
                                fillColor: 0xFF6C807F,
                                textSize: 30,
                                callback: numClick,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CalcButton(
                                text: '.',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '0',
                                callback: numClick,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '00',
                                callback: numClick,
                                textSize: 12,
                                fillColor: 0xfff44336,
                              ),
                              CalcButton(
                                text: '=',
                                fillColor: 0xFF6C807F,
                                callback: evaluate,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
