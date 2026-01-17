-- Politiques RLS pour la table item_images
-- Ces politiques permettent aux utilisateurs authentifiés d'insérer leurs propres images
-- et de voir toutes les images publiques

-- Activer RLS sur item_images (si pas déjà fait)
ALTER TABLE public.item_images ENABLE ROW LEVEL SECURITY;

-- Politique pour permettre l'insertion d'images par les utilisateurs authentifiés
CREATE POLICY "Users can insert their own images"
ON public.item_images
FOR INSERT
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Politique pour permettre la visualisation de toutes les images (publiques)
CREATE POLICY "Images are viewable by everyone"
ON public.item_images
FOR SELECT
TO public
USING (true);

-- Politique pour permettre la suppression de ses propres images
CREATE POLICY "Users can delete their own images"
ON public.item_images
FOR DELETE
TO authenticated
USING (auth.uid() = user_id);

-- Note: Le backend utilise la Service Role Key, donc ces politiques ne s'appliquent pas
-- aux opérations backend. Elles sont uniquement pour les opérations frontend.
