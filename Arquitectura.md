# E-COMMERCE INFRAESTRUCTURA AWS

Se explica la arquitectura general planteada para la solución e-commerce en AWS. 

![Alt text](/arquitectura.png)

La arquitectura se divide en 3 capas: Frontend, backend y datos. 

**Capa Frontend**

Los usuarios acceden a la pagina web del ecommerce por medio de un dominio que Route53 proporciona. Desde allí se puede gestionar tambien la adquisición del domain name. Este servicio ademas puede proporcionar capacidades de health checks para failover. 

La solicitud de los clientes es dirigida a Cloudfront para proveer un servicio de entrega de contenido altamente escalable con alcance global. Ademas respaldado por un servicio WAF que protege contra ataques comunes en paginas web. 

Una ventaja de cloudfront es que permite redirigir el trafico a distintos origenes. Se plantea que una parte del frontend esta en hosting statico de S3 para imagenes, fuentes, HTML, entre otras. Mientras que el frontend dinamico se desarrolla en una aplicación dockerizada que se despliega en ECS Fargate. Proporcionando alta escalabilidad con el balanceador de cargas. 

**Capa Backend**

Para el backend se realiza una arquitectura basada en APIs usando el servicio API gateway. Ya que la aplicación de e-commerce permite login de usuarios se realiza con cognito user pools. API gateway redirige las solicitudes a la logica del backend según la ruta indicada por el frontend. 

Se tienen 2 alternativas de desarrollo de logica para el backend. Multiples lambdas para ejecuciones puntuales, y servicios dockerizados soportados en ECS proporcionando alta disponibilidad con ALB. 

Estas aplicaciones usan secret manager para manejar token y datos sensibles como accesos a servicios de terceros. 

Tambien se plantea el uso de SQS para desacoplar funciones que requieran manejo de eventos. 

**Capa Backend**

Para la capa de datos se tienen 2 tipos de bases de datos. DynamoDB, no relacional, para acceso rapido y sin relaciones complejas. Con este servicio se usa DynamoDB Accelerator (DAX) proporcionando así caching. Tambien para operaciones mas complejas se plantea el uso de Aurora. 

** **

**CARACTERISTICAS**

**Observabilidad**

La observabilidad es transversal a todas las capas y servicios. Para esto se usa el servicio de cloudwatch y todas sus funcionalidades: Logs, metricas, eventos y alarmas. Tambien se tiene la opción de usar x-ray para rastrear las conexciones entre microservicios. 

**Alta disponibilidad, rendimiento y gestión**

La infraestructura en general minimiza los servicios que requieren alta administración como instancias o bases de datos tradicionales. Se basa principalmente en servicios serverless lo que provee de manera nativa alta disponibiidad incluso en picos de uso. 

**Seguridad**
Ademas del uso de servicios como AWS WAF para la parte del frontend, la arquitectura permita separar entornos publicos de privados por medio de distintas subredes, usando privadas para la logica del backend. Tambien se usan los roles de las lambdas y de los task para asignar permisos de acceso a las DB. La información confidencial se maneja en secret manager. 


** **

**CONTEXTO**
Para poner en contexto los servicios con las ejecuciones reales del web e-commerce se plantea el siguiente diagrama, cada uno es un paso posible que se ejecuta dentro del e-commerce y los servicios AWS que soportan las acciones. De esta manera se justifican algunas decisiones de infraestructura, especialmente el back y la DB. 


* Lambda + DynamoDB -- Catálogo, Carrito, Sesiones

* ECS + Aurora -- Órdenes, Pagos, Operaciones complejas

![Alt text](/contexto.png)