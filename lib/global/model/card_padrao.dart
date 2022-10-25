class CardPadrao {
  bool? seguroDeVida;
  bool? centralDeAtendimento;
  bool? auxLioFuneral;
  bool? descontoEmMedicamentos;

  CardPadrao(
      {this.seguroDeVida,
        this.centralDeAtendimento,
        this.auxLioFuneral,
        this.descontoEmMedicamentos});

  CardPadrao.fromJson(Map<String, dynamic> json) {
    seguroDeVida = json['seguro_de_vida'];
    centralDeAtendimento = json['central_de_atendimento'];
    auxLioFuneral = json['auxílio_funeral'];
    descontoEmMedicamentos = json['desconto_em_medicamentos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['seguro_de_vida'] = seguroDeVida;
    data['central_de_atendimento'] = centralDeAtendimento;
    data['auxílio_funeral'] = auxLioFuneral;
    data['desconto_em_medicamentos'] = descontoEmMedicamentos;
    return data;
  }
}