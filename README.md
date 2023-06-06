# hub-spoke-love-story

This is the basis for the Hub &amp; Spoke - A Love Story talk that I give at conferences world-wide

```bash
az deployment sub create --template-file hub.bicep --parameters hub.params.json --location westeurope --name hubspoke-hub
az deployment sub create --template-file spoke.bicep --parameters spoke.params.json --location westeurope --name hubspoke-spoke
```
