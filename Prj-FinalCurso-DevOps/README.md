<div align="center">
 
# Santander Coder 2024
</div>

 >[!NOTE]
> Objetivo do projeto -Com base nos conhecimentos adquiridos ao longo do curso, resolver o seguinte case proposto.

<br>

### **Cenário**
<br>
<p>A Ada Contabilidade enfrenta um desafio operacional diário: os contadores precisam enviar arquivos manualmente para armazenamento e, em seguida, registrar no banco de dados a quantidade de linhas contidas nesses arquivos. Esse processo manual é ineficiente e propenso a erros.
Criar uma solução que automatize a arquitetura em todo o seu fluxo, se baseando em práticas DevOps para simplificar o fluxo de trabalho e garantir a confiabilidade do processo.</p>

<br>

* Requisitos:
   - [X] Código com a aplicação que envia os arquivos para o s3.
   - [X] Código da arquitetura usando boto3 ou terraform para subir os recursos.
   - [X] Os códigos precisam estar no GitHub, usando as boas práticas visto no curso.
   - [X] A aplicação precisa gerar um arquivo de texto com um número aleatório de linhas.
   - [X] Esse arquivo precisa ser enviado para um s3 de forma automatizada.
   - [X] Usar S3, SNS, SQS, Lambda e Elasticache.
   - [X] No banco de dados armazenar nome do arquivo e o número de linhas contido;
   - [X] Justificar as escolhas dos recurso e arquitetura.


<br>

### Definição da Arquitetura da Solução.

<br>

![Arquitetura da Soução](https://github.com/AdrianoProfileAdsCloud/Santander-Coder-2024/blob/main/Prj-FinalCurso-DevOps/imagens/Prj-%20DeVops.drawio.png)

<br>

### 🎯 Detalhamento do fluxo da Arquitetura:

   . O Usuário faz uma requisição através de um Sistema Web que queira fazer uso desete recurso.<br>
   . A requisição feita pelo Sistema Web pelo usuário é encaminhada para uma Api que tem como finalidade armazenar o arquiuvo selecionada  no Banco de DadosO usuário faz o upload de um arquivo para um bucket no S3.<br>
  . No momneto em que a API realiza oi upload do Arquivo o S3 envia um evento para a fila SQS.<br>
  . Por sua vez esta mensagem contida na fila(SQS) e consumida por uma Função Lambida.<br>
  . A Função Lambida ao consumir a mensagem da fila(SQS) realiza as seguintes operações:<br>
     . Baixa o arquivo do S3.<br>
     . Raliza a contagem de linhas contidas no arquivo.<br>
     . Grava o nome do arquivo e o número de linhas no banco de dados Elasticache.<br>
  . Após concluir o processamento(operações) do Lambida.O Lambida envia uma notificações via SNS para e-mail ou ou qualquer outro meio.<br>
  . E por último temos o Monitoramento com o CloudWatch que tem com função receber todos os Logs e Métricas que poderão ser visualizados no Grafana.<br>



## Projeto em construção... 

   
    
