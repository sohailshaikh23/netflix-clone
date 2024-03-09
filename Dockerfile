FROM node:16.17.0-alpine as builder     # base Alpine linux with inbuit NodeJs
WORKDIR /app
COPY ./package.json .
COPY ./yarn.lock .
RUN yarn install    					# yarn will install by using pakage.lock and yarn.lock
COPY . .
ARG TMDB_V3_API_KEY="315950affef9dfb21906da7c7abdb004"		#you can provide from CLI as well
ENV VITE_APP_TMDB_V3_API_KEY=${TMDB_V3_API_KEY}
ENV VITE_APP_API_ENDPOINT_URL="https://api.themoviedb.org/3"
RUN yarn build								# yarn will build the application in /app/dist/


FROM nginx:stable-alpine		#final stage base image
WORKDIR /usr/share/nginx/html		
RUN rm -rf ./*
COPY --from=builder /app/dist .  		#copy content from build to nginx
EXPOSE 80
ENTRYPOINT ["nginx", "-g", "daemon off;"] 		#running nginx in foreground