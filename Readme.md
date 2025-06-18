# Task Master: Seu Gerenciador de Tarefas Pessoal!

O Task Master é um app Flutter super bacana e fácil de usar, feito para te ajudar a organizar e acompanhar suas tarefas do dia a dia. Com um visual limpo e recursos interativos, ele quer deixar a gestão das suas coisas mais simples, para que você fique sempre em dia e no controlo dos seus prazos. É demais! 🚀

## Coisas Legais que Ele Faz

- **Organização Completa:** Crie, edite e apague tarefas.
- **Controlo do Status:** Marque o que já fez, veja o que está pendente e descubra o que já passou do prazo. Fácil!
- **Filtros Inteligentes:** Encontre suas tarefas na hora, filtrando por "Todas", "Feitas", "Pendentes", "Atrasadas", "Hoje" ou "Esta Semana". Super útil!
- **Arrumar do Seu Jeito:** Organize suas tarefas por quando as criou (mais antigas ou recentes), pelo prazo (mais cedo ou mais tarde).
- **Temas que Combinam:** Mude entre o modo claro e o escuro, para que o app fique do jeito que você gosta.
- **Suas Estatísticas:** Dê uma olhada no seu progresso geral com um gráfico divertido que mostra o que já está feito e o que falta. Motivação pura!
- **Mexer é Simples:** Deslize (tipo swipe!) para apagar ou editar tarefas.
- **Animações Suaves:** Curta as transições e efeitos visuais que deixam o app ainda mais agradável de usar.

## ⚙️ Bora Rodar o Projeto (no Ubuntu Linux)!

Este guia vai te mostrar o passo a passo para colocar o Task Master a funcionar no seu computador com Ubuntu Linux. Vem comigo!


### 1. Pegar as Dependências do Projeto

Vá até a pasta principal do projeto Task Master no terminal e rode:

```bash
flutter pub get
```

Isso vai baixar todos os pacotes e coisas que o projeto precisa, que estão lá no arquivo `pubspec.yaml`.

### 2. Checar a Configuração do Flutter

Execute o `flutter doctor` para ver se está tudo certo no seu ambiente de desenvolvimento:

```bash
flutter doctor
```

Procure por um visto verde (✅) ao lado de `Linux toolchain - develop for Linux desktop`. Se tiver algum problema, o `flutter doctor` vai te dar dicas para resolver.

Para ver se o Flutter reconhece seu desktop Linux como um lugar pra rodar o app:

```bash
flutter devices
```

Você deve ver algo com `linux` lá. Show de bola!

### 3. Hora de Rodar o Aplicativo!

- **Modo de Debug (com Hot Reload):** Na pasta principal do projeto, rode:

  ```bash
  flutter run -d linux
  ```

  Isso vai compilar e abrir o app no seu desktop Linux, e você pode ver as mudanças na hora enquanto desenvolve. Que praticidade!

- **Versão Final (Release):** Para fazer uma versão otimizada pra distribuir:

  ```bash
  flutter build linux
  ```

  O arquivo executável vai estar em `./build/linux/x64/release/bundle/nome_do_seu_aplicativo`. Aí é só rodar direto do terminal!

## 📂 Como o Projeto Está Organizado

O Task Master foi feito de um jeito bem organizado, em "partes" para ser fácil de cuidar e entender:

```
task_master/
├── lib/
│   ├── main.dart                 # Onde tudo começa e a configuração dos temas.
│   ├── models/
│   │   └── task.dart             # O "molde" para as tarefas.
│   ├── providers/
│   │   └── theme_provider.dart   # Ajuda a gerenciar o tema do app (Provider).
│   ├── screens/
│   │   ├── welcome_screen.dart   # A tela de boas-vindas, cheia de animações.
│   │   ├── home_screen.dart      # A tela principal, com a lista de tarefas, filtros e como elas são ordenadas.
│   │   ├── task_form_screen.dart # A tela para adicionar ou editar as tarefas.
│   │   └── stats_screen.dart     # As estatísticas das tarefas, com um gráfico legal.
│   ├── utils/
│   │   └── app_enums.dart        # Os "tipos" para os filtros e a ordem das tarefas.
│   └── widgets/
│       └── task_item.dart        # Um pedacinho de código que mostra uma tarefa na lista.
├── assets/
│   └── images/
│       └── logo.png              # As imagens do app, tipo o logo.
├── pubspec.yaml                  # O arquivo de configuração do projeto e onde ficam as dependências.
└── README.md                     # Este mesmo arquivo que você está a ler!
```

## 📝 Entendendo o Projeto

### Como Funciona por Dentro (Arquitetura e Estado)

O app foi feito pensando em ser bem organizado, separando as coisas em "camadas" diferentes (o que você vê, a lógica do que acontece e os dados).

- `setState()`: Usado para mudar coisas pequenas e locais, tipo o que você digita num campo ou ligar/desligar algo.
- `Provider`: Pra controlar coisas que precisam ser vistas em várias partes do app, como o tema (o `ThemeProvider`) e a lista principal de tarefas. Assim, quando algo muda, só as partes que precisam são atualizadas, sem desperdiçar recursos.
- `ValueNotifier`: Perfeito para controlar um valor simples que muda e avisar quando ele muda.

### Guardando os Dados

Agora, as tarefas ficam só na memória (`HomeScreen`), ou seja, se você fechar o app, elas somem. Mas, para o futuro, a ideia é guardar tudo de verdade, e as melhores formas seriam:

- `shared_preferences`: Ótimo para guardar coisas pequenas e que não são super críticas, tipo suas preferências (o tema que você escolheu, por exemplo).
- `sqflite`: A melhor opção para guardar muitas tarefas com detalhes (títulos, descrições, se está feita, datas). Permite fazer buscas rápidas e é seguro contra ataques.


### Boas Práticas e Qualidade do Código

O projeto segue as boas práticas para que o código seja fácil de manter, ler e expandir:

- **Formato Padrão:** O código é sempre formatado do mesmo jeito, com espaços certinhos e vírgulas, para ser mais fácil de ler.
- **Reutilizar as Peças:** Componentes como o `TaskItem` são feitos para serem pequenos e usados em vários lugares. Assim, a gente não repete código e a manutenção fica mais tranquila.
- **App Leve e Rápido:** Tentamos usar `const` em tudo o que é fixo e gerenciar o estado direitinho, pra que o app não "engasgue" e rode sempre lisinho.
- **Tudo Separado:** O projeto é dividido em "blocos" lógicos (modelos, provedores, telas, widgets, utilitários). Assim, é mais fácil de entender, testar e adicionar coisas novas.

## 📦 O Que Ele Usa (Dependências)

As principais "ferramentas" que este projeto usa são:

- `flutter_animate`: Para as animações e efeitos visuais.
- `provider`: Para gerenciar o estado do app.
- `intl`: Para formatar as datas e outras coisas de internacionalização.

## 🚀 O Que Vem por Aí (Futuras Melhorias)

- **Guardar os Dados de Verdade:** Implementar o `sqflite` para que suas tarefas não sumam quando você fechar o app.
- **Lembretes Locais:** Adicionar notificações para que o app te avise sobre os prazos das tarefas.
- **Tarefas que se Repetem:** Que tal poder criar tarefas que acontecem todo dia, toda semana?
- **Categorias/Etiquetas:** Pra organizar suas tarefas ainda melhor, com categorias ou tags.
- **Sincronização na Nuvem:** Integrar com serviços tipo Firebase para que suas tarefas fiquem salvas na nuvem e você possa acessá-las de qualquer lugar!



## 👤 Autores

| Nome   | Rgm       | 
| :---------- | :--------- | 
| `Thiago Germano `      | `30001951` |
| `Murilo Henrique`      | `30466261` |
