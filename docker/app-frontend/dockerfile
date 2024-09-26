ARG BUILD_ENV="production"

FROM node:16.15.1 AS build

WORKDIR "/app"

RUN npm install -g @quasar/cli

COPY package.json ./
RUN npm install
COPY . .
RUN quasar build

FROM nginx:1.22.0-alpine AS prod-stage
COPY --from=build /app/dist/spa /usr/share/nginx/html
COPY docker/nginx/production/default.conf /etc/nginx/conf.d/default.conf
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
