# Santander Coders 2024 - Sistema de Casa de Eventos(Docker)

Este repositório contém o projeto "Sistema de Casa de Eventos".Base de Projeto importada para o projeto para ser possível implementar que possibilitar a conteinerizaCÃO de uma aplicação completa com Docker e Docker Compose para facilitando desta foma sua implantação e escalabilidade.

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

Para instalar o projeto localmente, siga os passos abaixo:

1. **Clone o repositório**:

   ```bash
   git clone https://github.com/viniciuscaol/projeto-final-scdocker.git
   cd projeto-final-scdocker
   ```

2. **Instale as dependências**:

    ```bash
    npm install
    ```

## Executar Docker a partir do Repositório

Para executar o contêiner da aplicação diretamente do repositório, siga as instruções abaixo:

1. **Baixe e execute o contêiner**:

    ```bash
    docker run -d -p 8080:5173 -p 3000:3000 viniciuscaol/projetofinalscdocker
    ```

<br>

- O parâmetro `-d` executa o contêiner em segundo plano (modo "detached").
- A porta `8080` no host será redirecionada para a porta `5173` do contêiner, que é onde o frontend está rodando.
- A porta `3000` do host será redirecionada para a mesma porta do contêiner, onde o backend está disponível.

2. **Acesse a aplicação**:

    - Frontend: http://localhost:8080
    - Backend: http://localhost:3000

Certifique-se de que o Docker esteja instalado e em execução no seu sistema antes de executar o comando.

## Docker
#### Dockerfile

O `Dockerfile` neste repositório foi criado para facilitar a conteinerização da aplicação.

**Como funciona**:

- O contêiner é baseado na imagem do Node.js.
- As dependências são instaladas e a aplicação é iniciada, incluindo o json-server.

#### Instruções para construir e rodar a aplicação com Docker
1. **Estrutura do** `Dockerfile`

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

<br>

2. **Construa a imagem Docker**:

    ```bash
    docker build -t projeto-final .
    ```

<br>

3. **Execute o contêiner**:

    ```bash
    docker run -p 5173:5173 -p 3000:3000 projeto-final
    ```

<br>

4. **Acesse a aplicação**:

    - Frontend: http://localhost:5173
    - Mock Server: http://localhost:3000

<br>

## Docker Compose
#### Instruções para usar Docker Compose

1. **Estrutura do** `docker-compose.yaml`

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

- **Estrutura do** `Dockerfile-front`:

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

<br>

- **Estrutura do** `Dockerfile-back`:

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

2. **Inicie os serviços**:

    ```bash
    docker compose up -d
    ```
<br>

3. **Acesse a aplicação**:

    - Frontend: http://localhost:8080
    - Backend: http://localhost:3000

<br>

4. **Parar os serviçoes**:

    ```bash
    docker compose down
    ```
<br>

[Readme Original](https://github.com/roofranklin/casa-de-eventos-react/blob/main/README.md)