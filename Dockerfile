FROM python:3.11

RUN python -mvenv /venv
ENV PATH=/venv/bin:$PATH

COPY requirements.txt .
RUN pip install -r requirements.txt

ENTRYPOINT [ "bash" ]
