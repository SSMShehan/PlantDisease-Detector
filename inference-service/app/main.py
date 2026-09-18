from fastapi import FastAPI, File, UploadFile, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from typing import Dict, Any

app = FastAPI(title="CropGuard Inference", version="1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.post("/predict")
async def predict(file: UploadFile = File(...)) -> Dict[str, Any]:
    # TODO: Implement actual TFLite/Keras inference here
    # This is a mock response matching the data contract
    if file.content_type not in ("image/jpeg", "image/png"):
        raise HTTPException(415, "JPEG or PNG only")
    
    return {
        "label": "Tomato_Early_blight",
        "confidence": 0.85,
        "top_3": [
            {"label": "Tomato_Early_blight", "confidence": 0.85},
            {"label": "Tomato_Late_blight", "confidence": 0.10},
            {"label": "Healthy", "confidence": 0.05}
        ]
    }
