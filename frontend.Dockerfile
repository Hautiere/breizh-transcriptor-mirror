# ============================================================
# Étape 1 : Build Angular avec Node 20 (en mode production)
# ============================================================
FROM node:20-alpine AS build

WORKDIR /app/frontend

# Copier les fichiers nécessaires
COPY package*.json ./

# Installer exactement les dépendances (sans maj)
RUN npm ci

# Copier tout le code source Angular
COPY . .

# Compiler Angular en mode production
RUN npm run build -- --configuration production


# ============================================================
# Étape 2 : Servir le build avec Nginx
# ============================================================
FROM nginx:alpine

# Copier la config Nginx personnalisée (upload + CORS)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier le build Angular dans le répertoire de Nginx
COPY --from=build /app/frontend/dist/frontend/browser /usr/share/nginx/html

# Exposer le port
EXPOSE 80

# Lancer Nginx
CMD ["nginx", "-g", "daemon off;"]
