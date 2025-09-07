Shiksha.ai 📘

Your Intelligent NCERT Learning Partner | RAG + LLM

Shiksha.ai is an AI-powered NCERT chatbot built with Retrieval-Augmented Generation (RAG) and LLMs. It provides accurate, contextual, and interactive learning support for students.

🚀 Features

RAG pipeline with LangChain + Hugging Face

Pinecone Vector DB for scalable search

FastAPI backend with SQLite & REST APIs

Role-based authentication (student, teacher, admin)

Dynamic prompt engineering with RunnablePassthrough

🏗️ Tech Stack

Backend: FastAPI, SQLite

AI/ML: LangChain, Hugging Face, Pinecone

Auth & APIs: RESTful API, JWT

⚙️ Setup
# Clone repo
git clone https://github.com/your-username/shiksha-ai.git
cd shiksha-ai

# Create venv
python -m venv venv
source venv/bin/activate   # Mac/Linux
venv\Scripts\activate      # Windows

# Install deps
pip install -r requirements.txt


Create .env file:

PINECONE_API_KEY=your_pinecone_api_key
HUGGINGFACE_API_KEY=your_hf_api_key
SECRET_KEY=your_auth_secret


Run server:

uvicorn backend.main:app --reload


API Docs → http://127.0.0.1:8000/docs

📖 Example

Request

{ "query": "Explain photosynthesis for Class 7", "user_role": "student" }


Response

{ "answer": "Photosynthesis is the process by which green plants make food using sunlight, water, and carbon dioxide..." }

📌 Roadmap

 React-based frontend

 Multi-language support

 Adaptive quizzes
