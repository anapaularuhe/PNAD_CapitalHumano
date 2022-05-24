*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Estimação IQT
*******************************************************************************


* PREPARAÇÃO ******************************************************************
* Pacotes:
 *ssc install labutil
 *ssc install mdesc
 *ssc install tabout
 *ssc install outreg2

* Preparando memória: 
  clear all
  cls								
  set maxvar 30000
	
* Diretório:  
   global dirpath = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT"
   global dirdata = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT\Dados"
   global diroriginal = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT\Dados\PNAD Original"
 
* Salvando log:   
  log using "LogIQT.log", replace
  
  
*******************************************************************************
* A. ORGANIZAÇÃO DA BASE
*******************************************************************************
{
* A.1. IMPORTANDO DADOS *******************************************************
{
 * Lista das variáveis mantidas:
 {
  /*
	Ano        | Ano
	Trimestre  | Trimestre
	UF         | UF
	V1028      | Peso trimestral com correção de não entrevista COM PÓS ESTRATIFICAÇÃO pela projeção de população  
	V1029      | Projeção da população
	
	V2007      | Sexo
	V2009      | Idade
	V2010      | Cor ou raça
		 
	VD3005     | Anos de estudo                           (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente) 
	             * Obs: variável parcialmente categória; 16 = 16 anos ou mais 
	VD3006     | Grupos de anos de estudo                 (TRÊS FASES: 2012 a set/2015; out/2015 a dez/2017; jan/2018 a presente)
	
	VD4002     | Condição de ocupação
	VD4009     | Posição na ocupação 
	VD4019     | Rendimento habitual mensal (todos os trabalhos)
	VD4020     | Rendimento efetivo mensal  (todos os trabalhos)
	VD4031     | Horas habitualmente trabalhadas por semana (todos os trabalhos)
	VD4035     | Horas efetivamente trabalhadas na semana   (todos os trabalhos)
	
	Efetivo    | Deflator com base nos redimentos efetivos
	Habitual   | Deflator com base nos rendimentos habituais		
  */		
 }

 use "$diroriginal/PNADC_012012.dta", clear
 keep Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035
 save "$dirdata/A_PNADC_20122022.dta", replace
  
 append using "$diroriginal/PNADC_022012.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032012.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042012.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
  
 append using "$diroriginal/PNADC_012013.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022013.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032013.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042013.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
   
 append using "$diroriginal/PNADC_012014.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022014.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032014.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042014.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
   
 append using "$diroriginal/PNADC_012015.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022015.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032015.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042015.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
  
 append using "$diroriginal/PNADC_012016.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022016.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032016.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042016.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
  
 append using "$diroriginal/PNADC_012017.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022017.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032017.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042017.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
  
 append using "$diroriginal/PNADC_012018.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022018.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032018.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042018.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)

 append using "$diroriginal/PNADC_012019.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022019.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032019.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042019.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
  
 append using "$diroriginal/PNADC_012020.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022020.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032020.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042020.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)

 append using "$diroriginal/PNADC_012021.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_022021.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_032021.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 append using "$diroriginal/PNADC_042021.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)

 append using "$diroriginal/PNADC_012022.dta", keep(Ano Trimestre UF V1028 V1029 V2007 V2009 V2010 VD3005 VD3006 VD4002 VD4009 VD4019 VD4020 VD4031 VD4035)
 
 compress 
 save "$dirdata/A_PNADC_20122022.dta", replace
}	
	
* A.2. DEFLATORES *************************************************************
{
 * Salvando deflatores em dta
   import excel "$diroriginal\deflator_PNADC_2022_trimestral_010203.xls", firstrow clear
	
    destring Ano UF, replace 
	keep if trim=="01-02-03" || trim=="04-05-06" || trim=="07-08-09" || trim=="10-11-12"
	
	gen Trimestre = 1 if trim=="01-02-03"
	replace Trimestre = 2 if trim=="04-05-06"
	replace Trimestre = 3 if trim=="07-08-09"
	replace Trimestre = 4 if trim=="10-11-12"
	
	compress
	save "$dirdata/A_Deflator.dta", replace
	 
  * Merge
	use "$dirdata/A_PNADC_20122022.dta", clear
	destring Trimestre, replace
    merge m:1 Ano UF Trimestre using "$dirdata/A_Deflator.dta"
	drop _merge
	
  * Criando variável de Período 
    gen T = ((Ano - 2012)*4) + Trimestre
    label var T "Período sequencial"
    order T, after(Trimestre)
   
    * Label:
     tostring Ano, generate(Ano_string) 
	 tostring Trimestre, generate(Trimestre_string)
     gen Periodo = Ano_string + "-" + Trimestre_string
     labmask T, values(Periodo)
   
     drop Ano_string Trimestre_string Periodo
	 
   compress
   save "$dirdata/A_PNADC_20122022.dta", replace	
}

* A.3. RENOMEAR VARIÁVEIS, LABELS E RESTRIÇÃO DA AMOSTRA **********************
{
 use "$dirdata/A_PNADC_20122022.dta", clear
 
 ** RENOMEANDO VARIÁVEIS BÁSICAS
  rename V1028 Peso
  rename V2007 Sexo
  rename V2009 Idade
  rename V2010 Cor 
  rename VD4002 PO 
  
 
 ** GÊNERO (eliminamos observações com missing values)  
  drop if Sexo ==.  
  label define Sexo_label 1 "Homem" 2 "Mulher" 
  label values Sexo Sexo_label
  
  gen byte mulher = (Sexo==2)
  label var mulher "Mulher"
  order mulher, after(Sexo)
 
 
 ** COR (eliminamos observações com missing values)  
  label define cor_label 1 "Branca" 2 "Preta" 3 "Amarela" 4 "Parda" 5 "Indigena" 9 "Ignorado"  
  label values Cor cor_label 
 
  drop if Cor == .
  gen PretoPardoIndig = 0
  replace PretoPardoIndig = 1 if (Cor==2 | Cor==4 | Cor== 5)
  label var PretoPardoIndig "Preto, Parto ou Indigena"
 
 
 ** TRABALHO
 * CONDIÇÃO DE OCUPAÇÃO
  label define PO_label 1 "Ocupado" 2 "Desocupado"
  label values PO PO_label
  tab T PO [iw=Peso] if PO==1
 
  
 * SETOR PÚBLICO
  label define VD4009_label 1 "Privado COM carteira" 2 "Privado SEM carteira" 3 "Doméstico COM carteira" 4 "Doméstico SEM carteira" 5 "Público COM carteira" 6 "Público SEM carteira" 7 "Militar e estatutário" 8 "Empregador" 9 "Conta-própria" 10 "Familiar auxiliar"
  label values VD4009 VD4009_label
  
  gen byte publico = (VD4009>=05 & VD4009<=07) if VD4009!=.
  label var publico "Setor publico"
  label define publico_label 0 "Setor privado" 1 "Setor publico"
  label values publico publico_label
  
  
 * FORMALIDADE
  gen byte informal = .
  label var informal "Informal"
  label define informal_label 0 "Formal" 1 "Informal"
  label values informal informal_label  
  replace informal = 0 if (VD4009==01 | VD4009==03 | VD4009==05 | VD4009==07 | VD4009==08)
  replace informal = 1 if (VD4009==02 | VD4009==04 | VD4009==06 | VD4009==09 | VD4009==10)
  
  order publico informal, after(VD4009)
  drop VD4009
  
 
 ** ESCOLARIDADE
 * VD3006: GRUPOS DE ANOS DE ESTUDO (eliminamos observações com missing values)  
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
  
  
 * EXPERIÊNCIA (eliminamos observações com missing values para idade)   
  drop if Idade == .
  gen Experiencia =.
  label var Experiencia "Experiencia"
  order Experiencia, after(VD3006)
  replace Experiencia = Idade - VD3005 - 6 if VD3005>=9
  replace Experiencia = Idade - 15 if VD3005<9
	
  * Corrigindo valores negativos (considerando pessoas ocupadas, mudança média de 2 mil observações por trimestre representando em média 130 mil pessoas):
  replace Experiencia= 0 if Experiencia<0 

  * Imputando 0 nos missings (considerando pessoas ocupadas, 0 observações perdidas):  
  replace Experiencia=0 if Experiencia ==. 
	
  * Potências de Experiência:
  gen Experiencia2 = Experiencia^2
  gen Experiencia3 = Experiencia^3
  gen Experiencia4 = Experiencia^4
	
  label var Experiencia2 "Experiencia^2"
  label var Experiencia3 "Experiencia^3"
  label var Experiencia4 "Experiencia^4"
	
  order Experiencia2 Experiencia3 Experiencia4, after(Experiencia)
   
  * Interações com dummy de gênero:
  gen ExperMulher = Experiencia*mulher
  gen ExperMulher2 = Experiencia2*mulher
  gen ExperMulher3 = Experiencia3*mulher
  gen ExperMulher4 = Experiencia4*mulher
  
  label var ExperMulher "Exper x Mulher"
  label var ExperMulher2 "Exper^2 x Mulher"
  label var ExperMulher3 "Exper^3 x Mulher"
  label var ExperMulher4 "Exper^4 x Mulher"
 
 
 ** RESTRIÇÃO DA AMOSTRA:
  * Manter apenas observações na PO, sem missing em horas e rendimentos
  * Eliminar observações com horas efetivas nulas (estratégia do IPEA)
  keep if PO ==1
  drop if VD4019==. | VD4020==. | VD4031==. | VD4035==.   
  drop if VD4035 == 0
 
  compress
  save "$dirdata/A_PNADC_amostra.dta", replace
}  

* A.4. RENDIMENTO *************************************************************
{
 use "$dirdata/A_PNADC_amostra.dta", clear
 
 * 1. RENDIMENTO REAL  
  * Habitual 	
    gen VD4019_real = VD4019*Habitual
	label var VD4019_real "Rendimento real habitual"
	order VD4019_real, after(VD4019)
 
  * Efetivo 
    gen VD4020_real = VD4020*Efetivo
    label var VD4020_real "Rendimento real efetivo"
	order VD4020_real, after(VD4020)
 
 
 * 2. SALÁRIO HORA
  * Salário-Hora Habitual Real 
    gen sh_hab = VD4019_real/(VD4031*4)
	label var sh_hab "Rendimento real por hora habitual"
  
  * Salário-Hora Habitual Nominal
    gen sh_hab_nominal = VD4019/(VD4031*4)
	label var sh_hab_nominal "Rendimento nominal por hora habitual"
    order sh_hab sh_hab_nominal, after(VD4019_real)
  
  * Salário-Hora Efetivo Real
    gen sh_efet = VD4020_real/(VD4035*4)
	label var sh_efet "Rendimento real por hora efetivo"
	
  * Salário-Hora Efetivo Nominal
    gen sh_efet_nominal = VD4020/(VD4035*4)
	label var sh_efet_nominal "Rendimento nominal por hora efetivo"	
	order sh_efet sh_efet_nominal, after(VD4020_real)
	
	
 * 3. LOG DOS SALÁRIOS  
  * Habitual:
    gen logW_hab = ln(sh_hab)
    label var logW_hab "Log do rendimento real habitual por hora"
   
    gen logW_hab_nominal = ln(sh_hab_nominal)
    label var logW_hab_nominal "Log do rendimento nominal habitual por hora"
   
  * Efetivo:
  ** ATENÇÃO: existem observações com rendimento efetivo = 0. logW_efet = . para essas observações. 
    gen logW_efet = ln(sh_efet)
    label var logW_efet "Log do rendimento real efetivo por hora"
 
    gen logW_efet_nominal = ln(sh_efet_nominal)
    label var logW_efet_nominal "Log do rendimento nominal efetivo por hora"
  
  compress
  save "$dirdata/A_PNADC_amostra.dta", replace
} 
}


*******************************************************************************
* B. ESTIMAÇÃO IQT
*******************************************************************************
{
* B.0: PREPARAÇÃO *************************************************************
{ 
  use "$dirdata/A_PNADC_amostra.dta", clear
  
* Eliminar variáveis que não são necessárias para a estimação (reduzir uso de memória):
  drop UF Idade VD3005 VD4019 VD4019_real VD4020 VD4020_real Efetivo Habitual 
   
* Quantidade de períodos:
  egen Tmax = max(T)
 
 compress
 save "$dirdata/B_BaseEstimacao.dta", replace   
} 

* B.1: REGRESSÕES (RETORNOS EDUC E EXPER) + SALÁRIOS PREDITOS *****************
{
 use "$dirdata/B_BaseEstimacao.dta", clear
 
 forvalues t = 1/`=Tmax' {     
 * SEM CONTROLES:
  * Efetivo:
    * Rendimento real:
    regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Efetivo_i", append
	predict RegLog_Ei_`t' if (T>=(`t'-1) & T<=(`t'+1)) 
	 
	* Rendimento nominal: 
	regress logW_efet_nominal mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Efetivo_nominal_i", append
	predict RegLog_Ei_nominal_`t' if (T>=(`t'-1) & T<=(`t'+1))  
	 
	 
  * Habitual:
	* Rendimento real:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Habitual_i", append
	predict RegLog_Hi_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	
	* Rendimento nominal:
	regress logW_hab_nominal mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Habitual_nominal_i", append
	predict RegLog_Hi_nominal_`t' if(T>=(`t'-1) & T<=(`t'+1))	 


 * COM CONTROLES:
  * Efetivo:
    * Rendimento real:
	regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Efetivo_iv", append
	gen RegLog_Eiv_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1))	 
	 
	* Rendimento nominal:
	regress logW_efet_nominal mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Efetivo_nominal_iv", append
	gen RegLog_Eiv_nominal_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1))	  
	 
	 
  * Habitual:
    * Rendimento real:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Habitual_iv", append
	gen RegLog_Hiv_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1)) 
	
	* Rendimento nominal:
	regress logW_hab_nominal mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	estimates save "$dirdata/B_Regressões/Habitual_nominal_iv", append
	gen RegLog_Hiv_nominal_`t' = _b[_cons] + _b[mulher]*mulher + _b[educ2]*educ2 + _b[educ3]*educ3 + _b[educ4]*educ4 + _b[educ5]*educ5 + _b[educ6]*educ6 + _b[Experiencia]*Experiencia + _b[Experiencia2]*Experiencia2 + _b[Experiencia3]*Experiencia3 + _b[Experiencia4]*Experiencia4 + _b[ExperMulher]*ExperMulher + _b[ExperMulher2]*ExperMulher2 + _b[ExperMulher3]*ExperMulher3 + _b[ExperMulher4]*ExperMulher4 if(T>=(`t'-1) & T<=(`t'+1)) 
	  
  estimates drop _all
  }

 save "$dirdata/B_BaseEstimacao.dta", replace  
} 

* B.2: SALÁRIOS PREDITOS ******************************************************
{
 use "$dirdata/B_BaseEstimacao.dta", clear
 
 * Exponencial + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
   * Sem controles
	 gen RegW_Ei_`t' = exp(RegLog_Ei_`t')	  
	 gen RegW_Hi_`t' = exp(RegLog_Hi_`t')
	 
	 gen RegW_Ei_nominal_`t' = exp(RegLog_Ei_nominal_`t')	  
	 gen RegW_Hi_nominal_`t' = exp(RegLog_Hi_nominal_`t')
	  
	  
   * Com controles
	 gen RegW_Eiv_`t' = exp(RegLog_Eiv_`t')	 
	 gen RegW_Hiv_`t' = exp(RegLog_Hiv_`t')	
	 
	 gen RegW_Eiv_nominal_`t' = exp(RegLog_Eiv_nominal_`t')	 
	 gen RegW_Hiv_nominal_`t' = exp(RegLog_Hiv_nominal_`t')	
	 
	 
	 drop RegLog_Ei_`t' RegLog_Eiv_`t' RegLog_Hi_`t' RegLog_Hiv_`t' RegLog_Ei_nominal_`t' RegLog_Hi_nominal_`t' RegLog_Eiv_nominal_`t' RegLog_Hiv_nominal_`t'
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - W_T     = salários em t preditos pelos coeficientes estimados de t
	- W_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- W_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
 * Sem controles:  
   gen WEi_T = .
   gen WEi_Tante = .
   gen WEi_Tprox = .
   
   gen WHi_T = .
   gen WHi_Tante = .
   gen WHi_Tprox = .
   
   gen WEi_T_nominal = .
   gen WEi_Tante_nominal = .
   gen WEi_Tprox_nominal = .
   
   gen WHi_T_nominal = .
   gen WHi_Tante_nominal = .
   gen WHi_Tprox_nominal = .
   
   
 * Com controles:
   gen WEiv_T = .
   gen WEiv_Tante = .
   gen WEiv_Tprox = .
   
   gen WHiv_T = .
   gen WHiv_Tante = .
   gen WHiv_Tprox = .
   
   gen WEiv_T_nominal = .
   gen WEiv_Tante_nominal = .
   gen WEiv_Tprox_nominal = .
   
   gen WHiv_T_nominal = .
   gen WHiv_Tante_nominal = .
   gen WHiv_Tprox_nominal = .
   
   
   forvalues t = 1/`=Tmax' {
      replace WEi_T = RegW_Ei_`t' if T==`t'
	  replace WHi_T = RegW_Hi_`t' if T==`t'
	  
      replace WEiv_T = RegW_Eiv_`t' if T==`t'
	  replace WHiv_T = RegW_Hiv_`t' if T==`t'
	  
	  replace WEi_T_nominal = RegW_Ei_nominal_`t' if T==`t'
	  replace WHi_T_nominal = RegW_Hi_nominal_`t' if T==`t'
	  
      replace WEiv_T_nominal = RegW_Eiv_nominal_`t' if T==`t'
	  replace WHiv_T_nominal = RegW_Hiv_nominal_`t' if T==`t'
	  
	  
	  local i = `t'-1
	  if `t' > 1 replace WEi_Tante = RegW_Ei_`i' if T==`t'
	  if `t' > 1 replace WHi_Tante = RegW_Hi_`i' if T==`t'
	  
	  if `t' > 1 replace WEiv_Tante = RegW_Eiv_`i' if T==`t'
	  if `t' > 1 replace WHiv_Tante = RegW_Hiv_`i' if T==`t'	 
	 
	  if `t' > 1 replace WEi_Tante_nominal = RegW_Ei_nominal_`i' if T==`t'
	  if `t' > 1 replace WHi_Tante_nominal = RegW_Hi_nominal_`i' if T==`t'
	  
	  if `t' > 1 replace WEiv_Tante_nominal = RegW_Eiv_nominal_`i' if T==`t'
	  if `t' > 1 replace WHiv_Tante_nominal = RegW_Hiv_nominal_`i' if T==`t'	
	 
	 
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WEi_Tprox = RegW_Ei_`j' if T==`t'
	  if `t' < `=Tmax' replace WHi_Tprox = RegW_Hi_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace WEiv_Tprox = RegW_Eiv_`j' if T==`t'
	  if `t' < `=Tmax' replace WHiv_Tprox = RegW_Hiv_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace WEi_Tprox_nominal = RegW_Ei_nominal_`j' if T==`t'
	  if `t' < `=Tmax' replace WHi_Tprox_nominal = RegW_Hi_nominal_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace WEiv_Tprox_nominal = RegW_Eiv_nominal_`j' if T==`t'
	  if `t' < `=Tmax' replace WHiv_Tprox_nominal = RegW_Hiv_nominal_`j' if T==`t'
   }
 

 * Excluindo os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_Ei_`t' RegW_Hi_`t' RegW_Eiv_`t' RegW_Hiv_`t' RegW_Ei_nominal_`t' RegW_Hi_nominal_`t' RegW_Eiv_nominal_`t' RegW_Hiv_nominal_`t'
   }  
 
   compress
   save "$dirdata/B_BaseEstimacao.dta", replace
} 
 
* B.3: PESOS ******************************************************************
{
 use "$dirdata/B_BaseEstimacao.dta", clear

 * Efetivo
   bysort T Sexo VD3006 Experiencia: egen HE = mean(VD4035)
   order HE, after(VD4035)
   label var HE "Horas efetivas médias por grupo de educação e experiência para cada trimestre"

  * Peso ajustado por hora:
    gen PEi = Peso*HE
    bysort T: egen PEt = sum(PEi)
    gen PE = PEi/PEt
    label var PE "Peso para cálculo do IQT de rendimento efetivo"
   
    order PE, after(Peso) 
    drop PEi PEt
   
   
 * Habitual
   bysort T VD3006 Experiencia: egen HH = mean(VD4031)
   order HH, after(VD4031)
   label var HH "Horas habituais médias por grupo de educação e experiência para cada trimestre"

  * Peso ajustado por hora:
    gen PHi = Peso*HH
    bysort T: egen PHt = sum(PHi)
    gen PH = PHi/PHt
    label var PH "Peso para cálculo do IQT de rendimento habitual"
   
    order PH, after(PE) 
    drop PHi PHt

 compress
 save "$dirdata/B_BaseEstimacao.dta", replace
 
 
 * B.3.1: Evolução horas ao longo do tempo
 {
  preserve 
     collapse (sum) VD4035 (sum) VD4031 [iw = Peso], by(T VD3006)
	 
	 rename VD4035 HE_soma
     label var HE_soma "Horas Efetivas - Soma da população por grupo de estudo"
	 rename VD4031 HH_soma
     label var HH_soma "Horas Habituais - Soma da população por grupo de estudo"
	 
	 compress
	 save "$dirdata/B_Horas.dta", replace
   restore
   
   preserve
      collapse (sum) VD4035 (sum) VD4031 [iw = Peso], by(T) 
	  
	 rename VD4035 HE_total
     label var HE_total "Horas Efetivas - Total da população"
	 rename VD4031 HH_total
     label var HH_total "Horas Habituais - Total da população"
	 
	 merge 1:m T using "$dirdata/B_Horas.dta"
	 drop _merge
	 
	 compress
	 save "$dirdata/B_Horas.dta", replace
   restore
   
   preserve
     use "$dirdata/B_Horas.dta", clear
	 
	 gen HE_part = HE_soma/HE_total
	 label var HE_part "Horas Efetivas - Participação no total"
	 
	 gen HH_part = HH_soma/HH_total
	 label var HH_part "Horas Habituais - Participação no total"
	 
	 order T VD3006 HE_soma HE_total HE_part HH_soma HH_total HH_part
	 
	 compress
	 save "$dirdata/B_Horas.dta", replace
	 export excel using "$dirdata\B_Horas.xlsx", sheet ("Horas", replace) firstrow(varlabels) 
   restore
 }
} 
  
* B.4: IQT ********************************************************************
{
 * IQT0
  * Efetivo:
    gen dIQT0_Ei = .            
    gen dIQT0_Eiv = .          
   
  * Habitual: 
    gen dIQT0_Hi = .         
    gen dIQT0_Hiv = .    
 

   forvalues t = 2/`=Tmax'{
   * Sem controles: 
	  gen nEi = PE*WEi_Tante if T==`t'
	  gen dEi = PE*WEi_T if T==(`t'-1)
	  gen nHi = PH*WHi_Tante if T==`t'
	  gen dHi = PH*WHi_T if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT0_Ei = sum_nEi/sum_dEi if T==`t'
	  replace dIQT0_Hi = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
   
	  
   * Com controles:
	  gen nEiv = PE*WEiv_Tante if T==`t'
	  gen dEiv = PE*WEiv_T if T==(`t'-1)
	  gen nHiv = PH*WHiv_Tante if T==`t'
	  gen dHiv = PH*WHiv_T if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT0_Eiv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT0_Hiv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  * Efetivo:
    gen dIQT1_Ei = .        
    gen dIQT1_Eiv = .        
   
  * Habitual: 
    gen dIQT1_Hi = .        
    gen dIQT1_Hiv = . 
  
   forvalues t = 2/`=Tmax'{
	* Sem controles: 
	  gen nEi = PE*WEi_T if T==`t'
	  gen dEi = PE*WEi_Tprox if T==(`t'-1)
	  gen nHi = PH*WHi_T if T==`t'
	  gen dHi = PH*WHi_Tprox if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT1_Ei = sum_nEi/sum_dEi if T==`t'
	  replace dIQT1_Hi = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
	
    * Com controles:
	  gen nEiv = PE*WEiv_T if T==`t'
	  gen dEiv = PE*WEiv_Tprox if T==(`t'-1)
	  gen nHiv = PH*WHiv_T if T==`t'
	  gen dHiv = PH*WHiv_Tprox if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT1_Eiv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT1_Hiv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
   gen dIQT_Ei = (dIQT0_Ei*dIQT1_Ei)^(1/2)
   gen dIQT_Hi = (dIQT0_Hi*dIQT1_Hi)^(1/2)
   
   gen dIQT_Eiv = (dIQT0_Eiv*dIQT1_Eiv)^(1/2)
   gen dIQT_Hiv = (dIQT0_Hiv*dIQT1_Hiv)^(1/2)
    
 compress
 save "$dirdata/B_BaseEstimacao.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T Tmax dIQT_Ei dIQT_Eiv dIQT_Hi dIQT_Hiv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * Sem controles:
     gen IQT_Ei = 100 if T==2
     replace IQT_Ei = IQT_Ei[_n-1]*dIQT_Ei if _n > 2
     label var IQT_Ei "IQT Efetivo - Sem controles"

	 gen IQT_Hi = 100 if T==2
     replace IQT_Hi = IQT_Hi[_n-1]*dIQT_Hi if _n > 2
     label var IQT_Hi "IQT Habitual - Sem controles"
	 
   * Com controles:
     gen IQT_Eiv = 100 if T==2
     replace IQT_Eiv = IQT_Eiv[_n-1]*dIQT_Eiv if _n > 2
     label var IQT_Eiv "IQT Efetivo - Com controles"
	 
	 gen IQT_Hiv = 100 if T==2
     replace IQT_Hiv = IQT_Hiv[_n-1]*dIQT_Hiv if _n > 2
     label var IQT_Hiv "IQT Habitual - Com controles" 
   
   save "$dirdata/B_IQT.dta", replace
   export excel T IQT_Ei IQT_Eiv IQT_Hi IQT_Hiv using "$dirdata\B_IQT.xlsx", firstrow(varlabels) replace
  restore
  }  
}  
}


*******************************************************************************
* C. RETORNOS EDUCAÇÃO: TABELAS E BASE DTA
*******************************************************************************
{
 use "$dirdata/B_BaseEstimacao.dta", clear
 
* C.1. EXPORTANDO TABELAS *****************************************************
{ 
* Grupo baseline: homens, grupo de educação 0 a 4 anos, 0 anos de experiência. 

 forvalues t = 1/`=Tmax' {     
 * Sem controles: 
  * Efetivo:
    regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	outreg2 using "$dirdata\C_Tabelas\Efetivo_`t'", replace ctitle("Sem controles") word tex(pretty) label: 
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	outreg2 using "$dirdata\C_Tabelas\Habitual_`t'", replace ctitle("Sem controles") word tex(pretty) label
	
  	  
 * Com controles:
  * Efetivo:
	regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	outreg2 using "$dirdata\C_Tabelas\Efetivo_`t'", append ctitle("Com controles") word tex(pretty) label
	 
  * Habitual:
	regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	outreg2 using "$dirdata\C_Tabelas\Habitual_`t'", append ctitle("Com controles") word tex(pretty) label
	 
 estimates drop _all 
 }
}

* C.2. SALVANDO COEFICIENTES: BASE DTA ****************************************
{
 * Efetivo:
   statsby, by(T) saving("$dirdata\C_Coeficientes\Efetivo_i.dta", replace): regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 [iw = Peso]
   estimates drop _all
    
   statsby, by(T) saving("$dirdata\C_Coeficientes\Efetivo_iv.dta", replace): regress logW_efet mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal [iw = Peso]
   estimates drop _all	
 
 
 * Habitual:
   statsby, by(T) saving("$dirdata\C_Coeficientes\Habitual_i.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 [iw = Peso]
   estimates drop _all	
	
   statsby, by(T) saving("$dirdata\C_Coeficientes\Habitual_iv.dta", replace): regress logW_hab mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal [iw = Peso]
   estimates drop _all 	
	
	
 * Consolidando base única:
  * Efetivo:
  {
    * Vamos fazer na ordem (iv)-(i) para que a base final fique ordenada (i)-(iv).
    use "$dirdata/C_Coeficientes/Efetivo_iv.dta", clear
	
	* Renomeando variáveis e labels para diferenciar entre estratégias de controles:
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Com controles"
	  rename `x' ivE_`nome'
    }	
	save "$dirdata/C_Coeficientes_Efetivo", replace   
	
   
	use "$dirdata/C_Coeficientes/Efetivo_i.dta", clear
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Sem controles"
	  rename `x' iE_`nome'
    }	
	
	merge 1:1 T using "$dirdata/C_Coeficientes_Efetivo"
	drop _merge
	save "$dirdata/C_Coeficientes_Efetivo", replace
	
    
    export excel T iE_cons iE_mulher iE_educ2 iE_educ3 iE_educ4 iE_educ5 iE_educ6 ivE_cons ivE_mulher ivE_educ2 ivE_educ3 ivE_educ4 ivE_educ5 ivE_educ6 using "$dirdata\C_CoeficientesEducação.xlsx", sheet ("Efetivo") firstrow(varlabels) replace
    export excel "$dirdata\C_CoeficientesCompletos.xlsx", sheet ("Efetivo") firstrow(varlabels) replace
  } 
 
  * Habitual:
  {
    * Vamos fazer na ordem (iv)-(i) para que a base final fique ordenada (i)-(iv).
	use "$dirdata/C_Coeficientes/Habitual_iv.dta", clear
	
	* Renomeando variáveis e labels para diferenciar entre estratégias de controles:
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Com controles"
	  rename `x' ivH_`nome'
    }	
	save "$dirdata/C_Coeficientes_Habitual", replace   
	
	
	use "$dirdata/C_Coeficientes/Habitual_i.dta", clear
	foreach x of varlist _b_* {
      local nome = substr("`x'", 4, 12)
	  label var `x' "`nome' - Sem controles"
	  rename `x' iH_`nome'
    }	
	
	merge 1:1 T using "$dirdata/C_Coeficientes_Habitual"
	drop _merge
	save "$dirdata/C_Coeficientes_Habitual", replace
	
	
	export excel T iH_cons iH_mulher iH_educ2 iH_educ3 iH_educ4 iH_educ5 iH_educ6 ivH_cons ivH_mulher ivH_educ2 ivH_educ3 ivH_educ4 ivH_educ5 ivH_educ6 using "$dirdata\C_CoeficientesEducação.xlsx", sheet ("Habitual", modify) firstrow(varlabels) 
    export excel "$dirdata\C_CoeficientesCompletos.xlsx", sheet ("Habitual", modify) firstrow(varlabels)
  } 	
} 
}


*******************************************************************************
* D. GRÁFICOS
*******************************************************************************
{
 use "$dirdata/B_IQT.dta", clear
  
* D.1. POR CONTROLE ***********************************************************
{
 * Sem controles:
   twoway (line IQT_Hi T, lcolor(orange)) (line IQT_Ei T, lcolor(blue)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTi, replace) 
   *graph export "$dirpath/Gráficos/IQTi.png", width(10000) as(png) replace

 * Com controles:
   twoway (line IQT_Hiv T, lcolor(orange)) (line IQT_Eiv T, lcolor(blue)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTiv, replace) 
   *graph export "$dirpath/Gráficos/IQTiv.png", width(10000) as(png) replace
}
 
* D.2. COMPARANDO CONTROLES ***************************************************
{
 * Efetivo:
   twoway (line IQT_Ei T, lpattern(dash) lcolor(blue)) (line IQT_Eiv T, lcolor(blue)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTEfetivo, replace) 
   *graph export "$dirpath/Gráficos/IQTEfetivo.png", width(10000) as(png) replace
   
 * Habitual:
   twoway (line IQT_Hi T, lpattern(dash) lcolor(orange)) (line IQT_Hiv T, lcolor(orange)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(95(5)125, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(IQTHabitual, replace) 
   *graph export "$dirpath/Gráficos/IQTHabitual.png", width(10000) as(png) replace   
}
}


log close