# Validador de CNPJ em MIPS Assembly

## Informações Gerais
* **Instituição:** Instituto Federal de Minas Gerais - Campus Ouro Branco
* **Curso:** Bacharelado em Sistemas de Informação
* **Disciplina:** Arquitetura e Organização de Computadores
* **Professor:** Saulo Henrique Cabral Silva
* **Projeto:** Trabalho Prático 3
* **Autores:** Aquiles Ascar e Estella Moreira

## Descrição do Projeto
Este projeto consiste em um programa desenvolvido em **MIPS Assembly** que valida números de CNPJ (Cadastro Nacional da Pessoa Jurídica). O objetivo é resolver um problema prático enfrentado por um empresário, "Seu José", que precisa de um método confiável para verificar o CNPJ de clientes no momento do cadastro para evitar fraudes e inadimplência.

O programa implementa o algoritmo de validação para o **novo formato de CNPJ alfanumérico**, conforme as regras detalhadas no Anexo da Instrução Normativa da Receita Federal. A lógica central envolve o cálculo de dois dígitos verificadores (DVs) com base em um sistema de pesos e o cálculo de Módulo 11.

## Funcionalidades
* **Validação de CNPJ:** O programa valida um CNPJ de 14 caracteres (alfanumérico nos 12 primeiros dígitos e numérico nos 2 DVs).
* **Interface Simples:** Solicita ao usuário que digite o CNPJ através do console.
* **Sistema de Tentativas:** Permite ao usuário até **três tentativas** para inserir um CNPJ válido.
* **Feedback ao Usuário:**
    * Exibe a mensagem `"Este e um CNPJ valido"` em caso de sucesso.
    * Exibe a mensagem `"Este e um CNPJ invalido, tente outra vez"` a cada tentativa incorreta.
    * Após três falhas, exibe `"Compra bloqueada por inserção de informação incorreta"` e encerra.

## Como Executar
Este programa foi projetado para ser executado no simulador **MARS 4.5**.

1.  Abra o simulador MARS 4.5.
2.  No menu, vá em `File > Open...` e selecione o arquivo `.asm` que contém este código.
3.  Monte o código clicando em `Run > Assemble` no menu (ou pressione a tecla `F3`).
4.  Execute o programa clicando em `Run > Go` (ou pressione a tecla `F5`).
5.  A janela **"Run I/O"** será aberta. É nela que o programa irá imprimir as mensagens e onde você deverá digitar o CNPJ quando solicitado.

## Estrutura do Código
O código é dividido em seções lógicas para facilitar a leitura e manutenção:
* **`.data`**: Define todas as strings para interação com o usuário e os arrays de pesos necessários para os cálculos.
* **`main` / `tentativas`**: Ponto de entrada do programa. Controla o fluxo principal e o sistema de 3 tentativas.
* **`copia`**: Rotina essencial que cria uma cópia de segurança do CNPJ inserido pelo usuário. Isso preserva a entrada original para a comparação final.
* **`somaDv1` / `somaDv2`**: O coração do programa. Estes dois blocos implementam o algoritmo matemático para calcular o primeiro e o segundo dígito verificador, respectivamente.
* **`compararCNPJ`**: Onde a validação de fato ocorre. Este loop compara o CNPJ original do usuário com a versão contendo os DVs calculados pelo programa.
* **`igual` / `diferente` / `bloqueado` / `fim`**: Blocos de controle de fluxo que direcionam o programa para a saída correta (sucesso, nova tentativa ou bloqueio) com base no resultado da comparação.
* **`fim`**: Ponto de saída único que encerra a execução do programa de forma limpa.
