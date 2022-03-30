*******************************************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Produtividade e Mercado de Trabalho
* Projeto: Capital Humano e Produtividade
* Estimação IQT Anual
*******************************************************************************


* PREPARAÇÃO ******************************************************************
* Pacotes:
 *ssc install mdesc
 
* Preparando memória: 
  clear all
  cls								
  set maxvar 30000
	
* Diretório: :   
  global dirpath = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT Anual"
  global dirdata = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT Anual\Dados"
  global dirtrim = "T:\pastas_pessoais\ana_ruhe\Capital Humano\IQT"
   
* Salvando log:   
  log using "IQT_Anual.log", replace
  
*******************************************************************************
* A. ORGANIZAÇÃO DA BASE
*******************************************************************************
{
* A.1. IMPORTANDO DADOS *******************************************************
 {
 * Lista das variáveis mantidas:
  {
/*
   id_dom       Número de identificação do domicílio
   uf           UF
   v0101        Ano de referência  
   v0302        Sexo 
   v8005        Idade
   v0404        Cor ou raça 
   v9001        Exerceu trabalho na semana de referência
   v9008        Posição na ocupação no trabalho principal (agropecuária) 
   v9029        Posição na ocupação no trabalho principal 
   v9032        Setor do emprego no trabalho principal 
   v9035        Era funcionário público estatutário no trabalho principal 
   v9058        Número de horas no trabalho principal 
   v9101        Número de horas no trabalho secundário 
   v9105        Número de horas em outros trabalhos 
   v9115        Tomou providência para conseguir trabalho nos últimos 7 dias 
   anoest       Número de anos de estudo  
   v4703        Anos de estudo (categórica) 
   v4704        Condição de atividade na semana de referência (na PEA ou não)
   v4706        Posição na ocupação no trabalho principal
   v4707        Horas habitualmente trabalhadas em todos os trabalhos       
   v4719        Rendimento mensal de todos os trabalhos (nominal)
   v4729        Peso da pessoa
   cond_ocup_s  Condição de ocupação na semana
   trab_afast   Esteve afastado do trabalho na semana de referência
   deflator     Deflator de rendimentos da pnad (out/2012 = 100)
   v4719def     Rendimento mensal de todos os trabalhos (real - out/2012 = 100)
*/
  }
 
 use "T:\data\pnad\pnad1992pes_comp92.dta", clear
 save "$dirdata\BasePnadAnual.dta", replace
 keep id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def 
 
 append using "T:\data\pnad\pnad1993pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
*append using "T:\data\pnad\pnad1994pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad1995pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad1996pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad1997pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad1998pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad1999pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 
*append using "T:\data\pnad\pnad2000pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2001pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2002pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2003pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2004pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2005pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2006pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2007pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2008pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2009pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 
*append using "T:\data\pnad\pnad2010pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2011pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 append using "T:\data\pnad\pnad2012pes_comp92.dta", keep(id_dom uf v0101 v0302 v8005 v0404 v9001 v9008 v9029 v9032 v9035 v9058 v9101 v9105 v9115 anoest v4703 v4704 v4706 v4707 v4719 v4729 cond_ocup_s trab_afast deflator v4719def)
 
 save "$dirdata\BasePnadAnual.dta", replace
 }

* A.2. ORGANIZANDO VARIÁVEIS E LABELS *****************************************
 {
  use "$dirdata\BasePnadAnual.dta", clear
 
 * Renomeando variáveis básicas
  rename v4729 Peso
  rename v0302 Sexo
  rename v8005 Idade
  rename v0404 Cor
  rename v0101 Ano
  rename uf UF
 
 
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
  
  order VD3005 VD3006, after(anoest)
 
 
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
 
 
 * Horas de todos os trabalhos:
  gen horas = v9058 + v9101 + v9105
  label var horas "Horas semanais em todos os trabalhos"
  replace horas = v9058 + v9101 if v9105==. 
  replace horas = v9058 if v9101==. 
 
 
 * PIA: População em idade ativa (pelo menos 14 anos de idade)
  gen byte pia = 0
  label var pia "População em idade ativa"
  replace pia=1 if Idade>=14 
 
 
 * PO
 ** Tomou providências para trabalhar nos últimos 7 dias
  recode v9115 (1=1) (3=0) 
  label define v9115_label 1 "Sim" 0 "Não"
  label values v9115 v9115_label
 
 ** PO conforme definição da PNADC
  * 1 = ocupado
  * 0 = desocupado
  * . = fora da pea
  
  gen byte po_pnadc = .
  label var po_pnadc "Condição de ocupação - PNADC"
  label define po_pnadc_label 0 "Desocupado" 1 "Ocupado"
  label values po_pnadc po_pnadc_label
 
  replace po_pnadc = 0 if [cond_ocup_s==0]
  replace po_pnadc = 1 if [cond_ocup_s==1]
 
 ** Consumo próprio não entra na PO: será desocupado ou inativo, dependendo de ter procurado emprego ou não
  replace po_pnadc = 0 if [v9008==13 | v9029==7] & v9115==1 
  replace po_pnadc = . if [v9008==13 | v9029==7] & v9115!=1 
 
 ** Trabalhadores afastados 
  recode trab_afast (2=1) (4=0)
  replace po_pnadc = 0 if trab_afast==1 & v9115==1
  replace po_pnadc = . if trab_afast==1 & v9115!=1 
 
 ** Trabalho inferior a 1 hora por semana
  replace po_pnadc = 0 if [v9058<1 & v9115==1] 
  replace po_pnadc = . if [v9058<1 & v9115!=1] 
  
 ** Idade mínima: 14 anos 
  replace po_pnadc = . if Idade<14
  
 * PEA: ocupados e desocupados
 gen byte pea_pnadc = (po_pnadc==0 | po_pnadc==1)
 label var pea_pnadc "Condição na PEA - PNADC"
 label define pea_pnadc_label 0 "Fora da PEA" 1 "Na PEA"
 label values pea_pnadc pea_pnadc_label
 
 
  compress
  save "$dirdata\BasePnadAnual.dta", replace
 }
 
* A.3. DEFLATORES *************************************************************
 {
 * Base apenas com os deflatores de 2012:
 use "$dirdata\BasePnadAnual.dta", clear
 keep Ano UF deflator
 keep if Ano<2012
 rename deflator deflator2012
 duplicates drop
 save "$dirdata\Deflatores2012.dta", replace
 
 
 * Base apenas com os deflatores da PNADC, para o terceiro trimestre do ano:
 use "$dirtrim\Dados\A_Deflator.dta"
 keep if Trimestre == 3
 drop Trimestre trim Efetivo
 rename Habitual deflator_atual
 label var deflator_atual "deflator - base mais recente da PNADC"
 save "$dirdata\Deflatores.dta", replace
 
 
 * Juntando as duas bases de deflatores: 
 use "$dirdata\Deflatores2012.dta", clear
 append using "$dirdata\Deflatores.dta"
 
 
 * Mudando base dos deflatores até 2012 para a base mais recente: 
 egen baserecente = total(deflator_atual * (Ano == 2021)), by(UF)
 gen deflator = deflator_atual if Ano>=2012 
 replace deflator = deflator2012/baserecente if Ano<2012
 drop deflator2012 deflator_atual baserecente
 save "$dirdata\Deflatores.dta", replace
 
 
 * Adicionando os novos deflatores na base de microdados:
 use "$dirdata\BasePnadAnual.dta", clear
 rename deflator deflator2012
 
 merge m:1 Ano UF using "$dirdata\Deflatores.dta"
 drop if Ano>=2013
 drop _merge 
  
 order deflator, after(deflator2012)
 compress
 save "$dirdata\BasePnadAnual.dta", replace 
 }

* A.4. RENDIMENTO E RESTRIÇÃO DA AMOSTRA **************************************
 {
 use "$dirdata\BasePnadAnual.dta", clear
 
 * Restrição da amostra: PO conforme definição da PNADC - apenas observações sem missing em horas e rendimentos
 keep if po_pnadc ==1
 drop if v4719==. | horas==.

 * Rendimento real a preços do 3º trimestre do ano mais recente disponível:
 gen v4719_real = v4719*deflator
 label var v4719_real "Rendimento real habitual de todos os trabalhos a preços mais recentes"
 order v4719_real, after(v4719def)
 
 * Salário-hora (Estratégia IPEA: drop observações com horas efetivas nulas)
  gen W_hora = v4719_real/(horas*4)
  label var W_hora "Rendimento real por hora habitual de todos os trabalhos a preços mais recentes"
  order W_hora, after(v4719_real)
  
 * Log: 
  gen logW_hab = ln(W_hora)
  label var logW_hab "Log do rendimento real habitual por hora"
   
  ** Missing values: trabalhadores não remunerados e alguns domésticos 

 compress
 save "$dirdata\BasePnadAnual.dta", replace 
 }
} 
 