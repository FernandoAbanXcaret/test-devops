FROM node:12 AS BUILDER
WORKDIR /app
COPY . .
ARG npm_token

RUN npm install --prod
RUN npm run build

FROM node:12-slim
ENV TZ=America/Cancun
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
WORKDIR /app
COPY --from=BUILDER /app .
EXPOSE 3000
CMD ["npm","run","start"]