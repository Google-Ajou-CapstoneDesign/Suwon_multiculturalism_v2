from .base import CamelModel


class Org(CamelModel):
    name: str
    distance_km: float
