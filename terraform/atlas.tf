##############################################
# 🌐 MongoDB Atlas (external)
##############################################

# Store / output the MongoDB Atlas connection string.
# The URI will be injected into your backend container
# via environment variable.

output "mongo_uri" {
  description = "MongoDB Atlas connection string"
  value       = var.mongo_uri
  sensitive   = true
}
