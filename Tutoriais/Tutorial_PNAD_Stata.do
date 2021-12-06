*****************************************************
************** TUTORIAL PNAD NO STATA ***************
*****************************************************

*** Sobre a PNAD: microdados trimestrais em pasta zipada, formato .txt
* Arquivos adicionais: Documentação (Dicionário), Deflatores, Tabelas (Algumas estatísticas agregadas, para conferir) 


*** Preparação:
* Garantindo que não há variáveis prévias na memória:
clear all								

* Configurações de memória:
set memory 10g
set matsize 11000
set maxvar 30000
	
* Configurando diretório: 
cd "C:/Users/ana.ruhe/Documents/Tutorial PNAD no Stata"
global dirdata = "C:/Users/ana.ruhe/Documents/Tutorial PNAD no Stata/Dados"

* Salvando log:
log using "TutorialPNAD_logfile.log", replace


*****************************************************
*** IMPORTANDO OS DADOS
* Baixar txt: https://www.ibge.gov.br/estatisticas/multidominio/condicoes-de-vida-desigualdade-e-pobreza/9173-pesquisa-nacional-por-amostra-de-domicilios-continua-trimestral.html?edicao=30789&t=downloads 


* Formas de abrir o txt:
* 1. Infix: salvar variáveis individualmente
	/* 	LISTA DE VARIÁVEIS E IDENTIFICADORES

	* Identificação e controle
	infix ano 1-4	  // Ano da PNAD
	trimestre 5-5     // Trimestre da PNAD
	uf 6-7  	      // UF de residencia
	UPA 12-20         // Unidade Primária de Amostragem (UPA)
	V1027 35-49       // Peso do domicílio e das pessoas sem pós estratificacao
	V1022 33-33       // Situaçao do domicilio        
	V1028 50-64       // Peso do domicílio e das pessoas com pós estratificacao
	V1029 65-73       // Projeção da população do trimestre (referência: mês do meio)

	* Características individuais
	V2007 83-83	      // sexo 1 homem 2 mulher
	V2009 92-94		  // Idade do morador na data de referência
	V2010 95-95		  // raca do morador 1 branco 2 preto 3 amarela 4 parda 5 indigena 9 ignorado

	* Parte 4: 2 - Características de trabalho das pessoas de 14 anos ou mais de idade ocupadas
	V4009 139-139     // Quantos trabalhos ... tinha na semana de ... a ... (semana de referência ?
	V4010 140-143     // Código da ocupação (cargo ou função)
	V4013 146-150     // Ver "Composição dos Grupamentos de Atividade" e “Relação de Códigos de Atividades” da CNAE-Domiciliar 
	V4016 159-159     // Na semana de ... a ... (semana de referência), quantos empregados trabalhavam nesse negócio/empresa que ... tinha ?
	V4018 168-168     // Na semana de ... a ... (semana de referência), contando com ... , quantas pessoas trabalhavam nesse negócio/empresa ?
	V4019 174-174     // Esse negócio/empresa era registrado no Cadastro Nacional da Pessoa Jurídica - CNPJ?
	V4029 183-183     // Nesse trabalho, ... tinha carteira de trabalho assinada ?
	V4033 185-185     // Qual era o rendimento bruto mensal que ... recebia/fazia  normalmente nesse trabalho? (variável auxiliar)
	V40331 186-186    // Recebia/fazia normalmente nesse trabalho rendimento/retirada em dinheiro?
	V403312 188-195   // Qual era o rendimento bruto/retirada mensal que ... recebia/fazia normalmente nesse trabalho ? (valor em dinheiro)
	V4034 208-208     // Qual foi o rendimento bruto que ... recebeu/fez  nesse trabalho, no mês de referência? (variável auxiliar)
	V40341 209-209    // Recebeu/fez nesse trabalho rendimento/retirada em dinheiro no mês de referência
	V403412 211-218   // Qual foi o rendimento bruto/retirada que ... recebeu/fez nesse trabalho, no mês de referência ? (valor em dinheiro)
	V4039 229-231     // Quantas horas ... trabalhava normalmente, por semana, nesse trabalho principal?
	V4039C 232-234    // Quantas horas ... trabalhou efetivamente na semana de referência nesse trabalho principal?
	V4040 235-235     // Até o dia ... (último dia da semana de referência) fazia quanto tempo que ... estava nesse trabalho ?

	* Variáveis Derivadas
	VD3004 391-391    // Nível de instrução mais elevado alcançado (pessoas de 5 anos ou mais de idade) padronizado para o Ensino fundamental -  SISTEMA DE 9 ANOS
	VD3005 392-393	  // Anos de estudo (pessoas de 5 anos ou mais de idade) padronizado para o Ensino fundamental - SISTEMA DE 9 ANOS
	VD4001 395-395    // Condição em relação à força de trabalho
	VD4002 396-396    // Condição em relação à força de trabalho
	VD4007 401-401    // Posição na ocupação no trabalho principal da semana de referência para pessoas de 14 anos ou mais de idade
	VD4008 402-402    // Posição na ocupação no trabalho principal da semana de referência para pessoas de 14 anos ou mais de idade (com subcategorias de empregados)
	VD4009 403-404    // (mais detalhado) Posição na ocupação e categoria do emprego do trabalho principal da semana de referência para pessoas de 14 anos ou mais de idade
	VD4010 405-406    // Grupamentos de atividade principal do empreendimento do trabalho principal da semana de referência para pessoas de 14 anos ou mais de idade
	VD4011 407-408    // Grupamentos ocupacionais do trabalho principal da semana de referência para pessoas de 14 anos ou mais de idade
	VD4015 412-412    // Tipo de remuneração habitualmente recebida no trabalho principal para pessoas de 14 anos ou mais de idade
	VD4016 413-420    // Rendimento mensal habitual do trabalho principal para pessoas de 14 anos ou mais de idade (apenas para pessoas que receberam em dinheiro, produtos ou mercadorias no trabalho principal)
	VD4017 421-428    // Rendimento mensal efetivo do trabalho principal para pessoas de 14 anos ou mais de idade (apenas para pessoas que receberam em dinheiro, produtos ou mercadorias no trabalho principal)

	VD4032 451-453    // Horas efetivamente trabalhadas na semana de referência no trabalho principal para pessoas de 14 anos ou mais de idade
	V4039 229-231     // Quantas horas ... trabalhava normalmente, por semana, nesse trabalho principal?
	V4039C 232-234    // Quantas horas ... trabalhou efetivamente na semana de referência nesse trabalho principal?
	VD4036 463-463    // Faixa das horas habitualmente trabalhadas por semana no trabalho principal para pessoas de 14 anos ou mais de idade
	VD4037 464-464    // Faixa das horas efetivamente trabalhadas na semana de referência no trabalho principal  para pessoas de 14 anos ou mais de idade

	*/

	* Comando:
    /*
	infix ano 1-4 trimestre 5-5 uf 6-7 UPA 12-20 V1022 33-33 V1027 35-49 V1028 50-64 V1029 65-73 V2007 83-83 V2009 92-94 V2010 95-95 V4009 139-139 V4010 140-143 V4013 146-150 V4016 159-159 V4018 168-168 V4019 174-174 V4029 183-183 V4033 185-185 V40331 186-186 V403312 188-195 V4034 208-208 V40341 209-209 V403412 211-218 V4040 235-235 VD3005 392-393 VD3004 391-391 VD4001 395-395 VD4002 396-396 VD4007 401-401 VD4008 402-402 VD4009 403-404 VD4010 405-406 VD4011 407-408 VD4015 412-412 VD4016 413-420 VD4017 421-428 VD4032 451-453 V4039 229-231 V4039C 232-234 VD4036 463-463 VD4037 464-464 using "$dirdata/nomedoarquivoPNAD.txt"

    save "$dirdata/PNADanotrimestre_infix_bruta.dta", replace
    */
	
	
* 2. Data Zoom (exporta base em dta - já vem com label)
* Primeira instalação: 
* net from http://www.econ.puc-rio.br/datazoom/portugues

     *db datazoom_pnadcontinua
	 *datazoom_pnadcontinua, years( 2018 2019 ) original(C:...\pnad_txt) saving(C:...) nid


* 3. A partir de base dta:
  use "$dirdata/nomearquivo.dta", clear	 

log close
