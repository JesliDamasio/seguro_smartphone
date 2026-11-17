
from datetime import date
from decimal import Decimal

from sqlalchemy import (
    ForeignKey,
    Date,
    Numeric,
    CheckConstraint,
    Index,
    text
)
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class ParcelaApolice(Base):
    __tablename__ = "parcela_apolice"

    __table_args__ = (
        CheckConstraint(
            "nr_parcela BETWEEN 1 AND 12",
            name="ck_parcela_numero"
        ),
        CheckConstraint(
            "vl_parcela > 0",
            name="ck_parcela_valor"
        ),
        Index("idx_parcela_status", "st_pagamento"),
    )

    cd_parcela: Mapped[int] = mapped_column(
        primary_key=True,
        autoincrement=True
    )

    cd_apolice: Mapped[int] = mapped_column(
        ForeignKey("apolice.cd_apolice"),
        nullable=False
    )

    nr_parcela: Mapped[int] = mapped_column(
        mssql.TINYINT,
        nullable=False
    )

    dt_vencimento: Mapped[date] = mapped_column(
        Date,
        nullable=False
    )

    vl_parcela: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False
    )

    dt_pagamento: Mapped[date | None] = mapped_column(
        Date,
        nullable=True
    )

    st_pagamento: Mapped[int] = mapped_column(
        mssql.TINYINT,
        nullable=False,
        server_default=text("0")
    )

    apolice = relationship(
        "Apolice",
        back_populates="parcelas"
    )
