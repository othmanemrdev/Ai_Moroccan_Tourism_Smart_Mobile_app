import os
import json
import io
from typing import List, Optional
from fastapi import FastAPI, UploadFile, File, Form, HTTPException
from fastapi.responses import FileResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from dotenv import load_dotenv
from supabase import create_client, Client
import google.generativeai as genai
from PIL import Image
<<<<<<< HEAD
from datetime import datetime
import uuid
os.environ["TF_USE_LEGACY_KERAS"] = "1"
# Import local classifier
try:
    from services.local_classifier import local_classifier
except ImportError:
    print("⚠️ Local classifier not available")
    local_classifier = None

# Import advanced prompts
try:
    from prompts.advanced_prompts import (
        get_food_classification_prompt,
        get_monument_classification_prompt,
        get_itinerary_generation_prompt,
        get_cost_estimation_prompt,
        get_darija_translation_prompt
    )
    print("✅ Advanced prompts loaded")
except ImportError as e:
    print(f"⚠️ Advanced prompts not available: {e}")
    # Fallback to basic prompts
    get_food_classification_prompt = None
    get_monument_classification_prompt = None
    get_itinerary_generation_prompt = None
    get_cost_estimation_prompt = None
    get_darija_translation_prompt = None
=======
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

load_dotenv()

app = FastAPI(title="MarocGuide AI - Imperial & Verdant Edition")

# --- Middlewares ---
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# --- Clients Setup ---
SUPABASE_URL = os.getenv("SUPABASE_URL")
<<<<<<< HEAD
# Use service role key to bypass RLS policies, fallback to regular key
SUPABASE_SERVICE_KEY = os.getenv("SUPABASE_SERVICE_ROLE_KEY") or os.getenv("SUPABASE_KEY")
supabase: Client = create_client(SUPABASE_URL, SUPABASE_SERVICE_KEY)
=======
SUPABASE_KEY = os.getenv("SUPABASE_KEY")
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc

genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
model = genai.GenerativeModel('gemini-flash-latest')

# --- Helper: AI Analysis Core ---
async def get_ai_analysis(img_bytes: bytes, category: str):
<<<<<<< HEAD
    """Universal AI analyzer for Food and Monuments with Advanced Prompts."""
=======
    """Universal AI analyzer for Food and Monuments."""
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
    # Convert image to JPEG format for consistency
    img = Image.open(io.BytesIO(img_bytes))
    if img.mode != 'RGB':
        img = img.convert('RGB')
    buffer = io.BytesIO()
    img.save(buffer, format='JPEG')
    jpeg_bytes = buffer.getvalue()
    
<<<<<<< HEAD
    # Use advanced prompts if available, otherwise fallback to basic
    if category == "food" and get_food_classification_prompt:
        prompt = get_food_classification_prompt()
    elif category == "monument" and get_monument_classification_prompt:
        prompt = get_monument_classification_prompt()
    else:
        # Fallback to basic prompt
        prompt = f"""
        You are a Moroccan {category} expert. Return a JSON object with:
        "name": "standard name",
        "description": "brief summary",
        "type": "specific category",
        "city": "city name if monument, else null",
        "cultural_fact": "fun fact"
        """
=======
    prompt = f"""
    You are a Moroccan {category} expert. Return a JSON object with:
    "name": "standard name",
    "description": "brief summary",
    "type": "specific category",
    "city": "city name if monument, else null",
    "cultural_fact": "fun fact"
    """
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
    
    try:
        response = model.generate_content(
            [prompt, {"mime_type": "image/jpeg", "data": jpeg_bytes}],
            generation_config={"response_mime_type": "application/json"}
        )
        return json.loads(response.text)
    except Exception as e:
        if "quota" in str(e).lower() or "exceeded" in str(e).lower():
            raise HTTPException(status_code=429, detail="AI quota exceeded. Please try again later or upgrade your plan.")
        raise HTTPException(status_code=500, detail="AI response is not valid JSON")

# --- ROUTES ---

@app.post("/analyze-and-save")
async def analyze_and_save(
    file: UploadFile = File(...),
    category: str = Form(...), # "food" or "monument"
    user_id: str = Form(...)
):
    try:
        img_bytes = await file.read()
        ai_data = await get_ai_analysis(img_bytes, category)
        
        # Ensure city is provided for monuments
        if category == "monument" and not ai_data.get("city"):
            ai_data["city"] = "Unknown City"
        
        table = "food" if category == "food" else "monuments"
        item_name = ai_data["name"]

        # 1. Deduplication: Check if item exists in DB
        existing = supabase.table(table).select("*").ilike("name", item_name).execute()

        if existing.data:
            item_id = existing.data[0]["id"]
            action_taken = "added_image_to_existing"
        else:
            # 2. Create new item entry
            insert_data = {
                "name": item_name,
                "description": ai_data["description"],
                "type": ai_data["type"],
                "first_added_by": user_id
            }
            if category == "monument":
                insert_data["city"] = ai_data.get("city")
            
            new_item = supabase.table(table).insert(insert_data).execute()
            item_id = new_item.data[0]["id"]
            action_taken = "created_new_item"

        # 3. Save Image Reference to DB
        # Note: Image should be uploaded to Supabase Storage first; 
        # For now, we store a placeholder path or the real URL from Flutter
        image_url = f"https://placeholder-url.com/{file.filename}" 

        supabase.table("item_images").insert({
            "item_id": item_id,
            "item_type": category,
            "user_id": user_id,
            "image_url": image_url
        }).execute()

        return {
            "status": "success",
            "action": action_taken,
            "item_details": ai_data,
            "item_id": item_id
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# --- Test Route: Analyze Only (No DB Save) ---
@app.post("/analyze-only")
async def analyze_only(
    file: UploadFile = File(...),
    category: str = Form(...)
):
    try:
        img_bytes = await file.read()
        ai_data = await get_ai_analysis(img_bytes, category)
        
        # Return only fields that respect the DB schema
        result = {
            "name": ai_data["name"],
            "type": ai_data["type"],
            "description": ai_data["description"]
        }
        if category == "monument":
            result["city"] = ai_data.get("city", "Unknown City")
        
        return {
            "status": "success",
            "item_details": result
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# --- Travel Planner (Phase 2 Update) ---
class ItineraryRequest(BaseModel):
    user_id: str
    city: str
    duration: int
    budget: str
    interests: str

@app.post("/generate-itinerary")
async def generate_itinerary(req: ItineraryRequest):
    try:
<<<<<<< HEAD
        # Use advanced prompts if available, otherwise fallback to basic
        if get_itinerary_generation_prompt:
            prompt = get_itinerary_generation_prompt(req.city, req.duration, req.budget, req.interests)
        else:
            prompt = f"""
            Create a {req.duration}-day {req.interests} itinerary for {req.city} with a {req.budget} budget.
            Return a JSON object where each key is "Day X" (e.g., "Day 1", "Day 2") and each value is an array of activities.
            Each activity should be an object with keys: "time" (string, e.g., "9:00 AM"), "activity" (string description), "type" (string like "sightseeing", "food", etc.).
            Ensure the JSON is valid and covers all {req.duration} days.
            """
=======
        prompt = f"""
        Create a {req.duration}-day {req.interests} itinerary for {req.city} with a {req.budget} budget.
        Return a JSON object where each key is "Day X" (e.g., "Day 1", "Day 2") and each value is an array of activities.
        Each activity should be an object with keys: "time" (string, e.g., "9:00 AM"), "activity" (string description), "type" (string like "sightseeing", "food", etc.).
        Ensure the JSON is valid and covers all {req.duration} days.
        """
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
        response = model.generate_content(prompt, generation_config={"response_mime_type": "application/json"})
        itinerary_data = json.loads(response.text)
        
        return itinerary_data
    except Exception as e:
        if "quota" in str(e).lower() or "exceeded" in str(e).lower():
            raise HTTPException(status_code=429, detail="AI quota exceeded. Please try again later or upgrade your plan.")
        raise HTTPException(status_code=500, detail=str(e))
class TranslationRequest(BaseModel):
    text: str
    target: str

@app.post("/translate-darija")
async def translate_darija(req: TranslationRequest):
    try:
        if req.target == "Darija":
            prompt = f"Translate '{req.text}' to Moroccan Darija. Provide the translation in both Latin script and Arabic script. Return JSON with 'latin' and 'arabic' fields."
        else:
            prompt = f"Translate '{req.text}' from Moroccan Darija to English. Return JSON with 'english' field."
        
        response = model.generate_content(prompt, generation_config={"response_mime_type": "application/json"})
        return json.loads(response.text)
    except Exception as e:
        if "quota" in str(e).lower() or "exceeded" in str(e).lower():
            raise HTTPException(status_code=429, detail="AI quota exceeded. Please try again later or upgrade your plan.")
        raise HTTPException(status_code=500, detail=str(e))

# --- Cost Estimator (Phase 2 Update) ---
class CostRequest(BaseModel):
    item: str
    location: str

@app.post("/estimate-cost")
async def estimate_cost(req: CostRequest):
    try:
        prompt = f"Estimate fair price for {req.item} in {req.location}, Morocco (2026). Return JSON with min, max, and haggling_tip."
        response = model.generate_content(prompt, generation_config={"response_mime_type": "application/json"})
        return json.loads(response.text)
    except Exception as e:
        if "quota" in str(e).lower() or "exceeded" in str(e).lower():
            raise HTTPException(status_code=429, detail="AI quota exceeded. Please try again later or upgrade your plan.")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
def health_check():
    return {"status": "healthy"}

@app.get("/")
def serve_index():
    return FileResponse("template/index.html")

@app.get("/test")
def serve_test():
<<<<<<< HEAD
    return FileResponse("template/index.html")

# --- NEW ENDPOINTS FOR HYBRID CLASSIFICATION ---

@app.post("/classify-local")
async def classify_local(
    file: UploadFile = File(...),
    category: str = Form(...)  # "food" or "monument"
):
    """Classification locale avec modèles MobileNetV3"""
    if local_classifier is None:
        raise HTTPException(
            status_code=503, 
            detail="Local models not available. Check server logs for details. Make sure TensorFlow and model files are properly installed."
        )
    
    try:
        img_bytes = await file.read()
        if len(img_bytes) == 0:
            raise HTTPException(status_code=400, detail="Empty image file")
        
        result = local_classifier.predict(img_bytes, category)
        
        if not result or "top_prediction" not in result:
            raise HTTPException(status_code=500, detail="Model prediction failed")
        
        # Récupérer infos depuis DB si existe
        table = "food" if category == "food" else "monuments"
        try:
            existing = supabase.table(table).select("*").ilike("name", result["top_prediction"]["name"]).execute()
        except Exception as db_error:
            print(f"Database query error in classify-local: {str(db_error)}")
            # Continue sans données DB si la requête échoue
            existing = type('obj', (object,), {'data': []})()
        
        if existing.data and len(existing.data) > 0:
            item = existing.data[0]
            return {
                "status": "success",
                "item_details": {
                    "name": item["name"],
                    "description": item.get("description", ""),
                    "type": item.get("type", ""),
                    "city": item.get("city") if category == "monument" else None,
                    "confidence": result["top_prediction"]["confidence"],
                    "source": "local_model"
                },
                "item_id": item["id"]
            }
        else:
            # Item pas encore dans DB
            return {
                "status": "success",
                "item_details": {
                    "name": result["top_prediction"]["name"],
                    "description": f"Moroccan {category}",
                    "type": category,
                    "confidence": result["top_prediction"]["confidence"],
                    "source": "local_model"
                },
                "item_id": None
            }
    except HTTPException:
        raise
    except Exception as e:
        print(f"Classify local error: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Classification failed: {str(e)}")

@app.post("/upload-photo")
async def upload_photo(
    file: UploadFile = File(...),
    item_name: str = Form(...),
    item_type: str = Form(...),  # "food" or "monument"
    user_id: str = Form(...)
):
    """Upload photo vers Supabase Storage et créer/lier item"""
    try:
        # Lire l'image
        img_bytes = await file.read()
        
        # Générer nom unique
        file_extension = file.filename.split('.')[-1] if '.' in file.filename else 'jpg'
        unique_filename = f"{uuid.uuid4()}.{file_extension}"
        
        # Choisir le bon bucket
        bucket_name = "food_photos" if item_type == "food" else "monument_photos"
        
        # Upload vers Supabase Storage avec gestion d'erreur améliorée
        try:
            upload_response = supabase.storage.from_(bucket_name).upload(
                unique_filename,
                img_bytes,
                file_options={'content-type': file.content_type or 'image/jpeg', 'upsert': 'false'}
            )
        except Exception as storage_error:
            print(f"Storage upload error: {str(storage_error)}")
            raise HTTPException(
                status_code=500, 
                detail=f"Failed to upload to storage: {str(storage_error)}"
            )
        
        # Obtenir URL publique
        try:
            public_url = supabase.storage.from_(bucket_name).get_public_url(unique_filename)
        except Exception as url_error:
            print(f"Error getting public URL: {str(url_error)}")
            # Construire l'URL manuellement si nécessaire
            public_url = f"{SUPABASE_URL}/storage/v1/object/public/{bucket_name}/{unique_filename}"
        
        # Vérifier si item existe déjà
        table = "food" if item_type == "food" else "monuments"
        try:
            existing = supabase.table(table).select("*").ilike("name", item_name).execute()
        except Exception as db_error:
            print(f"Database query error: {str(db_error)}")
            raise HTTPException(status_code=500, detail=f"Database error: {str(db_error)}")
        
        if existing.data and len(existing.data) > 0:
            item_id = existing.data[0]["id"]
        else:
            # Créer nouvel item
            new_item_data = {
                "name": item_name,
                "type": item_type,
                "description": f"Moroccan {item_type}",
                "first_added_by": user_id
            }
            if item_type == "monument":
                new_item_data["city"] = "Morocco"
            
            try:
                new_item = supabase.table(table).insert(new_item_data).execute()
                if not new_item.data or len(new_item.data) == 0:
                    raise HTTPException(status_code=500, detail="Failed to create item")
                item_id = new_item.data[0]["id"]
            except Exception as insert_error:
                print(f"Error inserting item: {str(insert_error)}")
                raise HTTPException(status_code=500, detail=f"Failed to create item: {str(insert_error)}")
        
        # Sauvegarder référence dans item_images
        try:
            image_insert = supabase.table("item_images").insert({
                "item_id": item_id,
                "item_type": item_type,
                "user_id": user_id,
                "image_url": public_url
            }).execute()
            if not image_insert.data:
                print("Warning: item_images insert returned no data, but may have succeeded")
        except Exception as img_error:
            print(f"Error inserting image reference: {str(img_error)}")
            # Ne pas échouer complètement si l'image est uploadée mais la référence échoue
            # L'image est déjà dans le storage
            pass
        
        return {
            "status": "success",
            "image_url": public_url,
            "item_id": item_id
        }
    except HTTPException:
        raise
    except Exception as e:
        print(f"Upload photo error: {str(e)}")
        import traceback
        traceback.print_exc()
        raise HTTPException(status_code=500, detail=f"Upload failed: {str(e)}")

# --- TRIP MANAGEMENT ENDPOINTS ---

class SaveTripRequest(BaseModel):
    user_id: str
    city: str
    duration: int
    itinerary_json: dict

@app.post("/save-trip")
async def save_trip(req: SaveTripRequest):
    """Sauvegarder un itinéraire"""
    try:
        print(f"Received trip data: {req.dict()}")  # Debug
        
        # Vérifier que user_id est valide (UUID)
        if not req.user_id or len(req.user_id) < 10:
            raise HTTPException(status_code=400, detail="Invalid user_id")
        
        result = supabase.table('user_trips').insert({
            'user_id': req.user_id,
            'city': req.city,
            'duration': req.duration,
            'itinerary_json': req.itinerary_json
        }).execute()
        
        if not result.data or len(result.data) == 0:
            raise HTTPException(status_code=500, detail="Failed to save trip: no data returned")
        
        return {
            "status": "success",
            "trip_id": result.data[0]['id']
        }
    except HTTPException:
        raise
    except Exception as e:
        error_msg = str(e)
        print(f"Error saving trip: {error_msg}")  # Debug
        import traceback
        traceback.print_exc()
        
        # Vérifier si c'est une erreur RLS
        if "row-level security" in error_msg.lower() or "42501" in error_msg:
            raise HTTPException(
                status_code=500, 
                detail="Permission denied. Please ensure the backend is using the service role key."
            )
        raise HTTPException(status_code=500, detail=f"Failed to save trip: {error_msg}")

@app.get("/my-trips/{user_id}")
async def get_my_trips(user_id: str):
    """Récupérer tous les trips d'un utilisateur"""
    try:
        result = supabase.table('user_trips')\
            .select('*')\
            .eq('user_id', user_id)\
            .order('created_at', desc=True)\
            .execute()
        
        return {
            "status": "success",
            "trips": result.data
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.delete("/trip/{trip_id}")
async def delete_trip(trip_id: str):
    """Supprimer un trip"""
    try:
        supabase.table('user_trips').delete().eq('id', trip_id).execute()
        return {"status": "success"}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
=======
    return FileResponse("template/index.html")
>>>>>>> a3ee2d642313047e3104f22ed8ad1d795e967dcc
