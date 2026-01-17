# Configuration de l'environnement backend

## Variables d'environnement requises

Créez un fichier `.env` dans le dossier `backend/` avec les variables suivantes :

```env
# Supabase Configuration
SUPABASE_URL=https://votre-projet.supabase.co
SUPABASE_SERVICE_ROLE_KEY=votre-service-role-key

# Optionnel (fallback si SERVICE_ROLE_KEY n'est pas défini)
# SUPABASE_KEY=votre-anon-key

# Gemini API
GEMINI_API_KEY=votre-gemini-api-key
```

## Important : Service Role Key

Le backend **DOIT** utiliser la **Service Role Key** (et non la clé anon) pour contourner les politiques Row Level Security (RLS) de Supabase.

### Comment obtenir la Service Role Key :

1. Allez sur votre projet Supabase : https://app.supabase.com
2. Sélectionnez votre projet
3. Allez dans **Settings** → **API**
4. Copiez la **`service_role` key** (⚠️ **NE JAMAIS** exposer cette clé publiquement)

### Pourquoi utiliser la Service Role Key ?

- Le backend doit pouvoir insérer des données sans être bloqué par les politiques RLS
- Les politiques RLS sont conçues pour les clients frontend (qui utilisent la clé anon)
- Le backend agit comme un service backend de confiance

## Vérification

Après avoir configuré les variables d'environnement, redémarrez le serveur :

```bash
python -m uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

Les erreurs RLS devraient être résolues si la Service Role Key est correctement configurée.
