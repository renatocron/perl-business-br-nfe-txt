use strict;
use Business::BR::NFe::RPS::TXT;
use Test::More;

my $txt = new Business::BR::NFe::RPS::TXT(
    data_ini => '00',
    data_fim => '00',
    inscricao_municipal => '00',
);

eval {
$txt->adiciona_rps(
        serie  => '00',
        numero => '00',
        emissao => '00',
        situacao => '0',
        valor_servico => '00',
        valor_deducao => '00',
        codigo_servico => '00',
        aliquota => '00',
        iss_retido => '1',
        cpf_cnpj_flag => '1',
        cpf_cnpj      => '00',
        inscricao_municipal => '00',
        inscricao_estadual => '00',
        razao_social => '00',
        endereco_tipo => '00',
        endereco => '00',
        endereco_num => '00',
        endereco_complemento => '00',
        endereco_bairro => '00',
        endereco_cidade => '00',
        endereco_uf => '00',
        endereco_cep => '00',
        email => '00',
        discriminacao => '00',
)};

like($@, qr/emissao nao esta no formato/, 'erro na data');

eval {
$txt->adiciona_rps(
        serie  => '00',
        numero => '00',
        emissao => '20121102',
        situacao => '0',
        valor_servico => '00',
        valor_deducao => '00',
        codigo_servico => '00',
        aliquota => '00',
        iss_retido => '1',
        cpf_cnpj_flag => '1',
        cpf_cnpj      => '00',
        inscricao_municipal => '00',
        inscricao_estadual => '00',
        razao_social => '00',
        endereco_tipo => '00',
        endereco => '00',

        endereco_complemento => '00',
        endereco_bairro => '00',
        endereco_cidade => '00',
        endereco_uf => '00',
        endereco_cep => '00',
        email => '00',
        discriminacao => '00',
)};

like($@, qr/endereco_num nao foi enviado/, 'campo faltando');


eval {
$txt->adiciona_rps(
        serie  => '00',
        numero => 'AAA',
        emissao => '00',
        situacao => '0',
        valor_servico => '00',
        valor_deducao => '00',
        codigo_servico => '00',
        aliquota => '00',
        iss_retido => '1',
        cpf_cnpj_flag => 1,
        cpf_cnpj      => '00',
        inscricao_municipal => '00',
        inscricao_estadual => '00',
        razao_social => '00',
        endereco_tipo => '00',
        endereco => '00',
        endereco_num => '00',
        endereco_complemento => '00',
        endereco_bairro => '00',
        endereco_cidade => '00',
        endereco_uf => '00',
        endereco_cep => '00',
        email => '00',
        discriminacao => '00',
)};

#like($@, qr/numero com valor AAA eh um numero/, 'str no int');

eval {
$txt->adiciona_rps(
        serie  => '01111110',
        numero => '00',
        emissao => '00',
        situacao => '0',
        valor_servico => '00',
        valor_deducao => '00',
        codigo_servico => '00',
        aliquota => '00',
        iss_retido => '1',
        cpf_cnpj_flag => '1',
        cpf_cnpj      => '00',
        inscricao_municipal => '00',
        inscricao_estadual => '00',
        razao_social => '00',
        endereco_tipo => '00',
        endereco => '00',
        endereco_num => '00',
        endereco_complemento => '00',
        endereco_bairro => '00',
        endereco_cidade => '00',
        endereco_uf => '00',
        endereco_cep => '00',
        email => '00',
        discriminacao => '00',
)};

like($@, qr/serie maior que 5/, 'campo maior que o limite');


eval {
$txt->adiciona_rps(
        serie  => '011',
        numero => '00',
        emissao => '20121222',
        situacao => '0',
        valor_servico => '999999999999999990',
        valor_deducao => '00',
        codigo_servico => '00',
        aliquota => '00',
        iss_retido => '1',
        cpf_cnpj_flag => '1',
        cpf_cnpj      => '00',
        inscricao_municipal => '00',
        inscricao_estadual => '00',
        razao_social => '00',
        endereco_tipo => '00',
        endereco => '00',
        endereco_num => '00',
        endereco_complemento => '00',
        endereco_bairro => '00',
        endereco_cidade => '00',
        endereco_uf => '00',
        endereco_cep => '00',
        email => '00',
        discriminacao => '00',
)};

like($@, qr/valor_servico maior que/, 'campo numero maior que o limite');

$txt = new Business::BR::NFe::RPS::TXT(
    data_ini => '20120202',
    data_fim => '20120204',
    inscricao_municipal => '12345667',
);

ok($txt->adiciona_rps(
        serie  => '011',
        numero => '00',
        emissao => '20121222',
        situacao => '0',
        valor_servico => 2400.34,
        valor_deducao => 140.45,
        codigo_servico => '00',
        aliquota => '00',
        iss_retido => '1',
        cpf_cnpj_flag => '1',
        cpf_cnpj      => '00',
        inscricao_municipal => '00',
        inscricao_estadual => '00',
        razao_social => '00',
        endereco_tipo => '00',
        endereco => '00',
        endereco_num => '00',
        endereco_complemento => '00',
        endereco_bairro => '00',
        endereco_cidade => '00',
        endereco_uf => '00',
        endereco_cep => '00',
        email => '00',
        discriminacao => '00',
), 'adicionado rps');
$txt->salva_txt;



done_testing;

