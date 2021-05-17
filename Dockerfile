# --------------> Imagem base
FROM node:current-alpine AS base
WORKDIR /usr/src/app
COPY package-*.json /usr/src/app/
COPY --chown=node:node . /usr/src/app
EXPOSE 3000

# --------------> Imagem de produção
FROM base as production
ENV NODE_ENV production
RUN apk add dumb-init && npm install -g pm2 
USER node
WORKDIR /usr/src/app

# --------------> O arquivo index.js é de acordo com seu arquivo
CMD ["dumb-init", "npm run start"]

# --------------> Imagem de desenvolvimento
FROM base as dev
ENV NODE_ENV=development
RUN npm i -g @nestjs/cli && npm install npm@latest -g && npm install
COPY . /
CMD ["nodemon", "usr/src/app"]
