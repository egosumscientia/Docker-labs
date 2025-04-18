# Stage 1: Build
FROM golang:1.21 AS builder
WORKDIR /app
COPY . .
RUN go build -o app

# Stage 2: Final lightweight
FROM alpine:latest
COPY --from=builder /app/app /app
CMD ["/app"]
