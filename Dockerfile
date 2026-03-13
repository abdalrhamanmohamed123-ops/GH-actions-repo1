# STAGE 1: The "Heavy" Golang Machine
FROM golang:1.22-alpine AS builder
WORKDIR /build
COPY go.mod ./
# Copy the src folder into the builder
COPY src/ ./src/
# Compile into a static binary named 'myapp'
RUN CGO_ENABLED=0 GOOS=linux go build -o myapp ./src/main.go

# STAGE 2: The "Lightweight" Alpine Machine
FROM alpine:3.19
# Create our non-root user (RHCSA Style)
RUN adduser -D appuser
WORKDIR /app
# COPY only the final binary (The Shrink-Ray result)
COPY --from=builder /build/myapp .
# Secure the file and switch user
RUN chmod +x ./myapp
USER appuser
# Run the binary
CMD ["./myapp"]