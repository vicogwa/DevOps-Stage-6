FROM node:14 AS build
WORKDIR /app

COPY package.json package-lock.json ./
RUN rm -f package-lock.json && npm install --legacy-peer-deps
COPY . .
RUN npm run build

FROM node:16-alpine
WORKDIR /app
RUN npm install -g http-server
COPY --from=build /app/dist ./dist
EXPOSE 80
CMD ["http-server", "./dist", "-p", "80"]
