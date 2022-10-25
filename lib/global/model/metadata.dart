class Metadata {
  String? nomeDependente;
  String? nomeDependente02;
  String? nomeDependente03;
  String? nomeDependente04;
  String? nomeDependente05;
  String? sexoTitular;
  String? sexoDependente01;
  String? sexoDependente02;
  String? sexoDependente03;
  String? sexoDependente04;
  String? sexoDependente05;
  String? cpfDependente;
  String? cpfDependente02;
  String? cpfDependente03;
  String? cpfDependente04;
  String? cpfDependente05;
  String? nascimentoDependente;
  String? nascimentoDependente02;
  String? nascimentoDependente03;
  String? nascimentoDependente04;
  String? nascimentoDependente05;
  String? nascimentoTitular;
  String? regimeDeTributacao;

  Metadata({
    this.nomeDependente,
    this.nomeDependente02,
    this.nomeDependente03,
    this.nomeDependente04,
    this.nomeDependente05,
    this.sexoTitular,
    this.sexoDependente01,
    this.sexoDependente02,
    this.sexoDependente03,
    this.sexoDependente04,
    this.sexoDependente05,
    this.cpfDependente,
    this.cpfDependente02,
    this.cpfDependente03,
    this.cpfDependente04,
    this.cpfDependente05,
    this.nascimentoDependente,
    this.nascimentoDependente02,
    this.nascimentoDependente03,
    this.nascimentoDependente04,
    this.nascimentoDependente05,
    this.nascimentoTitular,
    this.regimeDeTributacao,
  });

  Metadata.fromJson(Map<String, dynamic> json) {
    nomeDependente =
        json['nome_do_dependente'];
    nomeDependente02 = json['nome_do_dependente_02'];
    nomeDependente03 = json['nome_do_dependente_03'];
    nomeDependente04 =
        json['nome_dependente_4'];
    nomeDependente05 =
        json['nome_dependente_5'];
    sexoTitular = json['sexo_titular'];
    sexoDependente01 =
        json['sexo_dependente_01'];
    sexoDependente02 =
        json['sexo_dependente_02'];
    sexoDependente03 =
        json['sexo_dependente_03'];
    sexoDependente04 =
        json['sexo_dependente_04'];
    sexoDependente05 =
        json['sexo_dependente_05'];
    cpfDependente =
        json['cpf_do_dependente'];
    cpfDependente02 = json['cpf_do_dependente_02'];
    cpfDependente03 = json['cpf_do_dependente_03'];
    cpfDependente04 = json['cpf_do_dependente_04'];
    cpfDependente05 = json['cpf_do_dependente_05'];
    nascimentoDependente = json['nascimento_do_dependente'];
    nascimentoDependente02 = json['nascimento_do_dependente_02'];
    nascimentoDependente03 = json['nascimento_do_dependente_03'];
    nascimentoDependente04 = json['nascimento_do_dependente_04'];
    nascimentoDependente05 = json['nascimento_do_dependente_05'];
    nascimentoTitular =
        json['nascimento_titular'];
    regimeDeTributacao = json['_integration_nfeio_taxation'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['nome_do_dependente'] = nomeDependente;
    data['nome_do_dependente_02'] = nomeDependente02;
    data['nome_do_dependente_03'] = nomeDependente03;
    data['nome_dependente_4'] = nomeDependente04;
    data['nome_dependente_5'] = nomeDependente05;
    data['sexo_titular'] = sexoTitular;
    data['sexo_dependente_01'] = sexoDependente01;
    data['sexo_dependente_02'] = sexoDependente02;
    data['sexo_dependente_03'] = sexoDependente03;
    data['sexo_dependente_04'] = sexoDependente04;
    data['sexo_dependente_05'] = sexoDependente05;
    data['cpf_do_dependente'] = cpfDependente;
    data['cpf_do_dependente_02'] = cpfDependente02;
    data['cpf_do_dependente_03'] = cpfDependente03;
    data['cpf_do_dependente_04'] = cpfDependente04;
    data['cpf_do_dependente_05'] = cpfDependente05;
    data['nascimento_do_dependente'] = nascimentoDependente;
    data['nascimento_do_dependente_02'] = nascimentoDependente02;
    data['nascimento_do_dependente_03'] = nascimentoDependente03;
    data['nascimento_do_dependente_04'] = nascimentoDependente04;
    data['nascimento_do_dependente_05'] = nascimentoDependente05;
    data['nascimento_titular'] = nascimentoTitular;
    data['_integration_nfeio_taxation'] = regimeDeTributacao;
    return data;
  }
}
