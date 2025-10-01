# Dockerfile para n8n no Railway - v3
FROM n8nio/n8n:latest

# Expor porta
EXPOSE 5678

# Comando de inicialização
CMD ["n8n", "start"]
