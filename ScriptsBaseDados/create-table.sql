
CREATE TABLE comum.carta (
    id SERIAL primary key,
    numero integer not null check (numero between 2 and 14),
    naipe varchar(1) not null check (naipe in ('C', 'O', 'E', 'P'))
);

CREATE TABLE probabilidade.mao_duas_cartas (
	id serial NOT NULL,
	numero_carta_1 int4 NOT NULL,
	numero_carta_2 int4 NOT NULL,
	offorsuited varchar(1) NOT NULL,
	probabilidade_vitoria numeric NOT NULL,
	qtd_jogos_simulados int8 NOT NULL,
	probabilidade_sair numeric NULL,
	numero_jogos int4 NULL,
	CONSTRAINT maoduascartas_numero_carta_1_check CHECK (((numero_carta_1 >= 2) AND (numero_carta_1 <= 14))),
	CONSTRAINT maoduascartas_numero_carta_2_check CHECK (((numero_carta_2 >= 2) AND (numero_carta_2 <= 14))),
	CONSTRAINT maoduascartas_offorsuited_check CHECK (((offorsuited)::text = ANY (ARRAY[('S'::character varying)::text, ('O'::character varying)::text]))),
	CONSTRAINT maoduascartas_pkey PRIMARY KEY (id)
);

CREATE TABLE probabilidade.analise_convergencia (
	id serial NOT NULL,
	numero_de_cartas int4 NOT NULL,
	quantida_de_jogos_executados int4 NOT NULL,
	probabilidade float4 NULL,
	tempo_gasto_execucao timetz NOT NULL,
	status varchar NULL,
	dt_inclusaso timestamp NOT NULL,
	cartas varchar(200) NULL,
	CONSTRAINT analiseconvergencia_pkey PRIMARY KEY (id)
);


CREATE TABLE probabilidade.tb_valores_th_bonus (
	id serial NOT NULL,
    ds_nm_jogo varchar(200) NOT NULL,
	val_bet_play int4 NOT NULL,
	val_bet_flop int4 NOT NULL,
	val_raise_turn int4 NOT NULL,
	val_raise_river int4 NOT NULL,
	CONSTRAINT tb_valores_th_bonus_pkey PRIMARY KEY (id)
);

-- INSERT INTO probabilidade.tb_valores_th_bonus (ds_nm_jogo, val_bet_play, val_bet_flop, val_raise_turn, val_raise_river) VALUES('VL_BASICO', 5, 10, 5, 5);
-- INSERT INTO probabilidade.tb_valores_th_bonus (ds_nm_jogo, val_bet_play, val_bet_flop, val_raise_turn, val_raise_river) VALUES('VL_BASICO_2', 50, 100, 50, 50);

CREATE TABLE probabilidade.tb_prob_acao (
	id serial NOT NULL,
    prob_call_flop numeric NOT NULL,
    prob_check_turn numeric NOT NULL,
    prob_raise_turn numeric NOT NULL,
    prob_check_river numeric NOT NULL,
    prob_raise_river numeric NOT NULL,
	CONSTRAINT tb_prob_acao_pkey PRIMARY KEY (id)
);

CREATE TABLE probabilidade.tb_execucao_prob (
	id serial NOT NULL,
	qtd_jogos_simulados int4 NOT NULL,
	val_stack_inicial int4 NOT NULL,
	val_stack_final int4 NOT NULL,
	id_valor_th_bonus int4 NOT NULL,
	id_prob_acao int4 NOT NULL,
	CONSTRAINT tb_execucao_prob_pkey PRIMARY KEY (id)
);
-- probabilidade.tb_execucao_prob foreign keys
ALTER TABLE probabilidade.tb_execucao_prob ADD CONSTRAINT tb_execucao_prob_id_prob_acao_fkey FOREIGN KEY (id_prob_acao) REFERENCES probabilidade.tb_prob_acao(id);
ALTER TABLE probabilidade.tb_execucao_prob ADD CONSTRAINT tb_execucao_prob_id_valor_th_bonus_fkey FOREIGN KEY (id_valor_th_bonus) REFERENCES probabilidade.tb_valores_th_bonus(id);

CREATE TABLE probabilidade.simulacao_call_pre_flop (
	id serial NOT NULL,
	id_grupo int NOT NULL,
    qtd_jogos_simulados int NOT NULL,
    qtd_jogos_ganhos int NOT NULL,
    qtd_jogos_perdidos int NOT NULL,
	qtd_jogos_empatados int NOT NULL,
    qtd_jogos_simulados_pretendidos int NOT NULL,
    raise_flop boolean not null;
   	raise_flop_turn boolean not null;
    val_stack_inicial int NOT NULL,
    val_stack_final int NOT NULL,
    id_mao_duas_cartas int NOT NULL REFERENCES probabilidade.mao_duas_cartas (id),
    id_acao_probabilidade int4,
    constraint tb_execucao_simulacao_call_pre_flot PRIMARY KEY (id)
);

-- Configuração Poker
CREATE TABLE comum.config_poker (
	id serial NOT NULL,
	val_ant int4 NOT NULL,
	val_see_flop int4 NOT NULL,	
	val_raise_pre_turn int4 NOT NULL,	
	val_raise_pre_river int4 NOT null,
	CONSTRAINT config_poker_pkey PRIMARY KEY (id)
);

INSERT INTO comum.config_poker (val_ant, val_see_flop, val_raise_pre_turn, val_raise_pre_river) VALUES(5, 10, 5, 5);
INSERT INTO comum.config_poker (val_ant, val_see_flop, val_raise_pre_turn, val_raise_pre_river) VALUES(50, 100, 50, 50);


-- Resumo de uma estratégia
CREATE TABLE probabilidade.tb_simulacao_jogos_resumo (
	id serial NOT NULL,
	val_stack_inicial int4 NOT NULL,
	val_stack_final int4 NOT NULL,
	qtd_jogos_simulados int4 NOT NULL,	
	qtd_jogos_ganhos int4 NOT NULL,
	qtd_jogos_perdidos int4 NOT NULL,
	qtd_jogos_empatados int4 NOT NULL,
	ds_inteligencia varchar(4000) NOT NULL,	
	CONSTRAINT constr_simulacao_jogos_resumo_key PRIMARY KEY (id)
);

CREATE TABLE probabilidade.acao_probabilidade (
	id serial NOT NULL,
	val_call_pre_flop numeric NOT null,
	val_raise_pre_turn numeric NOT null,
	val_raise_pre_river numeric NOT null,	
	CONSTRAINT acao_probabilidade_key PRIMARY KEY (id)
);


alter table probabilidade.tb_simulacao_jogos_resumo add constraint fk_acao_probabilidade foreign key (id_acao_probabilidade) references  probabilidade.acao_probabilidade(id);


CREATE TABLE probabilidade.tb_probabilidade_mao_vencer (
	id serial NOT NULL,
    ds_jogo_mao varchar(200) NOT NULL,
	val_prob_vencer numeric NOT NULL,
	CONSTRAINT tb_probabilidade_mao_vencer_pkey PRIMARY KEY (id)
);
