FROM node:20-alpine
WORKDIR /app
COPY reporter/package.json .
RUN npm install
COPY reporter/report.js .
CMD ["node", "report.js"]