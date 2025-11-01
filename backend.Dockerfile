# Étape 1 : Image Python légère
FROM python:3.12-slim-bookworm

# Étape 2 : Installer ffmpeg et dépendances système
RUN apt-get update && \
    apt-get install -y libatomic1 ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Étape 3 : Dossier de travail
WORKDIR /app

# Étape 4 : Copier le fichier des dépendances Python
COPY requirements.txt .

# Étape 5 : Installer les dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Étape 6 : Copier le code source de l’application
COPY app/ ./app

# Étape 7 : Créer le dossier de sortie
RUN mkdir -p /app/generated

# Étape 8 : Exposer le port FastAPI
EXPOSE 8000

# Étape 9 : Lancer FastAPI avec Uvicorn (limite taille augmentée)
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
