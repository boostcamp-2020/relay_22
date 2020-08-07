FROM	ubuntu

RUN		apt update && apt install -y \
		python3 \
		python3-pip \
		curl \
		git
RUN		pip3 install \
		flask \
		konlpy \
		pandas
RUN		curl -s https://raw.githubusercontent.com/konlpy/konlpy/master/scripts/mecab.sh | bash

EXPOSE 5000

COPY srcs/main.py .
CMD python3 main.py
