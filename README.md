# Docker Compose - n8n + PostgreSQL + pgAdmin

Este docker-compose sobe um ambiente completo com n8n, PostgreSQL e pgAdmin, com todos os dados persistidos localmente.

## Estrutura de Pastas

Após executar o `docker-compose up`, serão criadas as seguintes pastas para persistir os dados:

- `postgres_data/` - Dados do PostgreSQL
- `n8n_data/` - Dados do n8n (workflows, configurações, etc.)
- `pgadmin_data/` - Dados do pgAdmin (configurações, conexões, etc.)

## Configuração Inicial

1. **Criar arquivo .env:**
   ```bash
   # Copie o template para .env
   copy env.template .env
   
   # Ou no Linux/Mac:
   cp env.template .env
   ```

2. **Editar configurações (opcional):**
   Abra o arquivo `.env` e ajuste as configurações conforme necessário:
   - Senhas
   - Portas
   - Usuários
   - Timezone

## Como usar

1. **Subir os serviços:**
   ```bash
   docker-compose up -d
   ```

2. **Acessar os serviços:**
   
   **n8n (Automação):**
   - URL: http://localhost:5678 (ou porta configurada no .env)
   - Usuário: Definido no .env (padrão: admin)
   - Senha: Definida no .env (padrão: admin123)
   
   **pgAdmin (Painel do PostgreSQL):**
   - URL: http://localhost:8080 (ou porta configurada no .env)
   - Email: Definido no .env (padrão: admin@admin.com)
   - Senha: Definida no .env (padrão: admin123)

3. **Parar os serviços:**
   ```bash
   docker-compose down
   ```

4. **Ver logs:**
   ```bash
   docker-compose logs -f
   ```

## Configurações

Todas as configurações são definidas através do arquivo `.env`:

### Variáveis Disponíveis

**PostgreSQL:**
- `POSTGRES_DB` - Nome do banco (padrão: n8n)
- `POSTGRES_USER` - Usuário do banco (padrão: n8n_user)  
- `POSTGRES_PASSWORD` - Senha do banco (padrão: n8n_password)
- `POSTGRES_PORT` - Porta externa (padrão: 5432)

**n8n:**
- `N8N_BASIC_AUTH_USER` - Usuário login (padrão: admin)
- `N8N_BASIC_AUTH_PASSWORD` - Senha login (padrão: admin123)
- `N8N_PORT` - Porta externa (padrão: 5678)

**pgAdmin:**
- `PGADMIN_DEFAULT_EMAIL` - Email login (padrão: admin@admin.com)
- `PGADMIN_DEFAULT_PASSWORD` - Senha login (padrão: admin123)  
- `PGADMIN_PORT` - Porta externa (padrão: 8080)

**Geral:**
- `TIMEZONE` - Fuso horário (padrão: America/Sao_Paulo)

## Personalização

Para alterar as configurações, edite o arquivo `.env`:

```bash
# Exemplo de personalização
POSTGRES_PASSWORD=minha_senha_super_segura
N8N_BASIC_AUTH_USER=meu_usuario
N8N_BASIC_AUTH_PASSWORD=minha_senha_n8n
PGADMIN_PORT=9090
```

**⚠️ IMPORTANTE:** Nunca commite o arquivo `.env` no git - ele contém informações sensíveis!

## Conectar pgAdmin ao PostgreSQL

Após acessar o pgAdmin (http://localhost:8080), siga estes passos para conectar ao banco:

1. **Clique em "Add New Server"**
2. **Aba "General":**
   - Name: `n8n Database`
3. **Aba "Connection":**
   - Host name/address: `postgres`
   - Port: `5432`
   - Maintenance database: `Valor do POSTGRES_DB no .env`
   - Username: `Valor do POSTGRES_USER no .env`
   - Password: `Valor do POSTGRES_PASSWORD no .env`
4. **Clique em "Save"**

Agora você pode explorar todas as tabelas do n8n no painel do pgAdmin! 🎉

## Backup

Para fazer backup dos dados:

```bash
# Backup PostgreSQL
docker-compose exec postgres pg_dump -U n8n_user n8n > backup_postgres.sql

# Os dados também estão nas pastas locais:
# - postgres_data/ (dados do PostgreSQL)
# - n8n_data/ (dados do n8n)
```

## Restore

Para restaurar um backup do PostgreSQL:

```bash
docker-compose exec -T postgres psql -U n8n_user n8n < backup_postgres.sql
```
