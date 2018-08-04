FROM node:10.8.0-alpine as node-builder
LABEL builder=true
RUN mkdir -p /root/app/public /root/app/src/front
WORKDIR /root/app
ADD package.json .
ADD package-lock.json .
ADD webpack.config.js .
ADD src/front src/front
ADD public/index.html public
RUN npm install
RUN npm run build:front

FROM durosoft/crystal-alpine:0.25.0 as crystal-builder
LABEL builder=true
RUN mkdir -p /root/app/src/back
WORKDIR /root/app
ADD shard.yml .
ADD shard.lock .
ADD src/back/neverorange.cr src/back
RUN shards install
RUN crystal build src/back/neverorange.cr --release --static --no-debug

FROM alpine:3.6
WORKDIR /root
RUN mkdir public
COPY --from=node-builder /root/app/public public
COPY --from=crystal-builder /root/app/neverorange .
EXPOSE 4000
CMD ["./neverorange"]

