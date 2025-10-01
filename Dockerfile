# Dockerfile para n8n no Railway
FROM n8nio/n8n:latest

# Instalar dependências adicionais se necessário
USER root
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Voltar para o usuário node
USER node

# Configurar diretório de trabalho
WORKDIR /home/node

# Expor porta
EXPOSE 5678

# Comando de inicialização
CMD ["n8n", "start"]
