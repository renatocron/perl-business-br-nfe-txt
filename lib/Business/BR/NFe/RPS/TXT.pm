package Business::BR::NFe::RPS::TXT;
use Moose;
use namespace::autoclean;


has data_ini => (
    is => 'ro',
);

has data_fim => (
    is => 'ro',
);

has inscricao_municipal => (
    is => 'ro',
);


sub _pad_str {}

sub _pad_num {}


sub adiciona_rps {
    my ($self, %params) = @_;

    # TODO Data::Verifier
    # param 1: esse daqui aceita date, str e num.
    # param 2: tamanho : positivo = pad, negativo = maximo
    # param 3:
    #    INT = pra numero = round de truncate
    #    ARRAY = valores aceitos

    # ps: todos os campos sao relativos ao tomador
    my $campos = {
        serie  => ['str', 5],
        numero => ['num', 12],
        emissao => ['date'],
        situacao => ['str', 1],
        valor_servico => ['num', 15, 2],
        valor_deducao => ['num', 15, 2],
        codigo_servico => ['num', 5],
        aliquota => ['num', 4, 2],
        iss_retido => ['num', [1,2,3]],
        cpf_cnpj_flag => ['num', [1,2,3]],
        cpf_cnpj      => ['num', 14],
        inscricao_municipal => ['num', 8],
        inscricao_estadual => ['num', 8],
        razao_social => ['str', 75],
        endereco_tipo => ['str', 3],
        endereco => ['str', 50],
        endereco_num => ['str', 10],
        endereco_complemento => ['str', 30],
        endereco_bairro => ['str', 30],
        endereco_cidade => ['str', 50],
        endereco_uf => ['str', 2],
        endereco_cep => ['num', 8],
        email => ['str', 75],
        discriminacao => ['str', -1000],
    };


}


sub salva_txt {



}
