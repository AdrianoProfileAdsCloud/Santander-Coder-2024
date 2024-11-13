# Projeto(Ada) Santander Coder 2024 
<br>

>[!NOTE]
> Projeto tem como objetivo propor uma arquitetura cloud para um site de e-commerce que vende produtos digitais, como e-books e cursos online. Tendo como objetivos principais escalar automaticamente em períodos de alta demanda, como em campanhas de marketing e datas de promoção.Reduzir custos e aumentar a confiabilidade.

 Segue abaixo o case proposto:

<p>Ambiente Simulado: “E-commerce de Produtos Digitais”
Descrição do Cenário: Imagine que você está revisando a arquitetura de um site de e-commerce
que vende produtos digitais, como e-books e cursos online. O sistema é configurado para escalar
automaticamente em períodos de alta demanda, como em campanhas de marketing e datas de
promoção.</p>
<p>Detalhes da Arquitetura: Este e-commerce foi configurado na AWS com uma arquitetura</p>

simplificada para uma startup, incluindo:
1. **Front-end:**
* Amazon S3 para armazenar os arquivos estáticos do site.
* Amazon CloudFront para entrega de conteúdo e CDN.

<br>

2. **Back-end:**
* Amazon EC2 para hospedar a API que lida com pedidos e login de usuários.
* Auto Scaling configurado para ajustar a quantidade de instâncias com base na demanda.

<br>

3. **Banco de Dados:**
* Amazon RDS (MySQL) configurado em uma VPC, em uma única AZ
* Backups automáticos do banco de dados são feitos diariamente.
4. Armazenamento de Produtos:
* Amazon S3 para armazenar os arquivos digitais (e-books, cursos).

<br>

5. **Segurança:**
* AWS IAM gerenciando as permissões para que apenas administradores possam acessar o
back-end.
* Amazon Cognito para autenticação de usuários do front-end.
6. Monitoramento:
* Amazon CloudWatch monitora o desempenho das instâncias EC2 e envia alarmes para o time
técnico.

<br>

7. **Gerenciamento de Custos:**
* AWS Budgets co

## Arquitetura proposta para a Resolução do Case

 ![Arquitetura](https://github.com/AdrianoProfileAdsCloud/Santander-Coder-2024/blob/main/PRJ-Infraestrutura%20como%20Codigo%20-%20Terraform/Imagen/Prj-%20Infraestrutura%20como%20C%C3%B3digo-Terraform.drawio.png)
