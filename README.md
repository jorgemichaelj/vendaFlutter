# 🛒 Sistema de Vendas (Flutter)

Projeto prático desenvolvido durante as aulas da disciplina de **Desenvolvimento para Dispositivos Móveis**, ministrada pelo **Prof. Silvio**, com o objetivo de aprender e aplicar conceitos de **Flutter** e **Dart**.

---

## 📖 Visão Geral do Projeto

O aplicativo simula um sistema de gestão comercial com armazenamento de dados temporário em memória (`DadosGlobais`). 

O foco principal do exercício é trabalhar a navegação entre telas, manipulação de formulários, validações e a lógica de **relacionamento entre entidades por meio de índices**, servindo como base preparatória para o uso futuro de bancos de dados relacionais e chaves estrangeiras.

---

## 📱 Mapeamento das Telas e Módulos do Sistema

| Nome da Tela / Arquivo | Papel / Função Principal |
| :--- | :--- |
| **Clientes** (`tela_cliente.dart`) | Cadastro de clientes com Nome, CPF, Telefone, Apelido e Turma/Turno. Gerenciamento com listagem sob demanda, busca por Nome ou CPF, edição e exclusão. |
| **Produtos** (`tela_produto.dart`) | Cadastro de produtos com Nome, Unidade (ex: UN, KG, LT) e Valor Unitário. Gerenciamento com listagem, filtro, edição, exclusão e tratamento de casas decimais (aceita vírgula ou ponto). |
| **Vendas** (`tela_vendas.dart`) | Registro de vendas com seleção de cliente e produto via Dropdown (captura de índices), quantidade, vendedor e data automática. Histórico com cálculo automático do valor total e comprovante detalhado via `showDialog`. |

---

## 🔄 Fluxo de Navegação e Transição de Dados

* **Navegação:** A movimentação entre as telas principais e os formulários do sistema é gerenciada pelas rotas e métodos de navegação nativos do Flutter (`Navigator.push` / `Navigator.pop` ou rotas nomeadas).
* **Transferência e Armazenamento de Dados:** Como o projeto utiliza a classe global `DadosGlobais`, as entidades de Clientes e Produtos são compartilhadas em memória. Nas Vendas, o relacionamento entre as tabelas é simulado e estruturado por meio da captura dos **índices** correspondentes selecionados nos componentes `DropdownButton`.

---

## 💻 Estrutura de Código e Arquitetura

### 4.1. Classes e Widgets Principais
* `DadosGlobais`: Classe centralizada responsável por simular o armazenamento em memória e gerenciar as listas de clientes, produtos e vendas.
* `TelaCliente`, `TelaProduto`, `TelaVendas`: Widgets de estado (`StatefulWidget`) que controlam a interface de usuário e a lógica de formulários de cada módulo.

### 4.2. Variáveis e Atributos Principais
* `_formKey`: Instâncias de `GlobalKey<FormState>` para controle e validação dos formulários de cadastro.
* Listas de controle globais para reter os registros inseridos de clientes, produtos e histórico de vendas.

### 4.3. Métodos e Funções
* Métodos de CRUD (Criar, Listar, Atualizar e Deletar) implementados individualmente para clientes e produtos.
* Funções de formatação e cálculo matemático para o valor total das vendas e tratamento de conversão de strings numéricas com ponto ou vírgula.

---

## 🛡️ Regras de Negócio e Validações

* **Campos Obrigatórios:** Validação de formulários para impedir o envio de dados incompletos ou nulos.
* **Formatação Numérica:** Tratamento específico no campo de valor unitário dos produtos para aceitar tanto separadores por ponto (`.`) quanto por vírgula (`,`).
* **Integridade Relacional Simulada:** Garantia de que a venda apenas registre referências válidas através dos índices selecionados dos clientes e produtos cadastrados.

---

## 🚀 Como Executar

Por se tratar de um projeto acadêmico, as pastas pesadas de build foram ignoradas. Para rodar na sua máquina:

1. Clone ou extraia o projeto.
2. Abra o terminal na pasta raiz (onde fica o `pubspec.yaml`).
3. Baixe as dependências:
   ```bash
   flutter pub get
   ```
4. Execute o aplicativo:
   ```bash
   flutter run