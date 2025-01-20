FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod /app

RUN go mod download

RUN . /app

RUN go build -o main .

# final stage with Distroless image

FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=builder /app/main .

COPY --from=builder /app/static ./static

EXPOSE 8080:80

CMD ["./main"]