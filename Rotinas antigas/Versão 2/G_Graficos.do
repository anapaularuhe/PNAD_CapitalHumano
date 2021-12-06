*******************************************************************************
* G.4 GRÁFICOS ****************************************************************
{
 use "$dirdata/G_IQT_Controles.dta", clear
 
** G.4.1 Baseline:
 {
*** POR CATEGORIA:
  * Efetivo C:
    twoway (line IQT_E1i T) (line IQT_E1ii T) (line IQT_E1iii T) (line IQT_E1iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Baseline") name(IQT_1E, replace)
	
  * Efetivo C_alt
    twoway (line IQT_E1i_alt T) (line IQT_E1ii_alt T) (line IQT_E1iii_alt T) (line IQT_E1iv_alt T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Baseline") name(IQT_1E_alt, replace)
   
  * Habitual:
    twoway (line IQT_H1i T) (line IQT_H1ii T) (line IQT_H1iii T) (line IQT_H1iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Baseline") name(IQT_1H, replace)
	
	
***	POR CONTROLE:
  * (i) Sem controles:
    twoway (line IQT_E1i T) (line IQT_E1i_alt T) (line IQT_H1i T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Baseline") name(IQT_1i, replace)
  
  * (ii) Cor:
    twoway (line IQT_E1ii T) (line IQT_E1ii_alt T) (line IQT_H1ii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Baseline") name(IQT_1ii, replace)
  
  * (iii) Setor público:
    twoway (line IQT_E1iii T) (line IQT_E1iii_alt T) (line IQT_H1iii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Baseline") name(IQT_1iii, replace)
  
  * (iv) Informal:
    twoway (line IQT_E1iv T) (line IQT_E1iv_alt T) (line IQT_H1iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Baseline") name(IQT_1iv, replace)
 }    
   

** G.4.2 Estimação log=0 se W=0:
 {
*** POR CATEGORIA:
  * Efetivo C:
    twoway (line IQT_E2i T) (line IQT_E2ii T) (line IQT_E2iii T) (line IQT_E2iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("log = 0 se W = 0") name(IQT_2E, replace)
	
  * Efetivo C_alt
    twoway (line IQT_E2i_alt T) (line IQT_E2ii_alt T) (line IQT_E2iii_alt T) (line IQT_E2iv_alt T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("log = 0 se W = 0") name(IQT_2E_alt, replace)
   
  * Habitual:
    twoway (line IQT_H2i T) (line IQT_H2ii T) (line IQT_H2iii T) (line IQT_H2iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("log = 0 se W = 0") name(IQT_2H, replace)
	
	
***	POR CONTROLE:
  * (i) Sem controles:
    twoway (line IQT_E2i T) (line IQT_E2i_alt T) (line IQT_H2i T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("log = 0 se W = 0") name(IQT_2i, replace)
  
  * (ii) Cor:
    twoway (line IQT_E2ii T) (line IQT_E2ii_alt T) (line IQT_H2ii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("log = 0 se W = 0") name(IQT_2ii, replace)
  
  * (iii) Setor público:
    twoway (line IQT_E2iii T) (line IQT_E2iii_alt T) (line IQT_H2iii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("log = 0 se W = 0") name(IQT_2iii, replace)
  
  * (iv) Informal:
    twoway (line IQT_E2iv T) (line IQT_E2iv_alt T) (line IQT_H2iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("log = 0 se W = 0") name(IQT_2iv, replace)
 }    
      

** G.4.3 Estimação com pesos:
 {
*** POR CATEGORIA:
  * Efetivo C:
    twoway (line IQT_E3i T) (line IQT_E3ii T) (line IQT_E3iii T) (line IQT_E3iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso") name(IQT_3E, replace)
	
  * Efetivo C_alt
    twoway (line IQT_E3i_alt T) (line IQT_E3ii_alt T) (line IQT_E3iii_alt T) (line IQT_E3iv_alt T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso") name(IQT_3E_alt, replace)
   
  * Habitual:
    twoway (line IQT_H3i T) (line IQT_H3ii T) (line IQT_H3iii T) (line IQT_H3iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso") name(IQT_3H, replace)
	
	
***	POR CONTROLE:
  * (i) Sem controles:
    twoway (line IQT_E3i T) (line IQT_E3i_alt T) (line IQT_H3i T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso") name(IQT_3i, replace)
  
  * (ii) Cor:
    twoway (line IQT_E3ii T) (line IQT_E3ii_alt T) (line IQT_H3ii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso") name(IQT_3ii, replace)
  
  * (iii) Setor público:
    twoway (line IQT_E3iii T) (line IQT_E3iii_alt T) (line IQT_H3iii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso") name(IQT_3iii, replace)
  
  * (iv) Informal:
    twoway (line IQT_E3iv T) (line IQT_E3iv_alt T) (line IQT_H3iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso") name(IQT_3iv, replace)
 }  	  
   

** G.4.4 Estimação com pesos + log=0 se W=0:
 {
*** POR CATEGORIA:
  * Efetivo C:
    twoway (line IQT_E4i T) (line IQT_E4ii T) (line IQT_E4iii T) (line IQT_E4iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso + log = 0") name(IQT_4E, replace)
	
  * Efetivo C_alt
    twoway (line IQT_E4i_alt T) (line IQT_E4ii_alt T) (line IQT_E4iii_alt T) (line IQT_E4iv_alt T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso + log = 0") name(IQT_4E_alt, replace)
   
  * Habitual:
    twoway (line IQT_H4i T) (line IQT_H4ii T) (line IQT_H4iii T) (line IQT_H4iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso + log = 0") name(IQT_4H, replace)
	
	
***	POR CONTROLE:
  * (i) Sem controles:
    twoway (line IQT_E4i T) (line IQT_E4i_alt T) (line IQT_H4i T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso + log = 0") name(IQT_4i, replace)
  
  * (ii) Cor:
    twoway (line IQT_E4ii T) (line IQT_E4ii_alt T) (line IQT_H4ii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso + log = 0") name(IQT_4ii, replace)
  
  * (iii) Setor público:
    twoway (line IQT_E4iii T) (line IQT_E4iii_alt T) (line IQT_H4iii T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso + log = 0") name(IQT_4iii, replace)
  
  * (iv) Informal:
    twoway (line IQT_E4iv T) (line IQT_E4iv_alt T) (line IQT_H4iv T), xtitle(" ") xlabel(1(2)`=Tmax', angle(vertical) valuelabel) title("Com peso + log = 0") name(IQT_4iv, replace)
 }  	  

 
** Comparando 4 tipos de regressão
   twoway (line IQT_E1iv_alt T) (line IQT_E2iv_alt T) (line IQT_E3iv_alt T) (line IQT_E4iv_alt T), ytitle(IQT) ytitle(, orientation(vertical)) xtitle(" ") xlabel(1(2)38, labels angle(vertical) valuelabel) title("Comparação Regressões - C_alt Informal") legend(on order(1 "Baseline" 2 "log = 0" 3 "Com peso" 4 "Com peso + log = 0")) name(IQT_regressoes, replace)
   
}  
