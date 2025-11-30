FROM node:12-alpine
# FROM node:20.19.6-alpine

# Install Python, make, g++, and other build tools
# RUN apk add --no-cache \
#     python3 \
#     make \
#     g++ \
#     git

# Set environment variable to use pre-built binaries when possible
# ENV SASS_BINARY_SITE=https://github.com/sass/node-sass/releases/download/v4.14.1/

WORKDIR /app

COPY package*.json ./
# RUN npm install -g pnpm
RUN npm install

COPY . .
RUN npm run build

FROM nginx:alpine
COPY --from=0 /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]