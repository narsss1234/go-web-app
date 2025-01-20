# Containerize the Go application that the developer has created
# This is the Dockerfile that we will use to build the image and build the container

# Start with the base image of golang:1.22, which is required for the application
FROM golang:1.22 AS builder

# Set the working director inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod .

# Download all the dependencies
RUN go mod download

# Copy the source code to the working directory to start building the application
COPY . /app

# Build the application
RUN go build -o main .

############################

# Reduce the image size by creating multi-stage dockerfile
# We will use a distroless image to run the application
FROM gcr.io/distroless/base

# Set the working directory inside the container

# Copy the binary form the previous build stage
COPY --from=builder /app .

# Copy the static files from the previous stage
COPY --from=builder /app/static ./static

# Expose the port on which the application will run
EXPOSE 8080

# Command to run the application
CMD ["./main"]