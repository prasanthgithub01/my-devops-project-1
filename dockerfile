# Use a base image with Java and Maven installed
FROM maven:3.8.4-openjdk-11 AS build

# Set working directory
WORKDIR /app

# Copy Maven dependencies file
COPY pom.xml .

# Download dependencies if any changes
RUN mvn dependency:go-offline -B

# Copy source code
COPY src ./src

# Build the application
RUN mvn package -DskipTests

# Use a lightweight Java runtime
FROM openjdk:11-jre-slim

# Set working directory
WORKDIR /app

# Copy built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Expose the port
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "app.jar"]
