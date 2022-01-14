*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Retornos Educação
*******************************************************************************


* PREPARAÇÃO ******************************************************************
* Preparando memória: 
  clear all
  cls								
  set maxvar 30000
	
* Diretório: 
** Servidor RDPBI1VPR0002 (Ana Paula):   
   global dirpath = "T:\pastas_pessoais\ana_ruhe\Capital Humano\1. IQT"
   global dirdata = "T:\pastas_pessoais\ana_ruhe\Capital Humano\1. IQT\Dados"
   global dirbeta = "T:\pastas_pessoais\ana_ruhe\Capital Humano\3. Retornos Educação"
   
** Janaina:    
   global dirpath = "C:\Users\janaina.feijo\Documents\capital_humano\result"   
   global dirdata = "C:\Users\janaina.feijo\Documents\capital_humano\data" 
   
* Salvando log:   
  log using "$dirbeta/Log.log", replace
  

  
*******************************************************************************
* 0. PREPARANDO BASE **********************************************************
{
 use "$dirdata/C_BaseEstimacao.dta", clear
 
 keep T Peso mulher Experiencia Experiencia2 Experiencia3 Experiencia4 educ1 educ2 educ3 educ4 educ5 educ6 Tmax ExperMulher ExperMulher2 ExperMulher3 ExperMulher4 WEi_T WEiv_T WHi_T WHiv_T
 
 save "$dirbeta/Base.dta", replace
 
 merge m:1 T using "$dirdata/D_Coeficientes_Efetivo"
 drop _merge
 
 merge m:1 T using "$dirdata/D_Coeficientes_Habitual"
 drop _merge
 
 
 drop iiE_mulher iiE_educ2 iiE_educ3 iiE_educ4 iiE_educ5 iiE_educ6 iiE_Experiencia iiE_Experiencia2 iiE_Experiencia3 iiE_Experiencia4 iiE_ExperMulher iiE_ExperMulher2 iiE_ExperMulher3 iiE_ExperMulher4 iiE_PretoPardoIn iiE_cons iiiE_mulher iiiE_educ2 iiiE_educ3 iiiE_educ4 iiiE_educ5 iiiE_educ6 iiiE_Experiencia iiiE_Experiencia2 iiiE_Experiencia3 iiiE_Experiencia4 iiiE_ExperMulher iiiE_ExperMulher2 iiiE_ExperMulher3 iiiE_ExperMulher4 iiiE_PretoPardoIn iiiE_publico iiiE_cons iiH_mulher iiH_educ2 iiH_educ3 iiH_educ4 iiH_educ5 iiH_educ6 iiH_Experiencia iiH_Experiencia2 iiH_Experiencia3 iiH_Experiencia4 iiH_ExperMulher iiH_ExperMulher2 iiH_ExperMulher3 iiH_ExperMulher4 iiH_PretoPardoIn iiH_cons iiiH_mulher iiiH_educ2 iiiH_educ3 iiiH_educ4 iiiH_educ5 iiiH_educ6 iiiH_Experiencia iiiH_Experiencia2 iiiH_Experiencia3 iiiH_Experiencia4 iiiH_ExperMulher iiiH_ExperMulher2 iiiH_ExperMulher3 iiiH_ExperMulher4 iiiH_PretoPardoIn iiiH_publico iiiH_cons
 
 compress
 save "$dirbeta/Base.dta", replace
}


*******************************************************************************
* 1. SALÁRIO PREDITO MÉDIO DA ECONOMIA ****************************************
{
 use "$dirbeta/Base.dta", clear

 preserve
   collapse (mean) WEi_T (mean) WEiv_T (mean) WHi_T (mean) WHiv_T [iw=Peso], by(T)  
   
   rename WEi_T WE
   label var WE "Salário efetivo predito médio da economia"
   rename WEiv_T WE_controles
   label var WE_controles "Salário efetivo predito médio da economia - Com controles"
   
   rename WHi_T WH
   label var WH "Salário habitual predito médio da economia"
   rename WHiv_T WH_controles
   label var WH_controles "Salário habitual predito médio da economia - Com controles"
   
   compress
   save "$dirbeta/BetasAgregados.dta", replace
   
 restore
} 


*******************************************************************************
* 2. SALÁRIO PREDITO MÉDIO DA ECONOMIA COM RETORNOS CONSTANTES ****************
{
* 2.1: RETORNOS DE 2012.1 *****************************************************
 {
 use "$dirbeta/Base.dta", clear
 
** Efetivo: sem controles
   * Salvando coeficientes de 2012.1:
   foreach x of varlist iE_* {
     gen `x'_2012 = `x'[1]
   }
 
   * Salário predito: coeficientes constantes
   gen WEi_2012 = iE_cons_2012 + iE_mulher_2012*mulher + iE_educ2_2012*educ2 + iE_educ3_2012*educ3 + iE_educ4_2012*educ4 + iE_educ5_2012*educ5 + iE_educ6_2012*educ6 + iE_Experiencia_2012*Experiencia + iE_Experiencia2_2012*Experiencia2 + iE_Experiencia3_2012*Experiencia3 + iE_Experiencia4_2012*Experiencia4 + iE_ExperMulher_2012*ExperMulher + iE_ExperMulher2_2012*ExperMulher2 + iE_ExperMulher3_2012*ExperMulher3 + iE_ExperMulher4_2012*ExperMulher4
   replace WEi_2012 = exp(WEi_2012)
   label var WEi_2012 "W Efetivo - Sem controles - Retornos de 2012.1"
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist iE_*_2012 {
     drop `x'
   } 	
   

** Efetivo: com controles
   * Salvando coeficientes de 2012.1:
   foreach x of varlist ivE_* {
     gen `x'_2012 = `x'[1]
   }
 
   * Salário predito: coeficientes constantes
   gen WEiv_2012 = ivE_cons_2012 + ivE_mulher_2012*mulher + ivE_educ2_2012*educ2 + ivE_educ3_2012*educ3 + ivE_educ4_2012*educ4 + ivE_educ5_2012*educ5 + ivE_educ6_2012*educ6 + ivE_Experiencia_2012*Experiencia + ivE_Experiencia2_2012*Experiencia2 + ivE_Experiencia3_2012*Experiencia3 + ivE_Experiencia4_2012*Experiencia4 + ivE_ExperMulher_2012*ExperMulher + ivE_ExperMulher2_2012*ExperMulher2 + ivE_ExperMulher3_2012*ExperMulher3 + ivE_ExperMulher4_2012*ExperMulher4 	 
   replace WEiv_2012 = exp(WEiv_2012)
   label var WEiv_2012 "W Efetivo - Com controles - Retornos de 2012.1"
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist ivE_*_2012 {
     drop `x'
   }    


** Habitual: sem controles
   * Salvando coeficientes de 2012.1:
   foreach x of varlist iH_* {
     gen `x'_2012 = `x'[1]
   }
 
   * Salário predito: coeficientes constantes
   gen WHi_2012 = iH_cons_2012 + iH_mulher_2012*mulher + iH_educ2_2012*educ2 + iH_educ3_2012*educ3 + iH_educ4_2012*educ4 + iH_educ5_2012*educ5 + iH_educ6_2012*educ6 + iH_Experiencia_2012*Experiencia + iH_Experiencia2_2012*Experiencia2 + iH_Experiencia3_2012*Experiencia3 + iH_Experiencia4_2012*Experiencia4 + iH_ExperMulher_2012*ExperMulher + iH_ExperMulher2_2012*ExperMulher2 + iH_ExperMulher3_2012*ExperMulher3 + iH_ExperMulher4_2012*ExperMulher4 
   replace WHi_2012 = exp(WHi_2012) 
   label var WHi_2012 "W Habitual - Sem controles - Retornos de 2012.1"
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist iH_*_2012 {
     drop `x'
   } 	
   

** Habitual: com controles
   * Salvando coeficientes de 2012.1:
   foreach x of varlist ivH_* {
     gen `x'_2012 = `x'[1]
   }
 
   * Salário predito: coeficientes constantes
   gen WHiv_2012 = ivH_cons_2012 + ivH_mulher_2012*mulher + ivH_educ2_2012*educ2 + ivH_educ3_2012*educ3 + ivH_educ4_2012*educ4 + ivH_educ5_2012*educ5 + ivH_educ6_2012*educ6 + ivH_Experiencia_2012*Experiencia + ivH_Experiencia2_2012*Experiencia2 + ivH_Experiencia3_2012*Experiencia3 + ivH_Experiencia4_2012*Experiencia4 + ivH_ExperMulher_2012*ExperMulher + ivH_ExperMulher2_2012*ExperMulher2 + ivH_ExperMulher3_2012*ExperMulher3 + ivH_ExperMulher4_2012*ExperMulher4 	 
   label var WHiv_2012 "W Habitual - Com controles - Retornos de 2012.1"
   replace WHiv_2012 = exp(WHiv_2012)
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist ivH_*_2012 {
     drop `x'
   }     
	
 
 compress
 save "$dirbeta/Base.dta", replace	
 
 
** Salário médio:
 preserve
   collapse (mean) WEi_2012 (mean) WEiv_2012 (mean) WHi_2012 (mean) WHiv_2012 [iw=Peso], by(T)  
   
   rename WEi_2012 WE_2012
   label var WE_2012 "Salário efetivo predito médio da economia - Retornos de 2012.1"
   rename WEiv_2012 WE_2012_controles
   label var WE_2012_controles "Salário efetivo predito médio da economia - Retornos de 2012.1 - Com controles"
   
   rename WHi_2012 WH_2012
   label var WH_2012 "Salário habitual predito médio da economia - Retornos de 2012.1"
   rename WHiv_2012 WH_2012_controles
   label var WH_2012_controles "Salário habitual predito médio da economia - Retornos de 2012.1 - Com controles"
   
   merge 1:1 T using "$dirbeta/BetasAgregados.dta"
   drop _merge
   
   
   order WE_2012  WE_2012_controles WH_2012 WH_2012_controles, after(WH_controles)
   compress
   save "$dirbeta/BetasAgregados.dta", replace   
 restore 
 
 }
 
 
* 2.2: RETORNOS DE 2021.1 *****************************************************
  * Uso o mesmo trimestre (1º) para tentar mitigar efeitos sazonais
 {
 use "$dirbeta/Base.dta", clear
 
** Efetivo: sem controles
   * Salvando coeficientes de 2021.1:
   foreach x of varlist iE_* {
     gen `x'_2021 = `x'[8076140]
   }
 
   * Salário predito: coeficientes constantes
   gen WEi_2021 = iE_cons_2021 + iE_mulher_2021*mulher + iE_educ2_2021*educ2 + iE_educ3_2021*educ3 + iE_educ4_2021*educ4 + iE_educ5_2021*educ5 + iE_educ6_2021*educ6 + iE_Experiencia_2021*Experiencia + iE_Experiencia2_2021*Experiencia2 + iE_Experiencia3_2021*Experiencia3 + iE_Experiencia4_2021*Experiencia4 + iE_ExperMulher_2021*ExperMulher + iE_ExperMulher2_2021*ExperMulher2 + iE_ExperMulher3_2021*ExperMulher3 + iE_ExperMulher4_2021*ExperMulher4
   replace WEi_2021 = exp(WEi_2021)
   label var WEi_2021 "W Efetivo - Sem controles - Retornos de 2021.1"
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist iE_*_2021 {
     drop `x'
   } 	
   

** Efetivo: com controles
   * Salvando coeficientes de 2021.1:
   foreach x of varlist ivE_* {
     gen `x'_2021 = `x'[8076140]
   }
 
   * Salário predito: coeficientes constantes
   gen WEiv_2021 = ivE_cons_2021 + ivE_mulher_2021*mulher + ivE_educ2_2021*educ2 + ivE_educ3_2021*educ3 + ivE_educ4_2021*educ4 + ivE_educ5_2021*educ5 + ivE_educ6_2021*educ6 + ivE_Experiencia_2021*Experiencia + ivE_Experiencia2_2021*Experiencia2 + ivE_Experiencia3_2021*Experiencia3 + ivE_Experiencia4_2021*Experiencia4 + ivE_ExperMulher_2021*ExperMulher + ivE_ExperMulher2_2021*ExperMulher2 + ivE_ExperMulher3_2021*ExperMulher3 + ivE_ExperMulher4_2021*ExperMulher4 	 
   replace WEiv_2021 = exp(WEiv_2021)
   label var WEiv_2021 "W Efetivo - Com controles - Retornos de 2021.1"
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist ivE_*_2021 {
     drop `x'
   }    


** Habitual: sem controles
   * Salvando coeficientes de 2021.1:
   foreach x of varlist iH_* {
     gen `x'_2021 = `x'[8076140]
   }
 
   * Salário predito: coeficientes constantes
   gen WHi_2021 = iH_cons_2021 + iH_mulher_2021*mulher + iH_educ2_2021*educ2 + iH_educ3_2021*educ3 + iH_educ4_2021*educ4 + iH_educ5_2021*educ5 + iH_educ6_2021*educ6 + iH_Experiencia_2021*Experiencia + iH_Experiencia2_2021*Experiencia2 + iH_Experiencia3_2021*Experiencia3 + iH_Experiencia4_2021*Experiencia4 + iH_ExperMulher_2021*ExperMulher + iH_ExperMulher2_2021*ExperMulher2 + iH_ExperMulher3_2021*ExperMulher3 + iH_ExperMulher4_2021*ExperMulher4 
   replace WHi_2021 = exp(WHi_2021) 
   label var WHi_2021 "W Habitual - Sem controles - Retornos de 2021.1"
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist iH_*_2021 {
     drop `x'
   } 	
   

** Habitual: com controles
   * Salvando coeficientes de 2021.1:
   foreach x of varlist ivH_* {
     gen `x'_2021 = `x'[8076140]
   }
 
   * Salário predito: coeficientes constantes
   gen WHiv_2021 = ivH_cons_2021 + ivH_mulher_2021*mulher + ivH_educ2_2021*educ2 + ivH_educ3_2021*educ3 + ivH_educ4_2021*educ4 + ivH_educ5_2021*educ5 + ivH_educ6_2021*educ6 + ivH_Experiencia_2021*Experiencia + ivH_Experiencia2_2021*Experiencia2 + ivH_Experiencia3_2021*Experiencia3 + ivH_Experiencia4_2021*Experiencia4 + ivH_ExperMulher_2021*ExperMulher + ivH_ExperMulher2_2021*ExperMulher2 + ivH_ExperMulher3_2021*ExperMulher3 + ivH_ExperMulher4_2021*ExperMulher4 	 
   label var WHiv_2021 "W Habitual - Com controles - Retornos de 2021.1"
   replace WHiv_2021 = exp(WHiv_2021)
  
   * Removendo da memória variáveis intermediárias (coeficientes salvos)
   foreach x of varlist ivH_*_2021 {
     drop `x'
   }     
	
 
 compress
 save "$dirbeta/Base.dta", replace	
 
 
** Salário médio:
 preserve
   collapse (mean) WEi_2021 (mean) WEiv_2021 (mean) WHi_2021 (mean) WHiv_2021 [iw=Peso], by(T)  
   
   rename WEi_2021 WE_2021
   label var WE_2021 "Salário efetivo predito médio da economia - Retornos de 2021.1"
   rename WEiv_2021 WE_2021_controles
   label var WE_2021_controles "Salário efetivo predito médio da economia - Retornos de 2021.1 - Com controles"
   
   rename WHi_2021 WH_2021
   label var WH_2021 "Salário habitual predito médio da economia - Retornos de 2021.1"
   rename WHiv_2021 WH_2021_controles
   label var WH_2021_controles "Salário habitual predito médio da economia - Retornos de 2021.1 - Com controles"
   
   merge 1:1 T using "$dirbeta/BetasAgregados.dta"
   drop _merge
   
   
   order WE_2021  WE_2021_controles WH_2021 WH_2021_controles, after(WH_2012_controles)
   compress
   save "$dirbeta/BetasAgregados.dta", replace   
 restore 
 
 }

 
* 2.3: GRÁFICOS ***************************************************************
 {
 use "$dirbeta/BetasAgregados.dta", clear
 
 egen Tmax = max(T)
 
** Efetivo: sem controles
   twoway (line WE_2012 T) (line WE_2021 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(10(2)16, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(1) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(WEfetivoMedio, replace) 
   *graph export "$dirpath/Gráficos/WEfetivoMedio.png", width(10000) as(png) replace
   
** Efetivo: com controles
   twoway (line WE_2012_controles T) (line WE_2021_controles T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(10(2)16, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(1) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(WEfetivoMedio_controles, replace) 
   *graph export "$dirpath/Gráficos/WEfetivoMedio_controles.png", width(10000) as(png) replace   
   
   
** Habitual: sem controles
   twoway (line WH_2012 T) (line WH_2021 T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(10(2)15, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(1) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(WHabitualMedio, replace) 
   *graph export "$dirpath/Gráficos/WHabitualMedio.png", width(10000) as(png) replace
   
** Habitual: com controles
   twoway (line WH_2012_controles T) (line WH_2021_controles T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(10(2)15, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(1) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(WHabitualMedio_controles, replace) 
   *graph export "$dirpath/Gráficos/WHabitualMedio_controles.png", width(10000) as(png) replace   
 }
}


*******************************************************************************
* 3. RETORNOS MÉDIOS **********************************************************
{
 use "$dirbeta/Base.dta", clear

* 3.1: RETORNO MÉDIO EM NÍVEL *************************************************
 {  
 * Efetivo: sem controles
   gen iE_BetaEduc = iE_cons
   replace iE_BetaEduc = iE_cons + iE_educ2 + (mulher*iE_mulher) if educ2 == 1
   replace iE_BetaEduc = iE_cons + iE_educ3 + (mulher*iE_mulher) if educ3 == 1
   replace iE_BetaEduc = iE_cons + iE_educ4 + (mulher*iE_mulher) if educ4 == 1
   replace iE_BetaEduc = iE_cons + iE_educ5 + (mulher*iE_mulher) if educ5 == 1
   replace iE_BetaEduc = iE_cons + iE_educ6 + (mulher*iE_mulher) if educ6 == 1
   
 * Efetivo: com controles
   gen ivE_BetaEduc = ivE_cons
   replace ivE_BetaEduc = ivE_cons + ivE_educ2 + (mulher*ivE_mulher) if educ2 == 1
   replace ivE_BetaEduc = ivE_cons + ivE_educ3 + (mulher*ivE_mulher) if educ3 == 1
   replace ivE_BetaEduc = ivE_cons + ivE_educ4 + (mulher*ivE_mulher) if educ4 == 1
   replace ivE_BetaEduc = ivE_cons + ivE_educ5 + (mulher*ivE_mulher) if educ5 == 1
   replace ivE_BetaEduc = ivE_cons + ivE_educ6 + (mulher*ivE_mulher) if educ6 == 1
   
   
 * Habitual: sem controles
   gen iH_BetaEduc = iH_cons
   replace iH_BetaEduc = iH_cons + iH_educ2 + (mulher*iH_mulher) if educ2 == 1
   replace iH_BetaEduc = iH_cons + iH_educ3 + (mulher*iH_mulher) if educ3 == 1
   replace iH_BetaEduc = iH_cons + iH_educ4 + (mulher*iH_mulher) if educ4 == 1
   replace iH_BetaEduc = iH_cons + iH_educ5 + (mulher*iH_mulher) if educ5 == 1
   replace iH_BetaEduc = iH_cons + iH_educ6 + (mulher*iH_mulher) if educ6 == 1
   
 * Habitual: com controles
   gen ivH_BetaEduc = ivH_cons
   replace ivH_BetaEduc = ivH_cons + ivH_educ2 + (mulher*ivH_mulher) if educ2 == 1
   replace ivH_BetaEduc = ivH_cons + ivH_educ3 + (mulher*ivH_mulher) if educ3 == 1
   replace ivH_BetaEduc = ivH_cons + ivH_educ4 + (mulher*ivH_mulher) if educ4 == 1
   replace ivH_BetaEduc = ivH_cons + ivH_educ5 + (mulher*ivH_mulher) if educ5 == 1
   replace ivH_BetaEduc = ivH_cons + ivH_educ6 + (mulher*ivH_mulher) if educ6 == 1
   
   save "$dirbeta/Base.dta", replace
   
   preserve 
     collapse (mean) iE_BetaEduc (mean) ivE_BetaEduc (mean) iH_BetaEduc (mean) ivH_BetaEduc [iw = Peso], by(T)
	 
	 rename iE_BetaEduc BetaE
     label var BetaE "Retorno médio da educação - Efetivo"
	 rename ivE_BetaEduc BetaE_controles
     label var BetaE_controles "Retorno médio da educação - Efetivo - Com controles"
	 
	 rename iH_BetaEduc BetaH
     label var BetaH "Retorno médio da educação - Habitual"
	 rename ivH_BetaEduc BetaH_controles
     label var BetaH_controles "Retorno médio da educação - Habitual - Com controles"
	 
	 merge 1:1 T using "$dirbeta/BetasAgregados.dta"
	 drop _merge
	 
	 compress
	 save "$dirbeta/BetasAgregados.dta", replace
   restore
 }


* 3.2: RETORNO MÉDIO EM EXPONENCIAL *******************************************
 {  
 * Efetivo: sem controles
   gen iE_ExpBetaEduc = exp(iE_cons)
   replace iE_ExpBetaEduc = exp(iE_cons + iE_educ2 + (mulher*iE_mulher)) if educ2 == 1
   replace iE_ExpBetaEduc = exp(iE_cons + iE_educ3 + (mulher*iE_mulher)) if educ3 == 1
   replace iE_ExpBetaEduc = exp(iE_cons + iE_educ4 + (mulher*iE_mulher)) if educ4 == 1
   replace iE_ExpBetaEduc = exp(iE_cons + iE_educ5 + (mulher*iE_mulher)) if educ5 == 1
   replace iE_ExpBetaEduc = exp(iE_cons + iE_educ6 + (mulher*iE_mulher)) if educ6 == 1
   
 * Efetivo: com controles
   gen ivE_ExpBetaEduc = exp(ivE_cons)
   replace ivE_ExpBetaEduc = exp(ivE_cons + ivE_educ2 + (mulher*ivE_mulher)) if educ2 == 1
   replace ivE_ExpBetaEduc = exp(ivE_cons + ivE_educ3 + (mulher*ivE_mulher)) if educ3 == 1
   replace ivE_ExpBetaEduc = exp(ivE_cons + ivE_educ4 + (mulher*ivE_mulher)) if educ4 == 1
   replace ivE_ExpBetaEduc = exp(ivE_cons + ivE_educ5 + (mulher*ivE_mulher)) if educ5 == 1
   replace ivE_ExpBetaEduc = exp(ivE_cons + ivE_educ6 + (mulher*ivE_mulher)) if educ6 == 1
   
   
 * Habitual: sem controles
   gen iH_ExpBetaEduc = exp(iH_cons)
   replace iH_ExpBetaEduc = exp(iH_cons + iH_educ2 + (mulher*iH_mulher)) if educ2 == 1
   replace iH_ExpBetaEduc = exp(iH_cons + iH_educ3 + (mulher*iH_mulher)) if educ3 == 1
   replace iH_ExpBetaEduc = exp(iH_cons + iH_educ4 + (mulher*iH_mulher)) if educ4 == 1
   replace iH_ExpBetaEduc = exp(iH_cons + iH_educ5 + (mulher*iH_mulher)) if educ5 == 1
   replace iH_ExpBetaEduc = exp(iH_cons + iH_educ6 + (mulher*iH_mulher)) if educ6 == 1
   
 * Habitual: com controles
   gen ivH_ExpBetaEduc = exp(ivH_cons)
   replace ivH_ExpBetaEduc = exp(ivH_cons + ivH_educ2 + (mulher*ivH_mulher)) if educ2 == 1
   replace ivH_ExpBetaEduc = exp(ivH_cons + ivH_educ3 + (mulher*ivH_mulher)) if educ3 == 1
   replace ivH_ExpBetaEduc = exp(ivH_cons + ivH_educ4 + (mulher*ivH_mulher)) if educ4 == 1
   replace ivH_ExpBetaEduc = exp(ivH_cons + ivH_educ5 + (mulher*ivH_mulher)) if educ5 == 1
   replace ivH_ExpBetaEduc = exp(ivH_cons + ivH_educ6 + (mulher*ivH_mulher)) if educ6 == 1
   
   save "$dirbeta/Base.dta", replace
   
   
 * Média: com pesos da PNAD
   preserve 
     collapse (mean) iE_ExpBetaEduc (mean) ivE_ExpBetaEduc (mean) iH_ExpBetaEduc (mean) ivH_ExpBetaEduc [iw = Peso], by(T)
	 
	 rename iE_ExpBetaEduc ExpBetaE
     label var ExpBetaE "Exponencial do retorno médio da educação - Efetivo"
	 rename ivE_ExpBetaEduc ExpBetaE_controles
     label var ExpBetaE_controles "Exponencial do retorno médio da educação  - Efetivo - Com controles"
	 
	 rename iH_ExpBetaEduc ExpBetaH
     label var ExpBetaH "Exponencial do retorno médio da educação  - Habitual"
	 rename ivH_ExpBetaEduc ExpBetaH_controles
     label var ExpBetaH_controles "Exponencial do retorno médio da educação  - Habitual - Com controles"
	 
	 merge 1:1 T using "$dirbeta/BetasAgregados.dta"
	 drop _merge
	 
	 compress
	 save "$dirbeta/BetasAgregados.dta", replace
   restore
   
   
  * Média: sem pesos da PNAD
   preserve 
     collapse (mean) iE_ExpBetaEduc (mean) ivE_ExpBetaEduc (mean) iH_ExpBetaEduc (mean) ivH_ExpBetaEduc, by(T)
	 
	 rename iE_ExpBetaEduc ExpBetaE_sempeso
     label var ExpBetaE_sempeso "Exponencial do retorno médio da educação - Efetivo (s/ peso PNAD)"
	 rename ivE_ExpBetaEduc ExpBetaE_controles_sempeso
     label var ExpBetaE_controles_sempeso "Exponencial do retorno médio da educação  - Efetivo - Com controles (s/ peso PNAD)"
	 
	 rename iH_ExpBetaEduc ExpBetaH_sempeso
     label var ExpBetaH_sempeso "Exponencial do retorno médio da educação  - Habitual (s/ peso PNAD)"
	 rename ivH_ExpBetaEduc ExpBetaH_controles_sempeso
     label var ExpBetaH_controles_sempeso "Exponencial do retorno médio da educação  - Habitual - Com controles (s/ peso PNAD)"
	 
	 merge 1:1 T using "$dirbeta/BetasAgregados.dta"
	 drop _merge
	 
	 compress
	 save "$dirbeta/BetasAgregados.dta", replace
   restore 

 }


* 3.2: GRÁFICOS *************************************************************** 
 {
 use "$dirbeta/BetasAgregados.dta", clear
   
 egen Tmax = max(T)
   
 twoway (line BetaE T) (line BetaE_controles T) (line BetaH T) (line BetaH_controles T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(1.85(0.1)2.25, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(2) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(BetaAgregado, replace) 
 *graph export "$dirpath/Gráficos/BetaAgregado.png", width(10000) as(BetaAgregado.png) replace
   

 twoway (line ExpBetaE T) (line ExpBetaE_controles T) (line ExpBetaH T) (line ExpBetaH_controles T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel labsize(*0.8)) graphregion(color(white)) ylab(7(0.5)10.5, labsize(*0.8) angle(horizontal))  xline(10 20 32 34, lpattern(dash) lcolor(gray)) legend(c(1) symys(*.7) symxs(*.7) size(*0.7) region(c(none))) name(ExpBetaAgregado, replace) 
 *graph export "$dirpath/Gráficos/BetaAgregado.png", width(10000) as(ExpBetaAgregado.png) replace
    
 }
 

* 3.3: EXPORTANDO EXCEL *******************************************************
 {
  use "$dirbeta/BetasAgregados.dta", clear

  export excel T BetaE BetaE_controles BetaH BetaH_controles using "$dirbeta\BetasAgregados.xlsx", sheet("Betas", modify) firstrow(varlabels) 
  export excel T ExpBetaE ExpBetaE_controles ExpBetaH ExpBetaH_controles using "$dirbeta\BetasAgregados.xlsx", sheet("Exp(Betas)", modify) firstrow(varlabels) 
  export excel T ExpBetaE_sempeso ExpBetaE_controles_sempeso ExpBetaH_sempeso ExpBetaH_controles_sempeso using "$dirbeta\BetasAgregados.xlsx", sheet("Exp(Betas) - Sem peso", modify) firstrow(varlabels) 
  export excel T WE WE_controles WH WH_controles WE_2012 WE_2012_controles WH_2012 WH_2012_controles WE_2021 WE_2021_controles WH_2021 WH_2021_controles using "$dirbeta\BetasAgregados.xlsx", sheet ("W Médio", modify) firstrow(varlabels) 
 } 
}




log close


   