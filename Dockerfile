# Dockerfile para n8n no Railway
FROM n8nio/n8n:latest

# Instalar dependências adicionais se necessário (Alpine Linux usa apk)
USER root
RUN apk update && apk add --no-cache curl && rm -rf /var/cache/apk/*

# Voltar para o usuário node
USER node

# Configurar diretório de trabalho
WORKDIR /home/node

# Expor porta
EXPOSE 5678

# Comando de inicialização
CMD ["n8n", "start"]
