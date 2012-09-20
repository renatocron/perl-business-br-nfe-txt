package Business::BR::NFe::RPS::TXT;

use Moose;
use Moose::Util::TypeConstraints;
use namespace::autoclean;
use Carp;

subtype 'DataRps',
    as 'Str',
    where { /^[1-2][0-9][0-9][0-9][0-1][0-9][0-3][0-9]$/ },
    message { 'The date you provided is not for NFe::RPS' };

has data_ini => (
    is => 'ro',
    isa => 'DataRps',
    required => 1
);

has data_fim => (
    is => 'ro',
    isa => 'DataRps',
    required => 1
);

has inscricao_municipal => (
    is => 'ro',
    required => 1
);

has _total_servico => (
    is => 'rw',
    isa => 'Num',
    default => sub {0}
);

has _total_deducao => (
    is => 'rw',
    isa => 'Num',
    default => sub {0}
);

has _rps_lines => (
    is => 'rw',
    isa => 'Str',
    default => sub {''}
);

has _total_linhas => (
    is => 'rw',
    isa => 'Int',
    default => sub {0}
);

sub _pad_str {
    my ($str, $size)=@_;
    return $str . ' ' x ($size - length($str));
}

sub _pad_num {
    my ($num, $size, $round) = @_;

    if ($round && $round =~ /^[0-9]$/){
        $round = int ('1' . '0' x ($round-1));
    }else{
        $round = 1;
    }
    $num = $num * $round;
    if (ref $size eq 'ARRAY'){
        croak "Not a number";
    }else{
        return sprintf( '%0'.$size.'s', $num * $round );
    }
}


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
        situacao => ['str', 1, ['T','I','F','C', 'E', 'J']],
        valor_servico => ['num', 15, 2],
        valor_deducao => ['num', 15, 2],
        codigo_servico => ['num', 5],
        aliquota => ['num', 4, 2],
        iss_retido => ['num', [1,2,3]],
        cpf_cnpj_flag => ['num', [1,2,3]],
        cpf_cnpj      => ['num', 14],
        inscricao_municipal => ['num', 8],
        inscricao_estadual => ['num', 12],
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
    $params{aliquota} = $params{aliquota} * 100 if $params{aliquota};
    $params{discriminacao} =~ s/\r?\n/|/g;

    my $out = $self->_validate($campos , %params);
    my @ordem = qw/
        serie
        numero
        emissao
        situacao
        valor_servico
        valor_deducao
        codigo_servico
        aliquota
        iss_retido
        cpf_cnpj_flag
        cpf_cnpj
        inscricao_municipal
        inscricao_estadual
        razao_social
        endereco_tipo
        endereco
        endereco_num
        endereco_complemento
        endereco_bairro
        endereco_cidade
        endereco_uf
        endereco_cep
        email
        discriminacao/;
    my $line = '2'; # registro 2 versao 001
    $line .= _pad_str('RPS', 5);
    foreach (@ordem){
        $line .= $out->{$_};
    };
    $line .= "\r\n";

    $self->_rps_lines($self->_rps_lines . $line);

    $self->_total_deducao( $self->_total_deducao + $params{valor_deducao});
    $self->_total_servico( $self->_total_servico + $params{valor_servico});

    $self->_total_linhas($self->_total_linhas + 1);
    return 1;
}

sub _validate {
    my ($self, $config, %params) = @_;
    my $x={};
    foreach my $campo (keys %$config){
        my $ref = $config->{$campo};
        next unless ref $ref eq 'ARRAY';

        croak "$campo nao foi enviado" unless defined $params{$campo};

        if ($ref->[0] eq 'str'){
            my $size = $ref->[1];

            if ($size > 0 && length($params{$campo}) > $size){
                croak "$campo maior que $size";
            }elsif ($size < 0){
                $size = $size * -1;
                if (length($params{$campo}) > $size){
                    croak "$campo maior que $size";
                }
                $x->{$campo} = $params{$campo};
            }else{
                $x->{$campo} = _pad_str($params{$campo}, $size);
            }

        }elsif ($ref->[0] eq 'num'){
            $params{$campo} ||= 0;
            if ($params{$campo} !~ /^[0-9]+(?:\.[0-9]+)?$/){
                croak "$campo com valor $params{$campo} nao eh um numero";
            }else{
                my $size = $ref->[1];
                my $round = $ref->[2];
                if (ref $size eq 'ARRAY'){
                    my %valid = map {$_=>1} @$size;
                    croak "$campo invalido " unless $valid{$params{$campo}};
                    $size = 1; # WARNING nao era pra ser assim..
                }elsif (length($params{$campo}) > $size){
                    croak "$campo maior que $size posicoes";
                }
                $x->{$campo} = _pad_num($params{$campo}, $size, $round);
            }

        }elsif ($ref->[0] eq 'date'){
            if ($params{$campo} !~ /^\d{4}\d{2}\d{2}$/){
                croak "$campo nao esta no formato AAAAMMDD";
            }else{
                $x->{$campo} = $params{$campo};
            }
        }
    }
    return $x;
}

sub salva_txt {
    my ($self) = @_;

    my $campos = {
        data_fim  => ['date'],
        data_ini => ['date'],
        inscricao_municipal=> ['num', 8],
    };

    my $out = $self->_validate($campos,
        data_fim => $self->data_fim,
        data_ini => $self->data_ini,
        inscricao_municipal => $self->inscricao_municipal);

    my $str = '1001' . $out->{inscricao_municipal} . $out->{data_ini}.$out->{data_fim} . "\r\n" . $self->_rps_lines;

    $str .= '9' .
        _pad_num($self->_total_linhas, 7) .
        _pad_num($self->_total_servico, 15, 2) .
        _pad_num($self->_total_deducao, 15, 2) . "\r\n";

    return $str;
}

1

