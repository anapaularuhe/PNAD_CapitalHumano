*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Outubro/2021
*******************************************************************************

* PREPARAÇÃO ******************************************************************
* Pacotes:
*ssc install sg97_5

* Garantindo que não há variáveis prévias na memória:
clear all
cls								

* Configurações de memória:
set maxvar 30000
	
* Configurando diretório: 
global dirpath = "C:/Users/ana.ruhe/Documents/Capital_Humano"
global dirdata = "C:/Users/ana.ruhe/Documents/Capital_Humano/Dados"
*global dirpath = "C:\Users\janaina.feijo\Documents\capital_humano\result"   
*global dirdata = "C:\Users\janaina.feijo\Documents\capital_humano\data" 


* Salvando log:
log using "D_Estimacao_IQT.log", replace


*******************************************************************************
* Estimações:
* - Uma regressão por trimestre
* - Gênero: 2 estratégias (i) Usando dummies em uma regressão única (interpretação mais simples); 
*                         (ii) Regressões separadas (estratégia adotada pelo IPEA)  
*
* - Lidando com horas e rendimento nulos: 4 estratégias (A, B, C e D)
*   A. Baseline: observações com horas efetivas nulas irão gerar missing values (são ignoradas nas regressões de salário efetivo, mas não habitual)
*   B. Indivíduos com horas efetivas nulas serão removidos das estimações (terão missing values) de salário efetivo e de salário habitual
*   C. Imputação: usaremos as horas habituais para os indivíduos com horas efetivas nulas para o cálculo do salário-hora
*   D. Usaremos horas efetivas = 1 para quem teve horas efetivas = 0


*******************************************************************************
* D. ESTIMAÇÃO RENDIMENTO EFETIVO
*******************************************************************************
* Dados:
  use "$dirdata/C_PNADC_POamostra.dta", clear
  
 * Eliminamos variáveis não mais necessárias da amostra:
   drop UF Regiao V1027 Populacao Idade Cor V3003 V3003A V3009 V3009A VD3004 VD3005 VD3006_pos Experiencia_pos VD4001 VD4002 VD4009 privado publico informal trabalhador VD4010 VD4016 VD4017 VD4019 VD4019_real VD4020 VD4020_real VD4032 Efetivo Habitual educ_pos1 educ_pos2 educ_pos3 educ_pos4 educ_pos5 educ_pos6 educ_pos7 educ_pos8 idade15 idade14 Experiencia_pos2 Experiencia_pos3 Experiencia_pos4 

 * Gerando interação mulher x experiência:
   gen ExperMulher = Experiencia*mulher
   gen ExperMulher2 = Experiencia2*mulher
   gen ExperMulher3 = Experiencia3*mulher
   gen ExperMulher4 = Experiencia4*mulher
   
   egen Tmax = max(T)

   save "$dirdata/D0_BaseEstimacao.dta", replace 
   

*******************************************************************************      
* D.A: BASELINE ***************************************************************
{                
** D.A.1: RETORNOS EDUCAÇÃO E EXPERIÊNCIA *************************************
 {                
   forvalues t = 1/`=Tmax' {  
    * Regressão única: 
	  regress logW_efet_A mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t' 
	  *predict Reg_logW_efet_A_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	  estimates save "$dirdata/DA1_Estimacoes", append
	
	* Homens:  
	  regress logW_efet_A educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0)
	  predict RegHomem_logW_efet_A_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/DA1_Estimacoes", append
	
	* Mulheres:
	  regress logW_efet_A educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1)
	  predict RegMulher_logW_efet_A_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/DA1_Estimacoes", append
   }
   
 * Salvando os coeficientes:	
   statsby, by(T) saving("$dirdata/DA2_Coeficientes_unico.dta", replace): regress logW_efet_A mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4
 
   statsby, by(T mulher) saving("$dirdata/DA2_Coeficientes_genero.dta", replace): regress logW_efet_A educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4
 
   estimates clear
   
 * Evolução dos retornos de educação e experiência ao longo do tempo: baseline (A)   
 {
   * 1. Regressão única  
   preserve
    use "$dirdata/DA2_Coeficientes_unico.dta", clear
	
	egen Tmax = max(T)
	
    label var _b_cons "Constante: Educação Grupo 1 - homens"
	label var _b_mulher "Constante: efeito diferencial mulheres"
	
	label var _b_educ2 "Educação: diferencial Grupo 2"
	label var _b_educ3 "Educação: diferencial Grupo 3"
	label var _b_educ4 "Educação: diferencial Grupo 4"
	label var _b_educ5 "Educação: diferencial Grupo 5"
	label var _b_educ6 "Educação: diferencial Grupo 6"
	
	label var _b_Experiencia "Experiência"
	label var _b_Experiencia2 "Experiência ao quadrado"
	label var _b_Experiencia3 "Experiência ao cubo"
	label var _b_Experiencia4 "Experiência na 4ª potência"
	
	label var _b_ExperMulher "Experiência: efeito diferencial mulheres"
	label var _b_ExperMulher2 "Experiência ao quadrado: efeito diferencial mulheres"
	label var _b_ExperMulher3 "Experiência ao cubo: efeito diferencial mulheres"
	label var _b_ExperMulher4 "Experiência na 4ª potência: efeito diferencial mulheres"


    * Coeficientes estimados dão retornos diferenciais. Vamos calcular os retornos acumulados:	
 	gen Educ2 = _b_cons + _b_educ2
 	gen Educ3 = _b_cons + _b_educ3
 	gen Educ4 = _b_cons + _b_educ4
 	gen Educ5 = _b_cons + _b_educ5
 	gen Educ6 = _b_cons + _b_educ6

 	label var Educ2 "Educ Grupo 2"
 	label var Educ3 "Educ Grupo 3"
 	label var Educ4 "Educ Grupo 4"
 	label var Educ5 "Educ Grupo 5"
 	label var Educ6 "Educ Grupo 6"
	
	gen Educ2M = Educ2 + _b_mulher
	gen Educ3M = Educ3 + _b_mulher
	gen Educ4M = Educ4 + _b_mulher
	gen Educ5M = Educ5 + _b_mulher
	gen Educ6M = Educ6 + _b_mulher
	
	label var Educ2M "Educ Grupo 2 Mulheres"
 	label var Educ3M "Educ Grupo 3 Mulheres"
 	label var Educ4M "Educ Grupo 4 Mulheres"
 	label var Educ5M "Educ Grupo 5 Mulheres"
 	label var Educ6M "Educ Grupo 6 Mulheres"
	
	gen ExperM = _b_Experiencia + _b_ExperMulher
	gen Exper2M = _b_Experiencia2 + _b_ExperMulher2
	gen Exper3M = _b_Experiencia3 + _b_ExperMulher3
	gen Exper4M = _b_Experiencia4 + _b_ExperMulher4
	
	label var ExperM "Experiencia Mulheres"
	label var Exper2M "Experiencia ao quadrado Mulheres"
	label var Exper3M "Experiencia ao cubo Mulheres"
	label var Exper4M "Experiencia na 4a pot. Mulheres"
	
    * Gráficos:
	twoway (line _b_cons T, lcolor(black)) (line Educ2 T, lcolor(red)) (line Educ2M T, lcolor(red) lpattern(dash)) (line Educ3 T, lcolor(blue)) (line Educ3M T, lcolor(blue) lpattern(dash)) (line Educ4 T, lcolor(green)) (line Educ4M T, lcolor(green) lpattern(dash)) (line Educ5 T, lcolor(yellow)) (line Educ5M T, lcolor(yellow) lpattern(dash)) (line Educ6 T, lcolor(teal)) (line Educ6M T, lcolor(teal) lpattern(dash)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosEducUnica, replace)

	twoway (line _b_Experiencia T, lcolor(red)) (line ExperM T, lcolor(red) lpattern(dash)) (line _b_Experiencia2 T, lcolor(blue)) (line Exper2M T, lcolor(blue) lpattern(dash)) (line _b_Experiencia3 T, lcolor(green)) (line Exper3M T, lcolor(green) lpattern(dash)) (line _b_Experiencia4 T, lcolor(teal)) (line Exper4M T, lcolor(teal) lpattern(dash)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosExperUnica, replace)

    save "$dirdata/DA2_Coeficientes_unico.dta", replace
   restore

 * 1.2 Regressões por gênero
   preserve
    use "$dirdata/DA2_Coeficientes_genero.dta", clear
	
	egen Tmax = max(T)
	
    label var _b_cons "Constante: Educação Grupo 1"
	label var _b_educ2 "Educação: diferencial Grupo 2"
	label var _b_educ3 "Educação: diferencial Grupo 3"
	label var _b_educ4 "Educação: diferencial Grupo 4"
	label var _b_educ5 "Educação: diferencial Grupo 5"
	label var _b_educ6 "Educação: diferencial Grupo 6"
	
	label var _b_Experiencia "Experiência"
	label var _b_Experiencia2 "Experiência ao quadrado"
	label var _b_Experiencia3 "Experiência ao cubo"
	label var _b_Experiencia4 "Experiência na 4ª potência"

    * Coeficientes estimados dão retornos diferenciais. Vamos calcular os retornos acumulados:	
 	gen Educ2 = _b_cons + _b_educ2
 	gen Educ3 = _b_cons + _b_educ3
 	gen Educ4 = _b_cons + _b_educ4
 	gen Educ5 = _b_cons + _b_educ5
 	gen Educ6 = _b_cons + _b_educ6

 	label var Educ2 "Educação Grupo 2"
 	label var Educ3 "Educação Grupo 3"
 	label var Educ4 "Educação Grupo 4"
 	label var Educ5 "Educação Grupo 5"
 	label var Educ6 "Educação Grupo 6"
  
    * Gráficos:
	twoway (line _b_cons T if(mulher==0)) (line Educ2 T if(mulher==0)) (line Educ3 T if(mulher==0)) (line Educ4 T if(mulher==0)) (line Educ5 T if(mulher==0)) (line Educ6 T if(mulher==0)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosEducHomens, replace)
	twoway (line _b_cons T if(mulher==1)) (line Educ2 T if(mulher==1)) (line Educ3 T if(mulher==1)) (line Educ4 T if(mulher==1)) (line Educ5 T if(mulher==1)) (line Educ6 T if(mulher==1)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosEducMulheres, replace)
	
	twoway (line _b_Experiencia T if(mulher==0)) (line _b_Experiencia2 T if(mulher==0)) (line _b_Experiencia3 T if(mulher==0)) (line _b_Experiencia4 T if(mulher==0)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosExperHomens, replace)
	twoway (line _b_Experiencia T if(mulher==1)) (line _b_Experiencia2 T if(mulher==1)) (line _b_Experiencia3 T if(mulher==1)) (line _b_Experiencia4 T if(mulher==1)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosExpermulheres, replace)
	

    save "$dirdata/DA2_Coeficientes_genero.dta", replace
   restore
   }
  
 } 


** D.A.2: SALÁRIOS PREDITOS ***************************************************
 { 
 * Exponencial + sintetizamos salários de homens e mulheres em mesma variável + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
	  gen RegW_efet_A_`t' = exp(RegHomem_logW_efet_A_`t') if mulher==0
	  replace RegW_efet_A_`t' = exp(RegMulher_logW_efet_A_`t') if mulher==1
	  
	  drop RegHomem_logW_efet_A_`t' RegMulher_logW_efet_A_`t' 
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - Wefet_T     = salários em t preditos pelos coeficientes estimados de t
	- WEefet_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- WEefet_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
   gen WefetA_T = .
   gen WefetA_Tante = .
   gen WefetA_Tprox = .
   
   label var WefetA_T "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t (A)"
   label var WefetA_Tante "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t-1 (A)"
   label var WefetA_Tprox "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t+1 (A)"
   
   
   forvalues t = 1/`=Tmax' {
      replace WefetA_T = RegW_efet_A_`t' if T==`t'
	  
	  local i = `t'-1
	  if `t' > 1 replace WefetA_Tante = RegW_efet_A_`i' if T==`t'
	  
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WefetA_Tprox = RegW_efet_A_`j' if T==`t'
   }
 
   order WefetA_T WefetA_Tante WefetA_Tprox, before(RegW_efet_A_1)

 * Podemos eliminar os salários efetivos separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_efet_A_`t'
   }  
 
 
   save "$dirdata/D0_BaseEstimacao.dta", replace
  } 
  

** D.A.3: PESOS PONDERADOS POR HORAS ******************************************  
 {
 * Calculando hora média por grupo (Educ e Experiencia) para cada t:     
   bysort T VD3006 Experiencia: egen HEfetA = mean(VD4035)
   label var HEfetA "Horas efetivas médias por grupo de educação e experiência para cada trimestre (A)"

 * Peso ajustado por hora:
  * Peso original multiplicado pelas horas efetivas médias do grupo i
    gen PEfetA_i = Peso*HEfetA
   
  * Soma (por trimestre) do produto peso x horas médias efetivas 
    bysort T: egen PEfetA_t = sum(PEfetA_i)
  
  * Peso final:
    gen PEfetA = PEfetA_i/PEfetA_t
    label var PEfetA "Peso para cálculo do IQT de rendimento efetivo (A)"
   
   order PEfetA, after(Peso) 
   drop PEfetA_i PEfetA_t

   save "$dirdata/D0_BaseEstimacao.dta", replace
  }
   

** D.A.4: IQT *****************************************************************   
 {
 * IQT0:
   gen dIQT0_efetA = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetA*WefetA_Tante if T==`t'
	  gen den = PEfetA*WefetA_T if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT0_efetA = sum_num/sum_den if T==`t'

	  drop num den sum_num sum_den
   }
  
  
 * IQT1:
   gen dIQT1_efetA = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetA*WefetA_T if T==`t'
	  gen den = PEfetA*WefetA_Tprox if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT1_efetA = sum_num/sum_den if T==`t'
	  
	  drop num den sum_num sum_den 
   }  
   
 * IQT: índice de Fisher   
   gen dIQT_efetA = (dIQT0_efetA*dIQT1_efetA)^(1/2)
   
   label var dIQT0_efetA "Variação IQT0 Efetivo (A)"
   label var dIQT1_efetA "Variação IQT1 Efetivo (A)"
   label var dIQT_efetA "Variação IQT Efetivo (A)"
   
** Salvando base apenas do IQT:   
   preserve
   keep T dIQT0_efetA dIQT1_efetA dIQT_efetA 
   duplicates drop
   
   gen IQT_efetA = 100 if T==1
   replace IQT_efetA = IQT_efetA[_n-1]*dIQT_efetA if _n > 1
   label var IQT_efetA "IQT Efetivo (A)"
   
   gen IQT_efetA_2012t2 = 100 if T==2
   replace IQT_efetA_2012t2 = IQT_efetA_2012t2[_n-1]*dIQT_efetA if _n > 2
   label var IQT_efetA_2012t2 "IQT Efetivo (A): 2012.2 = 100"
   
   save "$dirdata/D_IQT_Efetivo.dta", replace
   restore
  
   drop dIQT0_efetA dIQT1_efetA dIQT_efetA
   save "$dirdata/D0_BaseEstimacao.dta", replace 
 } 
}
   
   
*******************************************************************************      
* D.B: IGNORANDO HORAS NULAS **************************************************
{
* Para o salário efetivo, é exatamente igual ao caso A. A diferença está na amostra utilizada para o salário habitual.
  preserve
  use "$dirdata/D_IQT_Efetivo.dta", clear
  gen dIQT0_efetB = dIQT0_efetA
  gen dIQT1_efetB = dIQT1_efetA
  gen dIQT_efetB = dIQT_efetA
  
  label var dIQT0_efetB "Variação IQT0 Efetivo (B)"
  label var dIQT1_efetB "Variação IQT1 Efetivo (B)"
  label var dIQT_efetB "Variação IQT Efetivo (B)"
 
  gen IQT_efetB = IQT_efetA
  label var IQT_efetB "IQT Efetivo (B)"
   
  gen IQT_efetB_2012t2 = IQT_efetA_2012t2
  label var IQT_efetB_2012t2 "IQT Efetivo (B): 2012.2 = 100"
  
  save "$dirdata/D_IQT_Efetivo.dta", replace
  restore   
}   


*******************************************************************************      
* D.C: IMPUTANDO HORAS HABITUAIS **********************************************
{                
** D.C.1: RETORNOS EDUCAÇÃO E EXPERIÊNCIA *************************************
 {
*** D.C.1.I: Estimações convencionais 
  { 
   forvalues t = 1/`=Tmax' {  
    * Regressão única: 
	  regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	  *predict Reg_logW_efet_C_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	  estimates save "$dirdata/DC1_Estimacoes", append
	
	* Homens:  
	  regress logW_efet_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0)
	  predict RegHomem_logW_efet_C_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/DC1_Estimacoes", append
	
	* Mulheres:
	  regress logW_efet_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1)
	  predict RegMulher_logW_efet_C_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/DC1_Estimacoes", append
	  
	  
	* Estimação para salário efetivo nulo (log = 0):
	 * Homens:  
	  regress logW_efet0_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0)
	  predict RegHomem_logW_efet0_C_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/DC10_Estimacoes", append
	
	 * Mulheres:
	  regress logW_efet0_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1)
	  predict RegMulher_logW_efet0_C_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/DC10_Estimacoes", append
   }
   
 * Salvando os coeficientes:	
   statsby, by(T) saving("$dirdata/DC2_Coeficientes_unico.dta", replace): regress logW_efet_C mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4
 
   statsby, by(T mulher) saving("$dirdata/DC2_Coeficientes_genero.dta", replace): regress logW_efet_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4

   statsby, by(T mulher) saving("$dirdata/DC20_Coeficientes_genero.dta", replace): regress logW_efet0_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4
 
   estimates clear  
  } 
  
*** D.C.1.II: Estimações com peso
  {
  forvalues t = 1/`=Tmax' {  
	* Homens:  
	  regress logW_efet_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0) [iw = Peso]
	  predict RegHomem_logW_efet_C_peso_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/DC1_Estimacoes_peso", append
	
	* Mulheres:
	  regress logW_efet_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1) [iw = Peso]
	  predict RegMulher_logW_efet_C_peso_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/DC1_Estimacoes_peso", append
	  
	* Estimação para salário efetivo nulo (log = 0):
	 * Homens:  
	  regress logW_efet0_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0) [iw = Peso]
	  predict RegHomem_logW_efet0_C_peso_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/DC10_Estimacoes_peso", append
	
	 * Mulheres:
	  regress logW_efet0_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1) [iw = Peso]
	  predict RegMulher_logW_efet0_C_peso_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/DC10_Estimacoes_peso", append
   }
   
 * Salvando os coeficientes:	
   statsby, by(T mulher) saving("$dirdata/DC2_Coeficientes_genero_peso.dta", replace): regress logW_efet_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 [iw = Peso]

   statsby, by(T mulher) saving("$dirdata/DC20_Coeficientes_genero_peso.dta", replace): regress logW_efet0_C educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 [iw = Peso]
 
   estimates clear  
  }
 } 


** D.C.2: SALÁRIOS PREDITOS ***************************************************
 { 
*** D.C.2.I: Estimações convencionais 
  { 
 * Exponencial + sintetizamos salários de homens e mulheres em mesma variável + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
	  gen RegW_efet_C_`t' = exp(RegHomem_logW_efet_C_`t') if mulher==0
	  replace RegW_efet_C_`t' = exp(RegMulher_logW_efet_C_`t') if mulher==1
	  
	  gen RegW_efet0_C_`t' = exp(RegHomem_logW_efet0_C_`t') if mulher==0
	  replace RegW_efet0_C_`t' = exp(RegMulher_logW_efet0_C_`t') if mulher==1
	  
	  drop RegHomem_logW_efet_C_`t' RegMulher_logW_efet_C_`t' RegHomem_logW_efet0_C_`t' RegMulher_logW_efet0_C_`t' 
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - Wefet_T     = salários em t preditos pelos coeficientes estimados de t
	- WEefet_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- WEefet_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
   gen WefetC_T = .
   gen WefetC_Tante = .
   gen WefetC_Tprox = .
   
   label var WefetC_T "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t (C)"
   label var WefetC_Tante "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t-1 (C)"
   label var WefetC_Tprox "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t+1 (C)"
   
   
   gen WefetC0_T = .
   gen WefetC0_Tante = .
   gen WefetC0_Tprox = .
   
   label var WefetC0_T "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t (C) - log = 0"
   label var WefetC0_Tante "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t-1 (C) - log = 0"
   label var WefetC0_Tprox "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t+1 (C) - log = 0"
   
   
   forvalues t = 1/`=Tmax' {
      replace WefetC_T = RegW_efet_C_`t' if T==`t'
	  replace WefetC0_T = RegW_efet0_C_`t' if T==`t'
	  
	  local i = `t'-1
	  if `t' > 1 replace WefetC_Tante = RegW_efet_C_`i' if T==`t'
	  if `t' > 1 replace WefetC0_Tante = RegW_efet0_C_`i' if T==`t'
	  
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WefetC_Tprox = RegW_efet_C_`j' if T==`t'
	  if `t' < `=Tmax' replace WefetC0_Tprox = RegW_efet0_C_`j' if T==`t'
   }
 
   order WefetC_T WefetC_Tante WefetC_Tprox WefetC0_T WefetC0_Tante WefetC0_Tprox, before(RegW_efet_C_1)

 * Podemos eliminar os salários efetivos separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_efet_C_`t' RegW_efet0_C_`t'
   }  
 
 
   save "$dirdata/D0_BaseEstimacao.dta", replace
   }
 
*** D.C.2.II: Estimações com peso 
  { 
 * Exponencial + sintetizamos salários de homens e mulheres em mesma variável + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
	  gen RegW_efet_C_peso_`t' = exp(RegHomem_logW_efet_C_peso_`t') if mulher==0
	  replace RegW_efet_C_peso_`t' = exp(RegMulher_logW_efet_C_peso_`t') if mulher==1
	  
	  gen RegW_efet0_C_peso_`t' = exp(RegHomem_logW_efet0_C_peso_`t') if mulher==0
	  replace RegW_efet0_C_peso_`t' = exp(RegMulher_logW_efet0_C_peso_`t') if mulher==1
	  
	  drop RegHomem_logW_efet_C_peso_`t' RegMulher_logW_efet_C_peso_`t' RegHomem_logW_efet0_C_peso_`t' RegMulher_logW_efet0_C_peso_`t' 
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - Wefet_T     = salários em t preditos pelos coeficientes estimados de t
	- WEefet_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- WEefet_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
   gen WefetC_peso_T = .
   gen WefetC_peso_Tante = .
   gen WefetC_peso_Tprox = .
   
   label var WefetC_peso_T "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t (C)"
   label var WefetC_peso_Tante "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t-1 (C)"
   label var WefetC_peso_Tprox "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t+1 (C)"
   
   
   gen WefetC0_peso_T = .
   gen WefetC0_peso_Tante = .
   gen WefetC0_peso_Tprox = .
   
   label var WefetC0_peso_T "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t (C) - log = 0"
   label var WefetC0_peso_Tante "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t-1 (C) - log = 0"
   label var WefetC0_peso_Tprox "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t+1 (C) - log = 0"
   
   
   forvalues t = 1/`=Tmax' {
      replace WefetC_peso_T = RegW_efet_C_peso_`t' if T==`t'
	  replace WefetC0_peso_T = RegW_efet0_C_peso_`t' if T==`t'
	  
	  local i = `t'-1
	  if `t' > 1 replace WefetC_peso_Tante = RegW_efet_C_peso_`i' if T==`t'
	  if `t' > 1 replace WefetC0_peso_Tante = RegW_efet0_C_peso_`i' if T==`t'
	  
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WefetC_peso_Tprox = RegW_efet_C_peso_`j' if T==`t'
	  if `t' < `=Tmax' replace WefetC0_peso_Tprox = RegW_efet0_C_peso_`j' if T==`t'
   }


 * Podemos eliminar os salários efetivos separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_efet_C_peso_`t' RegW_efet0_C_peso_`t'
   }  
 
   save "$dirdata/D0_BaseEstimacao.dta", replace
   } 
 } 
  

** D.C.3: PESOS PONDERADOS POR HORAS ******************************************  
 {
 * Calculando hora média por grupo (Educ e Experiencia) para cada t:     
   bysort T VD3006 Experiencia: egen HEfetC = mean(VD4035_imput)
   label var HEfetC "Horas efetivas médias por grupo de educação e experiência para cada trimestre (C)"

 * Peso ajustado por hora:
  * Peso original multiplicado pelas horas efetivas médias do grupo i
    gen PEfetC_i = Peso*HEfetC
   
  * Soma (por trimestre) do produto peso x horas médias efetivas 
    bysort T: egen PEfetC_t = sum(PEfetC_i)
  
  * Peso final:
    gen PEfetC = PEfetC_i/PEfetC_t
    label var PEfetC "Peso para cálculo do IQT de rendimento efetivo (C)"
   
   order PEfetC, after(Peso) 
   drop PEfetC_i PEfetC_t
   
   
  ** Estratégia C alternativa: usando horas efetivas para o IQT, deixando imputação apenas para a regressão
     bysort T VD3006 Experiencia: egen HEfetC_alt = mean(VD4035)
     label var HEfetC_alt "Horas efetivas médias por grupo de educação e experiência para cada trimestre (C_alt)"

   * Peso original multiplicado pelas horas efetivas médias do grupo i
     gen PEfetC_ialt = Peso*HEfetC_alt
   
   * Soma (por trimestre) do produto peso x horas médias efetivas 
     bysort T: egen PEfetC_talt = sum(PEfetC_ialt)
  
   * Peso final:
     gen PEfetC_alt = PEfetC_ialt/PEfetC_talt
     label var PEfetC_alt "Peso para cálculo do IQT de rendimento efetivo (C_alt)"
   
     order PEfetC_alt, after(PEfetC) 
     drop PEfetC_ialt PEfetC_talt
  

   save "$dirdata/D0_BaseEstimacao.dta", replace
  }
   

** D.C.4: IQT *****************************************************************   
 {
*** D.C.4.I: Estimações convencionais  
  {
 * IQT0:
   gen dIQT0_efetC = .        // Baseline
   gen dIQT0_efetC_alt = .    // Estratégia alternativa (imputação apenas na regressão, não no peso)
   
   gen dIQT0_efetC0 = .       // log = 0
   gen dIQT0_efetC0_alt = .   // log = 0 + Estratégia alternativa
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetC*WefetC_Tante if T==`t'
	  gen den = PEfetC*WefetC_T if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT0_efetC = sum_num/sum_den if T==`t'
	  
	  gen num_alt = PEfetC_alt*WefetC_Tante if T==`t'
	  gen den_alt = PEfetC_alt*WefetC_T if T==(`t'-1)
   
      egen sum_num_alt = sum(num_alt)
	  egen sum_den_alt = sum(den_alt)
	  
	  replace dIQT0_efetC_alt = sum_num_alt/sum_den_alt if T==`t'
	  
	  gen num0 = PEfetC*WefetC0_Tante if T==`t'
	  gen den0 = PEfetC*WefetC0_T if T==(`t'-1)
   
      egen sum_num0 = sum(num0)
	  egen sum_den0 = sum(den0)
	  
	  replace dIQT0_efetC0 = sum_num0/sum_den0 if T==`t'
	  
	  gen num_alt0 = PEfetC_alt*WefetC0_Tante if T==`t'
	  gen den_alt0 = PEfetC_alt*WefetC0_T if T==(`t'-1)
   
      egen sum_num_alt0 = sum(num_alt0)
	  egen sum_den_alt0 = sum(den_alt0)
	  
	  replace dIQT0_efetC0_alt = sum_num_alt0/sum_den_alt0 if T==`t'

	  drop num den sum_num sum_den num_alt den_alt sum_num_alt sum_den_alt num0 den0 sum_num0 sum_den0 num_alt0 den_alt0 sum_num_alt0 sum_den_alt0
   }
  
  
 * IQT1:
   gen dIQT1_efetC = .
   gen dIQT1_efetC_alt = .
   
   gen dIQT1_efetC0 = .
   gen dIQT1_efetC0_alt = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetC*WefetC_T if T==`t'
	  gen den = PEfetC*WefetC_Tprox if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT1_efetC = sum_num/sum_den if T==`t'
	  
	  gen num_alt = PEfetC_alt*WefetC_T if T==`t'
	  gen den_alt = PEfetC_alt*WefetC_Tprox if T==(`t'-1)
   
      egen sum_num_alt = sum(num_alt)
	  egen sum_den_alt = sum(den_alt)
	  
	  replace dIQT1_efetC_alt = sum_num_alt/sum_den_alt if T==`t'
	  
	  gen num0 = PEfetC*WefetC0_T if T==`t'
	  gen den0 = PEfetC*WefetC0_Tprox if T==(`t'-1)
   
      egen sum_num0 = sum(num0)
	  egen sum_den0 = sum(den0)
	  
	  replace dIQT1_efetC0 = sum_num0/sum_den0 if T==`t'
	  
	  gen num_alt0 = PEfetC_alt*WefetC0_T if T==`t'
	  gen den_alt0 = PEfetC_alt*WefetC0_Tprox if T==(`t'-1)
   
      egen sum_num_alt0 = sum(num_alt0)
	  egen sum_den_alt0 = sum(den_alt0)
	  
	  replace dIQT1_efetC0_alt = sum_num_alt0/sum_den_alt0 if T==`t'
	  
	  drop num den sum_num sum_den num_alt den_alt sum_num_alt sum_den_alt num0 den0 sum_num0 sum_den0 num_alt0 den_alt0 sum_num_alt0 sum_den_alt0
   }  
   
 * IQT: índice de Fisher   
   gen dIQT_efetC = (dIQT0_efetC*dIQT1_efetC)^(1/2)
   gen dIQT_efetC_alt = (dIQT0_efetC_alt*dIQT1_efetC_alt)^(1/2)
   
   label var dIQT0_efetC "Variação IQT0 Efetivo (C)"
   label var dIQT1_efetC "Variação IQT1 Efetivo (C)"
   label var dIQT_efetC "Variação IQT Efetivo (C)"
   
   label var dIQT0_efetC_alt "Variação IQT0 Efetivo (C_alt)"
   label var dIQT1_efetC_alt "Variação IQT1 Efetivo (C_alt)"
   label var dIQT_efetC_alt "Variação IQT Efetivo (C_alt)"
   
   
   gen dIQT_efetC0 = (dIQT0_efetC0*dIQT1_efetC0)^(1/2)
   gen dIQT_efetC0_alt = (dIQT0_efetC0_alt*dIQT1_efetC0_alt)^(1/2)
   
   label var dIQT0_efetC0 "Variação IQT0 Efetivo (C0)"
   label var dIQT1_efetC0 "Variação IQT1 Efetivo (C0)"
   label var dIQT_efetC0 "Variação IQT Efetivo (C0)"
   
   label var dIQT0_efetC0_alt "Variação IQT0 Efetivo (C0_alt)"
   label var dIQT1_efetC0_alt "Variação IQT1 Efetivo (C0_alt)"
   label var dIQT_efetC0_alt "Variação IQT Efetivo (C0_alt)"
   
   
** Salvando base apenas do IQT:   
   preserve
   keep T dIQT0_efetC dIQT1_efetC dIQT_efetC dIQT0_efetC_alt dIQT1_efetC_alt dIQT_efetC_alt dIQT0_efetC0 dIQT1_efetC0 dIQT_efetC0 dIQT0_efetC0_alt dIQT1_efetC0_alt dIQT_efetC0_alt
   duplicates drop
     
   gen IQT_efetC = 100 if T==1
   replace IQT_efetC = IQT_efetC[_n-1]*dIQT_efetC if _n > 1
   label var IQT_efetC "IQT Efetivo (C)"
   
   gen IQT_efetC_2012t2 = 100 if T==2
   replace IQT_efetC_2012t2 = IQT_efetC_2012t2[_n-1]*dIQT_efetC if _n > 2
   label var IQT_efetC_2012t2 "IQT Efetivo (C): 2012.2 = 100"
   
   gen IQT_efetC_alt = 100 if T==1
   replace IQT_efetC_alt = IQT_efetC_alt[_n-1]*dIQT_efetC_alt if _n > 1
   label var IQT_efetC_alt "IQT Efetivo (C_alt)"
   
   gen IQT_efetC_alt_2012t2 = 100 if T==2
   replace IQT_efetC_alt_2012t2 = IQT_efetC_alt_2012t2[_n-1]*dIQT_efetC_alt if _n > 2
   label var IQT_efetC_alt_2012t2 "IQT Efetivo (C_alt): 2012.2 = 100"
   
     
   gen IQT_efetC0 = 100 if T==1
   replace IQT_efetC0 = IQT_efetC0[_n-1]*dIQT_efetC0 if _n > 1
   label var IQT_efetC0 "IQT Efetivo (C0)"
   
   gen IQT_efetC0_2012t2 = 100 if T==2
   replace IQT_efetC0_2012t2 = IQT_efetC0_2012t2[_n-1]*dIQT_efetC0 if _n > 2
   label var IQT_efetC0_2012t2 "IQT Efetivo (C0): 2012.2 = 100"
   
   
   gen IQT_efetC0_alt = 100 if T==1
   replace IQT_efetC0_alt = IQT_efetC0_alt[_n-1]*dIQT_efetC0_alt if _n > 1
   label var IQT_efetC0_alt "IQT Efetivo (C0_alt)"
   
   gen IQT_efetC0_alt_2012t2 = 100 if T==2
   replace IQT_efetC0_alt_2012t2 = IQT_efetC0_alt_2012t2[_n-1]*dIQT_efetC0_alt if _n > 2
   label var IQT_efetC0_alt_2012t2 "IQT Efetivo (C0_alt): 2012.2 = 100"
   
   
   merge 1:1 T using "$dirdata/D_IQT_Efetivo.dta"
   drop _merge
   save "$dirdata/D_IQT_Efetivo.dta", replace
   restore
  
   drop dIQT0_efetC dIQT1_efetC dIQT_efetC dIQT0_efetC0 dIQT1_efetC0 dIQT_efetC0 dIQT0_efetC_alt dIQT1_efetC_alt dIQT_efetC_alt dIQT0_efetC0_alt dIQT1_efetC0_alt dIQT_efetC0_alt
   save "$dirdata/D0_BaseEstimacao.dta", replace 
  } 
 
*** D.C.4.II: Estimações com peso
  { 
* IQT0:
   gen dIQT0_efetC_peso = .        // Baseline
   gen dIQT0_efetC_peso_alt = .    // Estratégia alternativa (imputação apenas na regressão, não no peso)
   
   gen dIQT0_efetC0_peso = .       // log = 0
   gen dIQT0_efetC0_peso_alt = .   // log = 0 + Estratégia alternativa
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetC*WefetC_peso_Tante if T==`t'
	  gen den = PEfetC*WefetC_peso_T if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT0_efetC_peso = sum_num/sum_den if T==`t'
	  
	  gen num_alt = PEfetC_alt*WefetC_peso_Tante if T==`t'
	  gen den_alt = PEfetC_alt*WefetC_peso_T if T==(`t'-1)
   
      egen sum_num_alt = sum(num_alt)
	  egen sum_den_alt = sum(den_alt)
	  
	  replace dIQT0_efetC_peso_alt = sum_num_alt/sum_den_alt if T==`t'
	  
	  gen num0 = PEfetC*WefetC0_peso_Tante if T==`t'
	  gen den0 = PEfetC*WefetC0_peso_T if T==(`t'-1)
   
      egen sum_num0 = sum(num0)
	  egen sum_den0 = sum(den0)
	  
	  replace dIQT0_efetC0_peso = sum_num0/sum_den0 if T==`t'
	  
	  gen num_alt0 = PEfetC_alt*WefetC0_peso_Tante if T==`t'
	  gen den_alt0 = PEfetC_alt*WefetC0_peso_T if T==(`t'-1)
   
      egen sum_num_alt0 = sum(num_alt0)
	  egen sum_den_alt0 = sum(den_alt0)
	  
	  replace dIQT0_efetC0_peso_alt = sum_num_alt0/sum_den_alt0 if T==`t'

	  drop num den sum_num sum_den num_alt den_alt sum_num_alt sum_den_alt num0 den0 sum_num0 sum_den0 num_alt0 den_alt0 sum_num_alt0 sum_den_alt0
   }
  
  
 * IQT1:
   gen dIQT1_efetC_peso = .
   gen dIQT1_efetC_peso_alt = .
   
   gen dIQT1_efetC0_peso = .
   gen dIQT1_efetC0_peso_alt = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetC*WefetC_peso_T if T==`t'
	  gen den = PEfetC*WefetC_peso_Tprox if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT1_efetC_peso = sum_num/sum_den if T==`t'
	  
	  gen num_alt = PEfetC_alt*WefetC_peso_T if T==`t'
	  gen den_alt = PEfetC_alt*WefetC_peso_Tprox if T==(`t'-1)
   
      egen sum_num_alt = sum(num_alt)
	  egen sum_den_alt = sum(den_alt)
	  
	  replace dIQT1_efetC_peso_alt = sum_num_alt/sum_den_alt if T==`t'
	  
	  gen num0 = PEfetC*WefetC0_peso_T if T==`t'
	  gen den0 = PEfetC*WefetC0_peso_Tprox if T==(`t'-1)
   
      egen sum_num0 = sum(num0)
	  egen sum_den0 = sum(den0)
	  
	  replace dIQT1_efetC0_peso = sum_num0/sum_den0 if T==`t'
	  
	  gen num_alt0 = PEfetC_alt*WefetC0_peso_T if T==`t'
	  gen den_alt0 = PEfetC_alt*WefetC0_peso_Tprox if T==(`t'-1)
   
      egen sum_num_alt0 = sum(num_alt0)
	  egen sum_den_alt0 = sum(den_alt0)
	  
	  replace dIQT1_efetC0_peso_alt = sum_num_alt0/sum_den_alt0 if T==`t'
	  
	  drop num den sum_num sum_den num_alt den_alt sum_num_alt sum_den_alt num0 den0 sum_num0 sum_den0 num_alt0 den_alt0 sum_num_alt0 sum_den_alt0
   }  
   
 * IQT: índice de Fisher   
   gen dIQT_efetC_peso = (dIQT0_efetC_peso*dIQT1_efetC_peso)^(1/2)
   gen dIQT_efetC_peso_alt = (dIQT0_efetC_peso_alt*dIQT1_efetC_peso_alt)^(1/2)
   
   label var dIQT0_efetC_peso "Variação IQT0 Efetivo (C)"
   label var dIQT1_efetC_peso "Variação IQT1 Efetivo (C)"
   label var dIQT_efetC_peso "Variação IQT Efetivo (C)"
   
   label var dIQT0_efetC_peso_alt "Variação IQT0 Efetivo (C_alt)"
   label var dIQT1_efetC_peso_alt "Variação IQT1 Efetivo (C_alt)"
   label var dIQT_efetC_peso_alt "Variação IQT Efetivo (C_alt)"
   
   
   gen dIQT_efetC0_peso = (dIQT0_efetC0_peso*dIQT1_efetC0_peso)^(1/2)
   gen dIQT_efetC0_peso_alt = (dIQT0_efetC0_peso_alt*dIQT1_efetC0_peso_alt)^(1/2)
   
   label var dIQT0_efetC0_peso "Variação IQT0 Efetivo (C0)"
   label var dIQT1_efetC0_peso "Variação IQT1 Efetivo (C0)"
   label var dIQT_efetC0_peso "Variação IQT Efetivo (C0)"
   
   label var dIQT0_efetC0_peso_alt "Variação IQT0 Efetivo (C0_alt)"
   label var dIQT1_efetC0_peso_alt "Variação IQT1 Efetivo (C0_alt)"
   label var dIQT_efetC0_peso_alt "Variação IQT Efetivo (C0_alt)"
   
   
** Salvando base apenas do IQT:   
   preserve
   keep T dIQT0_efetC_peso dIQT1_efetC_peso dIQT_efetC_peso dIQT0_efetC_peso_alt dIQT1_efetC_peso_alt dIQT_efetC_peso_alt dIQT0_efetC0_peso dIQT1_efetC0_peso dIQT_efetC0_peso dIQT0_efetC0_peso_alt dIQT1_efetC0_peso_alt dIQT_efetC0_peso_alt
   duplicates drop
     
   gen IQT_efetC_peso = 100 if T==1
   replace IQT_efetC_peso = IQT_efetC_peso[_n-1]*dIQT_efetC_peso if _n > 1
   label var IQT_efetC_peso "IQT Efetivo (C) - Peso"
   
   gen IQT_efetC_peso_2012t2 = 100 if T==2
   replace IQT_efetC_peso_2012t2 = IQT_efetC_peso_2012t2[_n-1]*dIQT_efetC_peso if _n > 2
   label var IQT_efetC_peso_2012t2 "IQT Efetivo (C): 2012.2 = 100 - Peso"
   
   gen IQT_efetC_peso_alt = 100 if T==1
   replace IQT_efetC_peso_alt = IQT_efetC_peso_alt[_n-1]*dIQT_efetC_peso_alt if _n > 1
   label var IQT_efetC_peso_alt "IQT Efetivo (C_alt) - Peso"
   
   gen IQT_efetC_peso_alt_2012t2 = 100 if T==2
   replace IQT_efetC_peso_alt_2012t2 = IQT_efetC_peso_alt_2012t2[_n-1]*dIQT_efetC_peso_alt if _n > 2
   label var IQT_efetC_peso_alt_2012t2 "IQT Efetivo (C_alt): 2012.2 = 100 - Peso"
   
     
   gen IQT_efetC0_peso = 100 if T==1
   replace IQT_efetC0_peso = IQT_efetC0_peso[_n-1]*dIQT_efetC0_peso if _n > 1
   label var IQT_efetC0_peso "IQT Efetivo (C0) - Peso"
   
   gen IQT_efetC0_peso_2012t2 = 100 if T==2
   replace IQT_efetC0_peso_2012t2 = IQT_efetC0_peso_2012t2[_n-1]*dIQT_efetC0_peso if _n > 2
   label var IQT_efetC0_peso_2012t2 "IQT Efetivo (C0): 2012.2 = 100 - Peso"
   
   
   gen IQT_efetC0_peso_alt = 100 if T==1
   replace IQT_efetC0_peso_alt = IQT_efetC0_peso_alt[_n-1]*dIQT_efetC0_peso_alt if _n > 1
   label var IQT_efetC0_peso_alt "IQT Efetivo (C0_alt) - Peso"
   
   gen IQT_efetC0_peso_alt_2012t2 = 100 if T==2
   replace IQT_efetC0_peso_alt_2012t2 = IQT_efetC0_peso_alt_2012t2[_n-1]*dIQT_efetC0_peso_alt if _n > 2
   label var IQT_efetC0_peso_alt_2012t2 "IQT Efetivo (C0_alt): 2012.2 = 100 - Peso"
   
   
   merge 1:1 T using "$dirdata/D_IQT_Efetivo.dta"
   drop _merge
   save "$dirdata/D_IQT_Efetivo.dta", replace
   restore
  
   drop dIQT0_efetC_peso dIQT1_efetC_peso dIQT_efetC_peso dIQT0_efetC0_peso dIQT1_efetC0_peso dIQT_efetC0_peso dIQT0_efetC_peso_alt dIQT1_efetC_peso_alt dIQT_efetC_peso_alt dIQT0_efetC0_peso_alt dIQT1_efetC0_peso_alt dIQT_efetC0_peso_alt
   save "$dirdata/D0_BaseEstimacao.dta", replace  
  }
 } 
}


*******************************************************************************      
* D.D: HORAS NULAS = 1 ********************************************************
{                
** D.D.1: RETORNOS EDUCAÇÃO E EXPERIÊNCIA *************************************
 {                
   forvalues t = 1/`=Tmax' {  
    * Regressão única: 
	  regress logW_efet_D mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	  *predict Reg_logW_efet_D_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	  estimates save "$dirdata/DD1_Estimacoes", append
	
	* Homens:  
	  regress logW_efet_D educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0)
	  predict RegHomem_logW_efet_D_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/DD1_Estimacoes", append
	
	* Mulheres:
	  regress logW_efet_D educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1)
	  predict RegMulher_logW_efet_D_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/DD1_Estimacoes", append
   }
   
 * Salvando os coeficientes:	
   statsby, by(T) saving("$dirdata/DD2_Coeficientes_unico.dta", replace): regress logW_efet_D mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4
 
   statsby, by(T mulher) saving("$dirdata/DD2_Coeficientes_genero.dta", replace): regress logW_efet_D educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4
 
   estimates clear  
 } 


** D.D.2: SALÁRIOS PREDITOS ***************************************************
 { 
 * Exponencial + sintetizamos salários de homens e mulheres em mesma variável + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
	  gen RegW_efet_D_`t' = exp(RegHomem_logW_efet_D_`t') if mulher==0
	  replace RegW_efet_D_`t' = exp(RegMulher_logW_efet_D_`t') if mulher==1
	  
	  drop RegHomem_logW_efet_D_`t' RegMulher_logW_efet_D_`t' 
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - Wefet_T     = salários em t preditos pelos coeficientes estimados de t
	- WEefet_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- WEefet_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
   gen WefetD_T = .
   gen WefetD_Tante = .
   gen WefetD_Tprox = .
   
   label var WefetD_T "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t (C)"
   label var WefetD_Tante "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t-1 (C)"
   label var WefetD_Tprox "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t+1 (C)"
   
   
   forvalues t = 1/`=Tmax' {
      replace WefetD_T = RegW_efet_D_`t' if T==`t'
	  
	  local i = `t'-1
	  if `t' > 1 replace WefetD_Tante = RegW_efet_D_`i' if T==`t'
	  
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WefetD_Tprox = RegW_efet_D_`j' if T==`t'
   }
 
   order WefetD_T WefetD_Tante WefetD_Tprox, before(RegW_efet_D_1)

 * Podemos eliminar os salários efetivos separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_efet_D_`t'
   }  
 
 
   save "$dirdata/D0_BaseEstimacao.dta", replace
  } 
  

** D.D.3: PESOS PONDERADOS POR HORAS ******************************************  
 {
 * Calculando hora média por grupo (Educ e Experiencia) para cada t:     
   bysort T VD3006 Experiencia: egen HEfetD = mean(VD4035_1)
   label var HEfetD "Horas efetivas médias por grupo de educação e experiência para cada trimestre (C)"

 * Peso ajustado por hora:
  * Peso original multiplicado pelas horas efetivas médias do grupo i
    gen PEfetD_i = Peso*HEfetD
   
  * Soma (por trimestre) do produto peso x horas médias efetivas 
    bysort T: egen PEfetD_t = sum(PEfetD_i)
  
  * Peso final:
    gen PEfetD = PEfetD_i/PEfetD_t
    label var PEfetD "Peso para cálculo do IQT de rendimento efetivo (D)"
   
   order PEfetD, after(Peso) 
   drop PEfetD_i PEfetD_t

   save "$dirdata/D0_BaseEstimacao.dta", replace
  }
   

** D.D.4: IQT *****************************************************************   
 {
 * IQT0:
   gen dIQT0_efetD = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetD*WefetD_Tante if T==`t'
	  gen den = PEfetD*WefetD_T if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT0_efetD = sum_num/sum_den if T==`t'

	  drop num den sum_num sum_den
   }
  
  
 * IQT1:
   gen dIQT1_efetD = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PEfetD*WefetD_T if T==`t'
	  gen den = PEfetD*WefetD_Tprox if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT1_efetD = sum_num/sum_den if T==`t'
	  
	  drop num den sum_num sum_den 
   }  
   
 * IQT: índice de Fisher   
   gen dIQT_efetD = (dIQT0_efetD*dIQT1_efetD)^(1/2)
   
   label var dIQT0_efetD "Variação IQT0 Efetivo (D)"
   label var dIQT1_efetD "Variação IQT1 Efetivo (D)"
   label var dIQT_efetD "Variação IQT Efetivo (D)"
   
** Salvando base apenas do IQT:   
   preserve
   keep T dIQT0_efetD dIQT1_efetD dIQT_efetD
   duplicates drop
   
   gen IQT_efetD = 100 if T==1
   replace IQT_efetD = IQT_efetD[_n-1]*dIQT_efetD if _n > 1
   label var IQT_efetD "IQT Efetivo (D)"
   
   gen IQT_efetD_2012t2 = 100 if T==2
   replace IQT_efetD_2012t2 = IQT_efetD_2012t2[_n-1]*dIQT_efetD if _n > 2
   label var IQT_efetD_2012t2 "IQT Efetivo (D): 2012.2 = 100"
   
   merge 1:1 T using "$dirdata/D_IQT_Efetivo.dta"
   drop _merge
   save "$dirdata/D_IQT_Efetivo.dta", replace
   restore
  
   drop dIQT0_efetD dIQT1_efetD dIQT_efetD
   save "$dirdata/D0_BaseEstimacao.dta", replace 
 } 
}

  
   
*******************************************************************************
* E. ESTIMAÇÃO RENDIMENTO HABITUAL
*******************************************************************************   
   use "$dirdata/C_PNADC_POamostra.dta", clear
  
 * Eliminamos variáveis não mais necessárias da amostra:
   drop UF Regiao V1027 Populacao Idade Cor V3003 V3003A V3009 V3009A VD3004 VD3005 VD3006_pos Experiencia_pos VD4001 VD4002 VD4009 privado publico informal trabalhador VD4010 VD4016 VD4017 VD4019 VD4019_real VD4020 VD4020_real VD4032 Efetivo Habitual educ_pos1 educ_pos2 educ_pos3 educ_pos4 educ_pos5 educ_pos6 educ_pos7 educ_pos8 idade15 idade14 Experiencia_pos2 Experiencia_pos3 Experiencia_pos4 

 * Gerando interação mulher x experiência:
   gen ExperMulher = Experiencia*mulher
   gen ExperMulher2 = Experiencia2*mulher
   gen ExperMulher3 = Experiencia3*mulher
   gen ExperMulher4 = Experiencia4*mulher
   
   egen Tmax = max(T)

   save "$dirdata/E0_BaseEstimacao.dta", replace 
  


*******************************************************************************      
* E.A: BASELINE ***************************************************************
{                
** E.A.1: RETORNOS EDUCAÇÃO E EXPERIÊNCIA *************************************
 {                
   forvalues t = 1/`=Tmax' {  
    * Regressão única: 
	  regress logW_hab_A mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	  *predict Reg_logW_hab_A_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	  estimates save "$dirdata/EA1_Estimacoes", append
	
	* Homens:  
	  regress logW_hab_A educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0)
	  predict RegHomem_logW_hab_A_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/EA1_Estimacoes", append
	
	* Mulheres:
	  regress logW_hab_A educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1)
	  predict RegMulher_logW_hab_A_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/EA1_Estimacoes", append
   }
   
 * Salvando os coeficientes:	
   statsby, by(T) saving("$dirdata/EA2_Coeficientes_unico.dta", replace): regress logW_hab_A mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4
 
   statsby, by(T mulher) saving("$dirdata/EA2_Coeficientes_genero.dta", replace): regress logW_hab_A educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4
 
   estimates clear
   
 * Evolução dos retornos de educação e experiência ao longo do tempo: baseline (A)   
 {
   * 1. Regressão única  
   preserve
    use "$dirdata/EA2_Coeficientes_unico.dta", clear
	
	egen Tmax = max(T)
	
    label var _b_cons "Constante: Educação Grupo 1 - homens"
	label var _b_mulher "Constante: efeito diferencial mulheres"
	
	label var _b_educ2 "Educação: diferencial Grupo 2"
	label var _b_educ3 "Educação: diferencial Grupo 3"
	label var _b_educ4 "Educação: diferencial Grupo 4"
	label var _b_educ5 "Educação: diferencial Grupo 5"
	label var _b_educ6 "Educação: diferencial Grupo 6"
	
	label var _b_Experiencia "Experiência"
	label var _b_Experiencia2 "Experiência ao quadrado"
	label var _b_Experiencia3 "Experiência ao cubo"
	label var _b_Experiencia4 "Experiência na 4ª potência"
	
	label var _b_ExperMulher "Experiência: efeito diferencial mulheres"
	label var _b_ExperMulher2 "Experiência ao quadrado: efeito diferencial mulheres"
	label var _b_ExperMulher3 "Experiência ao cubo: efeito diferencial mulheres"
	label var _b_ExperMulher4 "Experiência na 4ª potência: efeito diferencial mulheres"


    * Coeficientes estimados dão retornos diferenciais. Vamos calcular os retornos acumulados:	
 	gen Educ2 = _b_cons + _b_educ2
 	gen Educ3 = _b_cons + _b_educ3
 	gen Educ4 = _b_cons + _b_educ4
 	gen Educ5 = _b_cons + _b_educ5
 	gen Educ6 = _b_cons + _b_educ6

 	label var Educ2 "Educ Grupo 2"
 	label var Educ3 "Educ Grupo 3"
 	label var Educ4 "Educ Grupo 4"
 	label var Educ5 "Educ Grupo 5"
 	label var Educ6 "Educ Grupo 6"
	
	gen Educ2M = Educ2 + _b_mulher
	gen Educ3M = Educ3 + _b_mulher
	gen Educ4M = Educ4 + _b_mulher
	gen Educ5M = Educ5 + _b_mulher
	gen Educ6M = Educ6 + _b_mulher
	
	label var Educ2M "Educ Grupo 2 Mulheres"
 	label var Educ3M "Educ Grupo 3 Mulheres"
 	label var Educ4M "Educ Grupo 4 Mulheres"
 	label var Educ5M "Educ Grupo 5 Mulheres"
 	label var Educ6M "Educ Grupo 6 Mulheres"
	
	gen ExperM = _b_Experiencia + _b_ExperMulher
	gen Exper2M = _b_Experiencia2 + _b_ExperMulher2
	gen Exper3M = _b_Experiencia3 + _b_ExperMulher3
	gen Exper4M = _b_Experiencia4 + _b_ExperMulher4
	
	label var ExperM "Experiencia Mulheres"
	label var Exper2M "Experiencia ao quadrado Mulheres"
	label var Exper3M "Experiencia ao cubo Mulheres"
	label var Exper4M "Experiencia na 4a pot. Mulheres"
	
    * Gráficos:
	twoway (line _b_cons T, lcolor(black)) (line Educ2 T, lcolor(red)) (line Educ2M T, lcolor(red) lpattern(dash)) (line Educ3 T, lcolor(blue)) (line Educ3M T, lcolor(blue) lpattern(dash)) (line Educ4 T, lcolor(green)) (line Educ4M T, lcolor(green) lpattern(dash)) (line Educ5 T, lcolor(yellow)) (line Educ5M T, lcolor(yellow) lpattern(dash)) (line Educ6 T, lcolor(teal)) (line Educ6M T, lcolor(teal) lpattern(dash)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosEducUnicaHab, replace)

	twoway (line _b_Experiencia T, lcolor(red)) (line ExperM T, lcolor(red) lpattern(dash)) (line _b_Experiencia2 T, lcolor(blue)) (line Exper2M T, lcolor(blue) lpattern(dash)) (line _b_Experiencia3 T, lcolor(green)) (line Exper3M T, lcolor(green) lpattern(dash)) (line _b_Experiencia4 T, lcolor(teal)) (line Exper4M T, lcolor(teal) lpattern(dash)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosExperUnicaHab, replace)

    save "$dirdata/EA2_Coeficientes_unico.dta", replace
   restore

 * 1.2 Regressões por gênero
   preserve
    use "$dirdata/EA2_Coeficientes_genero.dta", clear
	
	egen Tmax = max(T)
	
    label var _b_cons "Constante: Educação Grupo 1"
	label var _b_educ2 "Educação: diferencial Grupo 2"
	label var _b_educ3 "Educação: diferencial Grupo 3"
	label var _b_educ4 "Educação: diferencial Grupo 4"
	label var _b_educ5 "Educação: diferencial Grupo 5"
	label var _b_educ6 "Educação: diferencial Grupo 6"
	
	label var _b_Experiencia "Experiência"
	label var _b_Experiencia2 "Experiência ao quadrado"
	label var _b_Experiencia3 "Experiência ao cubo"
	label var _b_Experiencia4 "Experiência na 4ª potência"

    * Coeficientes estimados dão retornos diferenciais. Vamos calcular os retornos acumulados:	
 	gen Educ2 = _b_cons + _b_educ2
 	gen Educ3 = _b_cons + _b_educ3
 	gen Educ4 = _b_cons + _b_educ4
 	gen Educ5 = _b_cons + _b_educ5
 	gen Educ6 = _b_cons + _b_educ6

 	label var Educ2 "Educação Grupo 2"
 	label var Educ3 "Educação Grupo 3"
 	label var Educ4 "Educação Grupo 4"
 	label var Educ5 "Educação Grupo 5"
 	label var Educ6 "Educação Grupo 6"
  
    * Gráficos:
	twoway (line _b_cons T if(mulher==0)) (line Educ2 T if(mulher==0)) (line Educ3 T if(mulher==0)) (line Educ4 T if(mulher==0)) (line Educ5 T if(mulher==0)) (line Educ6 T if(mulher==0)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosEducHomensHab, replace)
	twoway (line _b_cons T if(mulher==1)) (line Educ2 T if(mulher==1)) (line Educ3 T if(mulher==1)) (line Educ4 T if(mulher==1)) (line Educ5 T if(mulher==1)) (line Educ6 T if(mulher==1)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosEducMulheresHab, replace)
	
	twoway (line _b_Experiencia T if(mulher==0)) (line _b_Experiencia2 T if(mulher==0)) (line _b_Experiencia3 T if(mulher==0)) (line _b_Experiencia4 T if(mulher==0)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosExperHomensHab, replace)
	twoway (line _b_Experiencia T if(mulher==1)) (line _b_Experiencia2 T if(mulher==1)) (line _b_Experiencia3 T if(mulher==1)) (line _b_Experiencia4 T if(mulher==1)), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(RetornosExpermulheresHab, replace)
	

    save "$dirdata/EA2_Coeficientes_genero.dta", replace
   restore
   }
  
 } 


** E.A.2: SALÁRIOS PREDITOS ***************************************************
 { 
 * Exponencial + sintetizamos salários de homens e mulheres em mesma variável + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
	  gen RegW_hab_A_`t' = exp(RegHomem_logW_hab_A_`t') if mulher==0
	  replace RegW_hab_A_`t' = exp(RegMulher_logW_hab_A_`t') if mulher==1
	  
	  drop RegHomem_logW_hab_A_`t' RegMulher_logW_hab_A_`t' 
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - Whab_T     = salários em t preditos pelos coeficientes estimados de t
	- WEhab_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- WEhab_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
   gen WhabA_T = .
   gen WhabA_Tante = .
   gen WhabA_Tprox = .
   
   label var WhabA_T "Rendimento habitual por hora em t predito pelos coeficientes estimados de t (A)"
   label var WhabA_Tante "Rendimento habitual por hora em t predito pelos coeficientes estimados de t-1 (A)"
   label var WhabA_Tprox "Rendimento habitual por hora em t predito pelos coeficientes estimados de t+1 (A)"
   
   
   forvalues t = 1/`=Tmax' {
      replace WhabA_T = RegW_hab_A_`t' if T==`t'
	  
	  local i = `t'-1
	  if `t' > 1 replace WhabA_Tante = RegW_hab_A_`i' if T==`t'
	  
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WhabA_Tprox = RegW_hab_A_`j' if T==`t'
   }
 
   order WhabA_T WhabA_Tante WhabA_Tprox, before(RegW_hab_A_1)

 * Podemos eliminar os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_hab_A_`t'
   }  
 
 
   save "$dirdata/E0_BaseEstimacao.dta", replace
  } 
  

** E.A.3: PESOS PONDERADOS POR HORAS ******************************************  
 {
 * Calculando hora média por grupo (Educ e Experiencia) para cada t:     
   bysort T VD3006 Experiencia: egen HhabA = mean(VD4031)
   label var HhabA "Horas habituais médias por grupo de educação e experiência para cada trimestre (A)"

 * Peso ajustado por hora:
  * Peso original multiplicado pelas horas habituais médias do grupo i
    gen PhabA_i = Peso*HhabA
   
  * Soma (por trimestre) do produto peso x horas médias habituais
    bysort T: egen PhabA_t = sum(PhabA_i)
  
  * Peso final:
    gen PhabA = PhabA_i/PhabA_t
    label var PhabA "Peso para cálculo do IQT de rendimento habitual (A)"
   
   order PhabA, after(Peso) 
   drop PhabA_i PhabA_t

   save "$dirdata/E0_BaseEstimacao.dta", replace
  }
   

** E.A.4: IQT *****************************************************************   
 {
 * IQT0:
   gen dIQT0_habA = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PhabA*WhabA_Tante if T==`t'
	  gen den = PhabA*WhabA_T if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT0_habA = sum_num/sum_den if T==`t'

	  drop num den sum_num sum_den
   }
  
  
 * IQT1:
   gen dIQT1_habA = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PhabA*WhabA_T if T==`t'
	  gen den = PhabA*WhabA_Tprox if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT1_habA = sum_num/sum_den if T==`t'
	  
	  drop num den sum_num sum_den 
   }  
   
 * IQT: índice de Fisher   
   gen dIQT_habA = (dIQT0_habA*dIQT1_habA)^(1/2)
   
   label var dIQT0_habA "Variação IQT0 Habitual (A)"
   label var dIQT1_habA "Variação IQT1 Habitual (A)"
   label var dIQT_habA "Variação IQT Habitual (A)"
   
** Salvando base apenas do IQT:   
   preserve
   keep T dIQT0_habA dIQT1_habA dIQT_habA 
   duplicates drop
   
   gen IQT_habA = 100 if T==1
   replace IQT_habA = IQT_habA[_n-1]*dIQT_habA if _n > 1
   label var IQT_habA "IQT Habitual (A)"
   
   gen IQT_habA_2012t2 = 100 if T==2
   replace IQT_habA_2012t2 = IQT_habA_2012t2[_n-1]*dIQT_habA if _n > 2
   label var IQT_habA_2012t2 "IQT Habitual (A): 2012.2 = 100"
   
   save "$dirdata/E_IQT_Habitual.dta", replace
   restore
  
   drop dIQT0_habA dIQT1_habA dIQT_habA
   save "$dirdata/E0_BaseEstimacao.dta", replace 
 } 
}
      
	  
*******************************************************************************      
* E.B: IGNORANDO HORAS NULAS **************************************************
{                
** E.B.1: RETORNOS EDUCAÇÃO E EXPERIÊNCIA *************************************
 {                
   forvalues t = 1/`=Tmax' {  
    * Regressão única: 
	  regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 if T==`t'
	  *predict Reg_logW_hab_B_`t' if(T>=(`t'-1) & T<=(`t'+1))	 
	  estimates save "$dirdata/EB1_Estimacoes", append
	
	* Homens:  
	  regress logW_hab_B educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==0)
	  predict RegHomem_logW_hab_B_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==0)	 
	  estimates save "$dirdata/EB1_Estimacoes", append
	
	* Mulheres:
	  regress logW_hab_B educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & mulher==1)
	  predict RegMulher_logW_hab_B_`t' if(T>=(`t'-1) & T<=(`t'+1) & mulher==1)	 
	  estimates save "$dirdata/EB1_Estimacoes", append
   }
   
 * Salvando os coeficientes:	
   statsby, by(T) saving("$dirdata/EB2_Coeficientes_unico.dta", replace): regress logW_hab_B mulher educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 ExperMulher ExperMulher2 ExperMulher3 ExperMulher4
 
   statsby, by(T mulher) saving("$dirdata/EB2_Coeficientes_genero.dta", replace): regress logW_hab_B educ2 educ3 educ4 educ5 educ6 Experiencia Experiencia2 Experiencia3 Experiencia4
 
   estimates clear
 } 


** E.B.2: SALÁRIOS PREDITOS ***************************************************
 { 
 * Exponencial + sintetizamos salários de homens e mulheres em mesma variável + descartamos log para economizar memória
   forvalues t = 1/`=Tmax' {
	  gen RegW_hab_B_`t' = exp(RegHomem_logW_hab_B_`t') if mulher==0
	  replace RegW_hab_B_`t' = exp(RegMulher_logW_hab_B_`t') if mulher==1
	  
	  drop RegHomem_logW_hab_B_`t' RegMulher_logW_hab_B_`t' 
   }

 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - Whab_T     = salários em t preditos pelos coeficientes estimados de t
	- WEhab_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- WEhab_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
   gen WhabB_T = .
   gen WhabB_Tante = .
   gen WhabB_Tprox = .
   
   label var WhabB_T "Rendimento habitual por hora em t predito pelos coeficientes estimados de t (B)"
   label var WhabB_Tante "Rendimento habitual por hora em t predito pelos coeficientes estimados de t-1 (B)"
   label var WhabB_Tprox "Rendimento habitual por hora em t predito pelos coeficientes estimados de t+1 (B)"
   
   
   forvalues t = 1/`=Tmax' {
      replace WhabB_T = RegW_hab_B_`t' if T==`t'
	  
	  local i = `t'-1
	  if `t' > 1 replace WhabB_Tante = RegW_hab_B_`i' if T==`t'
	  
	  local j = `t'+1 
	  if `t' < `=Tmax' replace WhabB_Tprox = RegW_hab_B_`j' if T==`t'
   }
 
   order WhabB_T WhabB_Tante WhabB_Tprox, before(RegW_hab_B_1)

 * Podemos eliminar os salários separados por período, para economizar memória:
   forvalues t = 1/`=Tmax' { 
       drop RegW_hab_B_`t'
   }  
 
 
   save "$dirdata/E0_BaseEstimacao.dta", replace
  } 
  

** E.B.3: PESOS PONDERADOS POR HORAS ******************************************  
 {
 * Calculando hora média por grupo (Educ e Experiencia) para cada t:     
   gen VD4031_B = VD4031
   replace VD4031_B = 0 if VD4035==0
   label var VD4031_B "Horas habituais com 0 para observações com horas efetivas nulas"
   order VD4031_B, after(VD4031)
   
   bysort T VD3006 Experiencia: egen HhabB = mean(VD4031_B)
   label var HhabB "Horas habituais médias por grupo de educação e experiência para cada trimestre (B)"

 * Peso ajustado por hora:
  * Peso original multiplicado pelas horas habituais médias do grupo i
    gen PhabB_i = Peso*HhabB
   
  * Soma (por trimestre) do produto peso x horas médias habituais
    bysort T: egen PhabB_t = sum(PhabB_i)
  
  * Peso final:
    gen PhabB = PhabB_i/PhabB_t
    label var PhabB "Peso para cálculo do IQT de rendimento habitual (B)"
   
   order PhabB, after(Peso) 
   drop PhabB_i PhabB_t

   save "$dirdata/E0_BaseEstimacao.dta", replace
  }
   

** E.B.4: IQT *****************************************************************   
 {
 * IQT0:
   gen dIQT0_habB = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PhabB*WhabB_Tante if T==`t'
	  gen den = PhabB*WhabB_T if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT0_habB = sum_num/sum_den if T==`t'

	  drop num den sum_num sum_den
   }
  

 * IQT1:
   gen dIQT1_habB = .
  
   forvalues t = 2/`=Tmax'{
      gen num = PhabB*WhabB_T if T==`t'
	  gen den = PhabB*WhabB_Tprox if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT1_habB = sum_num/sum_den if T==`t'
	  
	  drop num den sum_num sum_den 
   }  
   
 * IQT: índice de Fisher   
   gen dIQT_habB = (dIQT0_habB*dIQT1_habB)^(1/2)
   
   label var dIQT0_habB "Variação IQT0 Habitual (B)"
   label var dIQT1_habB "Variação IQT1 Habitual (B)"
   label var dIQT_habB "Variação IQT Habitual (B)"
   
** Salvando base apenas do IQT:   
   preserve
   keep T dIQT0_habB dIQT1_habB dIQT_habB 
   duplicates drop
   
   gen IQT_habB = 100 if T==1
   replace IQT_habB = IQT_habB[_n-1]*dIQT_habB if _n > 1
   label var IQT_habB "IQT Habitual (B)"
   
   gen IQT_habB_2012t2 = 100 if T==2
   replace IQT_habB_2012t2 = IQT_habB_2012t2[_n-1]*dIQT_habB if _n > 2
   label var IQT_habB_2012t2 "IQT Habitual (B): 2012.2 = 100"
   
   merge 1:1 T using "$dirdata/E_IQT_Habitual.dta"
   drop _merge
   save "$dirdata/E_IQT_Habitual.dta", replace
   restore
  
   drop dIQT0_habB dIQT1_habB dIQT_habB
   save "$dirdata/E0_BaseEstimacao.dta", replace 
 } 
}
   
   
*******************************************************************************      
* E.C e E.D *******************************************************************   
{
  * Para o salário habitual, as estratégias C e D são exatamente iguais ao caso A. A diferença está no salário efetivo.
  preserve
  use "$dirdata/E_IQT_Habitual.dta", clear
  gen dIQT0_habC = dIQT0_habA
  gen dIQT1_habC = dIQT1_habA
  gen dIQT_habC = dIQT_habA
  
  label var dIQT0_habC "Variação IQT0 Habitual (C)"
  label var dIQT1_habC "Variação IQT1 Habitual (C)"
  label var dIQT_habC "Variação IQT Habitual (C)"
 
  gen IQT_habC = IQT_habA
  label var IQT_habC "IQT Habitual (C)"
   
  gen IQT_habC_2012t2 = IQT_habA_2012t2
  label var IQT_habC_2012t2 "IQT Habitual (C): 2012.2 = 100"
  
  
  gen dIQT0_habD = dIQT0_habA
  gen dIQT1_habD = dIQT1_habA
  gen dIQT_habD = dIQT_habA
  
  label var dIQT0_habD "Variação IQT0 Habitual (D)"
  label var dIQT1_habD "Variação IQT1 Habitual (D)"
  label var dIQT_habD "Variação IQT Habitual (D)"
 
  gen IQT_habD = IQT_habA
  label var IQT_habD "IQT Habitual (D)"
   
  gen IQT_habD_2012t2 = IQT_habA_2012t2
  label var IQT_habD_2012t2 "IQT Habitual (D): 2012.2 = 100"
  
  save "$dirdata/E_IQT_Habitual.dta", replace
  restore   
}   
   
   
   
*******************************************************************************
* F. GRÁFICOS  
*******************************************************************************
{
 use "$dirdata/D_IQT_Efetivo.dta", clear
 merge 1:1 T using "$dirdata/E_IQT_Habitual.dta"
 drop _merge

 egen Tmax = max(T)
 
 * Efetivo  
   twoway (line IQT_efetA T) (line IQT_efetB T) (line IQT_efetC T) (line IQT_efetC_alt T) (line IQT_efetD T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Efetivo, replace)
   twoway (line IQT_efetA_2012t2 T) (line IQT_efetB_2012t2 T) (line IQT_efetC_2012t2 T) (line IQT_efetC_alt_2012t2 T) (line IQT_efetD_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Efetivo2012, replace)
   twoway (line IQT_efetA_2012t2 T) (line IQT_efetB_2012t2 T) (line IQT_efetC_2012t2 T) (line IQT_efetC_alt_2012t2 T) (line IQT_efetC0_2012t2 T) (line IQT_efetC0_alt_2012t2 T) (line IQT_efetD_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Efetivo02012, replace)
   
   
 * Habitual
   twoway (line IQT_habA T) (line IQT_habB T) (line IQT_habC T) (line IQT_habD T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Habitual, replace)
   twoway (line IQT_habA_2012t2 T) (line IQT_habB_2012t2 T) (line IQT_habC_2012t2 T) (line IQT_habD_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_Habitual2012, replace)
 
 
 * Por estratégia:
   * A
     twoway (line IQT_efetA T) (line IQT_habA T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_A, replace)
	 twoway (line IQT_efetA_2012t2 T) (line IQT_habA_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_A2012, replace)
   
   * B
     twoway (line IQT_efetB T) (line IQT_habB T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_B, replace)
	 twoway (line IQT_efetB_2012t2 T) (line IQT_habB_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_B2012, replace)
   
   * C
     twoway (line IQT_efetC T) (line IQT_efetC_alt T) (line IQT_habC T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C, replace)
	 twoway (line IQT_efetC T) (line IQT_efetC_alt T) (line IQT_efetC0 T) (line IQT_efetC0_alt T) (line IQT_habC T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C0, replace)
	 twoway (line IQT_efetC_2012t2 T) (line IQT_efetC_alt_2012t2 T) (line IQT_habC_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C2012, replace)
	 twoway (line IQT_efetC_2012t2 T) (line IQT_efetC_alt_2012t2 T) (line IQT_efetC0_2012t2 T) (line IQT_efetC0_alt_2012t2 T) (line IQT_habC_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C02012, replace)
   
   * D
     twoway (line IQT_efetD T) (line IQT_habD T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_D, replace)
	 twoway (line IQT_efetD_2012t2 T) (line IQT_habD_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_D2012, replace)
	 
	 
 * Regressões com peso:
  * Estratégia C:
    twoway (line IQT_efetC_2012t2 T) (line IQT_efetC0_2012t2 T) (line IQT_efetC_peso_2012t2 T) (line IQT_efetC0_peso_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C2012_peso, replace)
	
	twoway (line IQT_efetC_alt_2012t2 T) (line IQT_efetC0_alt_2012t2 T) (line IQT_efetC_peso_alt_2012t2 T) (line IQT_efetC0_peso_alt_2012t2 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) name(IQT_C2012_peso_alt, replace)
	 
  save "$dirdata/F_IQT.dta", replace	 
 }  
  
log close
   
   
/* ETAPAS:
ok 1. Salvar coeficientes estimados
ok 2. Gráfico retornos ao longo do tempo
ok 3. Salários preditos para períodos subsequentes
ok 4. Exp dos salários
ok 5. Determinação dos grupos de EducxExper
ok 6. Horas médias por grupo
ok 7. Pesos ponderados por horas médias
ok 8. IQT0
ok 9. IQT1
ok 10. IQT
   ok - Valores
   ok - Gráfico
   ok - Base 100
   11. Repetir para:
   ok - Peso2
   ok - Rendimento efetivo nulo
   ok - Rendimento e horas habituais
   ok - Com peso
	  - Com controles
	  - Por região
	  - Por área de atividade
*/   