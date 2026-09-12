FROM node:16
WORKDIR /opt
COPY . /opt
RUN npm install
ARG PORT=3000
ENV PORT=$PORT
EXPOSE $PORT
ENTRYPOINT ["npm", "run", "start"]