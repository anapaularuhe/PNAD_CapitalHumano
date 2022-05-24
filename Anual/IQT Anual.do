*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Estimação IQT Anual
*******************************************************************************


* PREPARAÇÃO ******************************************************************
* Pacotes:
 *ssc install labutil
 *ssc install mdesc
 
* Preparando memória: 
  clear all
  cls								
  set maxvar 30000
	
* Diretório: :   
  global dirpath = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT Anual"
  global dirdata = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT Anual\Dados"
  global dirtrim = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT"
  global diroriginal = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT\Dados\PNAD Original"
   
* Salvando log:   
  log using "IQT_Anual.log", replace
  
*******************************************************************************
* A. ORGANIZAÇÃO DA BASE
*******************************************************************************
{
* A.1. IMPORTANDO DADOS: PNAD *************************************************
 {
 * Lista das variáveis mantidas: 
  {
/*
   uf           UF
   v0101        Ano de referência  
   v0302        Sexo 
   v8005        Idade
   v0404        Cor ou raça 
   v9008        Posição na ocupação no trabalho principal (agropecuária) 
   v9029        Posição na ocupação no trabalho principal 
   v9058        Número de horas no trabalho principal 
   v9101        Número de horas no trabalho secundário 
   v9105        Número de horas em outros trabalhos 
   v9115        Tomou providência para conseguir trabalho nos últimos 7 dias 
   v4703        Anos de estudo (categórica) 
   v4706        Posição na ocupação no trabalho principal    
   v4719        Rendimento mensal de todos os trabalhos (nominal)
   v4729        Peso da pessoa
   cond_ocup_s  Condição de ocupação na semana
   trab_afast   Esteve afastado do trabalho na semana de referência
*/
  }
 
 use "T:\data\pnad\pnad1995pes_comp92.dta", clear
 save "$dirdata\A_PNAD.dta", replace
 keep uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast 
 
 append using "T:\data\pnad\pnad1996pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad1997pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad1998pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad1999pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 
*append using "T:\data\pnad\pnad2000pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2001pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2002pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2003pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2004pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2005pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2006pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2007pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2008pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2009pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 
*append using "T:\data\pnad\pnad2010pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 append using "T:\data\pnad\pnad2011pes_comp92.dta", keep(uf v0101 v0302 v8005 v0404 v9008 v9029 v9058 v9101 v9105 v9115 v4703 v4706 v4719 v4729 cond_ocup_s trab_afast)
 
 save "$dirdata\A_PNAD.dta", replace
 }

* A.2. ORGANIZANDO VARIÁVEIS E LABELS: PNAD ***********************************
 {
  use "$dirdata\A_PNAD.dta", clear
 
 * Renomeando variáveis básicas
  rename v4729 Peso
  rename v0302 Sexo
  rename v8005 Idade
  rename v0404 Cor
  rename v0101 Ano
  rename uf UF
  rename v4719 rendimento
 
 
 * Gênero
  drop if Sexo ==.  
 
  recode Sexo (2=1) (4=2) 
  label define Sexo_label 1 "Homem" 2 "Mulher" 
  label values Sexo Sexo_label
  
  gen byte mulher = (Sexo==2)
  label var mulher "Mulher"
  order mulher, after(Sexo)
 
 
 * Cor
  recode Cor (2=1) (4=2) (6=3) (8=4) (0=5)
  label define cor_label 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indigena" 9 "Ignorado"  
  label values Cor cor_label 
 
  drop if Cor == .
  gen PretoPardoIndig = 0
  replace PretoPardoIndig = 1 if (Cor==2 | Cor==4 | Cor== 5)
  label var PretoPardoIndig "Preto, Parto ou Indigena"
 
 
 * Setor público
  label define v4706_label 1 "Empregado com carteira" 2 "Militar" 3 "Funcionário público estatutário" 4 "Outros Empregados sem carteira" 6 "Doméstico com carteira" 7 "Doméstico sem carteira" 9 "Conta própria" 10 "Empregador" 11 "Próprio consumo" 12 "Construção para o próprio uso" 13 "Não-remunerado"
  label values v4706 v4706_label
 
  gen byte publico = (v4706>=2 & v4706<=3) if v4706!=.
  label var publico "Setor publico" 
 
 
 * Formalidade
  gen byte informal = .
  label var informal "Informal"
  label define informal_label 0 "Formal" 1 "Informal"
  label values informal informal_label
  replace informal = 0 if (v4706==1 | v4706==2 | v4706==3 | v4706==6 | v4706==10)
  replace informal = 1 if (v4706==4 | v4706==7 | v4706==9 | v4706==11 | v4706==12 | v4706==13) 
 
 
 * Educação
 ** Anos de estudo
 gen VD3005 = v4703 - 1
 replace VD3005 = VD3005 + 1 if VD3005>=1
 label var VD3005 "Anos de estudo"
 drop if VD3005 == .
 
 ** Grupo de anos de estudo (eliminamos observações com missing values)  
  gen VD3006 = .
  label var VD3006 "Grupo de anos de estudo"
  label define VD3006_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "1 a 4 anos de estudo" 3 "5 a 8 anos de estudo" 4 "9 a 11 anos de estudo" 5 "12 a 15 anos de estudo" 6 "16 anos ou mais de estudo"
  label values VD3006 VD3006_label
  
  replace VD3006 = 1 if (VD3005<1)
  replace VD3006 = 2 if (VD3005>=1 & VD3005<=4)
  replace VD3006 = 3 if (VD3005>=5 & VD3005<=8)
  replace VD3006 = 4 if (VD3005>=9 & VD3005<=11)
  replace VD3006 = 5 if (VD3005>=12 & VD3005<=15)
  replace VD3006 = 6 if (VD3005>=16)
  
  gen byte educ1 = (VD3006==1)
  gen byte educ2 = (VD3006==2)
  gen byte educ3 = (VD3006==3)
  gen byte educ4 = (VD3006==4)
  gen byte educ5 = (VD3006==5)
  gen byte educ6 = (VD3006==6)
  
  label var educ1 "Estudo inferior a 1 ano"
  label var educ2 "Estudo 1 a 4 anos"
  label var educ3 "Estudo 5 a 8 anos"
  label var educ4 "Estudo 9 a 11 anos"
  label var educ5 "Estudo 12 a 15 anos"
  label var educ6 "Estudo 16+ anos"
 
 
 * Experiência
  drop if Idade == .
  gen Experiencia =.
  label var Experiencia "Experiencia"
  order Experiencia, after(VD3006)
  replace Experiencia = Idade - VD3005 - 6 if VD3005>=9
  replace Experiencia = Idade - 15 if VD3005<9
	
 ** Corrigindo valores negativos:
  replace Experiencia= 0 if Experiencia<0 

 ** Imputando 0 nos missings:
  replace Experiencia=0 if Experiencia ==. 
	
 ** Potências de Experiência:
  gen Experiencia2 = Experiencia^2
  gen Experiencia3 = Experiencia^3
  gen Experiencia4 = Experiencia^4
	
  label var Experiencia2 "Experiencia^2"
  label var Experiencia3 "Experiencia^3"
  label var Experiencia4 "Experiencia^4"
	
  order Experiencia2 Experiencia3 Experiencia4, after(Experiencia)
   
 ** Interações com dummy de gênero:
  gen ExperMulher = Experiencia*mulher
  gen ExperMulher2 = Experiencia2*mulher
  gen ExperMulher3 = Experiencia3*mulher
  gen ExperMulher4 = Experiencia4*mulher
  
  label var ExperMulher "Exper x Mulher"
  label var ExperMulher2 "Exper^2 x Mulher"
  label var ExperMulher3 "Exper^3 x Mulher"
  label var ExperMulher4 "Exper^4 x Mulher"
 
 
 * Horas de todos os trabalhos:
  gen horas = v9058 + v9101 + v9105
  label var horas "Horas semanais em todos os trabalhos"
  replace horas = v9058 + v9101 if v9105==. 
  replace horas = v9058 if v9101==. 
 
 
 * PO
 ** Tomou providências para trabalhar nos últimos 7 dias
  recode v9115 (1=1) (3=0) 
  label define v9115_label 1 "Sim" 0 "Não"
  label values v9115 v9115_label
 
 ** PO conforme definição da PNADC
  * 1 = ocupado
  * 0 = desocupado
  * . = fora da pea
  
  gen byte PO = .
  label var PO "Condição de ocupação"
  label define PO_label 0 "Desocupado" 1 "Ocupado"
  label values PO PO_label
 
  replace PO = 0 if [cond_ocup_s==0]
  replace PO = 1 if [cond_ocup_s==1]
 
 ** Consumo próprio não entra na PO: será desocupado ou inativo, dependendo de ter procurado emprego ou não
  replace PO = 0 if [v9008==13 | v9029==7] & v9115==1 
  replace PO = . if [v9008==13 | v9029==7] & v9115!=1 
 
 ** Trabalhadores afastados 
  recode trab_afast (2=1) (4=0)
  replace PO = 0 if trab_afast==1 & v9115==1
  replace PO = . if trab_afast==1 & v9115!=1 
 
 ** Trabalho inferior a 1 hora por semana
  replace PO = 0 if [v9058<1 & v9115==1] 
  replace PO = . if [v9058<1 & v9115!=1] 
  
 ** Idade mínima: 14 anos 
  replace PO = . if Idade<14
  
  drop v4703 v4706 v9008 v9029 v9058 v9101 v9105 v9115 cond_ocup_s trab_afast
  
 
 * Restrição da amostra: PO conforme definição da PNADC - apenas observações sem missing em horas e rendimentos
  keep if PO ==1
  drop if rendimento==. | horas==. 
  
  compress
  save "$dirdata\A_PNAD.dta", replace
 }
 
* A.3. IMPORTANDO DADOS: PNAD Contínua ****************************************
 {
 clear all
 * Lista das variáveis mantidas:
  {
 /*
	Ano        | Ano
	Trimestre  | Trimestre
	UF         | UF
	V1028      | Peso trimestral com correção de não entrevista COM PÓS ESTRATIFICAÇÃO pela projeção de população  
	
	V2007      | Sexo
	V2009      | Idade
	V2010      | Cor ou raça
		
	VD3005     | Anos de estudo                           (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	             * Obs: variável parcialmente categória; 16 = 16 anos ou mais 
	VD3006     | Grupos de anos de estudo                 (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente)
	
	VD4002     | Condição de ocupação
	VD4009     | Posição na ocupação 
	VD4019     | Rendimento habitual mensal (todos os trabalhos)
	VD4031     | Horas habitualmente trabalhadas por semana (todos os trabalhos)		
 */
  }

 use "$diroriginal/PNADC_032012.dta", clear
 keep Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031
 save "$dirdata/A_PNADC.dta", replace
  
 append using "$diroriginal/PNADC_032013.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032014.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032015.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032016.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032017.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032018.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032019.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032020.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)
 append using "$diroriginal/PNADC_032021.dta", keep(Ano UF V1028 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4031)

 compress 
 save "$dirdata/A_PNADC.dta", replace
 }	

* A.4. ORGANIZANDO VARIÁVEIS E LABELS: PNAD Contínua **************************
 {
 use "$dirdata\A_PNADC.dta", clear
 
 * Renomeando variáveis básicas
  rename V1028 Peso
  rename V2007 Sexo
  rename V2009 Idade
  rename V2010 Cor 
  rename VD4019 rendimento
  rename VD4031 horas
  rename VD4002 PO 
  
 
 * Gênero
  drop if Sexo ==.  
  label define Sexo_label 1 "Homem" 2 "Mulher" 
  label values Sexo Sexo_label
  
  gen byte mulher = (Sexo==2)
  label var mulher "Mulher"
  order mulher, after(Sexo)
 
 
 * Cor
  label define cor_label 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indigena" 9 "Ignorado"  
  label values Cor cor_label 
 
  drop if Cor == .
  gen PretoPardoIndig = 0
  replace PretoPardoIndig = 1 if (Cor==2 | Cor==4 | Cor== 5)
  label var PretoPardoIndig "Preto, Parto ou Indigena"
 
 
 * Setor público
  label define VD4009_label 1 "privado COM carteira" 2 "privado SEM carteira" 3 "doméstico COM carteira" 4 "doméstico SEM carteira" 5 "público COM carteira" 6 "público SEM carteira" 7 "Militar e estatutário" 8 "Empregador" 9 "Conta-própria" 10 "familiar auxiliar"
  label values VD4009 VD4009_label
  
  gen byte publico = (VD4009>=05 & VD4009<=07) if VD4009!=.
  label var publico "Setor publico"
  label define publico_label 0 "Setor privado" 1 "Setor publico"
  label values publico publico_label
  
  
 * Formaliade
  gen byte informal = .
  label var informal "Informal"
  label define informal_label 0 "Formal" 1 "Informal"
  label values informal informal_label  
  replace informal = 0 if (VD4009==01 | VD4009==03 | VD4009==05 | VD4009==07 | VD4009==08)
  replace informal = 1 if (VD4009==02 | VD4009==04 | VD4009==06 | VD4009==09 | VD4009==10)
  
  drop VD4009
  
  
 * VD3006: Grupos de anos de estudo (eliminamos observações com missing values)  
  label var VD3006 "Grupo de anos de estudo"
  label define VD3006_label 1 "Sem instrução e menos de 1 ano de estudo" 2 "1 a 4 anos de estudo" 3 "5 a 8 anos de estudo" 4 "9 a 11 anos de estudo" 5 "12 a 15 anos de estudo" 6 "16 anos ou mais de estudo"
  label values VD3006 VD3006_label
  
  drop if VD3006 ==.
  gen byte educ1 = (VD3006==1)
  gen byte educ2 = (VD3006==2)
  gen byte educ3 = (VD3006==3)
  gen byte educ4 = (VD3006==4)
  gen byte educ5 = (VD3006==5)
  gen byte educ6 = (VD3006==6)
  
  label var educ1 "Estudo inferior a 1 ano"
  label var educ2 "Estudo 1 a 4 anos"
  label var educ3 "Estudo 5 a 8 anos"
  label var educ4 "Estudo 9 a 11 anos"
  label var educ5 "Estudo 12 a 15 anos"
  label var educ6 "Estudo 16+ anos"
  
  
 * Experiência
  drop if Idade == .
  gen Experiencia =.
  label var Experiencia "Experiencia"
  order Experiencia, after(VD3006)
  replace Experiencia = Idade - VD3005 - 6 if VD3005>=9
  replace Experiencia = Idade - 15 if VD3005<9
	
 ** Corrigindo valores negativos (considerando pessoas ocupadas, mudança média de 2 mil observações por trimestre representando em média 130 mil pessoas):
  replace Experiencia= 0 if Experiencia<0 

 ** Imputando 0 nos missings (considerando pessoas ocupadas, 0 observações perdidas):  
  replace Experiencia=0 if Experiencia ==. 
	
 ** Potências de Experiência:
  gen Experiencia2 = Experiencia^2
  gen Experiencia3 = Experiencia^3
  gen Experiencia4 = Experiencia^4
	
  label var Experiencia2 "Experiencia^2"
  label var Experiencia3 "Experiencia^3"
  label var Experiencia4 "Experiencia^4"
	
  order Experiencia2 Experiencia3 Experiencia4, after(Experiencia)
   
 ** Interações com dummy de gênero:
  gen ExperMulher = Experiencia*mulher
  gen ExperMulher2 = Experiencia2*mulher
  gen ExperMulher3 = Experiencia3*mulher
  gen ExperMulher4 = Experiencia4*mulher
  
  label var ExperMulher "Exper x Mulher"
  label var ExperMulher2 "Exper^2 x Mulher"
  label var ExperMulher3 "Exper^3 x Mulher"
  label var ExperMulher4 "Exper^4 x Mulher"
 
 
 * Restrição da amostra: PO conforme definição da PNADC - apenas observações sem missing em horas e rendimentos
  keep if PO ==1
  drop if rendimento==. | horas==.  
 
 
  compress
  save "$dirdata/A_PNADC.dta", replace
  
 }
  
* A.5. APPEND + DEFLATORES ****************************************************
 {
 * Juntando as duas pesquisas:
 use "$dirdata\A_PNAD.dta", clear
 append using "$dirdata\A_PNADC.dta"
 
 save "$dirdata\A_BaseAnual.dta", replace
 
 * Deflatores:
 clear all
 import excel "$dirdata\Deflator.xlsx", firstrow clear
 
   * Eliminamos anos faltantes da PNAD:
   drop if Ano == 2000 | Ano == 2010
   drop fatordedeflacao
   
   save "$dirdata\A_Deflatores.dta", replace
 
 * Adicionando os deflatores aos microdados:
 use "$dirdata\A_BaseAnual.dta", clear
  
 merge m:1 Ano using "$dirdata\A_Deflatores.dta"
 drop _merge 
 
 compress
 save "$dirdata\A_BaseAnual.dta", replace 
 }

* A.6. RENDIMENTO *************************************************************
 {
 use "$dirdata\A_BaseAnual.dta", clear

 * Rendimento real a preços do 3º trimestre do ano mais recente disponível:
 gen rendimento_real = rendimento*Deflator
 label var rendimento_real "Rendimento real habitual de todos os trabalhos a preços mais recentes"
 order rendimento_real, after(rendimento)
 
 * Salário-hora
  gen W_hora = rendimento_real/(horas*4)
  label var W_hora "Rendimento real por hora habitual de todos os trabalhos a preços mais recentes"
  
  gen W_hora_nominal = rendimento/(horas*4)
  label var W_hora_nominal "Rendimento nominal por hora habitual de todos os trabalhos a preços mais recentes"
  order W_hora W_hora_nominal, after(rendimento_real)
  
 * Log: 
  gen logW_hab = ln(W_hora)
  label var logW_hab "Log do rendimento real habitual por hora"
  
  gen logW_hab_nominal = ln(W_hora_nominal)
  label var logW_hab_nominal "Log do rendimento nominal habitual por hora"

 compress
 save "$dirdata\A_BaseAnual.dta", replace 
 }
 
* A.7. ANOS FALTANTES NA PNAD *************************************************
 {
 * Não temos dados para 2000 e 2010.
 * Estratégia: repetir os dados do ano anterior. 
  use "$dirdata\A_BaseAnual.dta", clear
 
  keep if Ano==1999
  replace Ano = 2000
  save "$dirdata\A_temporario.dta", replace
  
  use "$dirdata\A_BaseAnual.dta", clear
  append using "$dirdata\A_temporario.dta"
  save "$dirdata\A_BaseAnual.dta", replace
  
  keep if Ano==2009
  replace Ano = 2010
  save "$dirdata\A_temporario.dta", replace
  
  use "$dirdata\A_BaseAnual.dta", clear
  append using "$dirdata\A_temporario.dta"
  sort Ano
  save "$dirdata\A_BaseAnual.dta", replace
  
 
  * Índice de período: criando variável T (compatibilidade com código da PNADC)
  gen T = Ano - 1994
  label var T "Período"
  order T, after(Ano)
  
 ** Label:
  tostring Ano, generate(Ano_string) 
  labmask T, values(Ano_string)
  drop Ano_string 
 
  egen Tmax = max(T)
 
 
 save "$dirdata\A_BaseAnual.dta", replace 
 } 
} 


*******************************************************************************
* B. IQT QUANTIDADE
*******************************************************************************
{
* B.1. REGRESSÕES *************************************************************
 {
 use "$dirdata\A_BaseAnual.dta", clear
 
 forvalues t = 1/`=Tmax' {     
 * Sem controles: 
  * Rendimento real:
    regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
    estimates save "$dirdata/B_Regressoes_semcontroles", append
    predict RegLog_Hi_`t' if(T>=(`t'-1) & T<=(`t'+1))
   
  * Rendimento nominal: 
    regress logW_hab_nominal mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
    estimates save "$dirdata/B_Regressoes_semcontroles_nominal", append
    predict RegLog_Hi_nominal_`t' if(T>=(`t'-1) & T<=(`t'+1))
	
  
 ** Com controles: 
  * Rendimento real:
    regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
    estimates save "$dirdata/B_Regressoes_comcontroles", append
    gen RegLog_Hiv_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1)) 
	
  * Rendimento real:
   regress logW_hab_nominal mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
   estimates save "$dirdata/B_Regressoes_comcontroles_nominal", append
   gen RegLog_Hiv_nominal_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1)) 	
  estimates drop _all
  }

  save "$dirdata/B_BaseEstimacao.dta", replace  
 } 
 
* B.2. SALÁRIO PREDITO ********************************************************
 {
  use "$dirdata/B_BaseEstimacao.dta", clear
  
 * Exponencial + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
   	 gen RegW_Hi_`t' = exp(RegLog_Hi_`t')	  
	 gen RegW_Hiv_`t' = exp(RegLog_Hiv_`t')	
	 
	 gen RegW_Hi_nominal_`t' = exp(RegLog_Hi_nominal_`t')	  
	 gen RegW_Hiv_nominal_`t' = exp(RegLog_Hiv_nominal_`t')	
	 
	 drop RegLog_Hi_`t' RegLog_Hiv_`t' RegLog_Hi_nominal_`t' RegLog_Hiv_nominal_`t' 
   }
 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - W_T     = salários em t preditos pelos coeficientes estimados de t
	- W_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- W_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
 * Sem controles:  
   gen WHi_T = .
   gen WHi_Tante = .
   gen WHi_Tprox = .
   
   gen WHi_T_nominal = .
   gen WHi_Tante_nominal = .
   gen WHi_Tprox_nominal = .
   
   
 * Com controles:
   gen WHiv_T = .
   gen WHiv_Tante = .
   gen WHiv_Tprox = .
   
   gen WHiv_T_nominal = .
   gen WHiv_Tante_nominal = .
   gen WHiv_Tprox_nominal = .
   
   forvalues t = 1/`=Tmax' {
	  replace WHi_T = RegW_Hi_`t' if T==`t'
	  replace WHiv_T = RegW_Hiv_`t' if T==`t'
	  
	  replace WHi_T_nominal = RegW_Hi_nominal_`t' if T==`t'
	  replace WHiv_T_nominal = RegW_Hiv_nominal_`t' if T==`t'
	  
	  
	  local i = `t'-1
	  if `t' > 1 replace WHi_Tante = RegW_Hi_`i' if T==`t'
	  if `t' > 1 replace WHiv_Tante = RegW_Hiv_`i' if T==`t'
	  
	  if `t' > 1 replace WHi_Tante_nominal = RegW_Hi_nominal_`i' if T==`t'
	  if `t' > 1 replace WHiv_Tante_nominal = RegW_Hiv_nominal_`i' if T==`t'
	 
	 
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WHi_Tprox = RegW_Hi_`j' if T==`t'
	  if `t' < `=Tmax' replace WHiv_Tprox = RegW_Hiv_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace WHi_Tprox_nominal = RegW_Hi_nominal_`j' if T==`t'
	  if `t' < `=Tmax' replace WHiv_Tprox_nominal = RegW_Hiv_nominal_`j' if T==`t'	  
   }
 
 * Excluindo os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_Hi_`t' RegW_Hiv_`t' RegW_Hi_nominal_`t' RegW_Hiv_nominal_`t' 
   }  
 
   compress
   save "$dirdata/B_BaseEstimacao.dta", replace  
 } 
 
* B.3. PESOS ******************************************************************
 {
 use "$dirdata/B_BaseEstimacao.dta", clear
 
 bysort T VD3006 Experiencia: egen HH = mean(horas)
 order HH, after(horas)
 label var HH "Horas habituais médias por grupo de educação e experiência para cada trimestre"

 * Peso ajustado por hora:
 gen PHi = Peso*HH
 bysort T: egen PHt = sum(PHi)
 gen PH = PHi/PHt
 label var PH "Peso para cálculo do IQT de rendimento habitual"
   
 order PH, after(Peso) 
 drop PHi PHt

 compress
 save "$dirdata/B_BaseEstimacao.dta", replace 
 }
 
* B.4. IQT ********************************************************************
 {
 use "$dirdata/B_BaseEstimacao.dta", clear
 
 * IQT0
  gen dIQT0_Hi = .        
  gen dIQT0_Hiv = .    
 
  forvalues t = 2/`=Tmax'{
  * Sem controles: 
	gen nHi = PH*WHi_Tante if T==`t'
	gen dHi = PH*WHi_T if T==(`t'-1)
	  
	egen sum_nHi = sum(nHi)
	egen sum_dHi = sum(dHi)
	
	replace dIQT0_Hi = sum_nHi/sum_dHi if T==`t'
	drop nHi dHi sum_nHi sum_dHi
	
  * Com controles:
	gen nHiv = PH*WHiv_Tante if T==`t'
	gen dHiv = PH*WHiv_T if T==(`t'-1)
	  
	egen sum_nHiv = sum(nHiv)
	egen sum_dHiv = sum(dHiv)
	  
	replace dIQT0_Hiv = sum_nHiv/sum_dHiv if T==`t'
	drop nHiv dHiv sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  gen dIQT1_Hi = .        
  gen dIQT1_Hiv = . 
  
  forvalues t = 2/`=Tmax'{
  * Sem controles: 
	gen nHi = PH*WHi_T if T==`t'
	gen dHi = PH*WHi_Tprox if T==(`t'-1)
	  
	egen sum_nHi = sum(nHi)
	egen sum_dHi = sum(dHi)
	  
	replace dIQT1_Hi = sum_nHi/sum_dHi if T==`t'
	drop nHi dHi sum_nHi sum_dHi

  * Com controles:
	gen nHiv = PH*WHiv_T if T==`t'
	gen dHiv = PH*WHiv_Tprox if T==(`t'-1)
	  
	egen sum_nHiv = sum(nHiv)
	egen sum_dHiv = sum(dHiv)
	  
	replace dIQT1_Hiv = sum_nHiv/sum_dHiv if T==`t'
	drop nHiv dHiv sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
  gen dIQT_Hi = (dIQT0_Hi*dIQT1_Hi)^(1/2)
  gen dIQT_Hiv = (dIQT0_Hiv*dIQT1_Hiv)^(1/2)
   
  compress
  save "$dirdata/B_BaseEstimacao.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQT_Hi dIQT_Hiv
   duplicates drop
  
   * 1992 = 100
   * Sem controles
     gen IQT_Hi = 100 if T==1
     replace IQT_Hi = IQT_Hi[_n-1]*dIQT_Hi if _n > 1
     label var IQT_Hi "IQT Anual - Sem controles"
	 
	 gen IQT_Hiv = 100 if T==1
     replace IQT_Hiv = IQT_Hiv[_n-1]*dIQT_Hiv if _n > 1
     label var IQT_Hiv "IQT Anual - Com controles" 
   
   save "$dirdata/B_IQT.dta", replace
   export excel T IQT_Hi IQT_Hiv using "$dirdata\B_IQT.xlsx", sheet(PNAD) firstrow(varlabels) replace
  restore
  }
 } 
  
}


*******************************************************************************
* C. IQT PRODUTIVIDADE E VALOR
*******************************************************************************
{
* C.1. IQT PRODUTIVIDADE ******************************************************
 {
 use "$dirdata/B_BaseEstimacao.dta", clear
 
 * IQT0:
  gen dIQTP0_Hi = .        
  gen dIQTP0_Hiv = .    

  forvalues t = 2/`=Tmax'{
  * Sem controles: 
    gen nHi = PH*WHi_Tprox if T==(`t'-1)
    gen dHi = PH*WHi_T if T==(`t'-1) 
   
    egen sum_nHi = sum(nHi)
    egen sum_dHi = sum(dHi)
   
    replace dIQTP0_Hi = sum_nHi/sum_dHi if T==`t'
    drop nHi dHi sum_nHi sum_dHi
   
   
  * Com controles: 
    gen nHiv = PH*WHiv_Tprox if T==(`t'-1)
    gen dHiv = PH*WHiv_T if T==(`t'-1)
   
    egen sum_nHiv = sum(nHiv)
    egen sum_dHiv = sum(dHiv)
   
    replace dIQTP0_Hiv = sum_nHiv/sum_dHiv if T==`t'
    drop nHiv dHiv sum_nHiv sum_dHiv
  }
  
  
 * IQT1:
  gen dIQTP1_Hi = .        
  gen dIQTP1_Hiv = .
  
  forvalues t = 2/`=Tmax'{
  * Sem controles: 
	gen nHi = PH*WHi_T if T==`t'
	gen dHi = PH*WHi_Tante if T==`t'
	  
	egen sum_nHi = sum(nHi)
	egen sum_dHi = sum(dHi)
	  
	replace dIQTP1_Hi = sum_nHi/sum_dHi if T==`t'
	drop nHi dHi sum_nHi sum_dHi
	
	
  * Com controles: 
	gen nHiv = PH*WHiv_T if T==`t'
	gen dHiv = PH*WHiv_Tante if T==`t'
	  
	egen sum_nHiv = sum(nHiv)
	egen sum_dHiv = sum(dHiv)
	  
	replace dIQTP1_Hiv = sum_nHiv/sum_dHiv if T==`t'
	drop nHiv dHiv sum_nHiv sum_dHiv  
  }  
   
   
 * dIQT: índice de Fisher    
  gen dIQTP_Hi = (dIQTP0_Hi*dIQTP1_Hi)^(1/2)
  gen dIQTP_Hiv = (dIQTP0_Hiv*dIQTP1_Hiv)^(1/2)
   
  compress
  save "$dirdata/C_BaseIQTProdutividade.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
    keep T Tmax dIQTP_Hi dIQTP_Hiv
    duplicates drop
  
  * 1992 = 100
  * Sem controles:
    gen IQTP_Hi = 100 if T==1
    replace IQTP_Hi = IQTP_Hi[_n-1]*dIQTP_Hi if _n > 1
    label var IQTP_Hi "IQT Anual Produtividade - Sem controles"
	
  * Com controles:	
	gen IQTP_Hiv = 100 if T==1
	replace IQTP_Hiv = IQTP_Hiv[_n-1]*dIQTP_Hiv if _n > 1
    label var IQTP_Hiv "IQT Anual Produtividade - Com controles" 
	 
   merge 1:1 T using "$dirdata/B_IQT.dta"
   drop _merge
   
   save "$dirdata\C_IQTProdutividade.dta", replace
   export excel T IQTP_Hi IQTP_Hiv using "$dirdata\B_IQT.xlsx", sheet ("Produtividade", modify) firstrow(varlabels)
  restore
  }
 }
 
* C.2. IQT VALOR **************************************************************
 {
 use "$dirdata/C_BaseIQTProdutividade.dta", clear
 
 * IQT Valor: dIQT_V = dIQT_P x dIQT_Q
  gen dIQTV_Hi = .        
  gen dIQTV_Hiv = .    
  
  gen dIQTV_Hi_nominal = .        
  gen dIQTV_Hiv_nominal = .    
  

  forvalues t = 2/`=Tmax'{
  * Sem controles: 
   * Rendimento real:
	 gen nHi = PH*WHi_T if T==`t'
	 gen dHi = PH*WHi_T if T==(`t'-1)
	  
	 egen sum_nHi = sum(nHi)
	 egen sum_dHi = sum(dHi)
	  
	 replace dIQTV_Hi = sum_nHi/sum_dHi if T==`t'
	 drop nHi dHi sum_nHi sum_dHi
	
	
   * Rendimento nominal:
	 gen nHi = PH*WHi_T_nominal if T==`t'
	 gen dHi = PH*WHi_T_nominal if T==(`t'-1)
	  
	 egen sum_nHi = sum(nHi)
	 egen sum_dHi = sum(dHi)
	  
	 replace dIQTV_Hi_nominal = sum_nHi/sum_dHi if T==`t'
	 drop nHi dHi sum_nHi sum_dHi
	 
	
  * Com controles:
   * Rendimento real:
	 gen nHiv = PH*WHiv_T if T==`t'
	 gen dHiv = PH*WHiv_T if T==(`t'-1)
	  
	 egen sum_nHiv = sum(nHiv)
	 egen sum_dHiv = sum(dHiv)
	  
	 replace dIQTV_Hiv = sum_nHiv/sum_dHiv if T==`t'
	 drop nHiv dHiv sum_nHiv sum_dHiv
	 
   * Rendimento nominal:
	 gen nHiv = PH*WHiv_T_nominal if T==`t'
	 gen dHiv = PH*WHiv_T_nominal if T==(`t'-1)
	  
	 egen sum_nHiv = sum(nHiv)
	 egen sum_dHiv = sum(dHiv)
	  
	 replace dIQTV_Hiv_nominal = sum_nHiv/sum_dHiv if T==`t'
	 drop nHiv dHiv sum_nHiv sum_dHiv
  }
  
  compress
  save "$dirdata/C_BaseIQTProdutividade.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQTV_Hi dIQTV_Hiv dIQTV_Hi_nominal dIQTV_Hiv_nominal
   duplicates drop
  
   * 1992 = 100
   * Sem controles:
     gen IQTV_Hi = 100 if T==1
     replace IQTV_Hi = IQTV_Hi[_n-1]*dIQTV_Hi if _n > 1
     label var IQTV_Hi "IQT Anual Valor - Sem controles"
	 
	 gen IQTV_Hi_nominal = 100 if T==1
     replace IQTV_Hi_nominal = IQTV_Hi_nominal[_n-1]*dIQTV_Hi_nominal if _n > 1
     label var IQTV_Hi_nominal "IQT Anual Valor Nominal - Sem controles"
	 
	 
   * Com controles:
     gen IQTV_Hiv = 100 if T==1
     replace IQTV_Hiv = IQTV_Hiv[_n-1]*dIQTV_Hiv if _n > 1
     label var IQTV_Hiv "IQT Anual Valor - Com controles" 
	 
	 gen IQTV_Hiv_nominal = 100 if T==1
     replace IQTV_Hiv_nominal = IQTV_Hiv_nominal[_n-1]*dIQTV_Hiv_nominal if _n > 1
     label var IQTV_Hiv_nominal "IQT Anual Valor Nominal - Com controles"
	 
   
   merge 1:1 T using "$dirdata\C_IQTProdutividade.dta"
   drop _merge
   
   save "$dirdata\C_IQTProdutividade.dta", replace
   export excel T IQT_Hi IQT_Hiv IQTP_Hi IQTP_Hiv IQTV_Hi IQTV_Hiv IQTV_Hi_nominal IQTV_Hiv_nominal using "$dirdata\B_IQT.xlsx", sheet ("Produtividade", modify) firstrow(varlabels)
   
  restore
  }  
 } 
}


*******************************************************************************
* D. RETORNOS EDUCAÇÃO
*******************************************************************************
{
 use "$dirdata/B_BaseEstimacao.dta", clear

* Salvando coeficientes em dta: 
  statsby, by(T) saving("$dirdata\D_Coeficientes_i.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 [iw = Peso]
 estimates drop _all	
 
  statsby, by(T) saving("$dirdata\D_Coeficientes_iv.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal [iw = Peso]
 estimates drop _all
 
* Consolidando base única:
  use "$dirdata\D_Coeficientes_iv.dta", clear
  
  * Renomeando variáveis e labels para diferenciar entre estratégias de controles:
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Com controles"
	  rename `x' iv_`nome'
    }	
	save "$dirdata\D_Coeficientes", replace   
	
	use "$dirdata\D_Coeficientes_i.dta", clear
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Sem controles"
	  rename `x' i_`nome'
    }	
	
	merge 1:1 T using "$dirdata\D_Coeficientes"
	drop _merge
	save "$dirdata\D_Coeficientes", replace
	
	export excel T i_cons i_mulher i_educ2 i_educ3 i_educ4 i_educ5 i_educ6 iv_cons iv_mulher iv_educ2 iv_educ3 iv_educ4 iv_educ5 iv_educ6 using "$dirdata\D_CoeficientesEducação.xlsx", sheet ("Anual", modify) firstrow(varlabels) 
}

log close