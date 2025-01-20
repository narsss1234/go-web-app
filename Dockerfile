FROM golang:1.22 AS builder

WORKDIR /app

COPY go.mod /app

RUN go mod download

COPY . /app

RUN go build -o main .

# final stage with Distroless image

FROM gcr.io/distroless/base

WORKDIR /app

COPY --from=builder /app/main .

COPY --from=builder /app/static ./static

EXPOSE 80:8080

CMD ["./main"]