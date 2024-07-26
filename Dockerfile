FROM python:3.11-slim as common

ENV PATH=/venv/bin:$PATH

FROM python:3.11 as install

RUN python -mvenv /venv
ENV PATH=/venv/bin:$PATH

COPY requirements.txt .
RUN pip install -r requirements.txt

FROM common as debug

RUN apt update && apt install -y net-tools tcpdump iproute2 iputils-ping vim
COPY --from=install /venv /venv

ENTRYPOINT [ "bash" ]

FROM common as runtime

COPY --from=install /venv /venv

ENTRYPOINT [ "bash" ]
