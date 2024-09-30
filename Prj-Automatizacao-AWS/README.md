# Santander Coder 2024

## 🎯 Objetivos Deste Desafio de Projeto.
Projetinho que tem como objetivo a utilização de scripts de inicialização (User Data) para automatizar a instalação e configuração de um servidor web ( Apache) em uma instância Amazon Linux.

## 📋 Pré-requisitos

Antes de começar, certifique-se de ter uma conta na AWS. Se precisar de ajuda para criar sua conta, confira neste repositório um passo a passo de como criar.<br>
 [AWS Cloud Quickstart](https://github.com/digitalinnovationone/aws-cloud-quickstart).

 ## 🚀 Passo a Passo

### 1. Criar uma EC2.

- Clicar em "Launch Instances"
  <br>

  ![image](https://github.com/AdrianoProfileAdsCloud/Santander-Coder-2024/blob/main/Prj-Automatizacao-AWS/Imagens/Criando%20uma%20Ec2.png)

  <br>

 >[!NOTE]
 >Se atente para realizar a liberação da porta 80 do tipo HTTP no Segcurity Group no momento da criação da EC3.
 
 ![image](https://github.com/AdrianoProfileAdsCloud/Santander-Coder-2024/blob/main/Prj-Automatizacao-AWS/Imagens/AdicionarHttpNoSecurityG.png)

 <br>

 - Próximo passo e clicar em Advanced details, para expandir e conseguirmos localizar onde vamos de fato adicionar nosso script de automação.

   <br>
   
![image](https://github.com/AdrianoProfileAdsCloud/Santander-Coder-2024/blob/main/Prj-Automatizacao-AWS/Imagens/UserData.png)

<br>

 >[!NOTE]
 >Para este projeto foi criado uma pagina html bem simples, apenas para demostrar o funcionamento do WebServer.O foco principal é o Script para criar um WebServer.

   
    
