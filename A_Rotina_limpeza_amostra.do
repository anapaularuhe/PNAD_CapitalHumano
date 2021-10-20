*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
*******************************************************************************

*ssc install mdesc
*ssc install tabout
*ssc install labutil 

clear all
cls								

* Configurações de memória:
set maxvar 30000
	
* Configurando diretório: 
global dirpath "C:/Users/ana.ruhe/Documents/Capital_Humano"
global dirdata = "C:/Users/ana.ruhe/Documents/Capital_Humano/Dados"
*global dirpath = "C:\Users\janaina.feijo\Documents\capital_humano\result"   
*global dirdata = "C:\Users\janaina.feijo\Documents\capital_humano\data" 


* Salvando log:
*log using "$dirpath\A_limpeza_amostra_capitalhumano.log", replace
log using "A_Limpeza_amostra.log", replace


*******************************************************************************
* A. IMPORTANDO DADOS E CONSTRUINDO BASE COMPLETA COM DEFLATORES: 2012.2-2021.2 
*******************************************************************************
{
* Primeira vez: datazoom
/*

datazoom_pnadcontinua, years( 2012 2013 2014 2015 2016 2017 2018 2019 2020 2021) original(C:\Users\ana.ruhe\Documents\Capital_Humano\PNAD_Original) saving (C:\Users\ana.ruhe\Documents\Capital_Humano\Dados) nid
  
    *Com os dados em .dta: criando base completa
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

	save "$dirdata/A0_PNADC2012_2021_bruta.dta", replace
*/	
	
* Construindo base completa com deflatores *****************************

  * Salvando deflatores em dta
	import excel "$dirdata\deflator_PNADC_2021_trimestral_040506.xls", sheet("deflatormod") firstrow clear
	destring Ano UF, replace 
	save  "$dirdata/A1_deflator_2t2021.dta" , replace
	 
  * Merge
	use "$dirdata/A0_PNADC2012_2021_bruta.dta", clear
	destring Trimestre, replace
    merge m:1 Ano UF Trimestre using "$dirdata/A1_deflator_2t2021.dta"
	
	drop _merge
	 
  * Criando variavel de Data
	gen data=yq(Ano, Trimestre)
	format data %tq 
	
  * Criando variável de Período 
    gen T = ((Ano - 2012)*4) + Trimestre
    label var T "Período sequencial"
    order T data, after(Trimestre)
   
    * Label:
     tostring Ano, generate(Ano_string) 
	 tostring Trimestre, generate(Trimestre_string)
     gen Periodo = Ano_string + "-" + Trimestre_string
     labmask T, values(Periodo)
   
     drop Ano_string Trimestre_string Periodo
	 
save "$dirdata/A2_PNADC2012_2021_completa_deflatores.dta", replace	

}

	
*******************************************************************************
* B. LIMPANDO BASE 
*******************************************************************************
{
/* Vamos manter as seguintes variáveis:
	Ano        | Ano
	Trimestre  | Trimestre
	Data       | Variável criada para identificar ano e trimestre conjuntamente	
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

use "$dirdata/A2_PNADC2012_2021_completa_deflatores.dta", clear

keep Ano Trimestre UF data V1027 V1028 V1029 V2007 V2009 V2010 V3003 V3003A V3009 V3009A VD3004 VD3005 VD3006 VD4001 VD4002 VD4009 VD4010 VD4016 VD4017 VD4019 VD4020 VD4031 VD4032 VD4035 Efetivo Habitual

   
* Nomeando algumas variáveis de forma mais intuitiva:
  rename V1028 Peso
  rename V1029 Populacao
  rename V2007 Sexo
  rename V2009 Idade
  rename V2010 Cor
  

** Definindo labels e criando dummies quando necessário 
* SEXO  
  mdesc Sexo
  drop if Sexo ==.  

  label define sexo 1 "Homem" 2 "Mulher" 
  label values Sexo sexo
  
  gen byte mulher = (Sexo==2)
  label var mulher "Dummy=1 se Mulher"
  
  order mulher, after(Sexo)
  
  
* COR
  tab data Cor
  label define cor_label 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indigena" 9 "Ignorado"  
  label values Cor cor_label 

	
* ESCOLARIDADE
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
   
   
  * VD3006: Grupo de anos de estudo (eliminamos observações com missing values)  
  label define VD3006_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "1 a 4 anos de estudo" 3 "5 a 8 anos de estudo" 4 "9 a 11 anos de estudo" 5 "12 a 15 anos de estudo" 6 "16 anos ou mais de estudo"
  label values VD3006 VD3006_label
  
  tab data VD3006 [iw=Peso] if VD4002==1
  * Obs: mais de 20% da pop ocupada (19.583.262) tem ensino superior 
  
  drop if VD3006 ==.
  gen byte educ1 = (VD3006==1)
  gen byte educ2 = (VD3006==2)
  gen byte educ3 = (VD3006==3)
  gen byte educ4 = (VD3006==4)
  gen byte educ5 = (VD3006==5)
  gen byte educ6 = (VD3006==6)
  
  label var educ1 "Dummy 0<= educacao < 1"
  label var educ2 "Dummy 1<= educacao <=4"
  label var educ3 "Dummy 5<= educacao <=8"
  label var educ4 "Dummy 9<= educacao <=11"
  label var educ5 "Dummy 12<= educacao <=15"
  label var educ6 "Dummy educacao >=16"
    
  * Criamos uma variável para grupos de educação que distingue quem tem mestrado e doutorado (pós graduação):
  gen VD3006_pos=VD3006
  replace VD3006_pos=7 if V3009A==14
  replace VD3006_pos=8 if V3009A==15
  replace VD3006_pos=7 if V3009==11
  replace VD3006_pos=8 if V3009==12  

  label define VD3006_pos_label 1 "Sem instrução e menos de 1 ano" 2 "1 a 4 anos" 3 "5 a 8 anos" 4 "9 a 11 anos" 5 "12 a 15 anos" 6 "16 ou 17 anos" 7 "18 anos" 8 "22 anos ou mais"
  label values VD3006_pos VD3006_pos_label
  order VD3006_pos, after(VD3006)
  
  tab data VD3006_pos [iw=Peso] if VD4002==1
  * Obs: 18.528.993 (superior) + 710.893 (mestrado) + 343.376 (Doutorado) = 19.583.262 
  
  gen byte educ_pos1 = (VD3006_pos==1)
  gen byte educ_pos2 = (VD3006_pos==2)
  gen byte educ_pos3 = (VD3006_pos==3)
  gen byte educ_pos4 = (VD3006_pos==4)
  gen byte educ_pos5 = (VD3006_pos==5)
  gen byte educ_pos6 = (VD3006_pos==6)
  gen byte educ_pos7 = (VD3006_pos==6)
  gen byte educ_pos8 = (VD3006_pos==6)
     
  label var educ_pos1 "Dummy Entre 0 e 1"
  label var educ_pos2 "Dummy 1 a 4 anos"
  label var educ_pos3 "Dummy 5 a 8 anos"
  label var educ_pos4 "Dummy 9 a 11 anos"
  label var educ_pos5 "Dummy 12 a 15 anos"
  label var educ_pos6 "Dummy 16 a 17 anos"
  label var educ_pos7 "Dummy 18 anos"
  label var educ_pos8 "Dummy 22 ou mais"
  
  tab data VD3006_pos [iw=Peso] if VD4002==1
  tab data VD3006 [iw=Peso] if VD4002==1
  
  
* TRABALHO  
  * VD4001: Condição na força de trabalho
  label define VD4001_label 1 "Na força de trabalho" 2 "Fora da força de trabalho"
  label values VD4001 VD4001_label

  
  * VD4002: Condição de ocupação
  label define VD4002_label 1 "Ocupado" 2 "Desocupado"
  label values VD4002 VD4002_label
  tab data VD4002 [iw=Peso] if VD4002==1
  
  
  * VD4009: Posição na ocupação 
  label define VD4009_label 1 "privado COM carteira" 2 "privado SEM carteira" 3 "doméstico COM carteira" 4 "doméstico SEM carteira" 5 "público COM carteira" 6 "público SEM carteira" 7 "Militar e estatutário" 8 "Empregador" 9 "Conta-própria" 10 "familiar auxiliar"
  label values VD4009 VD4009_label
  tab data VD4009 [iw=Peso] 
  
  gen byte privado = (VD4009>=01 & VD4009<=04) if VD4009!=. 
  label var privado "Dummy = 1 se ocupado no setor privado"
  
  gen byte publico = (VD4009>=05 & VD4009<=07) if VD4009!=.
  label var publico "Dummy = 1 se ocupado no setor publico"
  
  gen byte informal = (VD4009==02 | VD4009==04 | VD4009==06 | VD4009==10)
  label var informal "Dummy = 1 se ocupado no setor informal"
  
  gen byte trabalhador = (VD4009>=01 & VD4009<=07 | VD4009==10) if VD4009!=.
  label var trabalhador "Dummy = 1 se ocupado como trabalhador"
  
  order privado publico informal trabalhador, after(VD4009)
      
   
  * VD4010: Setor de atividade
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
     
  
* REGIÃO: Criando variável a partir das UF
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
		
	
* EXPERIÊNCIA:
* 1. Variável convencional: sem missing na variável idade e escolaridade
  mdesc Idade
  drop if Idade == .
  gen Experiencia =.
  label var Experiencia "Experiencia"
  order Experiencia, after(VD3006)
  replace Experiencia = Idade - VD3005 - 6 if VD3005>=9
  replace Experiencia = Idade - 15 if VD3005<9
	
  * Corrigindo valores negativos (considerando pessoas ocupadas, mudança média de 2 mil observações por trimestre representando em média 130 mil pessoas):
  replace Experiencia= 0 if Experiencia<0 

  * Obs: Teste de Robustez - estimar dropando pessoas que têm 15 anos
	gen idade15=(Idade>=15)
	gen idade14=(Idade>=14)
	
  * Imputando 0 nos missings (considerando pessoas ocupadas, 0 observações perdidas):  
	replace Experiencia=0 if Experiencia ==. 
	
  * Potências de Experiência:
	gen Experiencia2 = Experiencia^2
	gen Experiencia3 = Experiencia^3
	gen Experiencia4 = Experiencia^4
	
	label var Experiencia2 "Experiência ao quadrado"
	label var Experiencia3 "Experiência ao cubo"
	label var Experiencia4 "Experiência elevada à 4 potência"
	
   
* 2. Variável de experiência distinguindo mestres e doutores 
   gen Experiencia_pos =.
   label var Experiencia_pos "Experiência com pós-graduação"
   order Experiencia_pos, after(VD3006_pos)
   if VD3006_pos<6 replace Experiencia_pos = Experiencia
   if VD3006_pos==6 replace Experiencia_pos = Idade - 16 - 6
   if VD3006_pos==7 replace Experiencia_pos = Idade - 18 - 6
   if VD3006_pos==8 replace Experiencia_pos = Idade - 22 - 6
   
   * Corrigindo valores negativos (considerando pessoas ocupadas, mudança média de 2 mil observações por trimestre representando em média 130 mil pessoas):
   replace Experiencia_pos = 0 if Experiencia_pos < 0 
   * Observação: estimar dropando pessoas que tem 15 anos - teste de robustez
	
   * Imputando 0 nos missings (considerando pessoas ocupadas, 0 observações perdidas):  
   replace Experiencia_pos=0 if Experiencia ==. 

   * Potências de Experiência distinguindo mestres e doutores :
   gen Experiencia_pos2 = Experiencia_pos^2
   gen Experiencia_pos3 = Experiencia_pos^3
   gen Experiencia_pos4 = Experiencia_pos^4
	
   label var Experiencia_pos2 "Experiência ao quadrado"
   label var Experiencia_pos3 "Experiência ao cubo"
   label var Experiencia_pos4 "Experiência elevada à 4 potência"   
   
   save "$dirdata/B_PNADC2012_2021_limpa.dta", replace
     
	 
	 
* ANÁLISE: 16 ou + anos de estudo. Quem são? **********************************
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
  tab data Part16 [iw = Peso]
	
}


*******************************************************************************
* C. SELECIONANDO AMOSTRA: POPULACAO OCUPADA 
*******************************************************************************
{
  use "$dirdata/B_PNADC2012_2021_limpa.dta", clear

* Obs: estamos interessados nos movimentos da PO. 
  
* 1. ANALISANDO INDIVÍDUOS DA PO COM MISSING VALUES EM VARIÁVEIS FUNDAMENTAIS:
  preserve
  keep if VD4002==1
	  
  mdesc VD4019 VD4020 VD4031 VD4035 
  
  * Entendendo qual o perfil dos que serão dropados
    gen cont=1
    tab data cont [iw=Peso] if (VD4019==. & VD4020==.)
    tab data Sexo [iw=Peso] if (VD4019==. & VD4020==.)
    tab data Cor [iw=Peso] if (VD4019==. & VD4020==.)
    tab data Regiao [iw=Peso] if (VD4019==. & VD4020==.)
    tab data VD3006 [iw=Peso] if (VD4019==. & VD4020==.)
   
  * Obs1: 355.856 trabalhadores auxiliares sem rendimentos e 34.940 conta própria sem rendimento, representando conjuntamente, em média, mais de 2,2 milhões da PO por trimestre
  * Obs2: Observações faltantes são as mesmas para os dois tipos de rendimento.
   
    drop if VD4019==. & VD4020==. 
    mdesc VD4019 VD4020 VD4031 VD4035
  
  * Conclusão: iremos dropar indivíduos com missing nos rendimentos 
  restore	 
  
  
* 2. CARACTERÍSTICAS DA PO SEM MISSING VALUES NOS RENDIMENTOS:
  keep if VD4002==1
  drop if VD4019==. & VD4020==. 
  
  * Ao longo do tempo:
    tabout data VD4002 [iw = Peso] using "$dirpath/C_amostra_PO_BR.xls", cells(freq row) replace
      
  * Participação por cor e gênero:
    tabout data Sexo [iw = Peso] using "$dirpath/C_amostra_PO_BR.xls", cells(freq row) append
    tabout data Cor  [iw = Peso] using "$dirpath/C_amostra_PO_BR.xls", cells(freq row) append
   
  * Participação por região:
    tabout data Regiao  [iw = Peso] using "$dirpath/C_amostra_PO_BR.xls",  cells(freq row) append
  
  * Participação por grupo de escolaridade:
    tabout data VD3006  [iw = Peso] using "$dirpath/C_amostra_PO_BR.xls",  cells(freq row) append
  
  
/*  
  * Ao longo do tempo:
    tabout data VD4002 [iw = Peso] using "$dirpath/descritiva/C_amostra_PO_BR.xls", cells(freq row) replace
      
  * Participação por cor e gênero:
    tabout data Sexo [iw = Peso] using "$dirpath/descritiva/C_amostra_PO_BR.xls", cells(freq row) append
    tabout data Cor  [iw = Peso] using "$dirpath/descritiva/C_amostra_PO_BR.xls", cells(freq row) append
   
  * Participação por região:
    tabout data Regiao  [iw = Peso] using "$dirpath/descritiva/C_amostra_PO_BR.xls",  cells(freq row) append
  
  * Participação por grupo de escolaridade:
    tabout data VD3006  [iw = Peso] using "$dirpath/descritiva/C_amostra_PO_BR.xls",  cells(freq row) append
*/ 
 

* 3. CONSTRUINDO RENDIMENTOS REAIS E SALÁRIOS-HORA
  * Rendimento Habitual real de todos o trabalhos	
    gen VD4019_real = VD4019*Habitual
	label var VD4019_real "Rendimento real habitual de todos os trabalhos"
	order VD4019_real, after(VD4019)
    
	sum VD4019_real [iw=Peso] if (Trimestre==1 & Ano==2021 & VD4002==1) /// Checando
 
 
  * Rendimento Efetivo real de todos o trabalhos
    gen VD4020_real = VD4020*Efetivo
    label var VD4020_real "Rendimento real efetivo de todos os trabalhos"
	order VD4020_real, after(VD4020)
 
 
  * Salário-hora Habitual real de todos o trabalhos
    gen sh_hab = VD4019_real/(VD4031*4)
	label var sh_hab "Rendimento real por hora habitual de todos os trabalhos"
    order VD4031 sh_hab, after(VD4019_real)
  
  
  * Salário-hora Efetivo real de todos o trabalhos
    gen sh_efet = VD4020_real/(VD4035*4)
	label var sh_efet "Rendimento real por hora efetivo de todos os trabalhos"
	order VD4035 sh_efet, after(VD4020_real)
	
    ** Atenção presença de horas efetivas iguais a zero (2 milhões em média por trimestre e explode no segundo trimestre de 2021 - 13 milhões)
       preserve 
	   gen Horas_nulas = 1 if VD4035==0
	   gen W_nulo = 1 if VD4020==0
	   tab data Horas_nulas [iw = Peso]
	   restore
	   
	* Obs: quatro estratégias possíveis:
     * A. BASELINE: Observações com horas efetivas nulas irão gerar missing values. Vamos ignorar esses indivíduos nas estimações do salário efetivo, mas não do salário habitual (amostras finais diferentes para os dois tipos de rendimento)
       rename sh_hab sh_hab_A
	   rename sh_efet sh_efet_A
	   
     * B. Indivíduos com horas efetivas nulas serão removidos das estimações (terão missing values) de salário efetivo e de salário habitual
       gen sh_hab_B = VD4019_real/(VD4031*4) if (VD4035!=0 & VD4035!=.) 
	   gen sh_efet_B = VD4020_real/(VD4035*4) if (VD4035!=0 & VD4035!=.) 
	   
	   label var sh_hab_B "Rendimento real por hora habitual - sem missing"
	   label var sh_efet_B "Rendimento real por hora efetivo - sem missing"
  
     * C. Imputação: usaremos as horas habituais para os indivíduos com horas efetivas nulas para o cálculo do salário-hora
       gen VD4035_imput = VD4035
	   replace VD4035_imput = VD4031 if VD4035==0
	   label var VD4035_imput "Horas efetivas com imputação para horas nulas"
	   order VD4035_imput, after(VD4035)
    
	   gen sh_hab_C = VD4019_real/(VD4031*4) 
	   gen sh_efet_C = VD4020_real/(VD4035_imput*4)   
	   
	   label var sh_hab_C "Rendimento real por hora habitual - imput"
	   label var sh_efet_C "Rendimento real por hora efetivo - imput"
	   
    * D. Usaremos horas efetivas = 1 para quem teve horas efetivas = 0
 	  gen VD4035_1 = VD4035
	  replace VD4035_1 = 1 if VD4035==0
	  label var VD4035_1 "Horas efetivas com valor 1 para horas nulas"
	  order VD4035_1, after(VD4035_imput)
	  
	  gen sh_hab_D = VD4019_real/(VD4031*4) 
 	  gen sh_efet_D = VD4020_real/(4*VD4035_1)
	 	  
	  label var sh_hab_D "Rendimento real por hora habitual - dividindo por 1"
	  label var sh_efet_D "Rendimento real por hora efetivo - dividindo por 1"

	  order sh_hab_B sh_hab_C sh_hab_D , after(sh_hab_A)
	  order sh_efet_B sh_efet_C sh_efet_D, after(sh_efet_A)
	
	 
* 4. CONSTRUINDO LOGARITMOS DOS SALÁRIOS-HORA REAIS 
 * Habitual:
   gen logW_hab_A = ln(sh_hab_A)
   gen logW_hab_B = ln(sh_hab_B)   
   gen logW_hab_C = ln(sh_hab_C)
   gen logW_hab_D = ln(sh_hab_D)
   
   label var logW_hab_A "Log do rendimento real habitual por hora"
   label var logW_hab_B "Log do rendimento real habitual por hora - sem missing"
   label var logW_hab_C "Log do rendimento real habitual por hora - imput"
   label var logW_hab_D "Log do rendimento real habitual por hora - dividindo por 1"
	 
	
 * Efetivo:
 ** ATENÇÃO: existem observações com rendimento efetivo = 0. logW_efet = . para essas observações. 
  * A variável logW_efet0 atribui valor 0 ao log do salário dessas observações.
  * A. BASELINE: Observações com horas efetivas nulas irão gerar missing values. Vamos ignorar esses indivíduos nas estimações do salário efetivo, mas não do salário habitual (amostras finais diferentes para os dois tipos de rendimento)
    gen logW_efet_A = ln(sh_efet_A)
    gen logW_efet0_A = ln(sh_efet_A)
    replace logW_efet0_A = 0 if (sh_efet_A==0)
   
    label var logW_efet_A "Log do rendimento real efetivo por hora"
    label var logW_efet0_A "Log do rendimento real efetivo por hora - sem 0"     
    
	
  * B. Indivíduos com horas efetivas nulas serão removidos das estimações (terão missing values) de salário efetivo e de salário habitual	 
    gen logW_efet_B = ln(sh_efet_B)
    gen logW_efet0_B = ln(sh_efet_B) 
    replace logW_efet0_B=0 if (sh_efet_B==0)
   
    label var logW_efet_B "Log do rendimento real efetivo por hora - sem missing"
    label var logW_efet0_B "Log do rendimento real efetivo por hora - sem missing e sem 0"  
  
  
  * C. Imputação: usaremos as horas habituais para os indivíduos com horas efetivas nulas para o cálculo do salário-hora
     gen logW_efet_C = ln(sh_efet_C)
	 gen logW_efet0_C = ln(sh_efet_C) 
     replace logW_efet0_C=0 if (sh_efet_C==0)
  
     label var logW_efet_C "Log do rendimento real efetivo por hora - imput"
     label var logW_efet0_C "Log do rendimento real efetivo por hora - imput e sem 0"
  
  
   * D. Usaremos horas efetivas = 1 para quem teve horas efetivas = 0
     gen logW_efet_D = ln(sh_efet_D)
	 gen logW_efet0_D = ln(sh_efet_D) 
     replace logW_efet0_D=0 if (sh_efet_D==0)
    
	 label var logW_efet_D "Log do rendimento real efetivo por hora - dividindo por 1"
     label var logW_efet0_D "Log do rendimento real efetivo por hora - dividindo por 1 e sem 0"
  
 /* RESUMO: Missing values 
 
  mdesc logW_efet_A logW_efet0_A logW_hab_A logW_efet_B logW_efet0_B logW_hab_B logW_efet_C logW_efet0_C logW_hab_C logW_efet_D logW_efet0_D logW_hab_D
  
      Variable    |     Missing          Total     Percent Missing
  ----------------+-----------------------------------------------
      logW_efet_A |     419,523      8,249,275           5.09           (horas nulas e W nulo) 
     logW_efet0_A |     218,245      8,249,275           2.65           (horas nulas)
       logW_hab_A |           0      8,249,275           0.00 
      logW_efet_B |     419,523      8,249,275           5.09           (horas nulas e W nulo)  
     logW_efet0_B |     218,245      8,249,275           2.65           (horas nulas)
       logW_hab_B |     218,245      8,249,275           2.65           (horas nulas)
      logW_efet_C |     224,701      8,249,275           2.72           (W nulo)
     logW_efet0_C |           0      8,249,275           0.00
       logW_hab_C |           0      8,249,275           0.00
      logW_efet_D |     224,701      8,249,275           2.72           (W nulo)
     logW_efet0_D |           0      8,249,275           0.00
       logW_hab_D |           0      8,249,275           0.00
  ----------------+-----------------------------------------------

  */
}
		
*******************************************************************************		
* AMOSTRA FINAL 
******************************************************************************* 
describe
tab data VD4002
	  
save "$dirdata/C_PNADC_POamostra.dta", replace
log close