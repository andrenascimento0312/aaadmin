# Deploy no Railway - Guia Completo

## Visão Geral

Este guia mostra como fazer deploy do n8n com PostgreSQL no Railway, uma plataforma de deploy que facilita a hospedagem de aplicações Docker.

## Arquitetura no Railway

```
┌─────────────────┐    ┌──────────────────┐
│   n8n App       │    │  PostgreSQL      │
│   (Docker)      │◄──►│  (Gerenciado)    │
│   Port: 5678    │    │  Auto-configured │
└─────────────────┘    └──────────────────┘
```

## Pré-requisitos

- [ ] Conta no Railway (https://railway.app)
- [ ] Node.js instalado (para Railway CLI)
- [ ] Git configurado
- [ ] Projeto clonado localmente

## Passo 1: Instalar Railway CLI

```bash
# Instalar Railway CLI globalmente
npm install -g @railway/cli

# Verificar instalação
railway --version
```

## Passo 2: Login no Railway

```bash
# Fazer login no Railway
railway login

# Verificar status
railway whoami
```

## Passo 3: Configurar Projeto

```bash
# Navegar para o diretório do projeto
cd /caminho/para/seu/projeto

# Inicializar projeto Railway
railway init

# Isso criará um arquivo railway.json
```

## Passo 4: Adicionar PostgreSQL

```bash
# Adicionar serviço PostgreSQL
railway add postgresql

# Verificar serviços
railway status
```

## Passo 5: Configurar Variáveis de Ambiente

```bash
# Configurar variáveis do n8n
railway variables set N8N_BASIC_AUTH_ACTIVE=true
railway variables set N8N_BASIC_AUTH_USER=admin
railway variables set N8N_BASIC_AUTH_PASSWORD=sua_senha_super_segura
railway variables set DB_TYPE=postgresdb

# Configurar timezone
railway variables set GENERIC_TIMEZONE=America/Sao_Paulo
railway variables set TZ=America/Sao_Paulo

# Configurar segurança
railway variables set N8N_SECURE_COOKIE=false

# Ver todas as variáveis
railway variables
```

## Passo 6: Deploy

```bash
# Fazer deploy da aplicação
railway up

# Acompanhar logs em tempo real
railway logs --follow
```

## Passo 7: Verificar Deploy

```bash
# Ver status dos serviços
railway status

# Ver URL da aplicação
railway domain

# Testar conectividade
curl https://sua-app.railway.app/healthz
```

## Configuração Automática

O Railway automaticamente injeta as seguintes variáveis para o PostgreSQL:

- `DATABASE_URL` - URL completa de conexão
- `PGHOST` - Host do PostgreSQL
- `PGPORT` - Porta do PostgreSQL
- `PGDATABASE` - Nome do banco
- `PGUSER` - Usuário do banco
- `PGPASSWORD` - Senha do banco

## Acessos

### n8n
- **URL:** https://sua-app.railway.app
- **Usuário:** admin (ou o que você configurou)
- **Senha:** sua_senha_super_segura

### PostgreSQL
- **Host:** Valor de PGHOST
- **Porta:** Valor de PGPORT
- **Database:** Valor de PGDATABASE
- **Usuário:** Valor de PGUSER
- **Senha:** Valor de PGPASSWORD

## Monitoramento

### Logs
```bash
# Ver logs da aplicação
railway logs

# Ver logs em tempo real
railway logs --follow

# Ver logs de um serviço específico
railway logs --service postgresql
```

### Métricas
- Acesse o dashboard do Railway
- Monitore CPU, memória e rede
- Configure alertas se necessário

## Backup e Restore

### Backup Automático
- O Railway faz backup automático do PostgreSQL
- Dados são mantidos por 7 dias por padrão
- Backup pode ser configurado no dashboard

### Backup Manual
```bash
# Conectar ao PostgreSQL
railway connect postgresql

# Fazer backup
pg_dump -U postgres -d n8n > backup.sql

# Restaurar backup
psql -U postgres -d n8n < backup.sql
```

## Troubleshooting

### Problemas Comuns

#### 1. Build Falha
```bash
# Ver logs de build
railway logs --build

# Verificar Dockerfile
cat Dockerfile

# Testar localmente
docker build -t test-app .
```

#### 2. App Não Inicia
```bash
# Verificar variáveis
railway variables

# Ver logs de runtime
railway logs --follow

# Verificar healthcheck
curl https://sua-app.railway.app/healthz
```

#### 3. Erro de Conexão com Banco
```bash
# Verificar se PostgreSQL está rodando
railway status

# Ver logs do PostgreSQL
railway logs --service postgresql

# Testar conexão
railway connect postgresql
```

#### 4. Timeout na Inicialização
- Verifique se o healthcheck está configurado corretamente
- Aumente o timeout se necessário
- Verifique se a aplicação está respondendo na porta correta

### Comandos Úteis

```bash
# Ver status geral
railway status

# Ver variáveis de ambiente
railway variables

# Conectar a um serviço
railway connect postgresql

# Ver logs de um serviço específico
railway logs --service <service-name>

# Reiniciar aplicação
railway redeploy

# Ver domínios
railway domain

# Ver métricas
railway metrics
```

## Atualizações

### Deploy de Atualizações
```bash
# Fazer commit das mudanças
git add .
git commit -m "Atualização da aplicação"

# Deploy automático (se configurado)
git push origin main

# Ou deploy manual
railway up
```

### Atualizar Variáveis
```bash
# Atualizar uma variável
railway variables set KEY=new_value

# Deletar uma variável
railway variables delete KEY

# Ver todas as variáveis
railway variables
```

## Custos

- **n8n:** Gratuito até 500 horas/mês
- **PostgreSQL:** Gratuito até 1GB de dados
- **Bandwidth:** Gratuito até 100GB/mês

Para uso além dos limites gratuitos, consulte os preços no site do Railway.

## Suporte

- **Documentação:** https://docs.railway.app
- **Discord:** https://discord.gg/railway
- **GitHub:** https://github.com/railwayapp
- **Status:** https://status.railway.app

## Próximos Passos

1. Configure webhooks para integrações
2. Implemente monitoramento avançado
3. Configure CI/CD para deploys automáticos
4. Implemente backup personalizado se necessário
5. Configure domínio customizado se desejado
