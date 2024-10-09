import 'package:flutter/material.dart';
import 'package:bill/utils/database.dart';
import 'package:bill/bills_page.dart';

class BillInsertPage extends StatefulWidget {
  const BillInsertPage(
    {
      super.key,
    }
  );

  @override
  State<BillInsertPage> createState() => _BillInsertPageState();
}

class _BillInsertPageState extends State<BillInsertPage> {
  final TextEditingController _controllerAno = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();
  final TextEditingController _controllerParcela = TextEditingController();
  final TextEditingController _controllerQtdParcelas = TextEditingController();
  final TextEditingController _controllerMes = TextEditingController();
  final TextEditingController _controllercategria = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  final TextEditingController _controllerVencimento = TextEditingController();
  bool isUpload = false;
  bool sempre = false;
  bool unica = false;
  String wordButton = 'Adicionar conta';
  final List<String> _dropdownOptions = [];
  String? _selectedOption;

  @override
  void initState() {
    cards();
    super.initState();
  }

  Future<void> cards() async {
    _dropdownOptions.add('Não');
    List<String>? cards = await getCards();
    for (String card in cards!) {
      _dropdownOptions.add(card);
    }
  }

  void _insertBill() async {
    if (
      _controllerAno.text.isEmpty ||
      _controllerDescricao.text.isEmpty ||
      _controllerMes.text.isEmpty ||
      _controllerValor.text.isEmpty ||
      _controllerVencimento.text.isEmpty ||
      _controllercategria.text.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Insira todos os dados')),
      );
    } else {
      setState(() {
        isUpload = true;
        wordButton = 'Adicionando ...';
      });
      bool done = await addBill(
        int.parse(_controllerAno.text),
        double.parse(_controllerValor.text.replaceAll('.', '').replaceFirst(',', '.')),
        'gildsonbsantos@gmail.com',
        _controllerDescricao.text,
        _controllercategria.text,
        (unica || sempre) ? 1 : (_controllerParcela.text.isEmpty) ? 1 : int.parse(_controllerParcela.text),
        false,
        int.parse(_controllerMes.text),
        (unica || sempre) ? 1 : (_controllerQtdParcelas.text.isEmpty) ? 1 : int.parse(_controllerQtdParcelas.text),
        unica,
        sempre,
        int.parse(_controllerVencimento.text),
        _selectedOption!
      );
      setState(() {
        isUpload = false;
        wordButton = 'Adicionar conta';
      });
      if (done == true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Conta inserida')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível inserir')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonWidth = screenWidth * 0.95;
    final padding = screenWidth * 0.05;
    const buttonHeight = 50.0;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromRGBO(44, 44, 44, 1),
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 30, color: Colors.white,),
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const BillsPage()
                )
              ),
            ),
            const Text(
              'Inserir Conta',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ) 
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(
                        top: screenWidth * 0.05,
                        bottom: padding * 0.05,
                        left: screenHeight * 0.005,
                        right: screenHeight * 0.005
                      ),
                      child: TextField(
                        controller: _controllerDescricao,
                        autofocus: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Descrição',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira a descrição',
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hoverColor: Colors.blue
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.005,
                        vertical: screenHeight * 0.01
                      ),
                      child: TextField(
                        controller: _controllerValor,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Valor',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira o valor',
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.005,
                        vertical: screenHeight * 0.01
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          Checkbox(
                            value: unica,
                            onChanged: (checked) {
                              setState(() {
                                unica = !unica;
                              });
                            }),
                          Text(
                            'Única',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white,                              
                            ),
                          ),
                          const Spacer(),
                          Checkbox(
                            value: sempre,
                            onChanged: (checked) {
                              setState(() {
                                sempre = !sempre;
                              });
                            }
                          ),
                          Text(
                            'Sempre',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white,                              
                            ),
                          ),
                          const Spacer()
                        ],
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.005,
                        vertical: screenHeight * 0.01
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              readOnly: (unica == true) ? true : false,
                              controller: _controllerParcela,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: (unica == true) ? 'Única' : 'Parcela',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                                hintText: (unica == true) ? 'Única' : 'Parcela',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: TextField(
                              readOnly: (unica == true || sempre == true) ? true : false,
                              controller: _controllerQtdParcelas,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: (unica == true || sempre == true) ? 'Sempre' : 'Qtd. de parcelas',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                                hintText: (unica == true || sempre == true) ? 'Sempre' : 'Qtd de parcelas',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.005,
                        vertical: screenHeight * 0.01
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controllerMes,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Mês',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                                hintText: 'Insira o mês',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),                        
                          Expanded(
                            child: TextField(
                              controller: _controllerAno,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Ano',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                                hintText: 'Insira o ano',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.005,
                        vertical: screenHeight * 0.01
                      ),
                      child: TextField(
                        controller: _controllercategria,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Categoria',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira a categoria',
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.005,
                        vertical: screenHeight * 0.01
                      ),
                      child: TextField(
                        controller: _controllerVencimento,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Vencimento',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira o vencimento',
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenHeight * 0.005,
                        right: screenHeight * 0.005,
                        top: screenHeight * 0.005,
                        bottom: screenHeight * 0.001
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                            width: 1
                          ), // Definindo a borda
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: DropdownButton<String>(
                          dropdownColor: Colors.black,
                          underline: const SizedBox(),
                          autofocus: true,
                          borderRadius: BorderRadius.circular(10),
                          value: _selectedOption,
                          hint: Text(
                            'Compra no cartão?',
                            style: TextStyle(
                              fontSize: screenWidth * 0.05,
                              color: Colors.white
                            ),
                          ),
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          items: _dropdownOptions.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedOption = newValue;
                            });
                          },
                        ),
                      )
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: screenWidth * 0.1,
                        right: screenWidth * 0.1,
                        top: screenHeight * 0.03
                      ),
                      child: ElevatedButton(
                        onPressed: () => (!isUpload) ? _insertBill() : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: (!isUpload) ? const Color.fromRGBO(0, 0, 255, 1) : Colors.grey,
                          shadowColor: Colors.black,
                          minimumSize: Size(buttonWidth, buttonHeight),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenHeight * 0.005,
                            vertical: padding * 0.8
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Text(
                          wordButton,
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
