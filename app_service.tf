terraform{
    required_providers{
        azurerm={
            source="hashicorp/azurerm"
            version=">=3.0.0"
        }
    }
    required_version=">=1.0.0"
}

provider "azurerm"{
    subscription_id="f2b10cce-5416-4954-a546-cecc424e44f3"
    features{}
}
resource "azurerm_resource_group" "rg"{
    name="example-resources"
    location="East US"
}
resource "azurerm_app_service_plan" "app_service_plan"{
    name ="example-app-service-plan"
    location= azurerm_resource_group.rg.location
    resource_group_name=azurerm_resource_group.rg.name
    sku{
        tier="Basic"
        size="B1"
    }
}
resource "azurerm_app_service" "app_service"{
    name="example-app-service123"
    location = azurerm_resource_group.rg.location
    resource_group_name=azurerm_resource_group.rg.name
    app_service_plan_id= azurerm_app_service_plan.app_service_plan.id
    site_config{
        dotnet_framework_version="v4.0"
        scm_type="LocalGit"
    }
    app_settings={
        "WEBSITE_RUN_FROM_PACKAGE"="1"
    }

}