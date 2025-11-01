# 🐟 Breizh-comm-voices — Version 2.0 (Docker + Local)

💫 **Version 2.0** — Refonte complète et stabilisée :  
✅ Frontend Angular + Backend FastAPI fonctionnels  
✅ Dockerfiles propres et testés localement  
✅ Script unique `manage_dockers.sh` pour gérer les conteneurs  
✅ Compatible Render (déploiement cloud)

---

## ✅ Prérequis
- **Python** ≥ 3.12 (3.13 recommandé)  
- **Node.js** v20 LTS (Angular < 19)  
- **npm**  
- **ffmpeg** (pour convertir MP4 → WAV 16 kHz mono)
  ```bash
  brew install ffmpeg
🐳 Docker & Scripts
🚀 Lancement rapide avec manage_dockers.sh
Action	Commande	Description
🟩 Build complet	./manage_dockers.sh -build	Nettoie et rebuild les images backend + frontend
🟦 Démarrage	./manage_dockers.sh -start	Lance les conteneurs (backend : 8000, frontend : 4300)
🟥 Arrêt	./manage_dockers.sh -stop	Stoppe les conteneurs en cours
🧹 Nettoyage	./manage_dockers.sh -clean	Supprime images + conteneurs
❔ Aide	./manage_dockers.sh -h	Affiche le menu d’aide

🧠 Backend
Environnement	Commande	Port	Docs
Local	./start_backend.sh	8100	http://localhost:8100/docs
Docker	docker run -d -p 8000:8000 breizh-backend	8000	http://localhost:8000/docs

🎨 Frontend
Environnement	Commande	Port	UI
Local	./start_frontend.sh	4200	http://localhost:4200
Docker	docker run -d -p 4300:80 breizh-frontend	4300	http://localhost:4300

🗂️ Arborescence (extrait)
lua
Copier le code
breizh-comm-voices_vosk_transcriptor_v2/
│
├── backend/                         ← API FastAPI + moteur Vosk
│   ├── app/
│   │   ├── main.py                  ← routes principales (upload, transcribe, etc.)
│   │   ├── vosk_utils.py            ← fonctions Vosk (transcription, nettoyage)
│   │   ├── config.json              ← paramètres (taille max, modèle, etc.)
│   │   └── models/                  ← modèles Vosk (exclus du dépôt)
│   ├── Dockerfile                   ← conteneur backend
│   ├── requirements.txt             ← dépendances Python
│   └── VERSION.txt                  ← version du backend
│
├── frontend/                        ← Interface Angular
│   ├── src/app/                     ← composants & services
│   ├── src/environments/            ← `environment.ts` et `environment.prod.ts`
│   ├── nginx.conf                   ← config Nginx (uploads 200 Mo)
│   ├── Dockerfile                   ← conteneur frontend
│   ├── angular.json, package.json   ← config & dépendances
│   └── dist/frontend/               ← build Angular
│
├── manage_dockers.sh                ← 🧩 gestion complète Docker
├── start_backend.sh                 ← lancement local du backend
├── start_frontend.sh                ← lancement local du frontend
├── .gitignore                       ← exclusions (modèles lourds, venv, logs)
└── README.md                        ← doc principale (ce fichier)
🔌 Ports
Service	Port	URL
Backend	8000 / 8100	http://127.0.0.1:8000/docs
Frontend	4200 / 4300	http://127.0.0.1:4200

🧰 Démarrage local (hors Docker)
Backend
bash
Copier le code
chmod +x start_backend.sh
./start_backend.sh
Docs : http://127.0.0.1:8100/docs

Test rapide :

bash
Copier le code
curl -F "file=@test.mp4" -F "lang=br" http://127.0.0.1:8100/api/transcribe
Frontend
bash
Copier le code
chmod +x start_frontend.sh
./start_frontend.sh
UI : http://127.0.0.1:4200

🛟 Dépannage rapide
Problème	Solution
FileNotFoundError: app/config.json	Lancer Uvicorn depuis backend/ (déjà géré par le script).
Échec de conversion MP4	Vérifie ffmpeg -version.
Erreur Angular (Node incompatible)	Utilise Node v20 LTS.
Ports déjà utilisés	`lsof -t -i :8000
Permission denied sur un script	chmod +x start_*.sh

🏷️ Version
Breizh-comm-voices — Version 2.0 (Octobre 2025)
Stabilisation complète — Docker + Scripts + Nettoyage Git

📜 Licence
Projet open-source — à but linguistique et culturel (Breton, Gallois, Cornique).

yaml
Copier le code

---

4️⃣ **Enregistre et ferme** (Ctrl+S, puis Ctrl+Q ou Cmd+S selon ton éditeur).

5️⃣ Fais le commit et le push :
```bash
git add README.md
git commit -m "🧾 Update README.md for Version 2.0 – stable Docker setup"
git push origin main
