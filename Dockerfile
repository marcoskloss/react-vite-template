# setup react app
FROM node:16-alpine as builder

ARG HOME=/home/app
ARG APP_NAME=react-template

COPY package.json package-lock.json $HOME/$APP_NAME/
WORKDIR $HOME/$APP_NAME
RUN npm ci --progress=false
COPY . $HOME/$APP_NAME
RUN npm run build

# setup ngnix
FROM nginx:1.21.0-alpine

ENV NODE_ENV production
ARG HOME=/home/app
ARG APP_NAME=react-template

COPY --from=builder $HOME/$APP_NAME/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
