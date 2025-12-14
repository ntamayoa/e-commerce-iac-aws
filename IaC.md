# E-COMMERCE INFRAESTRUCTURA AWS - IaC

El repositorio actual contiene la arquitectura planteada en Arquitectura.md en infraestructura como codigo basado en terraform. 

La solución tiene la siguiente estructura: 

```md
.github
├── workflows/
│   ├── terraform-infra.yml
_CloudOps
├── env/
│   ├── dev
│   ├── prod
|   modules/
|   ├── backend/
|   ├── frontend/
|   ├── network/
|   ├── data/
Backend-repo
Frontend-repo
```

El folder "_CloudOps" representa como tal las funciones CloudOps de infraestructura, mientras que "Backend-repo" y "Frontend-repo" simulan lo que serian los repositorios especificos de los desarrolladores backend y frontend respectivamente. 

** **
Se modulariza la aplicación en las capas correspondientes, ademas de un modulo util y transversal a todas como lo es network.

**Network**

Despliegue de VPC y subnet publicas y privadas (separa front de back)

**Frontend**
Para mayor modularización se segrega en cdn (incluido dns) y en app.

en cdn se despliega Route53 como DNS y Cloudfront como CDN. ademas de incluir WAF. 
Para producción se requeria ademas ser dueño del dominio que se usara para el hosted zone. 

en app se despliega el bucket de s3 que tendra el hosting estatico, ademas de ECS cluster para el contenido dinamico junto con su ALB. 

**Backend**

Despliega multiples servicios, entre ellos API Gateway, ALB + ECS, Lambda. Cognito user pools para conexión con login y api gateway, ademas de secrets manager. 
No despliega SQS. Queda para desarrollos posteriores una vez se tenga clara la necesidad de la aplicación. 

**Data**

Modulo que despliega actualmente dybamoDB como database, se deja planteado aurora y dax para caching. 
Como alternativa de caching en aurora esta ElastiCache. 


** **


**Pipeline CI/CD**

Para el pipeline CI/CD se plantea el uso de github actions. Cuando un desarrollador realiza un cambio en la aplicación y lo sube al repositorio de producción se despliega un workflow en github actions que actualiza el codigo base de la lambda o del docker correspondiente, este pipeline tambien generaria la task definition, el ecs service y agrega al target group. 

Para el ejercicio se realiza el ejemplo con el codigo de una lambda del backend (lambda-catalog). Cuando se actualiza el codigo en el repo (Backend-repo) se despliega la nueva versión. Evita desplegar toda la infraestructura solo por un cambio de codigo (separación de funciones)

El despliegue de la infraestructura se realiza con github actions con un trigger "manual". Se deja esta opción para mayor control de la infraestructura.

En github se usan los secrets de github actions para almacenar las keys de un usuario IAM con permisos minimos. Para un entorno mas productivo se puede integrar un OIDC connect.