
from sqlalchemy import String, CHAR, text
from sqlalchemy.dialects import mssql
from sqlalchemy.orm import Mapped, mapped_column, relationship

from app.database.base import Base


class AssistenciaTecnica(Base):
    __tablename__ = "assistencia_tecnica"

    cd_assistencia: Mapped[int] = mapped_column(
        mssql.SMALLINT,
        primary_key=True,
        autoincrement=True
    )

    nm_razao_social: Mapped[str] = mapped_column(
        String(120),
        nullable=False
    )

    nr_cnpj: Mapped[str] = mapped_column(
        CHAR(14),
        nullable=False,
        unique=True
    )

    nr_telefone: Mapped[str] = mapped_column(
        String(15),
        nullable=False
    )

    ds_cidade: Mapped[str] = mapped_column(
        String(60),
        nullable=False
    )

    sg_uf: Mapped[str] = mapped_column(
        CHAR(2),
        nullable=False
    )

    fl_ativa: Mapped[bool] = mapped_column(
        mssql.BIT,
        nullable=False,
        server_default=text("1")
    )

    sinistros = relationship(
        "Sinistro",
        back_populates="assistencia"
    )
