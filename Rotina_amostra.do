******************************************************
* FGV IBRE - Instituto Brasileiro de Economia
* Núcleo de Mercado de Trabalho
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
log using "Rotina_amostra.log", replace



* DADOS **********************************************
  use "$dirdata/PNADC2012_2021_limpa.dta", clear
  
/* Lista das variáveis:
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
  
* RESTRIÇÃO DA AMOSTRA *******************************
*** Removendo observações com missing values em variáveis fundamentais ou em categorias não desejadas:
* Análise preliminar: 
  mdesc VD4002 VD4019 VD4020 VD4031 VD4035 
   
* Olhando apenas para as observações na força de trabalho (VD4001=1):   
  preserve
  drop if VD4001!=1
  mdesc VD4002 VD4019 VD4020 VD4031 VD4035
  restore
   
* Características da população por ocupação/desocupação:   
  tab VD4002
  tab VD4002 [iw = Peso]
  
  preserve
  keep if VD4002 == 1
  ** Ocupados: 
  sum Idade VD3005 VD4019 VD4020 VD4031 VD4035
  restore
  
  preserve
  drop if VD4002 == 1
  ** Desocupados e missing: 
  sum Idade VD3005 VD4019 VD4020 VD4031 VD4035
  restore

  
* Manter apenas população ocupada 
  keep if VD4002 == 1
  
* Missing values para rendimento de todos os trabalhos (habitual e efetivo)
  mdesc VD4019 VD4020 VD4031 VD4035
  drop if VD4019 ==.
  drop if VD4020 ==. 
  
  
* Missing values para horas de todos os trabalhos (habitual e efetivo)
  drop if VD4031 ==.
  drop if VD4035 ==.


  save "$dirdata/PNADC_amostra.dta", replace
  
  
* DEFLACIONAMENTO ************************************
*** Calculando rendimentos (de todos os trabalhos) deflacionados  
    gen VD4019_real = VD4019*Habitual
    gen VD4020_real = VD4020*Efetivo
  
    order VD4019_real, after(VD4019)
    order VD4020_real, after(VD4020)
	
	save "$dirdata/PNADC_amostra.dta", replace

	
/* Conferindo se funcionou: plotando as variáveis (descomentar) - média não representativa da população, apenas para ver o padrão geral.
 * Rendimento Habitual: 
   egen VD4019_medio = mean(VD4019), by(Ano)
   egen VD4019_real_medio = mean(VD4019_real), by(Ano)
   
   line VD4019_medio VD4019_real_medio Ano
   
 * Rendimento Efetivo: 
   egen VD4020_medio = mean(VD4020), by(Ano)
   egen VD4020_real_medio = mean(VD4020_real), by(Ano)
  
   line VD4020_medio VD4020_real_medio Ano
*/


* CALCULANDO LOG DOS SALÁRIOS ************************
  gen logW_Habitual = ln(VD4019_real)
  gen logW_Efetivo = ln(VD4020_real)
  gen logW_Efetivo_0 = 0
  replace logW_Efetivo_0 = ln(VD4020_real) if VD4020_real > 0
  
  *** ATENÇÃO: existem observações com rendimento efetivo = 0. logW_Efetivo = . para essas observações. 
  *** A variável logW_Efetivo_0 atribui valor 0 ao log do salário dessas observações.
  
  order logW_Habitual, after(VD4019_real)
  order logW_Efetivo logW_Efetivo_0, after(VD4020_real)
  
  save "$dirdata/PNADC_amostra.dta", replace
  
  * Analisando:
    tab Sexo 
	tab Cor 
	tab VD3006 
	
	preserve
	keep if VD4020_real==0
 	tab Sexo 
	tab Cor 
	tab VD3006 
	restore
  
  log close

  