
from datetime import datetime
from decimal import Decimal

from sqlalchemy import (
    ForeignKey,
    DateTime,
    String,
    Numeric,
    CheckConstraint,
    Index,
    text,
    func
)
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class Sinistro(Base):
    __tablename__ = "sinistro"

    __table_args__ = (
        CheckConstraint(
            "vl_prejuizo_estimado >= 0",
            name="ck_sinistro_prejuizo"
        ),
        CheckConstraint(
            "vl_franquia_paga >= 0",
            name="ck_sinistro_franquia"
        ),
        Index(
            "idx_sinistro_data_apolice",
            "dt_ocorrencia",
            "cd_apolice"
        ),
        Index(
            "idx_sinistro_assistencia_status",
            "cd_assistencia",
            "st_sinistro"
        ),
        Index(
            "idx_sinistro_apolice_data",
            "cd_apolice",
            "dt_ocorrencia"
        ),
    )

    cd_sinistro: Mapped[int] = mapped_column(
        primary_key=True,
        autoincrement=True
    )

    cd_apolice: Mapped[int] = mapped_column(
        ForeignKey("apolice.cd_apolice"),
        nullable=False
    )

    cd_cobertura: Mapped[int] = mapped_column(
        mssql.TINYINT,
        ForeignKey("cobertura.cd_cobertura"),
        nullable=False
    )

    cd_assistencia: Mapped[int | None] = mapped_column(
        mssql.SMALLINT,
        ForeignKey("assistencia_tecnica.cd_assistencia"),
        nullable=True
    )

    dt_ocorrencia: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False
    )

    dt_aviso: Mapped[datetime] = mapped_column(
        DateTime,
        nullable=False,
        server_default=func.getdate()
    )

    ds_relato_ocorrencia: Mapped[str] = mapped_column(
        String(1000),
        nullable=False
    )

    vl_prejuizo_estimado: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False
    )

    vl_franquia_paga: Mapped[Decimal] = mapped_column(
        Numeric(10, 2),
        nullable=False,
        server_default=text("0.00")
    )

    st_sinistro: Mapped[int] = mapped_column(
        mssql.TINYINT,
        nullable=False,
        server_default=text("1")
    )

    apolice = relationship(
        "Apolice",
        back_populates="sinistros"
    )

    cobertura = relationship(
        "Cobertura",
        back_populates="sinistros"
    )

    assistencia = relationship(
        "AssistenciaTecnica",
        back_populates="sinistros"
    )

    historicos = relationship(
        "HistoricoSinistro",
        back_populates="sinistro"
    )
