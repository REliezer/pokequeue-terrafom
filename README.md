# PokeQueue - Infraestructura con Terraform

Este proyecto contiene la infraestructura como código (IaC) para el proyecto PokeQueue utilizando Terraform para desplegar recursos en Microsoft Azure.

## 🏗️ Arquitectura del Sistema PokeQueue

Este repositorio es parte de un ecosistema completo de microservicios para el procesamiento de reportes de Pokémon. El sistema completo está compuesto por los siguientes componentes:

### 🔗 Repositorios Relacionados

| Componente | Repositorio | Descripción |
|------------|-------------|-------------|
| **Frontend** | [PokeQueue UI](https://github.com/REliezer/pokequeue-ui) | Interfaz de usuario web para solicitar y gestionar reportes de Pokémon |
| **API REST** | [PokeQueue API](https://github.com/REliezer/pokequeueAPI) | API principal que gestiona solicitudes de reportes y coordinación del sistema |
| **Azure Functions** | [PokeQueue Functions](https://github.com/REliezer/pokequeue-function) | Procesamiento asíncrono de reportes |
| **Base de Datos** | [PokeQueue SQL Scripts](https://github.com/REliezer/pokequeue-sql) | Scripts SQL para la configuración y mantenimiento de la base de datos |
| **Infraestructura** | [PokeQueue Terraform](https://github.com/REliezer/pokequeue-terrafom) | Este repositorio - Configuración de infraestructura como código (IaC) |

### 🔄 Flujo de Datos del Sistema Completo

1. **PokeQueue UI** → Usuario solicita reporte desde la interfaz web
2. **PokeQueue UI** → Envía solicitud a **PokeQueue API**
3. **PokeQueue API** → Valida la solicitud y la guarda en la base de datos
4. **PokeQueue API** → Envía mensaje a la cola de Azure Storage
5. **PokeQueue Function** → Procesa el mensaje de la cola
6. **PokeQueue Function** → Consulta PokéAPI y genera el reporte CSV
7. **PokeQueue Function** → Almacena el CSV en Azure Blob Storage
8. **PokeQueue Function** → Notifica el estado a **PokeQueue API**
9. **PokeQueue UI** → Consulta el estado y permite descargar el reporte terminado

### 🏗️ Diagrama de Arquitectura

```
   ┌─────────────────┐
   │   PokeQueue UI  │
   │ (Frontend Web)  │
   └─────────┼───────┘
             │
             ▼ HTTP/REST
  ┌─────────────────┐    ┌─────────────────┐
  │  PokeQueue API  │────│   Azure SQL DB  │
  │   (REST API)    │    │  (Persistencia) │
  └─────────┼───────┘    └─────────────────┘
            │
            ▼ Queue Message
   ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
   │  Azure Storage  │────│ PokeQueue Func  │────│   Azure Blob    │
   │     Queue       │    │ (Procesamiento) │    │    Storage      │
   └─────────────────┘    └─────────┼───────┘    └─────────────────┘
                                    │
                                    ▼ HTTP API Call
                           ┌─────────────────┐
                           │    PokéAPI      │
                           │ (Datos Pokémon) │
                           └─────────────────┘
```

## 📋 Descripción del Proyecto

PokeQueue es una aplicación distribuida que incluye:
- **Frontend (UI)**: Aplicación web desplegada en Azure Web App
- **Backend API**: API REST desplegada en Azure Web App
- **Función Serverless**: Azure Function App para procesamiento asíncrono
- **Base de datos**: SQL Server en Azure
- **Almacenamiento**: Cuentas de almacenamiento para blobs y colas
- **Registro de contenedores**: Azure Container Registry para imágenes Docker

## 🏗️ Arquitectura

La infraestructura despliega los siguientes recursos de Azure:

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Frontend UI   │    │   Backend API   │    │ Function App    │
│  (Web App)      │    │  (Web App)      │    │ (Serverless)    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
         ┌───────────────────────┼───────────────────────┐
         │                       │                       │
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   SQL Server    │    │ Storage Account │    │Container Registry│
│   (Database)    │    │(Blobs & Queues) │    │     (ACR)       │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

## 📁 Estructura del Proyecto

```
pokequeue-terraform/
├── main.tf              # Proveedor de Azure y Resource Group principal
├── variables.tf         # Definición de todas las variables
├── webapps.tf          # Web Apps (UI y API) y Service Plan
├── funtionapp.tf       # Azure Function App
├── db.tf               # SQL Server y Base de Datos
├── storages.tf         # Cuentas de almacenamiento, contenedores y colas
├── acr.tf              # Azure Container Registry
├── local.tfvars        # Valores de variables (no incluido en Git)
└── README.md           # Este archivo
```

## 🚀 Recursos Desplegados

### Grupo de Recursos
- **Resource Group**: Contenedor principal para todos los recursos

### Aplicaciones Web
- **Frontend UI**: Aplicación web React/Next.js en contenedor Docker
- **Backend API**: API REST en contenedor Docker (puerto 8000)
- **Service Plan**: Plan de servicio Linux B1 para hospedar las web apps

### Función Serverless
- **Function App**: Azure Function con Python 3.12 para procesamiento asíncrono

### Base de Datos
- **SQL Server**: Servidor SQL Server 12.0
- **SQL Database**: Base de datos con SKU Basic

### Almacenamiento
- **Storage Account Principal**: Para la aplicación (blobs y colas)
- **Storage Account Function**: Dedicada para la Azure Function
- **Blob Container**: "reportes" para almacenar archivos
- **Storage Queue**: "requests" para mensajes asincrónicos

### Registro de Contenedores
- **Azure Container Registry**: Para almacenar imágenes Docker

## 📋 Prerrequisitos

1. **Terraform** >= 1.0
2. **Azure CLI** instalado y autenticado
3. **Suscripción de Azure** activa
4. **Permisos** de Contributor en la suscripción

### Instalación de Prerrequisitos

```bash
# Instalar Terraform (Windows con Chocolatey)
choco install terraform

# Instalar Azure CLI
choco install azure-cli

# Autenticarse en Azure
az login
```

## ⚙️ Configuración

### 1. Clonar el repositorio

```bash
git clone https://github.com/REliezer/pokequeue-terrafom
cd pokequeue-terraform
```

### 2. Crear archivo de variables

Crea un archivo `local.tfvars` con los siguientes valores:

```hcl
# Configuración de Azure
subscription_id = "tu-subscription-id"
location = "Central US"

# Configuración del proyecto
project = "pokequeue"
name = "00"  # Para evitar conflictos de nombres (opcional)
environment = "dev"

# Configuración de SQL Server
admin_sql_user = "sqladmin"
admin_sql_password = "tu-password-seguro-123!"
user_sql = "appuser"
user_sql_password = "tu-user-password-123!"

# Configuración de la aplicación
sql_driver = "ODBC Driver 18 for SQL Server"

# Tags adicionales (opcional)
tags = {
  environment = "development"
  date        = "aug-2025"
  createdBy   = "Terraform"
  project     = "pokequeue"
}
```

### 3. Variables de Entorno (Alternativa)

Puedes usar variables de entorno en lugar del archivo tfvars:

```bash
export TF_VAR_subscription_id="tu-subscription-id"
export TF_VAR_admin_sql_password="tu-password-seguro"
# ... otras variables
```

## 🚀 Despliegue

### 1. Inicializar Terraform

```bash
terraform init
```

### 2. Planificar el despliegue

```bash
terraform plan -var-file="local.tfvars"
```

### 3. Aplicar la infraestructura

```bash
terraform apply -var-file="local.tfvars"
```

### 4. Confirmar el despliegue

Cuando se te solicite, escribe `yes` para confirmar.

## 🔧 Gestión Post-Despliegue

### Actualizar la infraestructura

Después de hacer cambios en los archivos `.tf`:

```bash
terraform plan -var-file="local.tfvars"
terraform apply -var-file="local.tfvars"
```

## 🔐 Seguridad

### Variables Sensibles

Las siguientes variables contienen información sensible y deben manejarse cuidadosamente:

- `admin_sql_password`
- `user_sql_password` 
- `subscription_id`

### Buenas Prácticas

1. **Nunca** commitees `local.tfvars` al repositorio
2. Usa **Azure Key Vault** para secretos en producción
3. Implementa **RBAC** adecuado en los recursos
4. Habilita **auditoría** en SQL Server
5. Configura **redes privadas** para producción

## 🌍 Variables de Configuración

| Variable | Tipo | Descripción | Valor por Defecto |
|----------|------|-------------|-------------------|
| `subscription_id` | string | ID de suscripción de Azure | - |
| `location` | string | Región de Azure | "Central US" |
| `project` | string | Nombre del proyecto | "pokequeue" |
| `name` | string | Sufijo para evitar conflictos | "refe" |
| `environment` | string | Entorno de despliegue | "dev" |
| `admin_sql_user` | string | Usuario administrador SQL | - |
| `admin_sql_password` | string | Contraseña admin SQL | - |
| `user_sql` | string | Usuario de aplicación SQL | - |
| `user_sql_password` | string | Contraseña usuario SQL | - |
| `sql_driver` | string | Driver ODBC para SQL Server | - |

## 📊 Costos Estimados

Los recursos desplegados tienen los siguientes costos aproximados (USD/mes):

- **Web Apps** (B1): ~$13.00
- **Function App**: Variable según uso
- **SQL Database** (Basic): ~$4.99
- **Storage Accounts**: Variable según uso
- **Container Registry** (Basic): ~$5.00

**Total estimado**: ~$25-30/mes para desarrollo

## 🐛 Solución de Problemas

### Error: Nombres duplicados

Si obtienes errores de nombres ya existentes:
- Cambia la variable `name` en tu `local.tfvars`
- Usa un sufijo único como tu inicial o fecha

### Error: Cuota excedida

Algunos recursos tienen cuotas por región. Intenta:
- Cambiar la `location`
- Contactar soporte de Azure para aumentar cuotas

## 🚀 Instalación Completa del Sistema PokeQueue

Para desplegar el sistema completo, necesitas configurar todos los componentes en el siguiente orden:

### 1. Infraestructura (Terraform) (Este Repositorio)
```bash
# Clonar el repositorio de infraestructura
git clone https://github.com/REliezer/pokequeue-terrafom.git
cd pokequeue-terrafom

# Configurar variables de Terraform
terraform init
terraform plan
terraform apply
```

### 2. Base de Datos (SQL Scripts)
```bash
# Clonar el repositorio de base de datos
git clone https://github.com/REliezer/pokequeue-sql.git
cd pokequeue-sql

# Ejecutar scripts SQL en Azure SQL Database
# (Revisar el README del repositorio SQL para instrucciones específicas)
```

### 3. API REST
```bash
# Clonar y desplegar la API
git clone https://github.com/REliezer/pokequeueAPI.git
cd pokequeueAPI

# Seguir las instrucciones del README de la API
```

### 4. Azure Functions
```bash
# Clonar este repositorio
git clone https://github.com/REliezer/pokequeue-function.git
cd pokequeue-function

# Seguir las instrucciones de despliegue
```

### 5. Frontend UI
```bash
# Clonar y desplegar el frontend
git clone https://github.com/REliezer/pokequeue-ui.git
cd pokequeue-ui

# Seguir las instrucciones del README del UI para configuración y despliegue
```

## 📚 Referencias

- [Documentación de Terraform](https://www.terraform.io/docs)
- [Provider AzureRM](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

## 🤝 Contribución

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/nueva-feature`)
3. Commit tus cambios (`git commit -am 'Agregar nueva feature'`)
4. Push a la rama (`git push origin feature/nueva-feature`)
5. Abre un Pull Request

## Licencia

Este proyecto es parte de un trabajo académico para Sistemas Expertos II PAC 2025.