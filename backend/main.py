from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from database import SessionLocal, engine, get_db
import models, schemas, crud
from ai_service import generate_polished_entry
from auth import verify_password, hash_password, create_access_token
from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session


models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="AID-AIDiary Backend")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/")
def read_root():
    return {"message": "Welcome to the AID-AIDiary API"}

# --- Journal Entry Endpoints ---

@app.get("/api/entries", response_model=list[schemas.JournalEntry])
def read_entries(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    entries = crud.get_entries(db, skip=skip, limit=limit)
    return entries

@app.post("/api/entries", response_model=schemas.JournalEntry)
def create_entry(entry: schemas.JournalEntryCreate, db: Session = Depends(get_db)):
    return crud.create_entry(db=db, entry=entry)

@app.get("/api/entries/{entry_id}", response_model=schemas.JournalEntry)
def read_entry(entry_id: int, db: Session = Depends(get_db)):
    db_entry = crud.get_entry(db, entry_id=entry_id)
    if db_entry is None:
        raise HTTPException(status_code=404, detail="Entry not found")
    return db_entry

@app.put("/api/entries/{entry_id}", response_model=schemas.JournalEntry)
def update_entry(entry_id: int, entry: schemas.JournalEntryUpdate, db: Session = Depends(get_db)):
    db_entry = crud.update_entry(db, entry_id=entry_id, entry=entry)
    if db_entry is None:
        raise HTTPException(status_code=404, detail="Entry not found")
    return db_entry

@app.delete("/api/entries/{entry_id}")
def delete_entry(entry_id: int, db: Session = Depends(get_db)):
    db_entry = crud.delete_entry(db, entry_id=entry_id)
    if db_entry is None:
        raise HTTPException(status_code=404, detail="Entry not found")
    return db_entry

@app.post("/api/ai/polish", response_model=schemas.AIPolishResponse)
async def ai_polish(request: schemas.AIPolishRequest):
    result = await generate_polished_entry(request.content)
    return result

# --- Auth Endpoints ---

@app.post("/api/auth/register", response_model=schemas.TokenResponse)
def register(data: schemas.UserRegister, db: Session = Depends(get_db)):
    existing = db.query(models.User).filter(models.User.username == data.username).first()
    if existing:
        raise HTTPException(status_code=400, detail="Username already taken")
    user = models.User(
        username=data.username,
        email=data.email,
        hashed_password=hash_password(data.password)
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    token = create_access_token({"sub": str(user.id), "username": user.username})
    return {"access_token": token, "token_type": "bearer", "user": user}

@app.post("/api/auth/login", response_model=schemas.TokenResponse)
def login(data: schemas.UserLogin, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.username == data.username).first()
    if not user or not verify_password(data.password, user.hashed_password):
        raise HTTPException(status_code=401, detail="Invalid username or password")
    token = create_access_token({"sub": str(user.id), "username": user.username})
    return {"access_token": token, "token_type": "bearer", "user": user}
