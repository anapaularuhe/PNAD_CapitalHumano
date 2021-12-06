******************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Ana Paula Nothen Ruhe
* Outubro/2021
******************************************************

* OBS: NECESSÁRIO INSTALAR PACOTE mdesc:
* search mdesc

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


* IMPORTANDO DADOS: 2012-2021 ************************
/* Primeira vez: datazoom
   datazoom_pnadcontinua, years( 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021) original(C:\Users\ana.ruhe\Documents\Capital_Humano\PNAD_Original) saving (C:\Users\ana.ruhe\Documents\Capital_Humano\Dados) nid

  
 Com os dados em .dta: criando base completa
	use "$dirdata/PNADC_trimestral_2012.dta"
	append using "$dirdata/PNADC_trimestral_2013.dta"
	append using "$dirdata/PNADC_trimestral_2014.dta"
	append using "$dirdata/PNADC_trimestral_2015.dta"
	append using "$dirdata/PNADC_trimestral_2016.dta"
	append using "$dirdata/PNADC_trimestral_2017.dta"
	append using "$dirdata/PNADC_trimestral_2018.dta"
	append using "$dirdata/PNADC_trimestral_2019.dta"
	append using "$dirdata/PNADC_trimestral_2020.dta"
	append using "$dirdata/PNADC_trimestral_2021.dta"

	save "$dirdata/PNADC2012_2021.dta", replace
*/

* Base já importada:
  use "$dirdata/PNADC2012_2021.dta", clear


* ADICIONANDO DEFLATORES *****************************	
  merge using "$dirdata/Deflatores.dta" 	
	
	
* LIMPANDO BASE **************************************
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
	
	V3003      | Qual o curso que frequenta (Até 2o tri 2015)
	V3003A     | Qual o curso que frequenta (A partir do 3o tri de 2015)
	V3009      | Qual o curso mais elevado que frequentou anteriormente (Até 2o tri 2015)
	V3009A     | Qual o curso mais elevado que frequentou anteriormente (A partir do 3o tri de 2015)
		
	VD3004	   | Nível de educação mais elevado alcançado (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	VD3005     | Anos de estudo                           (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	             * Obs: variável parcialmente categória; 16 = 16 anos ou mais 
	VD3006     | Grupos de anos de estudo                 (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente)
	
	VD4001     | Condição na força de trabalho
	VD4002     | Condição de ocupação
	VD4009     | Posição na ocupação 
	VD4010     | Atividade principal do setor
	VD4016     | Rendimento habitual mensal (trabalho principal)
	VD4017     | Rendimento efetivo mensal  (trabalho principal)
	VD4019     | Rendimento habitual mensal (todos os trabalhos)
	VD4020     | Rendimento efetivo mensal  (todos os trabalhos)
	VD4031     | Horas habitualmente trabalhadas por semana (todos os trabalhos)
	VD4032     | Horas efetivamente trabalhadas na semana   (trabalho principal)
	VD4035     | Horas efetivamente trabalhadas na semana   (todos os trabalhos)
	
	Efetivo    | Deflator com base nos redimentos efetivos
	Habitual   | Deflator com base nos rendimentos habituais	
*/

keep Ano Trimestre UF V1027 V1028 V1029 V2007 V2009 V2010 V3003 V3003A V3009 V3009A VD3004 VD3005 VD3006 VD4001 VD4002 VD4009 VD4010 VD4016 VD4017 VD4019 VD4020 VD4031 VD4032 VD4035 Efetivo Habitual


*** Nomeando variáveis de forma mais intuitiva:
  rename V1028 Peso
  rename V1029 Populacao
  
  rename V2007 Sexo
  rename V2009 Idade
  rename V2010 Cor
 
  save "$dirdata/PNADC2012_2021_limpa.dta", replace

  
*** Variáveis categóricas: nomeando labels e criando dummies quando apropriado
* Obs: variáveis dummy são do tipo byte - apenas 1 casa decimal, ocupam menos espaço na memória
* Sexo  (eliminamos observações com missing values) 
  label define sexo 1 "Homem" 2 "Mulher" 
  label values Sexo sexo
  
  mdesc Sexo
  drop if Sexo ==.
  gen byte dummy_Mulher = (Sexo==2)
  label var dummy_Mulher "Dummy=1 se Mulher"
  
  order dummy_Mulher, after(Sexo)
	  
	  
* Cor
  label define cor_label 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indígena" 9 "Ignorado" 
  label values Cor cor_label


* V3003: Qual o curso que frequenta (Até 2o tri 2015)
  label define V3003_label 1 "Pré-escolar (maternal e jardim de infância)" 2 "Alfabetização de jovens e adultos" 3 "Regular do ensino fundamental" 4 "Educação de jovens e adultos (EJA) ou supletivo do ensino fundamental" 5 "Regular do ensino médio" 6 "Educação de jovens e adultos (EJA) ou supletivo do ensino médio" 7 "Superior - graduação" 8 "Mestrado" 9 "Doutorado"
  label values V3003 V3003_label
  
  
* V3003A: Qual o curso que frequenta (A partir do 3o tri de 2015)
  label define V3003A_label 1 "Creche" 2 "Pré-escola" 3 "Alfabetização de jovens e adultos" 4 "Regular do ensino fundamental" 5 "Educação de jovens e adultos (EJA) do ensino fundamental" 6 "Regular do ensino médio" 7 "Educação de jovens e adultos (EJA) do ensino médio" 8 "Superior - graduação" 9 "Especialização de nível superior" 10 "Mestrado" 11 "Doutorado"
  label values V3003A V3003A_label
  
  
* V3009: Qual o curso mais elevado que frequentou anteriormente (Até 2o tri 2015) 
  label define V3009_label 1 "Classe de alfabetização" 2 "Alfabetização de jovens e adultos" 3 "Antigo primário (elementar)" 4 "Antigo ginásio (médio 1º ciclo)" 5 "Regular do ensino fundamental ou do 1º grau" 6 "Educação de jovens e adultos (EJA) ou supletivo do ensino fundamental" 7 "Antigo científico, clássico, etc. (médio 2º ciclo)" 8 "Regular do ensino médio ou do 2º grau" 9 "Educação de jovens e adultos (EJA) ou supletivo do ensino médio" 10 "Superior - graduação" 11 "Mestrado" 12 "Doutorado"
  label values V3009 V3009_label
  
  
* V3009A: Qual o curso mais elevado que frequentou anteriormente (A partir do 3o tri de 2015)
  label define V3009A_label 1 "Creche" 2 "Pré-escola" 3 "Classe de alfabetização" 4 "Alfabetização de jovens e adultos" 5 "Antigo primário (elementar)" 6 "Antigo ginásio (médio 1º ciclo)" 7 "Regular do ensino fundamental ou do 1º grau" 8 "Educação de jovens e adultos (EJA) ou supletivo do 1º grau" 9 "Antigo científico, clássico, etc. (médio 2º ciclo)" 10 "Regular do ensino médio ou do 2º grau" 11 "Educação de jovens e adultos (EJA) ou supletivo do 2º grau" 12 "Superior - graduação" 13 "Especialização de nível superior" 14 "Mestrado" 15 "Doutorado"
  label values V3009A V3009A_label
  
  
* VD3004: Nível de instrução
  label define VD3004_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "Fundamental incompleto ou equivalente" 3 "Fundamental completo ou equivalente" 4 "Médio incompleto ou equivalente" 5 "Médio completo ou equivalente" 6 "Superior incompleto ou equivalente" 7 "Superior completo" 
  label values VD3004 VD3004_label
     
	 
* VD3006: Grupo	de anos de estudo (eliminamos observações com missing values)  
  
  label define VD3006_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "1 a 4 anos de estudo" 3 "5 a 8 anos de estudo" 4 "9 a 11 anos de estudo" 5 "12 a 15 anos de estudo" 6 "16 anos ou mais de estudo"
  label values VD3006 VD3006_label
  
  ** Informações sobre missing values:
     mdesc VD3006
  ** Características das observações com missing values para grupo de educação (VD3006):
	 preserve
	 drop if VD3006 !=.
	 sum Idade VD4001 VD4002 VD4016, detail
	 restore
  ** Características da amostra remanescente:
     tab VD3006
  
  drop if VD3006 ==.
  gen byte dummy_educ1 = (VD3006==1)
  gen byte dummy_educ2 = (VD3006==2)
  gen byte dummy_educ3 = (VD3006==3)
  gen byte dummy_educ4 = (VD3006==4)
  gen byte dummy_educ5 = (VD3006==5)
  gen byte dummy_educ6 = (VD3006==6)
  
  label var dummy_educ1 "Dummy 0<= educação < 1"
  label var dummy_educ2 "Dummy 1<= educação <=4"
  label var dummy_educ3 "Dummy 5<= educação <=8"
  label var dummy_educ4 "Dummy 9<= educação <=11"
  label var dummy_educ5 "Dummy 12<= educação <=15"
  label var dummy_educ6 "Dummy educação >=16"
  
	  
* VD4001: Condição na força de trabalho
  label define VD4001_label 1 "Na força de trabalho" 2 "Fora da força de trabalho"
  label values VD4001 VD4001_label
  
 
* VD4002: Condição de ocupação
  label define VD4002_label 1 "Ocupado" 2 "Desocupado"
  label values VD4002 VD4002_label
   
  
* VD4009: Posição na ocupação  
  label define VD4009_label 1 "Empregado setor privado COM carteira" 2 "Empregado setor privado SEM carteira" 3 "Trabalhador doméstico COM carteira" 4 "Trabalhador doméstico SEM carteira" 5 "Setor público COM carteira" 6 "Setor público SEM carteira" 7 "Militar e estatutário" 8 "Empregador" 9 "Conta-própria" 10 "Trabalhador familiar auxiliar"
  label values VD4009 VD4009_label
  
  gen byte dummy_setorprivado = (VD4009>=01 & VD4009<=04) if VD4009!=. 
  label var dummy_setorprivado "Dummy = 1 se ocupado no setor privado"
  
  gen byte dummy_setorpublico = (VD4009>=05 & VD4009<=07) if VD4009!=.
  label var dummy_setorpublico "Dummy = 1 se ocupado no setor público"
  
  gen byte dummy_informal = (VD4009==02 | VD4009==04 | VD4009==06)
  label var dummy_informal "Dummy = 1 se ocupado no setor informal"
  
  gen byte dummy_trabalhador = (VD4009>=01 & VD4009<=07) if VD4009!=.
  label var dummy_trabalhador "Dummy = 1 se ocupado como trabalhador"
  
  gen byte dummy_trab_ou_empreg = (VD4009>=01 & VD4009<=09) if VD4009!=.
  label var dummy_trab_ou_empreg "Dummy = 1 se ocupado como trabalhador, empregador ou conta própria"
  
  order dummy_setorprivado dummy_setorpublico dummy_informal dummy_trabalhador dummy_trab_ou_empreg, after(VD4009)
   
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
     

  save "$dirdata/PNADC2012_2021_limpa.dta", replace

  
  
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
	label var Regiao "Região"
	replace Regiao="NO" if UF>=11 & UF<=17
	replace Regiao="NE" if UF>=21 & UF<=29
	replace Regiao="SE" if UF>=31 & UF<=35
	replace Regiao="SU" if UF>=41 & UF<=43
	replace Regiao="CO" if UF>=50 & UF<=53
    
	order Regiao, after(UF)
	
	
	save "$dirdata/PNADC2012_2021_limpa.dta", replace 
	
	
*** Criando variável de experiência (eliminamos observações com missing values de idade)
	mdesc Idade
	drop if Idade == .
	gen Experiencia = 0
	label var Experiencia "Experiência"
	order Experiencia, after(VD3006)
	replace Experiencia= Idade - VD3005 - 6 if VD3005>=9
	replace Experiencia= Idade - 15 if VD3005<9
	
  * Corrigindo valores negativos:
    replace Experiencia= 0 if Experiencia<0 
	
  * Potências de Experiência:
	gen Experiencia2 = Experiencia^2
	gen Experiencia3 = Experiencia^3
	gen Experiencia4 = Experiencia^4
	
	label var Experiencia2 "Experiência ao quadrado"
	label var Experiencia3 "Experiência ao cubo"
	label var Experiencia4 "Experiência elevada à 4 potência"
	
    save "$dirdata/PNADC2012_2021_limpa.dta", replace
  
 *** Análise: 16 ou + anos de estudo. Quem são?
   * Obs: todos com Especialização, Mestrado ou Doutorado tem VD3005 = 16
  
  * Criando dummies para aqueles cursando/já cursaram esses níveis educacionais: 
	gen byte Especializacao = 0
	replace Especializacao = 1 if V3003A==09 | V3009A==13

	gen byte Mestrado = 0 
	replace Mestrado = 1 if V3003==8 | V3009==11
	replace Mestrado = 1 if V3003A==10 | V3009A==14

	gen byte Doutorado = 0 
	replace Doutorado = 1 if V3003==9 | V3009==12
	replace Doutorado = 1 if V3003A==11 | V3009A==15
	
  * Avaliando participação na amostra e na população:	
	gen byte Part16 = 0
	replace Part16 = 1 if (VD3005==1 & Mestrado==0 & Doutorado==0 & Especializacao==0)
	replace Part16 = 2 if Especializacao==1
	replace Part16 = 3 if Mestrado==1
	replace Part16 = 4 if Doutorado==1
	
	label variable Part16 "Participação: 16 anos ou mais de estudo"
	label define Part16_labelh 0 "Menos de 16 anos de estudo" 1 "+16 anos sem pós" 2 "16+ e especializacao" 3 "16+ e mestrado" 4 "16+ e doutorado" 
	label values Part16 Part16_labelh
	
	tab Part16
	tab Part16 [iw = Peso]
	tab Ano Part16

  log close
