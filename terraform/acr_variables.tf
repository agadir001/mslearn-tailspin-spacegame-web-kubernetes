

# Generic naming variables
variable "acr_name_prefix" {
  description = "Optional prefix for the generated name"
  type        = string
  default     = ""
}

variable "acr_name_suffix" {
  description = "Optional suffix for the generated name"
  type        = string
  default     = ""
}

# Custom naming override
variable "acr_custom_name" {
  description = "Custom Azure Container Registry name, generated if not set"
  type        = string
  default     = ""
}

variable "acr_sku" {
  description = "The SKU name of the the container registry. Possible values are `Classic` (which was previously `Basic`), `Basic`, `Standard` and `Premium`."
  type        = string
  default     = "Standard"
}

variable "acr_admin_enabled" {
  description = "Whether the admin user is enabled."
  type        = bool
  default     = false
}

variable "acr_georeplication_locations" {
  description = <<DESC
  A list of Azure locations where the Ccontainer Registry should be geo-replicated. Only activated on Premium SKU.
  Supported properties are:
    location                  = string
    zone_redundancy_enabled   = bool
    regional_endpoint_enabled = bool
    tags                      = map(string)
  or this can be a list of `string` (each element is a location)
DESC
  type        = any
  default     = []
}

variable "acr_images_retention_enabled" {
  description = "Specifies whether images retention is enabled (Premium only)."
  type        = bool
  default     = false
}

variable "acr_images_retention_days" {
  description = "Specifies the number of images retention days."
  type        = number
  default     = 90
}

variable "acr_azure_services_bypass_allowed" {
  description = "Whether to allow trusted Azure services to access a network restricted Container Registry."
  type        = bool
  default     = false
}

variable "acr_trust_policy_enabled" {
  description = "Specifies whether the trust policy is enabled (Premium only)."
  type        = bool
  default     = false
}

variable "acr_allowed_cidrs" {
  description = "List of CIDRs to allow on the registry."
  default     = []
  type        = list(string)
}

variable "acr_allowed_subnets" {
  description = "List of VNet/Subnet IDs to allow on the registry."
  default     = []
  type        = list(string)
}

variable "acr_public_network_access_enabled" {
  description = "Whether the Container Registry is accessible publicly."
  type        = bool
  default     = true
}

variable "acr_data_endpoint_enabled" {
  description = "Whether to enable dedicated data endpoints for this Container Registry? (Only supported on resources with the Premium SKU)."
  default     = false
  type        = bool
}

variable "acr_default_tags_enabled" {
  description = "Option to enable or disable default tags."
  type        = bool
  default     = true
}

variable "acr_extra_tags" {
  description = "Additional tags to associate with your Azure Container Registry."
  type        = map(string)
  default     = {}
}

variable "acr_environment" {
  description = "Project environment."
  type        = string
}

variable "acr_stack" {
  description = "Project stack name."
  type        = string
}


