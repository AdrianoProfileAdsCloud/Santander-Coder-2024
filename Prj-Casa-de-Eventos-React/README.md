# Santander Coders 2024 - Sistema de Casa de Eventos(Conteinerizada)

> [!NOTE]
> Este repositório contém o projeto "Sistema de Casa de Eventos". A base para este Projeto foi importada do [Projeto Base](https://github.com/roofranklin/casa-de-eventos-react/blob/main/README.md) para este projeto para ter a implementação completa de uma conteinerização de uma aplicação com Docker e Docker Compose,facilitando desta foma sua implantação e escalabilidade.

## Tecnologias

- **Frontend**: React, Vite
- **Backend**: Node.js
- **Dependências**:
  - React Router
  - Styled Components
  - Axios
  - React Toastify
  - Json Server

## Instruções de Instalação

Instalação do projeto localmente .

* Funcionalidades da API:

  - [X] **Clonando o Repositório**.

  ```bash
  git clone https://github.com/AdrianoProfileAdsCloud/Santander-Coder-2024/tree/main/Prj-Casa-de-Eventos-React/casa-de-eventos-react

  cd Santander-Coder-2024/Casa-de-Eventos-React
  ```

  - [X] **Instalando as Dependências**.

  ```bash  
  npm install  
  ```

## Executar Docker a partir do Repositório

Para executar o contêiner da aplicação diretamente do repositório, siga as instruções abaixo:

1. **Baixando e executando o contêiner**:

> [!NOTE]
> Neste caso , estou pegando a minha imagem já buildada no Docker Hub em [Imagem Personalizada](https://hub.docker.com/repository/docker/adrianocloud/casa-de-eventos/general)

```bash 
  docker run -d -p 8080:5173 -p 3000:3000 adrianocloud/casa-de-eventos-react 
```

<br>

- O parâmetro `-d` executa o contêiner em segundo plano (modo "detached").
- A porta `8080` no host será redirecionada para a porta `5173` do contêiner, que é onde o frontend está rodando.
- A porta `3000` do host será redirecionada para a mesma porta do contêiner, onde o backend está disponível.

2. **Acessando a Aplicação**:

   - Frontend: http://localhost:8080
   - Backend: http://localhost:3000

Certifique-se de que o Docker esteja instalado e em execução no seu sistema antes de executar o comando.

## Docker

#### Dockerfile

O `Dockerfile` foi para definir um conjunto de instruções para construir a imagem. Nele está especificado passo a passo como o Docker deve criar a imagem, instalando dependências, copiando arquivos, configurando o ambiente, e definindo o comando a ser executado quando o contêiner for iniciado.

🎯 **Estrutura do `Dockerfile`**:

```bash

    FROM node:20.5.1
    WORKDIR /usr/src/app
    COPY package*.json ./
    RUN npm install
    RUN npm install -g json-server
    COPY . .
    EXPOSE 5173
    EXPOSE 3000
    CMD ["sh", "-c", "npm run dev -- --host & json-server --watch eventos.json"]

```

 O Dockerfile está configurado para construir uma imagem Docker que usa Node.js e o json-server para simular uma API enquanto executa uma aplicação Node.js em modo de desenvolvimento.

- **FROM node:20.5.1**

  - FROM -> Define a imagem base a partir da qual o Docker vai construir a imagem.
  - node:20.5.1 -> Especifica que a imagem base será a versão 20.5.1 do Node.js.Isso significa que a imagem vai incluir o runtime do Node.js e o npm, que são necessários para rodar uma aplicação Node.js.
- **WORKDIR /usr/src/app**

  - WORKDIR -> Define o diretório de trabalho dentro do contêiner, ou seja, o local onde os comandos subsequentes serão executados.
  - /usr/src/app - > É o caminho do diretório onde a aplicação será armazenada dentro do contêiner. A partir desse ponto, todas as operações (como cópia de arquivos, instalação de dependências) acontecerão dentro desse diretório.
- **COPY package*.json ./**

  - COPY -> Copia arquivos do sistema de arquivos local para o contêiner.
  - package*.json - > Copia os arquivos package.json e package-lock.json (se existirem) do diretório atual do sistema local para o diretório de trabalho dentro do contêiner (/usr/src/app). Esses arquivos contêm as dependências da aplicação.
- **RUN npm install**

  - Instala todas as dependências listadas no package.json. Isso configura o ambiente da aplicação, instalando todas as bibliotecas necessárias no contêiner.
- **RUN npm install -g json-server**

  - Comando que instalará o json-server globalmente(-g) dentro do contêiner.
    Já o json-server é uma ferramenta que simula uma API REST completa a partir de um arquivo JSON. Aqui ele está sendo instalado globalmente (-g) para estar disponível em todo o contêiner.
- **COPY . .**

  - COPY . . -> Copia todos os arquivos do diretório atual no sistema local para o diretório de trabalho  no contêiner (/usr/src/app).Isso inclui o código-fonte da aplicação, arquivos estáticos, o arquivo eventos.json (necessário para o json-server) e outros arquivos.
- **EXPOSE 5173**

  - EXPOSE -> Declara que o contêiner vai usar a porta 5173, que é usada aqui para servir a aplicação  Node.js em modo de desenvolvimento (geralmente usada pelo Vite ou outro bundler moderno).
    EXPOSE 3000 -> Também declara a porta 3000, que é usada pelo json-server para expor a API simulada.
- **CMD ["sh", "-c", "npm run dev -- --host & json-server --watch eventos.json"]**

  - CMD -> Define o comando que será executado quando o contêiner for iniciado.
  - sh -c  -> Permite executar um comando em uma shell.
  - npm run dev -- --host -> Inicia o servidor de desenvolvimento da aplicação Node.js, permitindo que   ele seja acessado externamente (por conta da --host).
  - &  -> executa o comando anterior em segundo plano, o que permite que o contêiner execute ambos os processos ao mesmo tempo.
  - json-server --watch eventos.json - > Executa o json-server e começa a monitorar o arquivo eventos.json para simular uma API REST que expõe os dados contidos nesse arquivo.

<br>

🎯 **Estrutura do** `Dockerfile-front`:

```bash

    FROM node:20.5.1 AS build
    WORKDIR /app
    COPY package*.json ./
    RUN npm install
    COPY . .
    RUN npm run build
    FROM nginx:alpine
    COPY --from=build /app/dist /usr/share/nginx/html
    EXPOSE 80
    CMD ["nginx", "-g", "daemon off;"]
  
```

- ***CMD***

  - CMD -> É uma instrução no Dockerfile que especifica o comando predeterminado que será executado
    quando o contêiner for iniciado. Só pode haver um CMD Dockerfile, e ele será executado quando
    o container for inicializado.Neste caso, o comando predeterminado que será executado será nginx.
- ***nginx***

  - nginx -> É um servidor web de alto rendimento que é usado para servir conteúdo estático (como arquivos HTML,
    CSS, imagens, etc.) e também pode funcionar como proxy reverso ou balanceador de carga para aplicativos web.
    Ao especificar nginx, indica que quando o container for iniciado, deverá iniciar o servidor Nginx.
- ***-g***

  - A opção -g  permite passar instruções de configuração globais diretamente da linha de comandos. Neste
    caso, estou fazendo uma configuração específica sobre como o processo do servidor se comportará.
    O parâmetro a seguir -g é uma instrução de configuração que normalmente que encontra em um arquivo de configuração do Nginx (como nginx.conf), mas pode ser incluída na linha de comandos.
- ***daemon off***

  - A diretiva  "daemon off" indica ao Nginx que não será executado em segundo plano (ou no modo "daemon").
    Por padrão, o Nginx é executado como um processo de background, mas no contexto de um container Docker,isso não é recomendável porque o Docker espera que o processo principal do container siga sendo executado no primeiro plano. Se o Nginx for executado em segundo plano, o container poderá ser encerrado imediatamente por não ecnontrar nenhum processo em primeiro plano.
    Ao usar "daemon off", forçamos o Nginx a ser executado no primeiro plano (no "foreground"), para manter o contêiner ativo e operacional.

  ***Por que é importante usar "daemon off"o Docker?***
  No Docker, o container é finalizado quando não há um processo de execução no primeiro plano.
  Se o Nginx for executado em segundo plano, o Docker pensará que o container concluiu seu trabalho e encerará. É esse motivo foi utilizado o "daemon off" para evitar que o Nginx seja executado em segundo plano e garantir que o container continue funcionando.

<br>

🎯 ***Estrutura do*** `Dockerfile-back` :

```bash
    FROM node:20.5.1
    WORKDIR /app
    COPY package*.json ./
    RUN npm install json-server --save-dev
    COPY eventos.json ./
    EXPOSE 3000
    CMD ["npx", "json-server", "--watch", "eventos.json", "--host", "0.0.0.0"]

```

<br>

- ***--save-dev***

  - --save-dev -> Guarda o pacote como uma dependência de desenvolvimento, o que significa que só será
    necessário no ambiente de desenvolvimento e não será instalado quando o aplicativo estiver em
    produção, mantendo o aplicativo mais liviana.
    Comando útil em ambientes de desenvolvimento , especialmente quando você está simulando APIs ou
    criando aplicativos front-end que ainda não têm um backend real.
- ***json-server***

  - É uma ferramenta do Node.js que permite gerar rapidamente uma API REST a partir de um arquivo JSON, permitindo que outros     aplicativos (como um aplicativo frontend) acessem esses dados de maneira estruturada.
- ***CMD ["npx", "json-server", "--watch", "eventos.json", "--host", "0.0.0.0"]***

  - Em um Dockerfile, o comando CMD especifica o que o contêiner deve ser executado quando for iniciado. É como o "comportamento por defeito" do contêiner.
    ["npx", "json-server", "--watch", "eventos.json", "--host", "0.0.0.0"] : Este conjunto de instruções é executado json-server usando npx.
- ***npx***

  - É uma ferramenta que vem com Node.js e permite executar pacotes sem precisar instalá-los
    globalmente. Se o pacote estiver no diretório do projeto ( node_modules), ele será executado de lá ou se não estiver instalado, ele será baixado temporariamente para essa execução.
    Neste caso, estamos usando npx para executar json-server, o que significa que não é necessário instalar json-serverglobalmente.
- ***--watch***

  - Este é um parâmetro json-serverque indica que você deve "observar" o arquivo JSON, neste
    caso eventos.json. Se o conteúdo do arquivo mudar enquanto o servidor estiver sendo executado,
    json-servera API será atualizada automaticamente com os novos dados.
    Útil quando trabalhamos em um ambiente de desenvolvimento e os dados estão mudando constantemente.
- ***eventos.json***

  - Este é o arquivo JSON que json-server está sendo utilizado para gerar a API. Dentro eventos.json
    provavelmente há dados estruturados no formato JSON (como eventos ou qualquer outro tipo de dados)
    que são expostos como uma API REST.
    Por exemplo, se seu arquivo tiver dados de eventos, você poderá acessá-los através de
    rotas como http://#localhost:3000/eventos
- ***--host 0.0.0.0***

  - O parâmetro --host indica a json-server direção IP que deve ouvir as conexões entrantes.
    0.0.0.0 é uma direção especial que significa "todas as interfaces de rede". É dito que o servidor
    estará disponível para qualquer dispositivo na rede, não apenas para localhost(que é a direção local).
    Isso é particularmente importante quando ele é executado em um contêiner Docker, pois permite que o servidor seja acessível de fora do container (por exemplo, do seu navegador ou de outra máquina).

🎯 **Estrutura do** `docker-compose.yaml`

```yaml
   version: '3.8'
   services:
       frontend:
           build:
           context: .
           dockerfile: Dockerfile-front
           ports:
           - "8080:80"
           volumes:
           - .:/app

       backend:
           build:
           context: .
           dockerfile: Dockerfile-back
           volumes:
           - ./eventos.json:/data/eventos.json
           ports:
           - "3000:3000"
```

<br>

  Docker-compose.yml, usado para definir e orquestrar os serviços de Frontend e Backend que precisam rodar juntos.

- **version: '3.8'**

  - Define a versão do Docker Compose que está sendo usada. A versão 3.8 é uma das versões mais recentes e é amplamente compatível com funcionalidades modernas do Docker Compose. Ela especifica como o arquivo docker-compose.yml será interpretado pelo Docker.
- **services**

  - Bloco que contém todos os serviços que compõem a aplicação. Neste caso,o Frontend e Backend.
- ### Rápida pasagem em cada Bloco que compoem o aqruivo YAML.


1. ***Serviço Frontend***

```yaml

    frontend:
    build:
        context: .
        dockerfile: Dockerfile-front
    ports:
        - "8080:80"
    volumes:
        - .:/app

```

- ***build***

  - context: -> Especifica o diretório atual como contexto de build (onde o Docker vai procurar o Dockerfile e outros arquivos necessários para construir a imagem).
  - dockerfile: Dockerfile-front: -> Especifica que o Docker deve usar o arquivo Dockerfile-front para construir a imagem do frontend. Nele informamos qual docker file usar.
- ***ports***

  - Mapeia as portas do contêiner para as portas da máquina host.
    "8080:80": Isso significa que a porta 80 do contêiner (que provavelmente é onde o servidor web do frontend está rodando) será  mapeada para a porta 8080 do host. Assim, quando você acessar http://localhost:8080, estamos acessando o serviço frontend.
- ***volumes***

  - Permite mapear arquivos do sistema local para o contêiner.
    - .:/app: ->  Mapeia o diretório atual (.) para o diretório /app dentro do contêiner. Isso significa que qualquer alteração feita nos arquivos locais será refletida instantaneamente dentro do contêiner, o que é muito útil durante o desenvolvimento.

2. ***Serviço Backend***

```yaml
     backend:
     build:
        context: .
        dockerfile: Dockerfile-back
     volumes:
        - ./eventos.json:/data/eventos.json
     ports:
        - "3000:3000"
  

```

- ***build***

  - Define como o Docker deve construir a imagem do backend.
  - context: -> Define o diretório atual como o contexto de build.
  - dockerfile: Dockerfile-back: -> Especifica que o Docker deve usar o arquivo Dockerfile-back para construir a imagem do backend. Isso é útil se o backend tiver um Dockerfile diferente do frontend (o que é comum).
- ***volumes***

  - ./eventos.json:/data/eventos.json: -> Mapeia o arquivo local eventos.json para o caminho /data/eventos.json dentro do contêiner. Esse mapeamento permite que o arquivo de eventos seja acessado diretamente pelo backend no contêiner, o que provavelmente será utilizado para alimentar uma API (por exemplo, usando json-server).
- ***ports***

  - "3000:3000" -> Mapeia a porta 3000 do contêiner para a porta 3000 da máquina host. Isso significa que ao acessar http://localhost:3000, você estará acessando o serviço backend.

<br>

> [!NOTE]
> Pesquisas de comandos e sintaxe, construida com o auxilio do chatGPT e utros meios como: https://stackoverflow.com/ e principalmente aulas do módulo de Conteineirização - Santander Coders 2024.

<br>

#### Instruções para Construir e executar a aplicação com Docker

1. **Construindo a imagem Docker**:
   ```bash
   
   docker build -t casa-de-eventos .

   ```
2. **Executando o contêiner**:

 ```bash

docker run -p 5173:5173 -p 3000:3000 casa-de-eventos

 ```

3. ***Acessando a aplicação***
   - Frontend: http://localhost:5173
   - Server(Mock): http://localhost:3000


4. ***Iniciando os serviços***

 ```bash
docker compose up -d

 ```

5. **Acessar a aplicação na Urls abaixo**:
   - Frontend: http://localhost:8080
   - Server(Mock): http://localhost:3000


6. ***Pararando os serviçoes***

 ```bash
docker compose down

 ```

Obs: Certifique-se de que o Docker esteja instalado e em execução no seu sistema antes de executar o comando.

<br> 

### Gerar imagem deste projeto e armazenar no DockerHub.

 Como boas praticas a serem seguidas em seguida forneça uma tag para imagem que seguindo a convenção dever estar no seguinte formato:
 docker tag nome da imagem criada anteriormente nome_do_seu-usuario_no-dockerhub/o nome da imagem que deseja criar ex:

 ```bash
  docker tag casa-de-eventos adrianocloud/casa-de-eventos
  ```
 Em seguida loge no DockerHub com suas credenciais:
  
  ```bash
  docker login 
  ```
  Forneça as informações solicitadas referente a sua conta em seguida:

  ```bash
  docker push adrianocloud/casa-de-eventos
  ```
  Pronto a imagem já se encontra no DockerHub

<br>
<br>
<br>

# Imagem no docker Hub

[Imagem do Projeto no DockerHub](https://hub.docker.com/repository/docker/adrianocloud/casa-de-eventos/general)

<br>

# Projeto base

 Projeto Original que serviu como aplicação para realizar a conteineirização.

[Readme Original](https://github.com/roofranklin/casa-de-eventos-react/blob/main/README.md)
