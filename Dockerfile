# Environnement Linux identique au vrai exam 42 (gcc + libc + ncurses pour les couleurs).
FROM debian:bookworm-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc libc6-dev make ncurses-bin ncurses-base bash coreutils && \
    rm -rf /var/lib/apt/lists/*

ENV TERM=xterm-256color
WORKDIR /exam
CMD ["bash", "exam.sh"]
