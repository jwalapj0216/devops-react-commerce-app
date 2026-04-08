FROM node:18-alpine

RUN npm install -g server

WORKDIR /app

COPY build ./build

EXPOSE 3000

CMD ["server", "-s", "build", "-l", "3000"]
