import 'package:flutter/material.dart';
import 'package:bill/utils/database.dart';
import 'package:bill/bills_page.dart';

class BillUpdatePage extends StatefulWidget {
  final int ano;
  final double valor;
  final String emailUser;
  final String descricao;
  final String categoria;
  final int parcela;
  final int mes;
  final int qtdparcelas;
  final String id;
  final bool unica;
  final bool sempre;
  final int vencimento;

  const BillUpdatePage(
    {
      super.key,
      required this.ano,
      required this.valor,
      required this.emailUser,
      required this.descricao,
      required this.categoria,
      required this.parcela,
      required this.mes,
      required this.qtdparcelas,
      required this.id,
      required this.unica,
      required this.sempre,
      required this.vencimento
    }
  );

  @override
  State<BillUpdatePage> createState() => _BillUpdatePageState();
}

class _BillUpdatePageState extends State<BillUpdatePage> {
  final TextEditingController _controllerAno = TextEditingController();
  final TextEditingController _controllerValor = TextEditingController();
  final TextEditingController _controllerParcela = TextEditingController();
  final TextEditingController _controllerQtdParcelas = TextEditingController();
  final TextEditingController _controllerMes = TextEditingController();
  final TextEditingController _controllercategria = TextEditingController();
  final TextEditingController _controllerDescricao = TextEditingController();
  late bool sempre;
  late bool unica;
  String wordButton = 'Atualizar conta';
  bool isUpdate = false;
  final List<String> _dropdownOptions = [];
  String? _selectedOption;

  @override
  void initState() {
    cards();
    super.initState();
    unica = widget.unica;
    sempre = widget.sempre;
  }

  Future<void> cards() async {
    _dropdownOptions.add('Não');
    List<String>? cards = await getCards();
    for (String card in cards!) {
      _dropdownOptions.add(card);
    }
  }

  void _updateBill() async {
    setState(() {
      wordButton = 'Atualizando ...';
      isUpdate = true;
    });
    List<Map<String, dynamic>> dados = [];
    dados.add({'Id':widget.id});
    if (_controllerAno.text.isEmpty) {
      dados.add({'Ano':widget.ano.toString()});
    } else {
      dados.add({'Ano':_controllerAno.text.toString()});
    }
    if (_controllerDescricao.text.isEmpty) {
      dados.add({'Descricao':widget.descricao.toString()});
    } else {
      dados.add({'Descricao':_controllerDescricao.text.toString()});
    }
    if (_controllerMes.text.isEmpty) {
      dados.add({'Mes':widget.mes.toString()});
    } else {
      dados.add({'Mes':_controllerMes.text.toString()});
    }
    if (_controllercategria.text.isEmpty) {
      dados.add({'Categoria':widget.categoria.toString()});
    } else {
      dados.add({'Categoria':_controllercategria.text.toString()});
    }
    dados.add({'unica':unica});
    dados.add({'sempre':sempre});
    dados.add({'card':_selectedOption});
    if (_controllerQtdParcelas.text.isEmpty) {
      dados.add({'Qtdparcela':widget.qtdparcelas.toString()});
    } else {
      dados.add({'Qtdparcela':_controllerQtdParcelas.text.toString()});
      if (int.parse(_controllerQtdParcelas.text) > 1) {
        if (_controllerValor.text.isEmpty) {
          double valor = widget.valor/int.parse(_controllerQtdParcelas.text);
          dados.add({'Valor':valor.toString()});
        } else {
          double valor = int.parse(_controllerValor.text)/int.parse(_controllerQtdParcelas.text);
          dados.add({'Valor':valor.toString()});
        }
      }

    }



    if (_controllerValor.text.isEmpty) {
      dados.add({'Valor':widget.valor.toString()});
    } else {
      dados.add({'Valor':_controllerValor.text.toString()});
    }
    if (_controllerParcela.text.isEmpty) {
      dados.add({'Parcela':widget.parcela.toString()});
    } else {
      dados.add({'Parcela':_controllerParcela.text.toString()});
    }
    if (_controllerQtdParcelas.text.isEmpty) {
      dados.add({'Qtdparcela':widget.qtdparcelas.toString()});
    } else {
      dados.add({'Qtdparcela':_controllerQtdParcelas.text.toString()});
    }




    var done = await updateBill(dados);
    setState(() {
        wordButton = 'Atualizar conta';
        isUpdate = false;
      });
    if (done == true) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Conta atualizada')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const BillsPage()
        )
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar')),
      );
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
              'Atualizar conta',
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
                        top: screenWidth * 0.1,
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
                          labelText: 'Descrição atual: ${widget.descricao}',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira a nova descrição',
                          hintStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          )
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
                        autofocus: true,
                        keyboardType: TextInputType.number,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Valor atual: ${widget.valor}',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira o novo valor',
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
                                unica = checked ?? false;
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
                                sempre = checked ?? false;
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
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: (unica == true) ? 'Única' : 'Parcela atual: ${widget.parcela}',
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
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: (unica == true || sempre == true) ? 'Sempre' : 'Qtd. pcls. atual: ${widget.qtdparcelas}',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                                hintText: (unica == true || sempre == true) ? 'Sempre' : 'Qtd. pcls.',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ), 
                          )
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
                              controller: _controllerMes,
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white,
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Mês atual: ${widget.mes}',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                                hintText: 'Insira o novo mês',
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
                              autofocus: true,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: screenWidth * 0.05,
                                color: Colors.white
                              ),
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Ano atual: ${widget.ano}',
                                labelStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                                hintText: 'Insira o novo ano',
                                hintStyle: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                        ],
                      ) 
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: screenHeight * 0.005,
                        vertical: screenHeight * 0.01
                      ),
                      child: TextField(
                        controller: _controllercategria,
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Categoria atual: ${widget.categoria}',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira a nova categoria',
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
                        controller: _controllercategria,
                        autofocus: true,
                        keyboardType: TextInputType.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          labelText: 'Vencimento atual: ${widget.vencimento}',
                          labelStyle: TextStyle(
                            fontSize: screenWidth * 0.05,
                            color: Colors.white,
                          ),
                          hintText: 'Insira o novo vencimento',
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
                        onPressed: () => (!isUpdate) ? _updateBill() : null,
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: (!isUpdate) ?const Color.fromRGBO(0, 0, 255, 1) : Colors.grey,
                          shadowColor: Colors.black,
                          minimumSize: Size(buttonWidth, buttonHeight),
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.005,
                            vertical: screenHeight * 0.02
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                        ),
                        child: Text(
                          wordButton,
                          style: TextStyle(
                            fontSize: screenWidth * 0.05,
                            fontFamily: 'Cresta',
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
