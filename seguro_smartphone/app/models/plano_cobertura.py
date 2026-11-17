
from decimal import Decimal

from sqlalchemy import (
    ForeignKey,
    Numeric,
    CheckConstraint
)
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class PlanoCobertura(Base):
    __tablename__ = "plano_cobertura"

    __table_args__ = (
        CheckConstraint(
            "vl_limite_indenizacao > 0",
            name="ck_plano_cobertura_limite"
        ),
    )

    cd_plano: Mapped[int] = mapped_column(
        mssql.TINYINT,
        ForeignKey("plano_seguro.cd_plano"),
        primary_key=True
    )

    cd_cobertura: Mapped[int] = mapped_column(
        mssql.TINYINT,
        ForeignKey("cobertura.cd_cobertura"),
        primary_key=True
    )

    vl_limite_indenizacao: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False
    )

    plano = relationship(
        "PlanoSeguro",
        back_populates="coberturas"
    )

    cobertura = relationship(
        "Cobertura",
        back_populates="planos"
    )
