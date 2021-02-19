//Declare input variables
// Address of person is set locally. Refer locals.tf

# Variable type: string
variable "name" {
  description = "Name of the person"
  type        = string
  default     = ""
}

# Variable type: number
variable "age" {
  description = "Age info"
  type        = number
  default     = null
}

# Variable type: boolean
variable "job" {
  description = "Job details"
  type        = bool
  default     = null
}

# Variable type: list
variable "hobby" {
  description = "Hobbies details"
  type        = list(string)
  default     = []
}

# Variable type: map
variable "property" {
  description = "Property details"
  type        = map(string)
  default     = {}
}

# Variable type: object
variable "family" {
  description = "Family details"
  type        = any
  default     = {}
}
