
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

SERVER = r"DESKTOP-DN9F7KH\SQLEXPRESS"
DATABASE = "SeguroSmartphone"

CONFIG = {
    "driver": "ODBC Driver 18 for SQL Server",
    "trusted_connection": "yes",
    "TrustServerCertificate": "yes"
}

url_database = URL.create(
    "mssql+pyodbc",
    host=SERVER,
    database=DATABASE,
    query=CONFIG
)

engine = create_engine(
    url_database,
    echo=True,
    pool_pre_ping=True
)
