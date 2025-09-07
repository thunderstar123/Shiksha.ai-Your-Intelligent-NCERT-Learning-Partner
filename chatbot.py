
from langchain.text_splitter import CharacterTextSplitter
from langchain_community.document_loaders import TextLoader
from langchain_community.embeddings import HuggingFaceEmbeddings
from langchain_community.vectorstores import Pinecone
from pinecone import Pinecone as PineconeClient, ServerlessSpec 
from langchain_community.llms import HuggingFaceHub
from langchain_core.prompts import PromptTemplate
from langchain.schema.runnable import RunnablePassthrough
from langchain.schema.output_parser import StrOutputParser
from dotenv import load_dotenv
load_dotenv()
import os
#print(dir(Pinecone))
class ChatBot:
    def __init__(self):
        # Create Pinecone client instance and initialize it
        self.pinecone_client = PineconeClient(
            api_key=os.getenv('PINECONE_API_KEY'),
            environment='gcp-starter'
        )

        self.index_name = "plantchatbot"

        text_dir = '/home/harshitha/Downloads/gesc1dd/'  # Update to the directory containing your text files
        all_documents = []

        # Load and concatenate all text files from the directory
        for filename in os.listdir(text_dir):
            if filename.endswith(".txt"):  # Filter only .txt files
                file_path = os.path.join(text_dir, filename)
                loader = TextLoader(file_path)
                documents = loader.load()
                print(filename)
                all_documents.extend(documents)
        text_splitter = CharacterTextSplitter(chunk_size=1000, chunk_overlap=4)
        docs = text_splitter.split_documents(all_documents)
       # print("Harhsitha")
        # Initialize embeddings and vector store
        embeddings = HuggingFaceEmbeddings(model_name="sentence-transformers/all-MiniLM-L6-v2")

        self.docsearch = Pinecone.from_documents(docs, embeddings, index_name=self.index_name)

        # Initialize LLM
        repo_id = "mistralai/Mixtral-8x7B-Instruct-v0.1"
        self.llm = HuggingFaceHub(
            repo_id=repo_id,
            model_kwargs={"temperature": 0.8, "top_k": 50},
            huggingfacehub_api_token=os.getenv('HUGGINGFACE_API_KEY')
        )

        # Define the prompt
        template = """
        You are an educational purpose chatbot, you will be asked questions related to science and you need to answer them.

        Context: {context}
        Question: {question}
        Answer: 
        """

        prompt = PromptTemplate(
            template=template,
            input_variables=["context", "question"]
        )

        # Create the RAG chain
        self.rag_chain = (
            {"context": self.docsearch.as_retriever(), "question": RunnablePassthrough()}
            | prompt
            | self.llm
            | StrOutputParser()
        )

    def get_response(self, query):
        answer = self.rag_chain.invoke(query).split("Answer:")[1].strip()  # Extract the part after "Answer:" and remove extra spaces
        return answer