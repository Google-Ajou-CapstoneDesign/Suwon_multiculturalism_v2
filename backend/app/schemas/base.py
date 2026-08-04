from pydantic import BaseModel, ConfigDict
from pydantic.alias_generators import to_camel


class CamelModel(BaseModel):
    """Python은 snake_case, JSON은 camelCase — Flutter의 AiResponse 등과 필드명을 맞춘다."""

    model_config = ConfigDict(alias_generator=to_camel, populate_by_name=True)
