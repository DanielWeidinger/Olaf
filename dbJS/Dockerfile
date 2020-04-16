FROM node:10
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install 
RUN npm install mqtt
COPY . .
EXPOSE 9090
#CMD [ "node", "./httpClient/httpServer.js" ]