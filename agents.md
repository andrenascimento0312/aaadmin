# Agents - Documentação dos Assistentes

## Visão Geral

Este documento descreve os agentes e assistentes disponíveis para trabalhar com este projeto de automação n8n + PostgreSQL + pgAdmin.

## Agentes Disponíveis

### 1. Docker Agent
**Responsabilidade:** Gerenciamento de containers e infraestrutura Docker

**Capacidades:**
- Configuração e inicialização de containers
- Monitoramento de saúde dos serviços
- Gerenciamento de volumes e redes
- Troubleshooting de problemas de containerização

**Comandos Principais:**
```bash
# Inicializar ambiente
docker-compose up -d

# Verificar status
docker-compose ps

# Parar serviços
docker-compose down

# Ver logs
docker-compose logs -f
```

**Quando Usar:**
- Problemas de inicialização dos serviços
- Configuração de novos containers
- Troubleshooting de conectividade
- Gerenciamento de recursos

### 2. Database Agent
**Responsabilidade:** Administração e manutenção do PostgreSQL

**Capacidades:**
- Criação e gerenciamento de bancos de dados
- Configuração de usuários e permissões
- Otimização de performance
- Backup e restore de dados
- Monitoramento de queries e logs

**Comandos Principais:**
```bash
# Conectar ao banco
docker-compose exec postgres psql -U n8n_user -d n8n

# Backup completo
docker-compose exec postgres pg_dump -U n8n_user n8n > backup.sql

# Restore
docker-compose exec -T postgres psql -U n8n_user n8n < backup.sql

# Verificar status
docker-compose exec postgres pg_isready -U n8n_user -d n8n
```

**Quando Usar:**
- Problemas de performance do banco
- Necessidade de backup/restore
- Configuração de novos usuários
- Otimização de queries
- Troubleshooting de conectividade

### 3. n8n Agent
**Responsabilidade:** Configuração e manutenção do n8n

**Capacidades:**
- Criação e edição de workflows
- Configuração de credenciais e integrações
- Troubleshooting de execuções
- Gerenciamento de webhooks
- Configuração de notificações

**Acessos:**
- Interface Web: http://localhost:5678
- Usuário: Definido no .env
- Senha: Definida no .env

**Quando Usar:**
- Criação de novos workflows
- Configuração de integrações
- Troubleshooting de automações
- Gerenciamento de credenciais
- Monitoramento de execuções

### 4. pgAdmin Agent
**Responsabilidade:** Interface gráfica para administração do PostgreSQL

**Capacidades:**
- Visualização de dados e estruturas
- Execução de queries SQL
- Gerenciamento de tabelas e índices
- Monitoramento de performance
- Configuração de servidores

**Acessos:**
- **Local:** Interface Web: http://localhost:8080
- **Railway:** Não disponível (use Railway Dashboard ou cliente local)
- Email: Definido no .env
- Senha: Definida no .env

**Configuração de Conexão:**
- **Local:**
  - Host: postgres
  - Port: 5432
  - Database: Valor do POSTGRES_DB no .env
  - Username: Valor do POSTGRES_USER no .env
  - Password: Valor do POSTGRES_PASSWORD no .env
- **Railway:**
  - Host: Valor de PGHOST (injetado automaticamente)
  - Port: Valor de PGPORT (injetado automaticamente)
  - Database: Valor de PGDATABASE (injetado automaticamente)
  - Username: Valor de PGUSER (injetado automaticamente)
  - Password: Valor de PGPASSWORD (injetado automaticamente)

**Quando Usar:**
- Análise visual de dados
- Execução de queries complexas
- Gerenciamento de esquemas
- Monitoramento de performance
- Configuração de índices

### 5. Railway Agent
**Responsabilidade:** Deploy e gerenciamento no Railway

**Capacidades:**
- Deploy automático de aplicações
- Gerenciamento de serviços PostgreSQL
- Monitoramento de recursos e logs
- Configuração de variáveis de ambiente
- Backup automático de dados

**Comandos Principais:**
```bash
# Login no Railway
railway login

# Inicializar projeto
railway init

# Adicionar PostgreSQL
railway add postgresql

# Configurar variáveis
railway variables set KEY=value

# Deploy
railway up

# Ver logs
railway logs

# Ver status
railway status
```

**Acessos:**
- Dashboard: https://railway.app/dashboard
- Aplicação: URL fornecida pelo Railway
- PostgreSQL: Conecta automaticamente via variáveis de ambiente

**Quando Usar:**
- Deploy em produção
- Gerenciamento de infraestrutura
- Monitoramento de recursos
- Configuração de ambiente
- Troubleshooting de deploy

## Fluxo de Trabalho dos Agentes

### 1. Setup Inicial

#### Local
```
Docker Agent → Configura ambiente
     ↓
Database Agent → Configura PostgreSQL
     ↓
n8n Agent → Configura automações
     ↓
pgAdmin Agent → Interface de administração
```

#### Railway
```
Railway Agent → Configura projeto e PostgreSQL
     ↓
n8n Agent → Deploy e configura automações
     ↓
Database Agent → Monitora PostgreSQL gerenciado
```

### 2. Desenvolvimento
```
pgAdmin Agent → Analisa dados existentes
     ↓
n8n Agent → Cria/edita workflows
     ↓
Database Agent → Otimiza performance
     ↓
Docker Agent → Monitora recursos
```

### 3. Troubleshooting
```
Docker Agent → Verifica containers
     ↓
Database Agent → Analisa logs do banco
     ↓
n8n Agent → Verifica execuções
     ↓
pgAdmin Agent → Valida dados
```

## Integração entre Agentes

### Docker ↔ Database
- Docker Agent gerencia o container PostgreSQL
- Database Agent executa comandos dentro do container
- Compartilham configurações via .env

### Database ↔ n8n
- Database Agent mantém o banco de dados
- n8n Agent armazena workflows e execuções
- Compartilham credenciais de conexão

### Database ↔ pgAdmin
- Database Agent configura o banco
- pgAdmin Agent fornece interface gráfica
- Compartilham configurações de conexão

### n8n ↔ pgAdmin
- n8n Agent executa workflows
- pgAdmin Agent monitora dados gerados
- Podem compartilhar dados via banco

## Scripts de Automação

### health-check.sh
```bash
#!/bin/bash
# Verifica saúde de todos os serviços

echo "Verificando Docker containers..."
docker-compose ps

echo "Verificando PostgreSQL..."
docker-compose exec postgres pg_isready -U n8n_user -d n8n

echo "Verificando n8n..."
curl -f http://localhost:5678/healthz || echo "n8n não está respondendo"

echo "Verificando pgAdmin..."
curl -f http://localhost:8080 || echo "pgAdmin não está respondendo"
```

### backup.sh
```bash
#!/bin/bash
# Backup completo do ambiente

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="./backups/$DATE"

mkdir -p $BACKUP_DIR

echo "Fazendo backup do PostgreSQL..."
docker-compose exec postgres pg_dump -U n8n_user n8n > $BACKUP_DIR/postgres_backup.sql

echo "Fazendo backup dos dados n8n..."
cp -r ./n8n_data $BACKUP_DIR/

echo "Fazendo backup dos dados pgAdmin..."
cp -r ./pgadmin_data $BACKUP_DIR/

echo "Backup concluído em: $BACKUP_DIR"
```

### restore.sh
```bash
#!/bin/bash
# Restore de backup

if [ -z "$1" ]; then
    echo "Uso: $0 <diretorio_do_backup>"
    exit 1
fi

BACKUP_DIR=$1

echo "Restaurando PostgreSQL..."
docker-compose exec -T postgres psql -U n8n_user n8n < $BACKUP_DIR/postgres_backup.sql

echo "Restaurando dados n8n..."
rm -rf ./n8n_data
cp -r $BACKUP_DIR/n8n_data ./

echo "Restaurando dados pgAdmin..."
rm -rf ./pgadmin_data
cp -r $BACKUP_DIR/pgadmin_data ./

echo "Restore concluído!"
```

## Monitoramento

### Métricas Importantes
- **Docker:** Uso de CPU, memória e disco
- **PostgreSQL:** Conexões ativas, queries lentas, tamanho do banco
- **n8n:** Workflows executados, erros, tempo de execução
- **pgAdmin:** Sessões ativas, queries executadas

### Alertas Recomendados
- Container parado inesperadamente
- Uso de memória > 80%
- Erros de conexão com banco
- Workflows falhando repetidamente
- Queries executando > 30 segundos

## Troubleshooting por Agente

### Docker Agent
- **Problema:** Container não inicia
- **Solução:** Verificar logs, configurações .env, portas disponíveis

### Database Agent
- **Problema:** Conexão recusada
- **Solução:** Verificar credenciais, aguardar health check, verificar logs

### n8n Agent
- **Problema:** Workflow não executa
- **Solução:** Verificar credenciais, configurações, logs de execução

### pgAdmin Agent
- **Problema:** Não consegue conectar ao banco
- **Solução:** Verificar configurações de servidor, credenciais, conectividade

## Manutenção Preventiva

### Diária
- Verificar logs de erro
- Monitorar uso de recursos
- Validar execução de workflows críticos

### Semanal
- Backup completo do ambiente
- Análise de performance do banco
- Limpeza de logs antigos
- Atualização de dependências

### Mensal
- Revisão de workflows obsoletos
- Otimização de queries
- Atualização de documentação
- Teste de procedimentos de backup/restore
