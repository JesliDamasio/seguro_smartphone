
from sqlalchemy import String
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class Fabricante(Base):
    __tablename__ = "fabricante"

    cd_fabricante: Mapped[int] = mapped_column(
        mssql.TINYINT,
        primary_key=True,
        autoincrement=True
    )

    nm_fabricante: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        unique=True
    )

    modelos = relationship(
        "ModeloAparelho",
        back_populates="fabricante"
    )
