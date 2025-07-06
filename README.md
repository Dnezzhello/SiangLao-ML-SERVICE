# SiangLao ML Service

Flask-based REST API service for Lao language Automatic Speech Recognition (ASR) using three pre-trained transformer models: XLS-R, XLSR-53, and HuBERT.

## Setup

### Prerequisites
- Python 3.8+
- Git LFS (for model files)

### Installation

1. **Clone repository**
```bash
git clone <your-repo-url>
cd sianglao-ml-service
```

2. **Install dependencies**
```bash
pip install -r requirements.txt
```

## Running the Service

### Normal Mode (16GB+ RAM)
```bash
python app.py
```

### Low Memory Mode (8GB RAM)
```bash
MEMORY_MODE=low_memory python app.py
```

Service runs on `http://localhost:8000`

## API Usage

### Endpoints
- `GET /` - Service information
- `GET /health` - Health check
- `GET /models` - Model information
- `POST /predict` - Transcribe with all models
- `POST /predict/<model_name>` - Transcribe with specific model

### Example
```bash
curl -X POST http://localhost:8000/predict \
  -F "audio=@your_audio_file.wav"
```

### Response
```json
{
  "success": true,
  "results": {
    "xls-r": {
      "prediction": "ສະບາຍດີ",
      "confidence": 0.95
    }
  }
}
```

## Authors

- **Souphaxay Naovalath**
- **Sounmy Chanthavong**

---

**Version**: 1.0.0