`lftools` - Labsin FEM Tools
=====

Um pequeno pacote de funções para simulações de Elementos Finitos no
Octave.

## Objetivos
Este pacote pretende ser simples, reduzido e generalizado. Ele não contém a 
formulação de nenhum elemento, de nenhuma disciplina, apenas funções para 
simulação. A nomenclatura geralmente usada, entretanto, é a de Mecância dos 
Sólidos, ao exigir matrizes de _massa_, _amortecimento_ e _rigidez_, por 
exemplo. Isso, contudo, em nada reduz a generalidade e a capacidade do pacote.

O `lftools` também não pretende substituir nenhum outro programa de Elementos 
Finitos, seja ele comercial ou não. A ausência de uma interface gráfica e, 
principalmente, de um gerador de malhas, tornaria essa ambição inalcançável.

O melhor uso que se pode ter deste pacote é para aplicações não muito 
complexas, cujos sistemas possam ser descritos no próprio código do programa 
ou numa folha de papel.

## Motivação
Depois de fazer várias simulações usando o Método dos Elementos Finitos 
(_Finite Element Method_, FEM), em diferentes ocasiões e por diferentes 
motivos, uma tarefa mais complexa e com tempo restrito exigiu que um conjunto 
de funções fosse escrito para que testes pudessem ser feitos de forma mais 
rápida e conveniente. Além de simplificar consideravelmente os programas, 
permitindo que o foco estivesse em outras partes do problema, mensagens de 
erros apropriadas ajudaram a realizar os trabalhos de forma muito mais 
confortável, sem a perda de tempo para procurar erros na definição do 
problema e de seus parâmetros, algo tão comum nas ocasiões anteriores. A 
abstração dessas funções e maior generalização delas resultou, então, neste 
pacote que, espera-se, possa ser útil a mais pessoas na mesma situação.

### Nome
O `lftools` nome deriva do Laboratório de Simulações Numéricas (Labsin) da 
Faculade de Engenharia de Ilha Solteira da Universidade Estadual Paulista 
"Júlio de Mesquita Filho", onde ele tem sido desenvolvido.

## Instalação
Baixe o repositório e adicione o caminho até `/inst/` usando `addpath` na 
sessão corrente do Octave.

### Requisitos
 * Octave >= 4.2.1

## Compatibilidade com MATLAB
A princípio, todas as funções deste pacote pode podem ser usadas no MATLAB. 
Portanto, espera-se que eventuais incompatibilidades ocorram apenas por 
diferenças de sintaxe entre Octave e MATLAB e, pensando em minimizá-las, 
adotou-se o uso de `%` para comentários, ao contrário do usual `#`, que é 
exclusivo para o Octave. Entretanto, o `lftools`, incluindo sua documentação, 
é desenvolvido com foco no Octave.

Se você é usuário do MATLAB, pode contribuir testando o pacote e enviando 
commits a este repositório com correções que corrijam incompatibilidade entre 
as plataformas.

## Licença
Este trabalho está sobe a licença [GPLv3+](COPYING).
