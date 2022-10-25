class CardDestaque {
  bool? teleconsulta;
  bool? meuPlano;
  bool? consultaOuExamePresencial;

  CardDestaque(
      {this.teleconsulta, this.meuPlano, this.consultaOuExamePresencial});

  CardDestaque.fromJson(Map<String, dynamic> json) {
    teleconsulta = json['teleconsulta'];
    meuPlano = json['meu_plano'];
    consultaOuExamePresencial = json['consulta_ou_exame_presencial'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['teleconsulta'] = teleconsulta;
    data['meu_plano'] = meuPlano;
    data['consulta_ou_exame_presencial'] = consultaOuExamePresencial;
    return data;
  }
}