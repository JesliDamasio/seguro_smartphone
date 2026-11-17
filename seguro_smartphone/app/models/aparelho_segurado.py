
from datetime import date
from decimal import Decimal

from sqlalchemy import (
    String,
    CHAR,
    Date,
    ForeignKey,
    Numeric,
    CheckConstraint,
    Index
)
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class AparelhoSegurado(Base):
    __tablename__ = "aparelho_segurado"

    __table_args__ = (
        CheckConstraint(
            "vl_nota_fiscal > 0",
            name="ck_aparelho_valor_nota"
        ),
        Index(
            "idx_aparelho_modelo",
            "cd_modelo"
        ),
    )

    cd_aparelho: Mapped[int] = mapped_column(
        primary_key=True,
        autoincrement=True
    )

    cd_cliente: Mapped[int] = mapped_column(
        ForeignKey("cliente.cd_cliente"),
        nullable=False
    )

    cd_modelo: Mapped[int] = mapped_column(
        ForeignKey("modelo_aparelho.cd_modelo"),
        nullable=False
    )

    nr_imei: Mapped[str] = mapped_column(
        CHAR(15),
        nullable=False,
        unique=True
    )

    nr_serie: Mapped[str | None] = mapped_column(
        String(30),
        nullable=True
    )

    dt_aquisicao: Mapped[date] = mapped_column(
        Date,
        nullable=False
    )

    vl_nota_fiscal: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False
    )

    cliente = relationship(
        "Cliente",
        back_populates="aparelhos"
    )

    modelo = relationship(
        "ModeloAparelho",
        back_populates="aparelhos"
    )
