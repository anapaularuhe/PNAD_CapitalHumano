
******************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Ana Paula Nothen Ruhe
* Setembro/2021
******************************************************


* PREPARAÇÃO *****************************************
* Garantindo que não há variáveis prévias na memória:
clear all
cls								

* Configurações de memória:
set maxvar 30000
	
* Configurando diretório: 
cd "C:/Users/ana.ruhe/Documents/Capital_Humano"
global dirdata = "C:/Users/ana.ruhe/Documents/Capital_Humano/Dados"

* Salvando log:
log using "Rotina_organizar_base.log", replace



* IMPORTANDO DADOS: 2021 *****************************
* Primeira vez: datazoom
  * datazoom_pnadcontinua, years( 2021 ) original(C:\Users\ana.ruhe\Documents\Capital_Humano\PNAD_Original) saving(C:\Users\ana.ruhe\Documents\Capital_Humano\Dados) nid
  
* Com os dados em .dta:
use "$dirdata/PNADC_trimestral_2021.dta"


* LIMPANDO BASE: 2021 ********************************
/* Vamos manter as seguintes variáveis:
	Ano        | Ano
	Trimestre  | Trimestre
	UF         | UF
	V1027      | Peso trimestral com correção de não entrevista SEM PÓS ESTRATIFICAÇÃO pela projeção de população
	V1028      | Peso trimestral com correção de não entrevista COM PÓS ESTRATIFICAÇÃO pela projeção de população  
	V1029      | Projeção da população
	
    V2007      | Sexo
	V2009      | Idade
	V2010      | Cor ou raça
	
	VD3004	   | Nível de educação mais elevado alcançado (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	VD3005     | Anos de estudo                           (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	             * Obs: variável parcialmente categória; 16 = 16 anos ou mais 
	VD3006     | Grupos de anos de estudo                 (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente)
	
	VD4001     | Condição na força de trabalho
	VD4002     | Condição de ocupação
	VD4003     | Força de trabalho potencial
	VD4009     | Posição na ocupação 
	VD4010     | Atividade principal do setor
	VD4016     | Rendimento habitual mensal (trabalho principal)
	VD4017     | Rendimento efetivo mensal  (trabalho principal)
	VD4019     | Rendimento habitual mensal (todos os trabalhos)
	VD4020     | Rendimento efetivo mensal  (todos os trabalhos)
	VD4031     | Horas habitualmente trabalhadas por semana (todos os trabalhos)
	VD4032     | Horas efetivamente trabalhadas na semana   (trabalho principal)
	VD4035     | Horas efetivamente trabalhadas na semana   (todos os trabalhos)
	
*/
keep Ano Trimestre UF V1027 V1028 V1029 V2007 V2009 V2010 VD3004 VD3005 VD3006 VD4001 VD4002 VD4003 VD4009 VD4010 VD4016 VD4017 VD4019 VD4020 VD4031 VD4032 VD4035


*** Nomeando variáveis de forma mais intuitiva:
  rename V1028 Peso
  rename V1029 Populacao
  
  rename V2007 Sexo
  rename V2009 Idade
  rename V2010 Cor
 
  save "$dirdata/PNADC2021_limpa.dta", replace

  
*** Variáveis categóricas: nomeando labels e criando dummies quando apropriado
* Sexo  (eliminamos observações com missing values) 
  label define sexo 1 "Homem" 2 "Mulher" 
  label values Sexo sexo
  
  drop if Sexo ==.
  gen dummy_Homem = (Sexo==1)
  gen dummy_Mulher = (Sexo==2)
  
  order dummy_Homem, after(Sexo)
  order dummy_Mulher, after(dummy_Homem)  
	  
	  
* Cor
  label define cor_label 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indígena" 9 "Ignorado" 
  label values Cor cor_label


* VD3004: Nível de instrução
  label define VD3004_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "Fundamental incompleto ou equivalente" 3 "Fundamental completo ou equivalente" 4 "Médio incompleto ou equivalente" 5 "Médio completo ou equivalente" 6 "Superior incompleto ou equivalente" 7 "Superior completo" 
  label values VD3004 VD3004_label
     
	 
* VD3006: Grupo	de anos de estudo (eliminamos observações com missing values)  
  label define VD3006_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "1 a 4 anos de estudo" 3 "5 a 8 anos de estudo" 4 "9 a 11 anos de estudo" 5 "12 a 15 anos de estudo" 6 "16 anos ou mais de estudo"
  label values VD3006 VD3006_label
  
  drop if VD3006 ==.
  gen dummy_educ1 = (VD3006==1)
  gen dummy_educ2 = (VD3006==2)
  gen dummy_educ3 = (VD3006==3)
  gen dummy_educ4 = (VD3006==4)
  gen dummy_educ5 = (VD3006==5)
  gen dummy_educ6 = (VD3006==6)
	
	  
* VD4001: Condição na força de trabalho
  label define VD4001_label 1 "Na força de trabalho" 2 "Fora da força de trabalho"
  label values VD4001 VD4001_label
  
 
* VD4002: Condição de ocupação
  label define VD4002_label 1 "Ocupado" 2 "Desocupado"
  label values VD4002 VD4002_label
   
   
* VD4003: Condição na FT potencial para aqueles fora da força de trabalho
  label define VD4003_label 1 "Na FT potencial" 2 "Fora da FT potencial"
  label values VD4003 VD4003_label
  
  
* VD4009: Posição na ocupação  
  label define VD4009_label 1 "Empregado setor privado COM carteira" 2 "Empregado setor privado SEM carteira" 3 "Trabalhador doméstico COM carteira" 4 "Trabalhador doméstico SEM carteira" 5 "Setor público COM carteira" 6 "Setor público SEM carteira" 7 "Militar e estatutário" 8 "Empregador" 9 "Conta-própria" 10 "Trabalhador familiar auxiliar"
  label values VD4009 VD4009_label
  
  gen dummy_setorprivado = (VD4009>=01 & VD4009<=04 | VD4009==10) if VD4009!=. 
  gen dummy_setorpublico = (VD4009>=05 & VD4009<=07) if VD4009!=. 
  gen dummy_informal = (VD4009==02 | VD4009==04 | VD4009==06 | VD4009==10)
  
  order dummy_setorprivado dummy_setorpublico dummy_informal, after(VD4009)
   
*VD4010: Setor de atividade
/* Como os nomes são muito longos, vamos usar resumos:
   01	Agricultura, pecuária, produção florestal, pesca e aquicultura    | Agropecuária
   02	Indústria geral                                                   | Indústria
   03	Construção                                                        | Construção
   04	Comércio, reparação de veículos automotores e motocicletas        | Veículos
   05	Transporte, armazenagem e correio                                 | Transporte
   06	Alojamento e alimentação                                          | Alojamento e alimentação
   07	Informação, comunicação e atividades financeiras, imobiliárias,   | Serviços de informação 
           profissionais e administrativas
   08	Administração pública, defesa e seguridade social                 | Administração pública 
   09	Educação, saúde humana e serviços sociais                         | Educação e saúde  
   10	Outros Serviços                                                   | Outros serviços  
   11	Serviços domésticos                                               | Serviços domésticos
   12	Atividades mal definidas                                          | Atividades mal definidas
*/

  label define VD4010_label 1 "Agropecuária" 2 "Indústria" 3 "Construção" 4 "Veículos" 5 "Transporte" 6 "Alojamento e alimentação" 7 "Serviços de informação" 8 "Administração pública" 9 "Educação e saúde" 10 "Outros serviços" 11 "Serviços domésticos" 12 "Atividades mal definidas"
  label values VD4010 VD4010_label
     

  save "$dirdata/PNADC2021_limpa.dta", replace	 

  
  
*** Criando variável de região:
/* Classificação das UF:
	11	Rondônia
	12	Acre
	13	Amazonas
	14	Roraima
	15	Pará
	16	Amapá
	17	Tocantins
	21	Maranhão
	22	Piauí
	23	Ceará
	24	Rio Grande do Norte
	25	Paraíba
	26	Pernambuco
	27	Alagoas
	28	Sergipe
	29	Bahia
	31	Minas Gerais
	32	Espírito Santo
	33	Rio de Janeiro
	35	São Paulo
	41	Paraná
	42	Santa Catarina
	43	Rio Grande do Sul
	50	Mato Grosso do Sul
	51	Mato Grosso
	52	Goiás
	53	Distrito Federal
*/
    gen Regiao=""
	replace Regiao="NO" if UF>=11 & UF<=17
	replace Regiao="NE" if UF>=21 & UF<=29
	replace Regiao="SE" if UF>=31 & UF<=35
	replace Regiao="SU" if UF>=41 & UF<=43
	replace Regiao="CO" if UF>=50 & UF<=53
    
	order Regiao, after(UF)
	
	
	save "$dirdata/PNADC2021_limpa.dta", replace	 
	
	log close

/* A fazer:
PREPARAÇÃO:
1. Calcular experiência e potências
2. Repetir exercício para outros anos


SELEÇÃO DA AMOSTRA:
1. Filtrar apenas ocupados
2. Filtrar apenas trabalhadores assalariados
3. Filtrar os que não informam rendimentos
4. Filtrar os que não informam horas
3. Deflacionar rendimentos
 
*/
  










*******************************************************************************************************************
*** RASCUNHOS: Trechos que foram modificados e não entraram no código principal (não apagar para evitar retrabalho)
/*
	V3009       | Qual o curso mais elevado que frequentou anteriormente? Até 2015
	V3009A      | Qual o curso mais elevado que frequentou anteriormente? A partir de 2016
	V3010       | A duração do curso que frequentou anteriormente era 8 ou 9 anos?
	V3011       | Este curso que frequentou anteriormente era seriado?
	V3011A      | Esse curso que frequentou era organizado em qual periodicidade?
	V3012       | Concluiu com aprovação pelo menos a primeira série?
	V3013       | Qual foi o último período que concluiu com aprovação neste curso?
	V3014       | Concluiu este curso que frequentou anteriormente? 
*/