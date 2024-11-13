# RDS(Relational Database Service)

# db_subnet_group_name-> Define o nome do grupo de subnets que serão associadas ao
# cluster do RDS.O grupo de subnets definen as subnets da VPC em que as instâncias do RDS serão colocadas

# db_cluster_instance_class = "db.m5d.large"-> Define o tipo de instância para o nó do cluster do banco de dados.
# Neste caso, está configurado como db.m5d.large.
# m5d.large-> É uma classe de instância otimizada para uso de memória e armazenamento em SSD (Solid State Drive), 
# adequada para a execução de cargas de trabalho de banco de dados.O tipo de instância determina os recursos de CPU, 
# memória e armazenamento alocados para o banco de dados.

# storage_type = "io2"-> Especifica o tipo de armazenamento para o cluster do RDS. O valor configurado é io2, que representa
# o armazenamento SSD de alta performance.
# O tipo io2 oferece alto desempenho de IOPS (operações de entrada e saída por segundo) para workloads críticas que necessitam de
# baixa latência e alto desempenho de disco.

# allocated_storage = var.allocated_storage -> Determina o tamanho do armazenamento(em GB) que será alocado para o banco de dados.
# O valor é passado por meio da variável var.allocated_storage contida no arquivo varable.tf

# skip_final_snapshot = true -> Controla se será tirado um snapshot final do banco de dados quando o cluster for destruído.
# O valor true indica que nenhum snapshot final será feito ao excluir o cluster de banco de dados. 
# Obs: Para ambientes de produção, geralmente, e recomendado tirar um snapshot antes de excluir um banco de dados,
# mas o valor true é útil em cenários de testes ou quando a retenção de snapshots não é necessária.


# Criação do cluster de banco de dados Amazon RDS(Relational Database Service) 
resource "aws_rds_cluster" "rds-cluster-db" {
  cluster_identifier        = "rds-cluster-db"
  availability_zones        = var.availability_zones
  db_subnet_group_name      = aws_db_subnet_group.santander-coders-db-group.name
  engine                    = "mysql"
  engine_version            = "8.0.39"
  db_cluster_instance_class = "db.m5d.large"
  storage_type              = "io2"
  allocated_storage         = var.allocated_storage
  iops                      = var.iops
  master_username           = "root"
  master_password           = var.root_password
  skip_final_snapshot       = true
}