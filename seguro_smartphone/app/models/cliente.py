
from datetime import date, datetime

from sqlalchemy import String, CHAR, Date, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class Cliente(Base):
    __tablename__ = "cliente"

    cd_cliente: Mapped[int] = mapped_column(
        primary_key=True,
        autoincrement=True
    )

    nm_cliente: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )

    nr_cpf: Mapped[str] = mapped_column(
        CHAR(11),
        nullable=False,
        unique=True
    )

    ds_email: Mapped[str] = mapped_column(
        String(100),
        nullable=False
    )

    nr_telefone: Mapped[str] = mapped_column(
        String(15),
        nullable=False
    )

    dt_nascimento: Mapped[date] = mapped_column(
        Date,
        nullable=False
    )

    dt_cadastro: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.getdate()
    )

    # Relacionamento: Cliente possui vários aparelhos
    aparelhos = relationship(
        "AparelhoSegurado",
        back_populates="cliente"
    )
