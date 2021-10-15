*********************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Ana Paula Nothen Ruhe
* Outubro/2021
*********************************************************************

* PREPARAÇÃO ********************************************************
* Necessária instalação de pacote:
*  search labutil 


* Garantindo que não há variáveis prévias na memória:
clear all
cls								

* Configurações de memória:
set maxvar 30000
	
* Configurando diretório: 
cd "C:/Users/ana.ruhe/Documents/Capital_Humano"
global dirdata = "C:/Users/ana.ruhe/Documents/Capital_Humano/Dados"


* Salvando log:
log using "Estimacao.log", replace


* RETORNOS DE EDUCAÇÃO E EXPERIÊNCIA: RENDIMENTO EFETIVO ************
* 1. PRELIMINARES
** Dados:
   use "$dirdata/PNADC_amostra.dta", clear
   
** Geramos variável para o período, t
   gen T = ((Ano - 2012)*4) + real(Trimestre)
   label var T "Período sequencial"
   order T, after(Trimestre)
   
 * Vamos criar label para o período:  
   tostring Ano, generate(Ano_string) 
   gen Periodo = Ano_string + "-" + Trimestre

 * Função labmask do pacote labutil: usa os valores de Periodo como label de T
   labmask T, values(Periodo)
   
   drop Ano_string Periodo
   
   save "$dirdata/PNADC_amostraT.dta", replace

   
* 2. ESTIMAÇÃO BASELINE    
** Grupo de educação 1 é omitido (referencial):   
forvalues t = 1/38 {  
    * Homens:  
	  regress logW_Efetivo dummy_educ2 dummy_educ3 dummy_educ4 dummy_educ5 dummy_educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & dummy_Mulher==0)
	  predict logRegEfetivoHomem_`t' if(T>=(`t'-1) & T<=(`t'+1) & dummy_Mulher==0)	 
	  estimates save "$dirdata/estimacao_efetivo_baseline", append
	
	* Mulheres:
	  regress logW_Efetivo dummy_educ2 dummy_educ3 dummy_educ4 dummy_educ5 dummy_educ6 Experiencia Experiencia2 Experiencia3 Experiencia4 if (T==`t' & dummy_Mulher==1)
	  predict logRegEfetivoMulher_`t' if(T>=(`t'-1) & T<=(`t'+1) & dummy_Mulher==1)	 
	  estimates save "$dirdata/estimacao_efetivo_baseline", append
   }
   
   
** Salvando os coeficientes:
   statsby, by(T dummy_Mulher) saving("$dirdata/coeficientes_efetivo_baseline.dta", replace): regress logW_Efetivo dummy_educ2 dummy_educ3 dummy_educ4 dummy_educ5 dummy_educ6 Experiencia Experiencia2 Experiencia3 Experiencia4
   
   
** Evolução dos retornos de educação e experiência ao longo do tempo:   
   preserve
    use "$dirdata/coeficientes_efetivo_baseline.dta", clear
    label var _b_cons "Constante: Educação Grupo 1"
	label var _b_dummy_educ2 "Educação: diferencial Grupo 2"
	label var _b_dummy_educ3 "Educação: diferencial Grupo 3"
	label var _b_dummy_educ4 "Educação: diferencial Grupo 4"
	label var _b_dummy_educ5 "Educação: diferencial Grupo 5"
	label var _b_dummy_educ6 "Educação: diferencial Grupo 6"
	
	label var _b_Experiencia "Experiência"
	label var _b_Experiencia2 "Experiência ao quadrado"
	label var _b_Experiencia3 "Experiência ao cubo"
	label var _b_Experiencia4 "Experiência na 4ª potência"

  * Coeficientes estimados dão retornos diferenciais. Vamos calcular os retornos acumulados:	
 	gen Educ2 = _b_cons + _b_dummy_educ2
 	gen Educ3 = _b_cons + _b_dummy_educ3
 	gen Educ4 = _b_cons + _b_dummy_educ4
 	gen Educ5 = _b_cons + _b_dummy_educ5
 	gen Educ6 = _b_cons + _b_dummy_educ6

 	label var Educ2 "Educação Grupo 2"
 	label var Educ3 "Educação Grupo 3"
 	label var Educ4 "Educação Grupo 4"
 	label var Educ5 "Educação Grupo 5"
 	label var Educ6 "Educação Grupo 6"
  
  * Gráficos:
	twoway (line _b_cons T if(dummy_Mulher==0)) (line Educ2 T if(dummy_Mulher==0)) (line Educ3 T if(dummy_Mulher==0)) (line Educ4 T if(dummy_Mulher==0)) (line Educ5 T if(dummy_Mulher==0)) (line Educ6 T if(dummy_Mulher==0)), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(RetornosEducHomens, replace)
	twoway (line _b_cons T if(dummy_Mulher==1)) (line Educ2 T if(dummy_Mulher==1)) (line Educ3 T if(dummy_Mulher==1)) (line Educ4 T if(dummy_Mulher==1)) (line Educ5 T if(dummy_Mulher==1)) (line Educ6 T if(dummy_Mulher==1)), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(RetornosEducMulheres, replace)
	
	twoway (line _b_Experiencia T if(dummy_Mulher==0)) (line _b_Experiencia2 T if(dummy_Mulher==0)) (line _b_Experiencia3 T if(dummy_Mulher==0)) (line _b_Experiencia4 T if(dummy_Mulher==0)), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(RetornosExperHomens, replace)
	twoway (line _b_Experiencia T if(dummy_Mulher==1)) (line _b_Experiencia2 T if(dummy_Mulher==1)) (line _b_Experiencia3 T if(dummy_Mulher==1)) (line _b_Experiencia4 T if(dummy_Mulher==1)), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(RetornosExperMulheres, replace)
	
	*line _b_cons Educ2 Educ3 Educ4 Educ5 Educ6 T if(dummy_Mulher==0), name(RetornosEducHomens)
	*line _b_cons Educ2 Educ3 Educ4 Educ5 Educ6 T if(dummy_Mulher==1), name(RetornosEducMulheres)

	*line _b_Experiencia _b_Experiencia2 _b_Experiencia3 _b_Experiencia4 T if(dummy_Mulher==0), name(RetornosExperHomens)
	*line _b_Experiencia _b_Experiencia2 _b_Experiencia3 _b_Experiencia4 T if(dummy_Mulher==1), name(RetornosExperMulheres)
   
    save "$dirdata/coeficientes_efetivo_baseline.dta", replace
   restore

   
** Calculando salários preditos:
 * Eliminamos variáveis não mais necessárias da amostra:
   drop UF Regiao V1027 Populacao Idade V3003 V3003A V3009 V3009A VD3004 VD3005 VD4001 VD4002 VD4009 VD4010 VD4016 VD4019 VD4019_real VD4019_real_hora logW_Habitual VD4031 VD4032 Habitual 
 
 * Exponencial + sintetizamos salários de homens e mulheres em mesma variável
   forvalues t = 1/38 {
	  gen WRegEfetivo_`t' = exp(logRegEfetivoHomem_`t') if dummy_Mulher==0
	  replace WRegEfetivo_`t' = exp(logRegEfetivoMulher_`t') if dummy_Mulher==1
   }
   
 * Para economizar memória, podemos descartar os valores em log:  
   forvalues t = 1/38 {
      drop logRegEfetivoHomem_`t' logRegEfetivoMulher_`t'
   }
 
 
 /* Vamos consolidar os salários preditos em 3 variáveis: 
    - WEfetivo_T     = salários em t preditos pelos coeficientes estimados de t
	- WEfetivo_Tante = salários em t preditos pelos coeficientes estimados de t-1
	- WEfetivo_Tprox = salários em t preditos pelos coeficientes estimados de t+1
 */
   
   gen WEfetivo_T = .
   gen WEfetivo_Tante = .
   gen WEfetivo_Tprox = .
   
   label var WEfetivo_T "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t"
   label var WEfetivo_Tante "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t-1"
   label var WEfetivo_Tprox "Rendimento efetivo por hora em t predito pelos coeficientes estimados de t+1"
   
   
   forvalues t = 1/38 {
      replace WEfetivo_T = WRegEfetivo_`t' if T==`t'
	  
	  local i = `t'-1
	  if `t' > 1 replace WEfetivo_Tante = WRegEfetivo_`i' if T==`t'
	  
	  local j = `t'+1 
	  if `t' < 38 replace WEfetivo_Tprox = WRegEfetivo_`j' if T==`t'
   }
 
   order WEfetivo_T WEfetivo_Tante WEfetivo_Tprox, before(WRegEfetivo_1)

 * Podemos eliminar os salários efetivos separados por período, para economizar memória:
   forvalues t = 1/38 { 
       drop WRegEfetivo_`t'
   }  
 
 
 * Visualizando estimação: rendimento real médio por hora observado x predito, por trimestre
   egen W_medio = mean(VD4020_real_hora), by(T)
   egen Wpred_medio = mean(WEfetivo_T), by(T)
   
   label var W_medio "Rendimento médio observado"
   label var Wpred_medio "Rendimento médio predito"
  
   twoway (line W_medio T) (line Wpred_medio T), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(W_efetivo, replace)
 
 
   save "$dirdata/PNADC_amostra_efetivo.dta", replace
   
  
  
** Pesos por hora média:
 * Calculando hora média por grupo (Educ e Experiencia) para cada t:     
   bysort T VD3006 Experiencia: egen HorasEfetivasMedia = mean(VD4035)
   label var HorasEfetivasMedia "Horas efetivas médias por grupo de educação e experiência para cada trimestre"
   

 * Peso ajustado por hora:
  * Peso original multiplicado pelas horas efetivas médias do grupo i
    gen PesoHora_Efetivo_i = Peso*HorasEfetivasMedia
   
  * Soma (por trimestre) do produto peso x horas médias efetivas 
    bysort T: egen PesoHora_Efetivo_t = sum(PesoHora_Efetivo_i)
  
  * Peso final:
    gen PesoHora_Efetivo = PesoHora_Efetivo_i/PesoHora_Efetivo_t
    label var PesoHora_Efetivo "Peso para cálculo do IQT de rendimento efetivo"
   
   
   order PesoHora_Efetivo, after(Peso) 
   drop PesoHora_Efetivo_i PesoHora_Efetivo_t

   save "$dirdata/PNADC_amostra_efetivo.dta", replace
   
   
** IQT0:
   gen dIQT0_Efetivo = .
  
   forvalues t = 2/38{
      gen num = PesoHora_Efetivo*WEfetivo_Tante if T==`t'
	  gen den = PesoHora_Efetivo*WEfetivo_T if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT0_Efetivo = sum_num/sum_den if T==`t'

	  drop num den sum_num sum_den
   }
  
  
** IQT1:
   gen dIQT1_Efetivo = .
  
   forvalues t = 2/38{
      gen num = PesoHora_Efetivo*WEfetivo_T if T==`t'
	  gen den = PesoHora_Efetivo*WEfetivo_Tprox if T==(`t'-1)
   
      egen sum_num = sum(num)
	  egen sum_den = sum(den)
	  
	  replace dIQT1_Efetivo = sum_num/sum_den if T==`t'
	  
	  drop num den sum_num sum_den 
   }  
   
** IQT: índice de Fisher   
   gen dIQT_Efetivo = (dIQT0_Efetivo*dIQT1_Efetivo)^(1/2)
   
   label var dIQT0_Efetivo "Variação IQT0 Efetivo"
   label var dIQT1_Efetivo "Variação IQT1 Efetivo"
   label var dIQT_Efetivo "Variação IQT Efetivo"
   
   save "$dirdata/PNADC_amostra_efetivo.dta", replace
   
** Salvando base apenas do IQT:   
   preserve
   keep T dIQT0_Efetivo dIQT1_Efetivo dIQT_Efetivo 
   duplicates drop
   
   gen IQT_Efetivo = 100 if T==1
   replace IQT_Efetivo = IQT_Efetivo[_n-1]* dIQT_Efetivo if _n > 1
   label var IQT_Efetivo "IQT Efetivo"
   
   gen IQT_Efetivo_2012t2 = 100 if T==2
   replace IQT_Efetivo_2012t2 = IQT_Efetivo_2012t2[_n-1]* dIQT_Efetivo if _n > 2
   label var IQT_Efetivo_2012t2 "IQT Efetivo: 2012.2 = 100"
   
   save "$dirdata/dIQT_Efetivo.dta", replace

   twoway (line dIQT0_Efetivo T) (line dIQT1_Efetivo T) (line dIQT_Efetivo T), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(dIQT_Efetivo, replace)
   twoway (line IQT_Efetivo T), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(IQT_Efetivo, replace)
   twoway (line IQT_Efetivo_2012t2 T), xtitle(" ") xlabel(1(2)38, angle(vertical) valuelabel) name(IQT_Efetivo_2012t2, replace)
   
   restore
  
   
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
	  - Rendimento efetivo nulo
	  - Rendimento e horas habituais
	  - Com controles
	  - Restringindo grupos de trabalhadores
	  - Por região
	  - Por área de atividade
*/   