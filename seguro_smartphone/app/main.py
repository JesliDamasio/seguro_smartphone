
from fastapi import FastAPI, HTTPException
from sqlalchemy import text

from app.database.connection import engine


app = FastAPI(
    title="SeguroSmartphone API",
    description="API para gerenciamento do sistema de seguros de smartphones.",
    version="1.0.0"
)


@app.get("/")
def inicio():
    return {
        "mensagem": "API SeguroSmartphone funcionando!",
        "status": "online"
    }


@app.get("/health")
def verificar_conexao():
    try:
        with engine.connect() as connection:
            resultado = connection.execute(
                text("""
                    SELECT
                        @@SERVERNAME AS servidor,
                        DB_NAME() AS banco
                """)
            ).mappings().one()

            return {
                "status": "conectado",
                "servidor": resultado["servidor"],
                "banco": resultado["banco"]
            }

    except Exception as erro:
        raise HTTPException(
            status_code=503,
            detail=f"Erro na conexão com o banco: {str(erro)}"
        )
