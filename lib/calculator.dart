import 'package:expressions/expressions.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class Calculator extends StatefulWidget {
  const Calculator({super.key});

  @override
  State<Calculator> createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  final String _limpar = 'Clear';
  String _expressao = '';
  String _resultado = '';

  void _pressionarBotao(String valor) {
    setState(() {
      if (valor == _limpar) {
        _expressao = '';
        _resultado = '';
      } else if (valor == '=') {
        _calcularResultado();
      } else if (valor == '←' && _expressao.isNotEmpty) {
        _expressao = _expressao.substring(0, _expressao.length - 1);
      } else {
        _expressao += valor;
      }
    });
  }

  void _calcularResultado() {
    try {
      _resultado = _avaliarExpressao(_expressao).toString();
    } catch (e) {
      _resultado = 'Erro de cálculo';
    }
  }

  double _avaliarExpressao(String expressao) {
    expressao = expressao.replaceAll('x', '*').replaceAll('÷', '/');

    final functions = {
      'sin': (num x) => sin(x),
      'cos': (num x) => cos(x),
      'tan': (num x) => tan(x),
      'log': (num x) => log(x),
      'sqrt': (num x) => sqrt(x),
      'exp': (num x) => exp(x),
    };

    ExpressionEvaluator avaliador = const ExpressionEvaluator();
    var resultado = avaliador.eval(
      Expression.parse(expressao),
      functions.map((k, v) => MapEntry(k, (args) => v(args[0])))
    );

    return resultado is num ? resultado.toDouble() : double.nan;
  }

  Widget _botao(String valor) {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 50, 48, 85),
        foregroundColor: Colors.white,
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        valor,
        style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
      ),
      onPressed: () => _pressionarBotao(valor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Text(
            _expressao,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          child: Text(
            _resultado,
            style: const TextStyle(fontSize: 24),
          ),
        ),
        Expanded(
          flex: 3,
          child: GridView.count(
            crossAxisCount: 4,
            childAspectRatio: 2,
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 2.0,
            children: [
              _botao('7'), _botao('8'), _botao('9'), _botao('÷'),
              _botao('4'), _botao('5'), _botao('6'), _botao('x'),
              _botao('1'), _botao('2'), _botao('3'), _botao('-'),
              _botao('0'), _botao('.'), _botao('='), _botao('+'),
              _botao('sin'), _botao('cos'), _botao('tan'), _botao('log'),
              _botao('sqrt'), _botao('exp'), _botao('←'), _botao(_limpar),
            ],
          ),
        ),
      ],
    );
  }
}
