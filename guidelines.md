# Guidelines do Projeto

## Visão Geral

Este projeto fornece um ambiente Docker completo para automação de workflows usando n8n, com PostgreSQL como banco de dados e pgAdmin para administração do banco.

## Estrutura do Projeto

```
├── docker-compose.yml      # Configuração dos serviços Docker
├── env.template           # Template de variáveis de ambiente
├── README.md              # Documentação principal
├── guidelines.md          # Este arquivo - diretrizes do projeto
├── agents.md              # Documentação dos agentes/assistentes
├── postgres_data/         # Dados persistentes do PostgreSQL
├── n8n_data/             # Dados persistentes do n8n
└── pgadmin_data/         # Dados persistentes do pgAdmin
```

## Padrões de Desenvolvimento

### 1. Configuração de Ambiente

- **SEMPRE** use o arquivo `.env` para configurações sensíveis
- **NUNCA** commite o arquivo `.env` no repositório
- Use o `env.template` como referência para novas variáveis
- Documente todas as novas variáveis no README.md

### 2. Docker e Containers

- Mantenha os containers com `restart: unless-stopped`
- Use health checks para dependências entre serviços
- Sempre especifique versões específicas das imagens (evite `latest`)
- Configure volumes para persistência de dados

### 3. Segurança

- Use senhas fortes e únicas para cada serviço
- Configure autenticação básica para o n8n
- Mantenha as configurações de segurança atualizadas
- Documente procedimentos de backup e restore

### 4. Documentação

- Mantenha o README.md sempre atualizado
- Documente mudanças significativas no CHANGELOG.md
- Use comentários claros no código
- Inclua exemplos de uso quando apropriado

## Convenções de Nomenclatura

### Arquivos e Pastas
- Use snake_case para nomes de arquivos
- Use kebab-case para nomes de pastas
- Prefixe arquivos de configuração com o serviço (ex: `n8n_config.json`)

### Variáveis de Ambiente
- Use UPPER_SNAKE_CASE
- Agrupe por serviço (ex: `POSTGRES_*`, `N8N_*`, `PGADMIN_*`)
- Use nomes descritivos e claros

### Containers Docker
- Use nomes descritivos e consistentes
- Inclua o tipo de serviço no nome (ex: `postgres_n8n`, `n8n`, `pgadmin`)

## Workflow de Desenvolvimento

### 1. Setup Inicial
```bash
# 1. Clone o repositório
git clone <repository-url>
cd <project-directory>

# 2. Configure o ambiente
cp env.template .env
# Edite o .env com suas configurações

# 3. Inicie os serviços
docker-compose up -d
```

### 2. Desenvolvimento
- Faça alterações no código
- Teste localmente com `docker-compose up`
- Verifique logs com `docker-compose logs -f`
- Documente mudanças significativas

### 3. Deploy

#### Deploy Local
- Valide todas as configurações
- Execute testes de integração
- Faça backup dos dados existentes
- Atualize a documentação

#### Deploy no Railway

O Railway é uma plataforma de deploy que facilita a hospedagem de aplicações Docker. Para este projeto, você pode fazer deploy do n8n e usar o PostgreSQL como serviço gerenciado.

##### Pré-requisitos
- Conta no Railway (https://railway.app)
- Railway CLI instalado (`npm install -g @railway/cli`)
- Projeto configurado com Railway

##### Configuração do Railway

1. **Instalar Railway CLI:**
   ```bash
   npm install -g @railway/cli
   ```

2. **Login no Railway:**
   ```bash
   railway login
   ```

3. **Inicializar projeto:**
   ```bash
   railway init
   ```

4. **Adicionar PostgreSQL:**
   ```bash
   railway add postgresql
   ```

5. **Configurar variáveis de ambiente:**
   ```bash
   # Copie as configurações do railway.env.template
   cp railway.env.template .env
   
   # Configure as variáveis no Railway
   railway variables set N8N_BASIC_AUTH_USER=admin
   railway variables set N8N_BASIC_AUTH_PASSWORD=sua_senha_segura
   railway variables set DB_TYPE=postgresdb
   # As outras variáveis serão configuradas automaticamente pelo PostgreSQL plugin
   ```

6. **Deploy:**
   ```bash
   railway up
   ```

##### Estrutura de Deploy no Railway

- **n8n:** Aplicação principal (deploy via Dockerfile)
- **PostgreSQL:** Serviço gerenciado (plugin do Railway)
- **pgAdmin:** Não disponível no Railway (use interface web do Railway ou cliente local)

##### Variáveis de Ambiente no Railway

O Railway automaticamente injeta as seguintes variáveis para o PostgreSQL:
- `DATABASE_URL`
- `PGHOST`
- `PGPORT`
- `PGDATABASE`
- `PGUSER`
- `PGPASSWORD`

##### Monitoramento no Railway

- **Logs:** `railway logs`
- **Status:** Dashboard web do Railway
- **Métricas:** CPU, memória, rede
- **Backup:** Automático para PostgreSQL

##### Troubleshooting Railway

- **Build falha:** Verifique Dockerfile e dependências
- **App não inicia:** Verifique variáveis de ambiente
- **Erro de conexão DB:** Aguarde inicialização do PostgreSQL
- **Timeout:** Verifique healthcheck e startCommand

## Boas Práticas

### Docker
- Use multi-stage builds quando apropriado
- Otimize o tamanho das imagens
- Use .dockerignore para excluir arquivos desnecessários
- Configure recursos adequados para cada container

### n8n
- Organize workflows em pastas lógicas
- Use nomes descritivos para workflows e nós
- Documente workflows complexos
- Implemente tratamento de erros adequado

### PostgreSQL
- Use índices apropriados para consultas frequentes
- Configure backup automático
- Monitore performance e logs
- Mantenha o banco atualizado

### pgAdmin
- Configure conexões com nomes descritivos
- Organize servidores em grupos lógicos
- Use queries salvos para operações frequentes
- Mantenha configurações de segurança

## Troubleshooting

### Problemas Comuns

1. **Container não inicia**
   - Verifique logs: `docker-compose logs <service-name>`
   - Confirme configurações no .env
   - Verifique se as portas estão disponíveis

2. **Erro de conexão com banco**
   - Aguarde o health check do PostgreSQL
   - Verifique credenciais no .env
   - Confirme se o container do PostgreSQL está rodando

3. **Dados não persistem**
   - Verifique se os volumes estão montados corretamente
   - Confirme permissões das pastas de dados
   - Verifique se os volumes estão definidos no docker-compose.yml

### Comandos Úteis

```bash
# Ver status dos containers
docker-compose ps

# Reiniciar um serviço específico
docker-compose restart <service-name>

# Ver logs em tempo real
docker-compose logs -f <service-name>

# Executar comando em container
docker-compose exec <service-name> <command>

# Backup do banco
docker-compose exec postgres pg_dump -U n8n_user n8n > backup.sql

# Restore do banco
docker-compose exec -T postgres psql -U n8n_user n8n < backup.sql
```

## Contribuição

1. Faça fork do projeto
2. Crie uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. Push para a branch (`git push origin feature/nova-feature`)
5. Abra um Pull Request

## Licença

[Especificar licença do projeto]

## Contato

[Informações de contato do mantenedor]
