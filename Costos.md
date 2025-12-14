# E-COMMERCE INFRAESTRUCTURA AWS - ANALISIS DE COSTOS

Para la siguiente arquitectura planteada de la solución e-commerce en AWS se asumen los siguientes datos con el fin de realizar la estimación de costos en la arquitectura AWS

![Alt text](/arquitectura.png)

La arquitectura prioriza servicios serverless para que el costo escale de forma proporcional al uso real.

Supuestos:

1 ambiente (dev o prod), Región us-east-1


**Usuarios** 

* Promedio: 300–500 
* Pico: 3,000 
* Usuarios mensuales activos: 50,000 


**Trafico** 

* Promedio: 5 millones / mes

Distribución del contenido:

* 60–70% contenido estático (S3 Hosting static)

* 30–40% llamadas dinámicas (API / backend)

**Frontend**

* CloudFront, Cache hit ratio esperado: 70–85%

**Backend**

* API Gateway requests: 2 millones / mes

* Lambda backend: 1 millón / mes

* ECS Fargate backend: Menor trafico

**Datos**

* DynamoDB: alta lectura y baja escritura. Uso de DAX para cache, 500mil reads, 2 Millones writes

* Aurora: Bajo volumen





