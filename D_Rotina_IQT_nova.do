*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* 2021
*******************************************************************************

* PREPARAÇÃO ******************************************************************
* Pacotes:
* ssc install outreg2

* Garantindo que não há variáveis prévias na memória:
  clear all
  cls								

* Configurações de memória:
  set maxvar 30000
	
* Configurando diretório: 
** Servidor bif004 (Ana Paula):
   global dirpath = "A:/Ana Paula Ruhe/Capital Humano" 
   global dirdata = "A:/Ana Paula Ruhe/Capital Humano/Dados"
   
** Servidor RDPBI1VPR0002 (Ana Paula):   
  *global dirpath = "B:/Ana Paula Ruhe/Capital Humano"
  *global dirdata = "B:/Ana Paula Ruhe/Capital Humano/Dados"

** Janaina:    
  *global dirpath = "C:\Users\janaina.feijo\Documents\capital_humano\result"   
  *global dirdata = "C:\Users\janaina.feijo\Documents\capital_humano\data" 


* Salvando log:
  log using "D_Rotina_IQT.log", replace

*******************************************************************************
* ROTEIRO DA ROTINA:
* - Estratégias B e C (lidando com horas efetivas nulas)
* - Estimações com e sem peso da PNAD 
* - Regressões com e sem controles
* - Estratégia C: duas versões do IQT efetivo (C e C_alt)
  
  
  
*******************************************************************************
* ESTRATÉGIA B
*******************************************************************************
{
* Descrição: indivíduos com horas efetivas nulas serão removidos das estimações (terão missing values) de salário efetivo e de salário habitual

*******************************************************************************
* 0. PREPARAÇÃO ***************************************************************
{ 
  use "$dirdata/C_PNADC_POamostra.dta", clear
  
  * Eliminamos variáveis da amostra não necessárias:
   drop UF Regiao V1027 Populacao Idade V3003 V3003A V3009 V3009A VD3004 VD3005 VD3006_pos Experiencia_pos VD4001 VD4002 VD4009 privado trabalhador VD4010 VD4016 VD4017 VD4019 VD4019_real VD4020 VD4020_real VD4032 Efetivo Habitual educ_pos1 educ_pos2 educ_pos3 educ_pos4 educ_pos5 educ_pos6 educ_pos7 educ_pos8 idade15 idade14 Experiencia_pos2 Experiencia_pos3 Experiencia_pos4 sh_hab_A sh_hab_D sh_efet_A sh_efet_D logW_hab_A logW_hab_D logW_efet_A logW_efet_D logW_efet0_A logW_efet0_B logW_efet0_C logW_efet0_D
   
   egen Tmax = max(T)

 * Gerando interação mulher x experiência:
   gen ExperMulher = Experiencia*mulher
   gen ExperMulher2 = Experiencia2*mulher
   gen ExperMulher3 = Experiencia3*mulher
   gen ExperMulher4 = Experiencia4*mulher

 * Para as tabelas, vamos renomear alguns labels:
   label var mulher "Mulher"
   label var educ2 "Estudo 1 a 4 anos"
   label var educ3 "Estudo 5 a 8 anos"
   label var educ4 "Estudo 9 a 11 anos"
   label var educ5 "Estudo 12 a 15 anos"
   label var educ6 "Estudo 16+ anos"
   label var Experiencia2 "Experiencia^2"
   label var Experiencia3 "Experiencia^3"
   label var Experiencia4 "Experiencia^4"
   label var ExperMulher "Exper x Mulher"
   label var ExperMulher2 "Exper^2 x Mulher"
   label var ExperMulher3 "Exper^3 x Mulher"
   label var ExperMulher4 "Exper^4 x Mulher"
   label var publico "Setor publico"
   label var informal "Informal"
   
   
 * Cor/raça ignorada:  2.093 observações em 8.249.275 (0,03 %)
   drop if Cor == 9
   
   gen PretoPardoIndig = 0
   replace PretoPardoIndig = 1 if (Cor==2 | Cor==4 | Cor== 5)
   label var PretoPardoIndig "Preto, Parto ou Indigena"
   
   save "$dirdata/D_BaseEstimacao.dta", replace 

}


*******************************************************************************
* 1. RETORNOS + SALÁRIOS PREDITOS *********************************************
{
** 1.1: Estimações sem peso ***************************************************
 {             
*** ESTIMAÇÃO 
  {
   forvalues t = 1/`=Tmax' {     
   * (i) Sem controles: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	 predict BRegLogE_1i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1i_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	 predict BRegLogH_1i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1i_Habitual", append
	
	
   * (ii) Cor: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t'
	 predict BRegLogE_1ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1ii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t'
	 predict BRegLogH_1ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1ii_Habitual", append

	 
   * (iii) Setor público: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t'
	 predict BRegLogE_1iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1iii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t'
	 predict BRegLogH_1iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1iii_Habitual", append
	  
	  
   * (iv) Setor informal: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t'
	 predict BRegLogE_1iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1iv_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t'
	 predict BRegLogH_1iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B1iv_Habitual", append
  
    estimates clear
   }
   estimates clear	 			
  } 

*** SALÁRIOS PREDITOS
  { 
  * Exponencial + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
   * (i) Sem controles
	  gen BRegWE_1i_`t' = exp(BRegLogE_1i_`t')	  
	  gen BRegWH_1i_`t' = exp(BRegLogH_1i_`t')	  
	  
   * (ii) Cor 
	  gen BRegWE_1ii_`t' = exp(BRegLogE_1ii_`t')	  
	  gen BRegWH_1ii_`t' = exp(BRegLogH_1ii_`t')	  
	  
   * (iii) Setor público 
	  gen BRegWE_1iii_`t' = exp(BRegLogE_1iii_`t')
	  gen BRegWH_1iii_`t' = exp(BRegLogH_1iii_`t')
	 
   * (iv) Informal
	  gen BRegWE_1iv_`t' = exp(BRegLogE_1iv_`t')	 
	  gen BRegWH_1iv_`t' = exp(BRegLogH_1iv_`t')	
	 
	 drop BRegLogE_1i_`t' BRegLogE_1ii_`t' BRegLogE_1iii_`t' BRegLogE_1iv_`t' BRegLogH_1i_`t' BRegLogH_1ii_`t' BRegLogH_1iii_`t' BRegLogH_1iv_`t'
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - W_T     = salários em t preditos pelos coeficientes estimados de t
	- W_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- W_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
* (i) Sem controles:  
   gen BWE_1i_T = .
   gen BWE_1i_Tante = .
   gen BWE_1i_Tprox = .
   
   gen BWH_1i_T = .
   gen BWH_1i_Tante = .
   gen BWH_1i_Tprox = .
   
* (ii) Cor:
   gen BWE_1ii_T = .
   gen BWE_1ii_Tante = .
   gen BWE_1ii_Tprox = .
   
   gen BWH_1ii_T = .
   gen BWH_1ii_Tante = .
   gen BWH_1ii_Tprox = .
   
* (iii) Setor publico: 
   gen BWE_1iii_T = .
   gen BWE_1iii_Tante = .
   gen BWE_1iii_Tprox = .
   
   gen BWH_1iii_T = .
   gen BWH_1iii_Tante = .
   gen BWH_1iii_Tprox = .
   
* (iv) Informal
   gen BWE_1iv_T = .
   gen BWE_1iv_Tante = .
   gen BWE_1iv_Tprox = .
   
   gen BWH_1iv_T = .
   gen BWH_1iv_Tante = .
   gen BWH_1iv_Tprox = .
   
   
   forvalues t = 1/`=Tmax' {
      replace BWE_1i_T = BRegWE_1i_`t' if T==`t'
	  replace BWH_1i_T = BRegWH_1i_`t' if T==`t'
	  
	  replace BWE_1ii_T = BRegWE_1ii_`t' if T==`t'
	  replace BWH_1ii_T = BRegWH_1ii_`t' if T==`t'
	  
	  replace BWE_1iii_T = BRegWE_1iii_`t' if T==`t'
	  replace BWH_1iii_T = BRegWH_1iii_`t' if T==`t'
	  
      replace BWE_1iv_T = BRegWE_1iv_`t' if T==`t'
	  replace BWH_1iv_T = BRegWH_1iv_`t' if T==`t'
	  
	  
	  local i = `t'-1
	  if `t' > 1 replace BWE_1i_Tante = BRegWE_1i_`i' if T==`t'
	  if `t' > 1 replace BWH_1i_Tante = BRegWH_1i_`i' if T==`t'
	  
	  if `t' > 1 replace BWE_1ii_Tante = BRegWE_1ii_`i' if T==`t'
	  if `t' > 1 replace BWH_1ii_Tante = BRegWH_1ii_`i' if T==`t'
	  
	  if `t' > 1 replace BWE_1iii_Tante = BRegWE_1iii_`i' if T==`t'
	  if `t' > 1 replace BWH_1iii_Tante = BRegWH_1iii_`i' if T==`t'	  
	  
	  if `t' > 1 replace BWE_1iv_Tante = BRegWE_1iv_`i' if T==`t'
	  if `t' > 1 replace BWH_1iv_Tante = BRegWH_1iv_`i' if T==`t'	 
	 
	 
	  local j = `t'+1 
	  if `t' < `=Tmax' replace BWE_1i_Tprox = BRegWE_1i_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_1i_Tprox = BRegWH_1i_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace BWE_1ii_Tprox = BRegWE_1ii_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_1ii_Tprox = BRegWH_1ii_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace BWE_1iii_Tprox = BRegWE_1iii_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_1iii_Tprox = BRegWH_1iii_`j' if T==`t'	  
	  
	  if `t' < `=Tmax' replace BWE_1iv_Tprox = BRegWE_1iv_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_1iv_Tprox = BRegWH_1iv_`j' if T==`t'
   }
 

 * Excluindo os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop BRegWE_1i_`t' BRegWH_1i_`t' BRegWE_1ii_`t' BRegWH_1ii_`t' BRegWE_1iii_`t' BRegWH_1iii_`t' BRegWE_1iv_`t' BRegWH_1iv_`t' 
   }  
 
   save "$dirdata/D_BaseEstimacao.dta", replace
   }
 } 
 
** 1.2: Estimações com peso ***************************************************
 {             
*** ESTIMAÇÃO 
  {
   forvalues t = 1/`=Tmax' {     
   * (i) Sem controles: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	 predict BRegLogE_2i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2i_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	 predict BRegLogH_2i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2i_Habitual", append
	
	
   * (ii) Cor: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	 predict BRegLogE_2ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2ii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	 predict BRegLogH_2ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2ii_Habitual", append

	 
   * (iii) Setor público: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	 predict BRegLogE_2iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2iii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	 predict BRegLogH_2iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2iii_Habitual", append
	  
	  
   * (iv) Setor informal: 
    * Efetivo:
	 regress logW_efet_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	 predict BRegLogE_2iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2iv_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	 predict BRegLogH_2iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/B2iv_Habitual", append
  
    estimates clear
   }
   estimates clear	 			
  } 

*** SALÁRIOS PREDITOS
  { 
  * Exponencial + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
   * (i) Sem controles
	  gen BRegWE_2i_`t' = exp(BRegLogE_2i_`t')	  
	  gen BRegWH_2i_`t' = exp(BRegLogH_2i_`t')	  
	  
   * (ii) Cor 
	  gen BRegWE_2ii_`t' = exp(BRegLogE_2ii_`t')	  
	  gen BRegWH_2ii_`t' = exp(BRegLogH_2ii_`t')	  
	  
   * (iii) Setor público 
	  gen BRegWE_2iii_`t' = exp(BRegLogE_2iii_`t')
	  gen BRegWH_2iii_`t' = exp(BRegLogH_2iii_`t')
	 
   * (iv) Informal
	  gen BRegWE_2iv_`t' = exp(BRegLogE_2iv_`t')	 
	  gen BRegWH_2iv_`t' = exp(BRegLogH_2iv_`t')	
	 
	 drop BRegLogE_2i_`t' BRegLogE_2ii_`t' BRegLogE_2iii_`t' BRegLogE_2iv_`t' BRegLogH_2i_`t' BRegLogH_2ii_`t' BRegLogH_2iii_`t' BRegLogH_2iv_`t'
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - W_T     = salários em t preditos pelos coeficientes estimados de t
	- W_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- W_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
* (i) Sem controles:  
   gen BWE_2i_T = .
   gen BWE_2i_Tante = .
   gen BWE_2i_Tprox = .
   
   gen BWH_2i_T = .
   gen BWH_2i_Tante = .
   gen BWH_2i_Tprox = .
   
* (ii) Cor:
   gen BWE_2ii_T = .
   gen BWE_2ii_Tante = .
   gen BWE_2ii_Tprox = .
   
   gen BWH_2ii_T = .
   gen BWH_2ii_Tante = .
   gen BWH_2ii_Tprox = .
   
* (iii) Setor publico: 
   gen BWE_2iii_T = .
   gen BWE_2iii_Tante = .
   gen BWE_2iii_Tprox = .
   
   gen BWH_2iii_T = .
   gen BWH_2iii_Tante = .
   gen BWH_2iii_Tprox = .
   
* (iv) Informal
   gen BWE_2iv_T = .
   gen BWE_2iv_Tante = .
   gen BWE_2iv_Tprox = .
   
   gen BWH_2iv_T = .
   gen BWH_2iv_Tante = .
   gen BWH_2iv_Tprox = .
   
   
   forvalues t = 1/`=Tmax' {
      replace BWE_2i_T = BRegWE_2i_`t' if T==`t'
	  replace BWH_2i_T = BRegWH_2i_`t' if T==`t'
	  
	  replace BWE_2ii_T = BRegWE_2ii_`t' if T==`t'
	  replace BWH_2ii_T = BRegWH_2ii_`t' if T==`t'
	  
	  replace BWE_2iii_T = BRegWE_2iii_`t' if T==`t'
	  replace BWH_2iii_T = BRegWH_2iii_`t' if T==`t'
	  
      replace BWE_2iv_T = BRegWE_2iv_`t' if T==`t'
	  replace BWH_2iv_T = BRegWH_2iv_`t' if T==`t'
	  
	  
	  local i = `t'-1
	  if `t' > 1 replace BWE_2i_Tante = BRegWE_2i_`i' if T==`t'
	  if `t' > 1 replace BWH_2i_Tante = BRegWH_2i_`i' if T==`t'
	  
	  if `t' > 1 replace BWE_2ii_Tante = BRegWE_2ii_`i' if T==`t'
	  if `t' > 1 replace BWH_2ii_Tante = BRegWH_2ii_`i' if T==`t'
	  
	  if `t' > 1 replace BWE_2iii_Tante = BRegWE_2iii_`i' if T==`t'
	  if `t' > 1 replace BWH_2iii_Tante = BRegWH_2iii_`i' if T==`t'	  
	  
	  if `t' > 1 replace BWE_2iv_Tante = BRegWE_2iv_`i' if T==`t'
	  if `t' > 1 replace BWH_2iv_Tante = BRegWH_2iv_`i' if T==`t'	 
	 
	 
	  local j = `t'+1 
	  if `t' < `=Tmax' replace BWE_2i_Tprox = BRegWE_2i_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_2i_Tprox = BRegWH_2i_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace BWE_2ii_Tprox = BRegWE_2ii_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_2ii_Tprox = BRegWH_2ii_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace BWE_2iii_Tprox = BRegWE_2iii_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_2iii_Tprox = BRegWH_2iii_`j' if T==`t'	  
	  
	  if `t' < `=Tmax' replace BWE_2iv_Tprox = BRegWE_2iv_`j' if T==`t'
	  if `t' < `=Tmax' replace BWH_2iv_Tprox = BRegWH_2iv_`j' if T==`t'
   }
 

 * Excluindo os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop BRegWE_2i_`t' BRegWH_2i_`t' BRegWE_2ii_`t' BRegWH_2ii_`t' BRegWE_2iii_`t' BRegWH_2iii_`t' BRegWE_2iv_`t' BRegWH_2iv_`t' 
   }  
 
   save "$dirdata/D_BaseEstimacao.dta", replace
   }
 }    
}  


*******************************************************************************
* 2. PESOS ********************************************************************
{
 * EFETIVO:
   bysort T VD3006 Experiencia: egen BHE = mean(VD4035)
   label var BHE "Horas efetivas médias por grupo de educação e experiência para cada trimestre (B)"

  * Peso ajustado por hora:
   gen BPEi = Peso*BHE
   bysort T: egen BPEt = sum(BPEi)
   gen BPE = BPEi/BPEt
   label var BPE "Peso para cálculo do IQT de rendimento efetivo (B)"
   
   order BPE, after(Peso) 
   drop BPEi BPEt
   
 * HABITUAL:
   gen VD4031_B = VD4031
   replace VD4031_B = 0 if VD4035==0
   label var VD4031_B "Horas habituais com 0 para observações com horas efetivas nulas"
   order VD4031_B, after(VD4031)
   
   bysort T VD3006 Experiencia: egen BHH = mean(VD4031_B)
   label var BHH "Horas habituais médias por grupo de educação e experiência para cada trimestre (B)"

  * Peso ajustado por hora:
   gen BPHi = Peso*BHH
   bysort T: egen BPHt = sum(BPHi)
   gen BPH = BPHi/BPHt
   label var BPH "Peso para cálculo do IQT de rendimento habitual (B)"
   
   order BPH, after(BPE) 
   drop BPHi BPHt

   save "$dirdata/D_BaseEstimacao.dta", replace
} 


*******************************************************************************
* 3. IQT **********************************************************************
{
** 3.1: Estimações sem peso ***************************************************
 {
 * IQT0
  * Efetivo:
   gen dIQT0_BE1i = .        
   gen dIQT0_BE1ii = .        
   gen dIQT0_BE1iii = .        
   gen dIQT0_BE1iv = .          
   
  * Habitual: 
   gen dIQT0_BH1i = .        
   gen dIQT0_BH1ii = .        
   gen dIQT0_BH1iii = .        
   gen dIQT0_BH1iv = .    


   forvalues t = 2/`=Tmax'{
   * (i) Sem controles: 
	  gen nEi = BPE*BWE_1i_Tante if T==`t'
	  gen dEi = BPE*BWE_1i_T if T==(`t'-1)
	  gen nHi = BPH*BWH_1i_Tante if T==`t'
	  gen dHi = BPH*BWH_1i_T if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT0_BE1i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT0_BH1i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = BPE*BWE_1ii_Tante if T==`t'
	  gen dEii = BPE*BWE_1ii_T if T==(`t'-1)
	  gen nHii = BPH*BWH_1ii_Tante if T==`t'
	  gen dHii = BPH*BWH_1ii_T if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT0_BE1ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT0_BH1ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = BPE*BWE_1iii_Tante if T==`t'
	  gen dEiii = BPE*BWE_1iii_T if T==(`t'-1)
	  gen nHiii = BPH*BWH_1iii_Tante if T==`t'
	  gen dHiii = BPH*BWH_1iii_T if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT0_BE1iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT0_BH1iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = BPE*BWE_1iv_Tante if T==`t'
	  gen dEiv = BPE*BWE_1iv_T if T==(`t'-1)
	  gen nHiv = BPH*BWH_1iv_Tante if T==`t'
	  gen dHiv = BPH*BWH_1iv_T if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT0_BE1iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT0_BH1iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  * Efetivo C:
   gen dIQT1_BE1i = .        
   gen dIQT1_BE1ii = .        
   gen dIQT1_BE1iii = .        
   gen dIQT1_BE1iv = .        
   
  * Habitual: 
   gen dIQT1_BH1i = .        
   gen dIQT1_BH1ii = .        
   gen dIQT1_BH1iii = .        
   gen dIQT1_BH1iv = . 
  
   forvalues t = 2/`=Tmax'{
	* (i) Sem controles: 
	  gen nEi = BPE*BWE_1i_T if T==`t'
	  gen dEi = BPE*BWE_1i_Tprox if T==(`t'-1)
	  gen nHi = BPH*BWH_1i_T if T==`t'
	  gen dHi = BPH*BWH_1i_Tprox if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT1_BE1i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT1_BH1i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = BPE*BWE_1ii_T if T==`t'
	  gen dEii = BPE*BWE_1ii_Tprox if T==(`t'-1)
	  gen nHii = BPH*BWH_1ii_T if T==`t'
	  gen dHii = BPH*BWH_1ii_Tprox if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT1_BE1ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT1_BH1ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = BPE*BWE_1iii_T if T==`t'
	  gen dEiii = BPE*BWE_1iii_Tprox if T==(`t'-1)
	  gen nHiii = BPH*BWH_1iii_T if T==`t'
	  gen dHiii = BPH*BWH_1iii_Tprox if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT1_BE1iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT1_BH1iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = BPE*BWE_1iv_T if T==`t'
	  gen dEiv = BPE*BWE_1iv_Tprox if T==(`t'-1)
	  gen nHiv = BPH*BWH_1iv_T if T==`t'
	  gen dHiv = BPH*BWH_1iv_Tprox if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT1_BE1iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT1_BH1iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
   gen dIQT_BE1i = (dIQT0_BE1i*dIQT1_BE1i)^(1/2)
   gen dIQT_BH1i = (dIQT0_BH1i*dIQT1_BH1i)^(1/2)
   
   gen dIQT_BE1ii = (dIQT0_BE1ii*dIQT1_BE1ii)^(1/2)
   gen dIQT_BH1ii = (dIQT0_BH1ii*dIQT1_BH1ii)^(1/2)
  
   gen dIQT_BE1iii = (dIQT0_BE1iii*dIQT1_BE1iii)^(1/2)
   gen dIQT_BH1iii = (dIQT0_BH1iii*dIQT1_BH1iii)^(1/2)  
  
   gen dIQT_BE1iv = (dIQT0_BE1iv*dIQT1_BE1iv)^(1/2)
   gen dIQT_BH1iv = (dIQT0_BH1iv*dIQT1_BH1iv)^(1/2)
   
 
 save "$dirdata/D_BaseEstimacao.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T dIQT_BE1i dIQT_BE1ii dIQT_BE1iii dIQT_BE1iv dIQT_BH1i dIQT_BH1ii dIQT_BH1iii dIQT_BH1iv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * (i) Sem controles
     gen IQT_BE1i = 100 if T==2
     replace IQT_BE1i = IQT_BE1i[_n-1]*dIQT_BE1i if _n > 2
     label var IQT_BE1i "IQT Efetivo (B) - Sem pesos - Sem controles"

	 gen IQT_BH1i = 100 if T==2
     replace IQT_BH1i = IQT_BH1i[_n-1]*dIQT_BH1i if _n > 2
     label var IQT_BH1i "IQT Habitual (B) - Sem pesos - Sem controles"
	 
	 
   * (ii) Cor
     gen IQT_BE1ii = 100 if T==2
     replace IQT_BE1ii = IQT_BE1ii[_n-1]*dIQT_BE1ii if _n > 2
     label var IQT_BE1ii "IQT Efetivo (B) - Sem pesos - Cor"
	 
	 gen IQT_BH1ii = 100 if T==2
     replace IQT_BH1ii = IQT_BH1ii[_n-1]*dIQT_BH1ii if _n > 2
     label var IQT_BH1ii "IQT Habitual (B) - Sem pesos - Cor"
   
   
   * (iii) Setor público
     gen IQT_BE1iii = 100 if T==2
     replace IQT_BE1iii = IQT_BE1iii[_n-1]*dIQT_BE1iii if _n > 2
     label var IQT_BE1iii "IQT Efetivo (B) - Sem pesos - Setor público"
	 
	 gen IQT_BH1iii = 100 if T==2
     replace IQT_BH1iii = IQT_BH1iii[_n-1]*dIQT_BH1iii if _n > 2
     label var IQT_BH1iii "IQT Habitual (B) - Sem pesos - Setor público" 
	 
	 
   * (iv) Informal
     gen IQT_BE1iv = 100 if T==2
     replace IQT_BE1iv = IQT_BE1iv[_n-1]*dIQT_BE1iv if _n > 2
     label var IQT_BE1iv "IQT Efetivo (B) - Sem pesos - Informal"
	 
	 gen IQT_BH1iv = 100 if T==2
     replace IQT_BH1iv = IQT_BH1iv[_n-1]*dIQT_BH1iv if _n > 2
     label var IQT_BH1iv "IQT Habitual (B) - Sem pesos - Informal" 
   
   save "$dirdata/D_IQT.dta", replace
   restore
   }  
  
  } 
 

** 3.2: Estimações com peso ***************************************************
 {
 * IQT0
  * Efetivo:
   gen dIQT0_BE2i = .        
   gen dIQT0_BE2ii = .        
   gen dIQT0_BE2iii = .        
   gen dIQT0_BE2iv = .          
   
  * Habitual: 
   gen dIQT0_BH2i = .        
   gen dIQT0_BH2ii = .        
   gen dIQT0_BH2iii = .        
   gen dIQT0_BH2iv = .    


   forvalues t = 2/`=Tmax'{
   * (i) Sem controles: 
	  gen nEi = BPE*BWE_2i_Tante if T==`t'
	  gen dEi = BPE*BWE_2i_T if T==(`t'-1)
	  gen nHi = BPH*BWH_2i_Tante if T==`t'
	  gen dHi = BPH*BWH_2i_T if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT0_BE2i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT0_BH2i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = BPE*BWE_2ii_Tante if T==`t'
	  gen dEii = BPE*BWE_2ii_T if T==(`t'-1)
	  gen nHii = BPH*BWH_2ii_Tante if T==`t'
	  gen dHii = BPH*BWH_2ii_T if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT0_BE2ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT0_BH2ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = BPE*BWE_2iii_Tante if T==`t'
	  gen dEiii = BPE*BWE_2iii_T if T==(`t'-1)
	  gen nHiii = BPH*BWH_2iii_Tante if T==`t'
	  gen dHiii = BPH*BWH_2iii_T if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT0_BE2iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT0_BH2iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = BPE*BWE_2iv_Tante if T==`t'
	  gen dEiv = BPE*BWE_2iv_T if T==(`t'-1)
	  gen nHiv = BPH*BWH_2iv_Tante if T==`t'
	  gen dHiv = BPH*BWH_2iv_T if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT0_BE2iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT0_BH2iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  * Efetivo C:
   gen dIQT1_BE2i = .        
   gen dIQT1_BE2ii = .        
   gen dIQT1_BE2iii = .        
   gen dIQT1_BE2iv = .        
   
  * Habitual: 
   gen dIQT1_BH2i = .        
   gen dIQT1_BH2ii = .        
   gen dIQT1_BH2iii = .        
   gen dIQT1_BH2iv = . 
  
   forvalues t = 2/`=Tmax'{
	* (i) Sem controles: 
	  gen nEi = BPE*BWE_2i_T if T==`t'
	  gen dEi = BPE*BWE_2i_Tprox if T==(`t'-1)
	  gen nHi = BPH*BWH_2i_T if T==`t'
	  gen dHi = BPH*BWH_2i_Tprox if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT1_BE2i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT1_BH2i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nHi dHi sum_nEi sum_dEi sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = BPE*BWE_2ii_T if T==`t'
	  gen dEii = BPE*BWE_2ii_Tprox if T==(`t'-1)
	  gen nHii = BPH*BWH_2ii_T if T==`t'
	  gen dHii = BPH*BWH_2ii_Tprox if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT1_BE2ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT1_BH2ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nHii dHii sum_nEii sum_dEii sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = BPE*BWE_2iii_T if T==`t'
	  gen dEiii = BPE*BWE_2iii_Tprox if T==(`t'-1)
	  gen nHiii = BPH*BWH_2iii_T if T==`t'
	  gen dHiii = BPH*BWH_2iii_Tprox if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT1_BE2iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT1_BH2iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nHiii dHiii sum_nEiii sum_dEiii sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = BPE*BWE_2iv_T if T==`t'
	  gen dEiv = BPE*BWE_2iv_Tprox if T==(`t'-1)
	  gen nHiv = BPH*BWH_2iv_T if T==`t'
	  gen dHiv = BPH*BWH_2iv_Tprox if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT1_BE2iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT1_BH2iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nHiv dHiv sum_nEiv sum_dEiv sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
   gen dIQT_BE2i = (dIQT0_BE2i*dIQT1_BE2i)^(1/2)
   gen dIQT_BH2i = (dIQT0_BH2i*dIQT1_BH2i)^(1/2)
   
   gen dIQT_BE2ii = (dIQT0_BE2ii*dIQT1_BE2ii)^(1/2)
   gen dIQT_BH2ii = (dIQT0_BH2ii*dIQT1_BH2ii)^(1/2)
  
   gen dIQT_BE2iii = (dIQT0_BE2iii*dIQT1_BE2iii)^(1/2)
   gen dIQT_BH2iii = (dIQT0_BH2iii*dIQT1_BH2iii)^(1/2)  
  
   gen dIQT_BE2iv = (dIQT0_BE2iv*dIQT1_BE2iv)^(1/2)
   gen dIQT_BH2iv = (dIQT0_BH2iv*dIQT1_BH2iv)^(1/2)
   
 
 save "$dirdata/D_BaseEstimacao.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T dIQT_BE2i dIQT_BE2ii dIQT_BE2iii dIQT_BE2iv dIQT_BH2i dIQT_BH2ii dIQT_BH2iii dIQT_BH2iv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * (i) Sem controles
     gen IQT_BE2i = 100 if T==2
     replace IQT_BE2i = IQT_BE2i[_n-1]*dIQT_BE2i if _n > 2
     label var IQT_BE2i "IQT Efetivo (B) - Com pesos - Sem controles"

	 gen IQT_BH2i = 100 if T==2
     replace IQT_BH2i = IQT_BH2i[_n-1]*dIQT_BH2i if _n > 2
     label var IQT_BH2i "IQT Habitual (B) - Com pesos - Sem controles"
	 
	 
   * (ii) Cor
     gen IQT_BE2ii = 100 if T==2
     replace IQT_BE2ii = IQT_BE2ii[_n-1]*dIQT_BE2ii if _n > 2
     label var IQT_BE2ii "IQT Efetivo (B) - Com pesos - Cor"
	 
	 gen IQT_BH2ii = 100 if T==2
     replace IQT_BH2ii = IQT_BH2ii[_n-1]*dIQT_BH2ii if _n > 2
     label var IQT_BH2ii "IQT Habitual (B) - Com pesos - Cor"
   
   
   * (iii) Setor público
     gen IQT_BE2iii = 100 if T==2
     replace IQT_BE2iii = IQT_BE2iii[_n-1]*dIQT_BE2iii if _n > 2
     label var IQT_BE2iii "IQT Efetivo (B) - Com pesos - Setor público"
	 
	 gen IQT_BH2iii = 100 if T==2
     replace IQT_BH2iii = IQT_BH2iii[_n-1]*dIQT_BH2iii if _n > 2
     label var IQT_BH2iii "IQT Habitual (B) - Com pesos - Setor público" 
	 
	 
   * (iv) Informal
     gen IQT_BE2iv = 100 if T==2
     replace IQT_BE2iv = IQT_BE2iv[_n-1]*dIQT_BE2iv if _n > 2
     label var IQT_BE2iv "IQT Efetivo (B) - Com pesos - Informal"
	 
	 gen IQT_BH2iv = 100 if T==2
     replace IQT_BH2iv = IQT_BH2iv[_n-1]*dIQT_BH2iv if _n > 2
     label var IQT_BH2iv "IQT Habitual (B) - Com pesos - Informal" 
   
   
   merge 1:1 T using "$dirdata/D_IQT.dta"
   drop _merge
   save "$dirdata/D_IQT.dta", replace
   restore
   }  
  
  } 
 
}


}   
  

*** Rodar a partir daqui!  
  
*******************************************************************************
* ESTRATÉGIA C
*******************************************************************************  
{  
* Descrição: imputação das horas habituais para os indivíduos com horas efetivas nulas para o cálculo do salário-hora 
*            duas versões (efetivo): C     - horas habituais imputadas na regressão e no peso do IQT
*                                    C_alt - horas habituais imputadas apenas na regressão; horas efetivas nulas no peso do IQT  


*******************************************************************************
* 1. RETORNOS + SALÁRIOS PREDITOS *********************************************
{
** 1.1: Estimações sem peso ***************************************************
 {             
*** ESTIMAÇÃO 
  {
   forvalues t = 1/`=Tmax' {     
   * (i) Sem controles: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	 predict CRegLogE_1i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1i_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	 predict CRegLogH_1i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1i_Habitual", append
	
	
   * (ii) Cor: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t'
	 predict CRegLogE_1ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1ii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t'
	 predict CRegLogH_1ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1ii_Habitual", append

	 
   * (iii) Setor público: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t'
	 predict CRegLogE_1iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1iii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t'
	 predict CRegLogH_1iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1iii_Habitual", append
	  
	  
   * (iv) Setor informal: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t'
	 predict CRegLogE_1iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1iv_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t'
	 predict CRegLogH_1iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C1iv_Habitual", append
  
    estimates clear
   }
   estimates clear	 			
  } 

*** SALÁRIOS PREDITOS
  { 
  * Exponencial + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
   * (i) Sem controles
	  gen CRegWE_1i_`t' = exp(CRegLogE_1i_`t')	  
	  gen CRegWH_1i_`t' = exp(CRegLogH_1i_`t')	  
	  
   * (ii) Cor 
	  gen CRegWE_1ii_`t' = exp(CRegLogE_1ii_`t')	  
	  gen CRegWH_1ii_`t' = exp(CRegLogH_1ii_`t')	  
	  
   * (iii) Setor público 
	  gen CRegWE_1iii_`t' = exp(CRegLogE_1iii_`t')
	  gen CRegWH_1iii_`t' = exp(CRegLogH_1iii_`t')
	 
   * (iv) Informal
	  gen CRegWE_1iv_`t' = exp(CRegLogE_1iv_`t')	 
	  gen CRegWH_1iv_`t' = exp(CRegLogH_1iv_`t')	
	 
	 drop CRegLogE_1i_`t' CRegLogE_1ii_`t' CRegLogE_1iii_`t' CRegLogE_1iv_`t' CRegLogH_1i_`t' CRegLogH_1ii_`t' CRegLogH_1iii_`t' CRegLogH_1iv_`t'
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - W_T     = salários em t preditos pelos coeficientes estimados de t
	- W_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- W_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
* (i) Sem controles:  
   gen CWE_1i_T = .
   gen CWE_1i_Tante = .
   gen CWE_1i_Tprox = .
   
   gen CWH_1i_T = .
   gen CWH_1i_Tante = .
   gen CWH_1i_Tprox = .
   
* (ii) Cor:
   gen CWE_1ii_T = .
   gen CWE_1ii_Tante = .
   gen CWE_1ii_Tprox = .
   
   gen CWH_1ii_T = .
   gen CWH_1ii_Tante = .
   gen CWH_1ii_Tprox = .
   
* (iii) Setor publico: 
   gen CWE_1iii_T = .
   gen CWE_1iii_Tante = .
   gen CWE_1iii_Tprox = .
   
   gen CWH_1iii_T = .
   gen CWH_1iii_Tante = .
   gen CWH_1iii_Tprox = .
   
* (iv) Informal
   gen CWE_1iv_T = .
   gen CWE_1iv_Tante = .
   gen CWE_1iv_Tprox = .
   
   gen CWH_1iv_T = .
   gen CWH_1iv_Tante = .
   gen CWH_1iv_Tprox = .
   
   
   forvalues t = 1/`=Tmax' {
      replace CWE_1i_T = CRegWE_1i_`t' if T==`t'
	  replace CWH_1i_T = CRegWH_1i_`t' if T==`t'
	  
	  replace CWE_1ii_T = CRegWE_1ii_`t' if T==`t'
	  replace CWH_1ii_T = CRegWH_1ii_`t' if T==`t'
	  
	  replace CWE_1iii_T = CRegWE_1iii_`t' if T==`t'
	  replace CWH_1iii_T = CRegWH_1iii_`t' if T==`t'
	  
      replace CWE_1iv_T = CRegWE_1iv_`t' if T==`t'
	  replace CWH_1iv_T = CRegWH_1iv_`t' if T==`t'
	  
	  
	  local i = `t'-1
	  if `t' > 1 replace CWE_1i_Tante = CRegWE_1i_`i' if T==`t'
	  if `t' > 1 replace CWH_1i_Tante = CRegWH_1i_`i' if T==`t'
	  
	  if `t' > 1 replace CWE_1ii_Tante = CRegWE_1ii_`i' if T==`t'
	  if `t' > 1 replace CWH_1ii_Tante = CRegWH_1ii_`i' if T==`t'
	  
	  if `t' > 1 replace CWE_1iii_Tante = CRegWE_1iii_`i' if T==`t'
	  if `t' > 1 replace CWH_1iii_Tante = CRegWH_1iii_`i' if T==`t'	  
	  
	  if `t' > 1 replace CWE_1iv_Tante = CRegWE_1iv_`i' if T==`t'
	  if `t' > 1 replace CWH_1iv_Tante = CRegWH_1iv_`i' if T==`t'	 
	 
	 
	  local j = `t'+1 
	  if `t' < `=Tmax' replace CWE_1i_Tprox = CRegWE_1i_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_1i_Tprox = CRegWH_1i_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace CWE_1ii_Tprox = CRegWE_1ii_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_1ii_Tprox = CRegWH_1ii_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace CWE_1iii_Tprox = CRegWE_1iii_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_1iii_Tprox = CRegWH_1iii_`j' if T==`t'	  
	  
	  if `t' < `=Tmax' replace CWE_1iv_Tprox = CRegWE_1iv_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_1iv_Tprox = CRegWH_1iv_`j' if T==`t'
   }
 

 * Excluindo os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop CRegWE_1i_`t' CRegWH_1i_`t' CRegWE_1ii_`t' CRegWH_1ii_`t' CRegWE_1iii_`t' CRegWH_1iii_`t' CRegWE_1iv_`t' CRegWH_1iv_`t' 
   }  
 
   save "$dirdata/D_BaseEstimacao.dta", replace
   }
 } 
 
** 1.2: Estimações com peso ***************************************************
 {             
*** ESTIMAÇÃO 
  {
   forvalues t = 1/`=Tmax' {     
   * (i) Sem controles: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	 predict CRegLogE_2i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2i_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' [iw = Peso]
	 predict CRegLogH_2i_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2i_Habitual", append
	
	
   * (ii) Cor: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	 predict CRegLogE_2ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2ii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig if T==`t' [iw = Peso]
	 predict CRegLogH_2ii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2ii_Habitual", append

	 
   * (iii) Setor público: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	 predict CRegLogE_2iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2iii_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico if T==`t' [iw = Peso]
	 predict CRegLogH_2iii_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2iii_Habitual", append
	  
	  
   * (iv) Setor informal: 
    * Efetivo:
	 regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	 predict CRegLogE_2iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2iv_Efetivo", append
	 
    * Habitual:
	 regress logW_hab_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 PretoPardoIndig publico informal if T==`t' [iw = Peso]
	 predict CRegLogH_2iv_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	 estimates save "$dirdata/Regressões/C2iv_Habitual", append
  
    estimates clear
   }
   estimates clear	 			
  } 

*** SALÁRIOS PREDITOS
  { 
  * Exponencial + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
   * (i) Sem controles
	  gen CRegWE_2i_`t' = exp(CRegLogE_2i_`t')	  
	  gen CRegWH_2i_`t' = exp(CRegLogH_2i_`t')	  
	  
   * (ii) Cor 
	  gen CRegWE_2ii_`t' = exp(CRegLogE_2ii_`t')	  
	  gen CRegWH_2ii_`t' = exp(CRegLogH_2ii_`t')	  
	  
   * (iii) Setor público 
	  gen CRegWE_2iii_`t' = exp(CRegLogE_2iii_`t')
	  gen CRegWH_2iii_`t' = exp(CRegLogH_2iii_`t')
	 
   * (iv) Informal
	  gen CRegWE_2iv_`t' = exp(CRegLogE_2iv_`t')	 
	  gen CRegWH_2iv_`t' = exp(CRegLogH_2iv_`t')	
	 
	 drop CRegLogE_2i_`t' CRegLogE_2ii_`t' CRegLogE_2iii_`t' CRegLogE_2iv_`t' CRegLogH_2i_`t' CRegLogH_2ii_`t' CRegLogH_2iii_`t' CRegLogH_2iv_`t'
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - W_T     = salários em t preditos pelos coeficientes estimados de t
	- W_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- W_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
* (i) Sem controles:  
   gen CWE_2i_T = .
   gen CWE_2i_Tante = .
   gen CWE_2i_Tprox = .
   
   gen CWH_2i_T = .
   gen CWH_2i_Tante = .
   gen CWH_2i_Tprox = .
   
* (ii) Cor:
   gen CWE_2ii_T = .
   gen CWE_2ii_Tante = .
   gen CWE_2ii_Tprox = .
   
   gen CWH_2ii_T = .
   gen CWH_2ii_Tante = .
   gen CWH_2ii_Tprox = .
   
* (iii) Setor publico: 
   gen CWE_2iii_T = .
   gen CWE_2iii_Tante = .
   gen CWE_2iii_Tprox = .
   
   gen CWH_2iii_T = .
   gen CWH_2iii_Tante = .
   gen CWH_2iii_Tprox = .
   
* (iv) Informal
   gen CWE_2iv_T = .
   gen CWE_2iv_Tante = .
   gen CWE_2iv_Tprox = .
   
   gen CWH_2iv_T = .
   gen CWH_2iv_Tante = .
   gen CWH_2iv_Tprox = .
   
   
   forvalues t = 1/`=Tmax' {
      replace CWE_2i_T = CRegWE_2i_`t' if T==`t'
	  replace CWH_2i_T = CRegWH_2i_`t' if T==`t'
	  
	  replace CWE_2ii_T = CRegWE_2ii_`t' if T==`t'
	  replace CWH_2ii_T = CRegWH_2ii_`t' if T==`t'
	  
	  replace CWE_2iii_T = CRegWE_2iii_`t' if T==`t'
	  replace CWH_2iii_T = CRegWH_2iii_`t' if T==`t'
	  
      replace CWE_2iv_T = CRegWE_2iv_`t' if T==`t'
	  replace CWH_2iv_T = CRegWH_2iv_`t' if T==`t'
	  
	  
	  local i = `t'-1
	  if `t' > 1 replace CWE_2i_Tante = CRegWE_2i_`i' if T==`t'
	  if `t' > 1 replace CWH_2i_Tante = CRegWH_2i_`i' if T==`t'
	  
	  if `t' > 1 replace CWE_2ii_Tante = CRegWE_2ii_`i' if T==`t'
	  if `t' > 1 replace CWH_2ii_Tante = CRegWH_2ii_`i' if T==`t'
	  
	  if `t' > 1 replace CWE_2iii_Tante = CRegWE_2iii_`i' if T==`t'
	  if `t' > 1 replace CWH_2iii_Tante = CRegWH_2iii_`i' if T==`t'	  
	  
	  if `t' > 1 replace CWE_2iv_Tante = CRegWE_2iv_`i' if T==`t'
	  if `t' > 1 replace CWH_2iv_Tante = CRegWH_2iv_`i' if T==`t'	 
	 
	 
	  local j = `t'+1 
	  if `t' < `=Tmax' replace CWE_2i_Tprox = CRegWE_2i_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_2i_Tprox = CRegWH_2i_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace CWE_2ii_Tprox = CRegWE_2ii_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_2ii_Tprox = CRegWH_2ii_`j' if T==`t'
	  
	  if `t' < `=Tmax' replace CWE_2iii_Tprox = CRegWE_2iii_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_2iii_Tprox = CRegWH_2iii_`j' if T==`t'	  
	  
	  if `t' < `=Tmax' replace CWE_2iv_Tprox = CRegWE_2iv_`j' if T==`t'
	  if `t' < `=Tmax' replace CWH_2iv_Tprox = CRegWH_2iv_`j' if T==`t'
   }
 

 * Excluindo os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop CRegWE_2i_`t' CRegWH_2i_`t' CRegWE_2ii_`t' CRegWH_2ii_`t' CRegWE_2iii_`t' CRegWH_2iii_`t' CRegWE_2iv_`t' CRegWH_2iv_`t' 
   }  
 
   save "$dirdata/D_BaseEstimacao.dta", replace
   }
 }    
}  


*******************************************************************************
* 2. PESOS ********************************************************************
{
 * EFETIVO:
   bysort T VD3006 Experiencia: egen CHE = mean(VD4035_imput)
   label var CHE "Horas efetivas médias por grupo de educação e experiência para cada trimestre (C)"

  * Peso ajustado por hora:
   gen CPEi = Peso*CHE
   bysort T: egen CPEt = sum(CPEi)
   gen CPE = CPEi/CPEt
   label var CPE "Peso para cálculo do IQT de rendimento efetivo (C)"
   
   order CPE, after(Peso) 
   drop CPEi CPEt
   
   
 * EFETIVO ALT:
   bysort T VD3006 Experiencia: egen CHE_alt = mean(VD4035)
   label var CHE_alt "Horas efetivas médias por grupo de educação e experiência para cada trimestre (C_alt)"

  * Peso ajustado por hora:
   gen CPEi_alt = Peso*CHE_alt
   bysort T: egen CPEt_alt = sum(CPEi_alt)
   gen CPE_alt = CPEi_alt/CPEt_alt
   label var CPE_alt "Peso para cálculo do IQT de rendimento efetivo (C_alt)"
   
   order CPE_alt, after(CPE) 
   drop CPEi_alt CPEt_alt
   
   
 * HABITUAL:
   bysort T VD3006 Experiencia: egen CHH = mean(VD4031)
   label var CHH "Horas habituais médias por grupo de educação e experiência para cada trimestre (C)"

  * Peso ajustado por hora:
   gen CPHi = Peso*CHH
   bysort T: egen CPHt = sum(CPHi)
   gen CPH = CPHi/CPHt
   label var CPH "Peso para cálculo do IQT de rendimento habitual (C)"
   
   order CPH, after(CPE_alt) 
   drop CPHi CPHt
   
   save "$dirdata/D_BaseEstimacao.dta", replace
} 


*******************************************************************************
* 3. IQT **********************************************************************
{
** 3.1: Estimações sem peso ***************************************************
 {
 * IQT0
  * Efetivo C:
   gen dIQT0_CE1i = .        
   gen dIQT0_CE1ii = .        
   gen dIQT0_CE1iii = .        
   gen dIQT0_CE1iv = .        
  
  * Efetivo C_alt:   
   gen dIQT0_CE1i_alt = .        
   gen dIQT0_CE1ii_alt = .        
   gen dIQT0_CE1iii_alt = .        
   gen dIQT0_CE1iv_alt = .   
   
  * Habitual: 
   gen dIQT0_CH1i = .        
   gen dIQT0_CH1ii = .        
   gen dIQT0_CH1iii = .        
   gen dIQT0_CH1iv = .    

  
   forvalues t = 2/`=Tmax'{
   * (i) Sem controles: 
	  gen nEi = CPE*CWE_1i_Tante if T==`t'
	  gen dEi = CPE*CWE_1i_T if T==(`t'-1)
	  gen nEi_alt = CPE_alt*CWE_1i_Tante if T==`t'
	  gen dEi_alt = CPE_alt*CWE_1i_T if T==(`t'-1)
	  gen nHi = CPH*CWH_1i_Tante if T==`t'
	  gen dHi = CPH*CWH_1i_T if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nEi_alt = sum(nEi_alt)
	  egen sum_dEi_alt = sum(dEi_alt)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT0_CE1i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT0_CE1i_alt = sum_nEi_alt/sum_dEi_alt if T==`t'
	  replace dIQT0_CH1i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nEi_alt dEi_alt nHi dHi sum_nEi sum_dEi sum_nEi_alt sum_dEi_alt sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = CPE*CWE_1ii_Tante if T==`t'
	  gen dEii = CPE*CWE_1ii_T if T==(`t'-1)
	  gen nEii_alt = CPE_alt*CWE_1ii_Tante if T==`t'
	  gen dEii_alt = CPE_alt*CWE_1ii_T if T==(`t'-1)
	  gen nHii = CPH*CWH_1ii_Tante if T==`t'
	  gen dHii = CPH*CWH_1ii_T if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nEii_alt = sum(nEii_alt)
	  egen sum_dEii_alt = sum(dEii_alt)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT0_CE1ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT0_CE1ii_alt = sum_nEii_alt/sum_dEii_alt if T==`t'
	  replace dIQT0_CH1ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nEii_alt dEii_alt nHii dHii sum_nEii sum_dEii sum_nEii_alt sum_dEii_alt sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = CPE*CWE_1iii_Tante if T==`t'
	  gen dEiii = CPE*CWE_1iii_T if T==(`t'-1)
	  gen nEiii_alt = CPE_alt*CWE_1iii_Tante if T==`t'
	  gen dEiii_alt = CPE_alt*CWE_1iii_T if T==(`t'-1)
	  gen nHiii = CPH*CWH_1iii_Tante if T==`t'
	  gen dHiii = CPH*CWH_1iii_T if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nEiii_alt = sum(nEiii_alt)
	  egen sum_dEiii_alt = sum(dEiii_alt)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT0_CE1iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT0_CE1iii_alt = sum_nEiii_alt/sum_dEiii_alt if T==`t'
	  replace dIQT0_CH1iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nEiii_alt dEiii_alt nHiii dHiii sum_nEiii sum_dEiii sum_nEiii_alt sum_dEiii_alt sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = CPE*CWE_1iv_Tante if T==`t'
	  gen dEiv = CPE*CWE_1iv_T if T==(`t'-1)
	  gen nEiv_alt = CPE_alt*CWE_1iv_Tante if T==`t'
	  gen dEiv_alt = CPE_alt*CWE_1iv_T if T==(`t'-1)
	  gen nHiv = CPH*CWH_1iv_Tante if T==`t'
	  gen dHiv = CPH*CWH_1iv_T if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nEiv_alt = sum(nEiv_alt)
	  egen sum_dEiv_alt = sum(dEiv_alt)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT0_CE1iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT0_CE1iv_alt = sum_nEiv_alt/sum_dEiv_alt if T==`t'
	  replace dIQT0_CH1iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nEiv_alt dEiv_alt nHiv dHiv sum_nEiv sum_dEiv sum_nEiv_alt sum_dEiv_alt sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  * Efetivo C:
   gen dIQT1_CE1i = .        
   gen dIQT1_CE1ii = .        
   gen dIQT1_CE1iii = .        
   gen dIQT1_CE1iv = .        
  
  * Efetivo C_alt:   
   gen dIQT1_CE1i_alt = .        
   gen dIQT1_CE1ii_alt = .        
   gen dIQT1_CE1iii_alt = .        
   gen dIQT1_CE1iv_alt = .   
   
  * Habitual: 
   gen dIQT1_CH1i = .        
   gen dIQT1_CH1ii = .        
   gen dIQT1_CH1iii = .        
   gen dIQT1_CH1iv = . 
  
   forvalues t = 2/`=Tmax'{
	* (i) Sem controles: 
	  gen nEi = CPE*CWE_1i_T if T==`t'
	  gen dEi = CPE*CWE_1i_Tprox if T==(`t'-1)
	  gen nEi_alt = CPE_alt*CWE_1i_T if T==`t'
	  gen dEi_alt = CPE_alt*CWE_1i_Tprox if T==(`t'-1)
	  gen nHi = CPH*CWH_1i_T if T==`t'
	  gen dHi = CPH*CWH_1i_Tprox if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nEi_alt = sum(nEi_alt)
	  egen sum_dEi_alt = sum(dEi_alt)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT1_CE1i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT1_CE1i_alt = sum_nEi_alt/sum_dEi_alt if T==`t'
	  replace dIQT1_CH1i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nEi_alt dEi_alt nHi dHi sum_nEi sum_dEi sum_nEi_alt sum_dEi_alt sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = CPE*CWE_1ii_T if T==`t'
	  gen dEii = CPE*CWE_1ii_Tprox if T==(`t'-1)
	  gen nEii_alt = CPE_alt*CWE_1ii_T if T==`t'
	  gen dEii_alt = CPE_alt*CWE_1ii_Tprox if T==(`t'-1)
	  gen nHii = CPH*CWH_1ii_T if T==`t'
	  gen dHii = CPH*CWH_1ii_Tprox if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nEii_alt = sum(nEii_alt)
	  egen sum_dEii_alt = sum(dEii_alt)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT1_CE1ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT1_CE1ii_alt = sum_nEii_alt/sum_dEii_alt if T==`t'
	  replace dIQT1_CH1ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nEii_alt dEii_alt nHii dHii sum_nEii sum_dEii sum_nEii_alt sum_dEii_alt sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = CPE*CWE_1iii_T if T==`t'
	  gen dEiii = CPE*CWE_1iii_Tprox if T==(`t'-1)
	  gen nEiii_alt = CPE_alt*CWE_1iii_T if T==`t'
	  gen dEiii_alt = CPE_alt*CWE_1iii_Tprox if T==(`t'-1)
	  gen nHiii = CPH*CWH_1iii_T if T==`t'
	  gen dHiii = CPH*CWH_1iii_Tprox if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nEiii_alt = sum(nEiii_alt)
	  egen sum_dEiii_alt = sum(dEiii_alt)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT1_CE1iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT1_CE1iii_alt = sum_nEiii_alt/sum_dEiii_alt if T==`t'
	  replace dIQT1_CH1iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nEiii_alt dEiii_alt nHiii dHiii sum_nEiii sum_dEiii sum_nEiii_alt sum_dEiii_alt sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = CPE*CWE_1iv_T if T==`t'
	  gen dEiv = CPE*CWE_1iv_Tprox if T==(`t'-1)
	  gen nEiv_alt = CPE_alt*CWE_1iv_T if T==`t'
	  gen dEiv_alt = CPE_alt*CWE_1iv_Tprox if T==(`t'-1)
	  gen nHiv = CPH*CWH_1iv_T if T==`t'
	  gen dHiv = CPH*CWH_1iv_Tprox if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nEiv_alt = sum(nEiv_alt)
	  egen sum_dEiv_alt = sum(dEiv_alt)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT1_CE1iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT1_CE1iv_alt = sum_nEiv_alt/sum_dEiv_alt if T==`t'
	  replace dIQT1_CH1iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nEiv_alt dEiv_alt nHiv dHiv sum_nEiv sum_dEiv sum_nEiv_alt sum_dEiv_alt sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
   gen dIQT_CE1i = (dIQT0_CE1i*dIQT1_CE1i)^(1/2)
   gen dIQT_CE1i_alt = (dIQT0_CE1i_alt*dIQT1_CE1i_alt)^(1/2)
   gen dIQT_CH1i = (dIQT0_CH1i*dIQT1_CH1i)^(1/2)
   
   gen dIQT_CE1ii = (dIQT0_CE1ii*dIQT1_CE1ii)^(1/2)
   gen dIQT_CE1ii_alt = (dIQT0_CE1ii_alt*dIQT1_CE1ii_alt)^(1/2)
   gen dIQT_CH1ii = (dIQT0_CH1ii*dIQT1_CH1ii)^(1/2)
  
   gen dIQT_CE1iii = (dIQT0_CE1iii*dIQT1_CE1iii)^(1/2)
   gen dIQT_CE1iii_alt = (dIQT0_CE1iii_alt*dIQT1_CE1iii_alt)^(1/2)
   gen dIQT_CH1iii = (dIQT0_CH1iii*dIQT1_CH1iii)^(1/2)  
  
   gen dIQT_CE1iv = (dIQT0_CE1iv*dIQT1_CE1iv)^(1/2)
   gen dIQT_CE1iv_alt = (dIQT0_CE1iv_alt*dIQT1_CE1iv_alt)^(1/2)
   gen dIQT_CH1iv = (dIQT0_CH1iv*dIQT1_CH1iv)^(1/2)
   
 
 save "$dirdata/D_BaseEstimacao.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T dIQT_CE1i dIQT_CE1ii dIQT_CE1iii dIQT_CE1iv dIQT_CE1i_alt dIQT_CE1ii_alt dIQT_CE1iii_alt dIQT_CE1iv_alt dIQT_CH1i dIQT_CH1ii dIQT_CH1iii dIQT_CH1iv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * (i) Sem controles
     gen IQT_CE1i = 100 if T==2
     replace IQT_CE1i = IQT_CE1i[_n-1]*dIQT_CE1i if _n > 2
     label var IQT_CE1i "IQT Efetivo (C) - Sem pesos - Sem controles"
   
     gen IQT_CE1i_alt = 100 if T==2
     replace IQT_CE1i_alt = IQT_CE1i_alt[_n-1]*dIQT_CE1i_alt if _n > 2
     label var IQT_CE1i_alt "IQT Efetivo (C_alt) - Sem pesos - Sem controles"
	 
	 gen IQT_CH1i = 100 if T==2
     replace IQT_CH1i = IQT_CH1i[_n-1]*dIQT_CH1i if _n > 2
     label var IQT_CH1i "IQT Habitual (C) - Sem pesos - Sem controles"
	 
	 
   * (ii) Cor
     gen IQT_CE1ii = 100 if T==2
     replace IQT_CE1ii = IQT_CE1ii[_n-1]*dIQT_CE1ii if _n > 2
     label var IQT_CE1ii "IQT Efetivo (C) - Sem pesos - Cor"
   
     gen IQT_CE1ii_alt = 100 if T==2
     replace IQT_CE1ii_alt = IQT_CE1ii_alt[_n-1]*dIQT_CE1ii_alt if _n > 2
     label var IQT_CE1ii_alt "IQT Efetivo (C_alt) - Sem pesos - Cor"
	 
	 gen IQT_CH1ii = 100 if T==2
     replace IQT_CH1ii = IQT_CH1ii[_n-1]*dIQT_CH1ii if _n > 2
     label var IQT_CH1ii "IQT Habitual (C) - Sem pesos - Cor"
   
   
   * (iii) Setor público
     gen IQT_CE1iii = 100 if T==2
     replace IQT_CE1iii = IQT_CE1iii[_n-1]*dIQT_CE1iii if _n > 2
     label var IQT_CE1iii "IQT Efetivo (C) - Sem pesos - Setor público"
   
     gen IQT_CE1iii_alt = 100 if T==2
     replace IQT_CE1iii_alt = IQT_CE1iii_alt[_n-1]*dIQT_CE1iii_alt if _n > 2
     label var IQT_CE1iii_alt "IQT Efetivo (C_alt) - Sem pesos - Setor público"
	 
	 gen IQT_CH1iii = 100 if T==2
     replace IQT_CH1iii = IQT_CH1iii[_n-1]*dIQT_CH1iii if _n > 2
     label var IQT_CH1iii "IQT Habitual (C) - Sem pesos - Setor público" 
	 
	 
   * (iv) Informal
     gen IQT_CE1iv = 100 if T==2
     replace IQT_CE1iv = IQT_CE1iv[_n-1]*dIQT_CE1iv if _n > 2
     label var IQT_CE1iv "IQT Efetivo (C) - Sem pesos - Informal"
   
     gen IQT_CE1iv_alt = 100 if T==2
     replace IQT_CE1iv_alt = IQT_CE1iv_alt[_n-1]*dIQT_CE1iv_alt if _n > 2
     label var IQT_CE1iv_alt "IQT Efetivo (C_alt) - Sem pesos - Informal"
	 
	 gen IQT_CH1iv = 100 if T==2
     replace IQT_CH1iv = IQT_CH1iv[_n-1]*dIQT_CH1iv if _n > 2
     label var IQT_CH1iv "IQT Habitual (C) - Sem pesos - Informal" 
   
   
   merge 1:1 T using "$dirdata/D_IQT.dta"
   drop _merge
   save "$dirdata/D_IQT.dta", replace
   restore
   }  
  
 } 
 

** 3.2: Estimações com peso ***************************************************
 {
 * IQT0
  * Efetivo C:
   gen dIQT0_CE2i = .        
   gen dIQT0_CE2ii = .        
   gen dIQT0_CE2iii = .        
   gen dIQT0_CE2iv = .        
  
  * Efetivo C_alt:   
   gen dIQT0_CE2i_alt = .        
   gen dIQT0_CE2ii_alt = .        
   gen dIQT0_CE2iii_alt = .        
   gen dIQT0_CE2iv_alt = .   
   
  * Habitual: 
   gen dIQT0_CH2i = .        
   gen dIQT0_CH2ii = .        
   gen dIQT0_CH2iii = .        
   gen dIQT0_CH2iv = .    

  
   forvalues t = 2/`=Tmax'{
   * (i) Sem controles: 
	  gen nEi = CPE*CWE_2i_Tante if T==`t'
	  gen dEi = CPE*CWE_2i_T if T==(`t'-1)
	  gen nEi_alt = CPE_alt*CWE_2i_Tante if T==`t'
	  gen dEi_alt = CPE_alt*CWE_2i_T if T==(`t'-1)
	  gen nHi = CPH*CWH_2i_Tante if T==`t'
	  gen dHi = CPH*CWH_2i_T if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nEi_alt = sum(nEi_alt)
	  egen sum_dEi_alt = sum(dEi_alt)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT0_CE2i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT0_CE2i_alt = sum_nEi_alt/sum_dEi_alt if T==`t'
	  replace dIQT0_CH2i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nEi_alt dEi_alt nHi dHi sum_nEi sum_dEi sum_nEi_alt sum_dEi_alt sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = CPE*CWE_2ii_Tante if T==`t'
	  gen dEii = CPE*CWE_2ii_T if T==(`t'-1)
	  gen nEii_alt = CPE_alt*CWE_2ii_Tante if T==`t'
	  gen dEii_alt = CPE_alt*CWE_2ii_T if T==(`t'-1)
	  gen nHii = CPH*CWH_2ii_Tante if T==`t'
	  gen dHii = CPH*CWH_2ii_T if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nEii_alt = sum(nEii_alt)
	  egen sum_dEii_alt = sum(dEii_alt)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT0_CE2ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT0_CE2ii_alt = sum_nEii_alt/sum_dEii_alt if T==`t'
	  replace dIQT0_CH2ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nEii_alt dEii_alt nHii dHii sum_nEii sum_dEii sum_nEii_alt sum_dEii_alt sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = CPE*CWE_2iii_Tante if T==`t'
	  gen dEiii = CPE*CWE_2iii_T if T==(`t'-1)
	  gen nEiii_alt = CPE_alt*CWE_2iii_Tante if T==`t'
	  gen dEiii_alt = CPE_alt*CWE_2iii_T if T==(`t'-1)
	  gen nHiii = CPH*CWH_2iii_Tante if T==`t'
	  gen dHiii = CPH*CWH_2iii_T if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nEiii_alt = sum(nEiii_alt)
	  egen sum_dEiii_alt = sum(dEiii_alt)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT0_CE2iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT0_CE2iii_alt = sum_nEiii_alt/sum_dEiii_alt if T==`t'
	  replace dIQT0_CH2iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nEiii_alt dEiii_alt nHiii dHiii sum_nEiii sum_dEiii sum_nEiii_alt sum_dEiii_alt sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = CPE*CWE_2iv_Tante if T==`t'
	  gen dEiv = CPE*CWE_2iv_T if T==(`t'-1)
	  gen nEiv_alt = CPE_alt*CWE_2iv_Tante if T==`t'
	  gen dEiv_alt = CPE_alt*CWE_2iv_T if T==(`t'-1)
	  gen nHiv = CPH*CWH_2iv_Tante if T==`t'
	  gen dHiv = CPH*CWH_2iv_T if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nEiv_alt = sum(nEiv_alt)
	  egen sum_dEiv_alt = sum(dEiv_alt)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT0_CE2iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT0_CE2iv_alt = sum_nEiv_alt/sum_dEiv_alt if T==`t'
	  replace dIQT0_CH2iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nEiv_alt dEiv_alt nHiv dHiv sum_nEiv sum_dEiv sum_nEiv_alt sum_dEiv_alt sum_nHiv sum_dHiv
   }
  
  
 * IQT1:
  * Efetivo C:
   gen dIQT1_CE2i = .        
   gen dIQT1_CE2ii = .        
   gen dIQT1_CE2iii = .        
   gen dIQT1_CE2iv = .        
  
  * Efetivo C_alt:   
   gen dIQT1_CE2i_alt = .        
   gen dIQT1_CE2ii_alt = .        
   gen dIQT1_CE2iii_alt = .        
   gen dIQT1_CE2iv_alt = .   
   
  * Habitual: 
   gen dIQT1_CH2i = .        
   gen dIQT1_CH2ii = .        
   gen dIQT1_CH2iii = .        
   gen dIQT1_CH2iv = . 
  
   forvalues t = 2/`=Tmax'{
	* (i) Sem controles: 
	  gen nEi = CPE*CWE_2i_T if T==`t'
	  gen dEi = CPE*CWE_2i_Tprox if T==(`t'-1)
	  gen nEi_alt = CPE_alt*CWE_2i_T if T==`t'
	  gen dEi_alt = CPE_alt*CWE_2i_Tprox if T==(`t'-1)
	  gen nHi = CPH*CWH_2i_T if T==`t'
	  gen dHi = CPH*CWH_2i_Tprox if T==(`t'-1)
	  
	  egen sum_nEi = sum(nEi)
	  egen sum_dEi = sum(dEi)
	  egen sum_nEi_alt = sum(nEi_alt)
	  egen sum_dEi_alt = sum(dEi_alt)
	  egen sum_nHi = sum(nHi)
	  egen sum_dHi = sum(dHi)
	  
	  replace dIQT1_CE2i = sum_nEi/sum_dEi if T==`t'
	  replace dIQT1_CE2i_alt = sum_nEi_alt/sum_dEi_alt if T==`t'
	  replace dIQT1_CH2i = sum_nHi/sum_dHi if T==`t'  

	  drop nEi dEi nEi_alt dEi_alt nHi dHi sum_nEi sum_dEi sum_nEi_alt sum_dEi_alt sum_nHi sum_dHi
	
	
   * (ii) Cor:
	  gen nEii = CPE*CWE_2ii_T if T==`t'
	  gen dEii = CPE*CWE_2ii_Tprox if T==(`t'-1)
	  gen nEii_alt = CPE_alt*CWE_2ii_T if T==`t'
	  gen dEii_alt = CPE_alt*CWE_2ii_Tprox if T==(`t'-1)
	  gen nHii = CPH*CWH_2ii_T if T==`t'
	  gen dHii = CPH*CWH_2ii_Tprox if T==(`t'-1)
	  
	  egen sum_nEii = sum(nEii)
	  egen sum_dEii = sum(dEii)
	  egen sum_nEii_alt = sum(nEii_alt)
	  egen sum_dEii_alt = sum(dEii_alt)
	  egen sum_nHii = sum(nHii)
	  egen sum_dHii = sum(dHii)
	  
	  replace dIQT1_CE2ii = sum_nEii/sum_dEii if T==`t'
	  replace dIQT1_CE2ii_alt = sum_nEii_alt/sum_dEii_alt if T==`t'
	  replace dIQT1_CH2ii = sum_nHii/sum_dHii if T==`t'  

	  drop nEii dEii nEii_alt dEii_alt nHii dHii sum_nEii sum_dEii sum_nEii_alt sum_dEii_alt sum_nHii sum_dHii
	
	
   * (iii) Setor Público:
	  gen nEiii = CPE*CWE_2iii_T if T==`t'
	  gen dEiii = CPE*CWE_2iii_Tprox if T==(`t'-1)
	  gen nEiii_alt = CPE_alt*CWE_2iii_T if T==`t'
	  gen dEiii_alt = CPE_alt*CWE_2iii_Tprox if T==(`t'-1)
	  gen nHiii = CPH*CWH_2iii_T if T==`t'
	  gen dHiii = CPH*CWH_2iii_Tprox if T==(`t'-1)
	  
	  egen sum_nEiii = sum(nEiii)
	  egen sum_dEiii = sum(dEiii)
	  egen sum_nEiii_alt = sum(nEiii_alt)
	  egen sum_dEiii_alt = sum(dEiii_alt)
	  egen sum_nHiii = sum(nHiii)
	  egen sum_dHiii = sum(dHiii)
	  
	  replace dIQT1_CE2iii = sum_nEiii/sum_dEiii if T==`t'
	  replace dIQT1_CE2iii_alt = sum_nEiii_alt/sum_dEiii_alt if T==`t'
	  replace dIQT1_CH2iii = sum_nHiii/sum_dHiii if T==`t'  

	  drop nEiii dEiii nEiii_alt dEiii_alt nHiii dHiii sum_nEiii sum_dEiii sum_nEiii_alt sum_dEiii_alt sum_nHiii sum_dHiii
	  
	  
   * (iv) Informal: 
	  gen nEiv = CPE*CWE_2iv_T if T==`t'
	  gen dEiv = CPE*CWE_2iv_Tprox if T==(`t'-1)
	  gen nEiv_alt = CPE_alt*CWE_2iv_T if T==`t'
	  gen dEiv_alt = CPE_alt*CWE_2iv_Tprox if T==(`t'-1)
	  gen nHiv = CPH*CWH_2iv_T if T==`t'
	  gen dHiv = CPH*CWH_2iv_Tprox if T==(`t'-1)
	  
	  egen sum_nEiv = sum(nEiv)
	  egen sum_dEiv = sum(dEiv)
	  egen sum_nEiv_alt = sum(nEiv_alt)
	  egen sum_dEiv_alt = sum(dEiv_alt)
	  egen sum_nHiv = sum(nHiv)
	  egen sum_dHiv = sum(dHiv)
	  
	  replace dIQT1_CE2iv = sum_nEiv/sum_dEiv if T==`t'
	  replace dIQT1_CE2iv_alt = sum_nEiv_alt/sum_dEiv_alt if T==`t'
	  replace dIQT1_CH2iv = sum_nHiv/sum_dHiv if T==`t'  

	  drop nEiv dEiv nEiv_alt dEiv_alt nHiv dHiv sum_nEiv sum_dEiv sum_nEiv_alt sum_dEiv_alt sum_nHiv sum_dHiv  
   }  
   
   
 * dIQT: índice de Fisher    
   gen dIQT_CE2i = (dIQT0_CE2i*dIQT1_CE2i)^(1/2)
   gen dIQT_CE2i_alt = (dIQT0_CE2i_alt*dIQT1_CE2i_alt)^(1/2)
   gen dIQT_CH2i = (dIQT0_CH2i*dIQT1_CH2i)^(1/2)
   
   gen dIQT_CE2ii = (dIQT0_CE2ii*dIQT1_CE2ii)^(1/2)
   gen dIQT_CE2ii_alt = (dIQT0_CE2ii_alt*dIQT1_CE2ii_alt)^(1/2)
   gen dIQT_CH2ii = (dIQT0_CH2ii*dIQT1_CH2ii)^(1/2)
  
   gen dIQT_CE2iii = (dIQT0_CE2iii*dIQT1_CE2iii)^(1/2)
   gen dIQT_CE2iii_alt = (dIQT0_CE2iii_alt*dIQT1_CE2iii_alt)^(1/2)
   gen dIQT_CH2iii = (dIQT0_CH2iii*dIQT1_CH2iii)^(1/2)  
  
   gen dIQT_CE2iv = (dIQT0_CE2iv*dIQT1_CE2iv)^(1/2)
   gen dIQT_CE2iv_alt = (dIQT0_CE2iv_alt*dIQT1_CE2iv_alt)^(1/2)
   gen dIQT_CH2iv = (dIQT0_CH2iv*dIQT1_CH2iv)^(1/2)
   
 
 save "$dirdata/D_BaseEstimacao.dta", replace  
 
 * IQT: Base separada 
  {
  preserve
   keep T dIQT_CE2i dIQT_CE2ii dIQT_CE2iii dIQT_CE2iv dIQT_CE2i_alt dIQT_CE2ii_alt dIQT_CE2iii_alt dIQT_CE2iv_alt dIQT_CH2i dIQT_CH2ii dIQT_CH2iii dIQT_CH2iv
   duplicates drop
  
   *OBS: calcularemos apenas os IQT com 2012.2 = 100
   * (i) Sem controles
     gen IQT_CE2i = 100 if T==2
     replace IQT_CE2i = IQT_CE2i[_n-1]*dIQT_CE2i if _n > 2
     label var IQT_CE2i "IQT Efetivo (C) - Com pesos - Sem controles"
   
     gen IQT_CE2i_alt = 100 if T==2
     replace IQT_CE2i_alt = IQT_CE2i_alt[_n-1]*dIQT_CE2i_alt if _n > 2
     label var IQT_CE2i_alt "IQT Efetivo (C_alt) - Com pesos - Sem controles"
	 
	 gen IQT_CH2i = 100 if T==2
     replace IQT_CH2i = IQT_CH2i[_n-1]*dIQT_CH2i if _n > 2
     label var IQT_CH2i "IQT Habitual (C) - Com pesos - Sem controles"
	 
	 
   * (ii) Cor
     gen IQT_CE2ii = 100 if T==2
     replace IQT_CE2ii = IQT_CE2ii[_n-1]*dIQT_CE2ii if _n > 2
     label var IQT_CE2ii "IQT Efetivo (C) - Com pesos - Cor"
   
     gen IQT_CE2ii_alt = 100 if T==2
     replace IQT_CE2ii_alt = IQT_CE2ii_alt[_n-1]*dIQT_CE2ii_alt if _n > 2
     label var IQT_CE2ii_alt "IQT Efetivo (C_alt) - Com pesos - Cor"
	 
	 gen IQT_CH2ii = 100 if T==2
     replace IQT_CH2ii = IQT_CH2ii[_n-1]*dIQT_CH2ii if _n > 2
     label var IQT_CH2ii "IQT Habitual (C) - Com pesos - Cor"
   
   
   * (iii) Setor público
     gen IQT_CE2iii = 100 if T==2
     replace IQT_CE2iii = IQT_CE2iii[_n-1]*dIQT_CE2iii if _n > 2
     label var IQT_CE2iii "IQT Efetivo (C) - Com pesos - Setor público"
   
     gen IQT_CE2iii_alt = 100 if T==2
     replace IQT_CE2iii_alt = IQT_CE2iii_alt[_n-1]*dIQT_CE2iii_alt if _n > 2
     label var IQT_CE2iii_alt "IQT Efetivo (C_alt) - Com pesos - Setor público"
	 
	 gen IQT_CH2iii = 100 if T==2
     replace IQT_CH2iii = IQT_CH2iii[_n-1]*dIQT_CH2iii if _n > 2
     label var IQT_CH2iii "IQT Habitual (C) - Com pesos - Setor público" 
	 
	 
   * (iv) Informal
     gen IQT_CE2iv = 100 if T==2
     replace IQT_CE2iv = IQT_CE2iv[_n-1]*dIQT_CE2iv if _n > 2
     label var IQT_CE2iv "IQT Efetivo (C) - Sem pesos - Informal"
   
     gen IQT_CE2iv_alt = 100 if T==2
     replace IQT_CE2iv_alt = IQT_CE2iv_alt[_n-1]*dIQT_CE2iv_alt if _n > 2
     label var IQT_CE2iv_alt "IQT Efetivo (C_alt) - Com pesos - Informal"
	 
	 gen IQT_CH2iv = 100 if T==2
     replace IQT_CH2iv = IQT_CH2iv[_n-1]*dIQT_CH2iv if _n > 2
     label var IQT_CH2iv "IQT Habitual (C) - Com pesos - Informal" 
   
   
   merge 1:1 T using "$dirdata/D_IQT.dta"
   drop _merge
   save "$dirdata/D_IQT.dta", replace
   restore
   }  
  
 }
 
}

}

log close

*** Complementos:
  * Gráficos
  * Rodar sem controles no salário predito
  * Tabelas




















