#!/bin/bash
# Atualiza o sistema
sudo yum update -y

# Instala o Apache (httpd)
sudo yum install -y httpd

# Habilita o serviço Apache para iniciar com o sistema
sudo systemctl enable httpd

# Inicia o serviço Apache
sudo systemctl start httpd

# Cria uma página HTML simples
echo "<html>
<head>
    <title>Bem vindo a minha primeira Página Web</title>
</head>
<body>
<div style="text-align:center">
   <br>
       <h1>Bem vindo a minha primeira Página Web</h1>
       <br>
       <br>
    <h2>Bem-vindo ao meu servidor Apache na EC2!</h2>
    <p>Esta é uma página HTML simples hospedada na AWS.</p>
    <br>
    <br>
    <p>Adriano Aparecido da Silva</p>
    </div>
</body>
</html>" | sudo tee /var/www/html/index.html