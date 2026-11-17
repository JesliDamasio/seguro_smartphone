
from decimal import Decimal

from sqlalchemy import String, ForeignKey, Numeric, CheckConstraint
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class ModeloAparelho(Base):
    __tablename__ = "modelo_aparelho"

    __table_args__ = (
        CheckConstraint(
            "vl_mercado_referencia > 0",
            name="ck_modelo_valor_positivo"
        ),
    )

    cd_modelo: Mapped[int] = mapped_column(
        mssql.SMALLINT,
        primary_key=True,
        autoincrement=True
    )

    cd_fabricante: Mapped[int] = mapped_column(
        mssql.TINYINT,
        ForeignKey("fabricante.cd_fabricante"),
        nullable=False
    )

    nm_modelo: Mapped[str] = mapped_column(
        String(80),
        nullable=False
    )

    vl_mercado_referencia: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False
    )

    fabricante = relationship(
        "Fabricante",
        back_populates="modelos"
    )

    aparelhos = relationship(
        "AparelhoSegurado",
        back_populates="modelo"
    )
