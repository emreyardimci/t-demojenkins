# Runtime image (Java 17)
FROM  registry.access.redhat.com/ubi8/openjdk-17-runtime:latest

WORKDIR /app

# Jenkins/Maven build çıktısı: target/*.jar
# (artifactId/version değişse bile yakalar)
COPY app/target/*.jar /app/app.jar

# Uygulama sadece stdout'a yazıyorsa port gerekmez.
# Eğer ileride web app olursa açabilirsin:
# EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]
