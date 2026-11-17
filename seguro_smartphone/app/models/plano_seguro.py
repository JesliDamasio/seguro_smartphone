
from sqlalchemy import String, Numeric, CheckConstraint, text
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class PlanoSeguro(Base):
    __tablename__ = "plano_seguro"

    __table_args__ = (
        CheckConstraint(
            "pc_franquia >= 0 AND pc_franquia <= 100",
            name="ck_plano_percentual_franquia"
        ),
    )

    cd_plano: Mapped[int] = mapped_column(
        mssql.TINYINT,
        primary_key=True,
        autoincrement=True
    )

    nm_plano: Mapped[str] = mapped_column(
        String(50),
        nullable=False
    )

    ds_descricao: Mapped[str] = mapped_column(
        String(200),
        nullable=False
    )

    pc_franquia: Mapped[float] = mapped_column(
        Numeric(5, 2),
        nullable=False,
        server_default=text("15.00")
    )

    fl_ativo: Mapped[bool] = mapped_column(
        mssql.BIT,
        nullable=False,
        server_default=text("1")
    )

    coberturas = relationship(
        "PlanoCobertura",
        back_populates="plano"
    )

    apolices = relationship(
        "Apolice",
        back_populates="plano"
    )
