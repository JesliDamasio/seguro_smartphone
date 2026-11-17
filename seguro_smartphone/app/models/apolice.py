
from datetime import date, datetime
from decimal import Decimal

from sqlalchemy import (
    ForeignKey,
    Date,
    DateTime,
    Numeric,
    CheckConstraint,
    Index,
    text,
    func
)
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class Apolice(Base):
    __tablename__ = "apolice"

    __table_args__ = (
        CheckConstraint(
            "dt_fim_vigencia > dt_inicio_vigencia",
            name="ck_apolice_vigencia"
        ),
        CheckConstraint(
            "vl_premio_total > 0",
            name="ck_apolice_premio"
        ),
        Index("idx_apolice_plano", "cd_plano"),
        Index(
            "idx_apolice_status_aparelho",
            "st_apolice",
            "cd_aparelho"
        ),
    )

    cd_apolice: Mapped[int] = mapped_column(
        primary_key=True,
        autoincrement=True
    )

    cd_cliente: Mapped[int] = mapped_column(
        ForeignKey("cliente.cd_cliente"),
        nullable=False
    )

    cd_aparelho: Mapped[int] = mapped_column(
        ForeignKey("aparelho_segurado.cd_aparelho"),
        nullable=False
    )

    cd_plano: Mapped[int] = mapped_column(
        mssql.TINYINT,
        ForeignKey("plano_seguro.cd_plano"),
        nullable=False
    )

    dt_emissao: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.getdate()
    )

    dt_inicio_vigencia: Mapped[date] = mapped_column(
        Date,
        nullable=False
    )

    dt_fim_vigencia: Mapped[date] = mapped_column(
        Date,
        nullable=False
    )

    vl_franquia: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False,
        server_default=text("0.00")
    )

    vl_premio_total: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False
    )

    st_apolice: Mapped[int] = mapped_column(
        mssql.TINYINT,
        nullable=False,
        server_default=text("1")
    )

    plano = relationship(
        "PlanoSeguro",
        back_populates="apolices"
    )

    parcelas = relationship(
        "ParcelaApolice",
        back_populates="apolice"
    )

    sinistros = relationship(
        "Sinistro",
        back_populates="apolice"
    )

    cliente = relationship("Cliente")

    aparelho = relationship("AparelhoSegurado")
