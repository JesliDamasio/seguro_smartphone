
from datetime import datetime

from sqlalchemy import (
    ForeignKey,
    DateTime,
    String,
    text,
    func
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class HistoricoSinistro(Base):
    __tablename__ = "historico_sinistro"

    cd_historico: Mapped[int] = mapped_column(
        primary_key=True,
        autoincrement=True
    )

    cd_sinistro: Mapped[int] = mapped_column(
        ForeignKey("sinistro.cd_sinistro"),
        nullable=False
    )

    st_anterior: Mapped[int] = mapped_column(
        nullable=False
    )

    st_novo: Mapped[int] = mapped_column(
        nullable=False
    )

    dt_mudanca: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.getdate()
    )

    ds_usuario: Mapped[str] = mapped_column(
        String(50),
        nullable=False,
        server_default=func.suser_name()
    )

    sinistro = relationship(
        "Sinistro",
        back_populates="historicos"
    )
