from .base import CamelModel


class UploadResponse(CamelModel):
    file_id: str
    stored_path: str
    content_type: str
    size_bytes: int
