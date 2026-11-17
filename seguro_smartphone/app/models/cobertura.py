
from sqlalchemy import String
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class Cobertura(Base):
    __tablename__ = "cobertura"

    cd_cobertura: Mapped[int] = mapped_column(
        mssql.TINYINT,
        primary_key=True,
        autoincrement=True
    )

    nm_cobertura: Mapped[str] = mapped_column(
        String(60),
        nullable=False
    )

    ds_cobertura: Mapped[str] = mapped_column(
        String(255),
        nullable=False
    )

    planos = relationship(
        "PlanoCobertura",
        back_populates="cobertura"
    )

    sinistros = relationship(
        "Sinistro",
        back_populates="cobertura"
    )
