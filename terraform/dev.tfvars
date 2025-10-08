# MongoDB Atlas connection string
mongo_uri = "mongodb+srv://Omkar:Password%4009082004@cluster0.it0sg17.mongodb.net/?retryWrites=true&w=majority"

resource_group_name = "todoapp-tf-rg"
location            = "southeastasia"
acr_name            = "todotfappacr"

vnet_name          = "todoapp-vnet"
subnet_name        = "todoapp-subnet"
vnet_address_space = ["10.0.0.0/16"]
subnet_prefix      = ["10.0.1.0/23"]
