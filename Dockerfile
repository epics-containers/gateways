FROM python:3.11

RUN python -mvenv /venv
ENV PATH=/venv/bin:$PATH

# don't use numpy 2.0 yet, pin to latest 1.x version
RUN pip install numpy=1.26.4 p4p nose2

