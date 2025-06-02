using Azure.Data.Tables;
using Azure.Identity;
using Demo.WebApi.DataTransferObjects;
using Demo.WebApi.Entities;
using Microsoft.AspNetCore.Mvc;

namespace Demo.WebApi.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ValuesController(IConfiguration configuration) : ControllerBase
{
    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var storageAccountName = configuration["AzureStorageAccountName"];
        var tableStorageUri = new Uri($"https://{storageAccountName}.table.core.windows.net");
        var credentials = new DefaultAzureCredential();
        var tableClient = new TableClient(tableStorageUri, "apivalues", credentials);

        var fruitList = new List<ConferenceDetailsResponse>();

        await foreach (var page in tableClient.QueryAsync<ConferenceTableEntity>().AsPages())
        {
            fruitList.AddRange(
                page.Values.Select(e => new ConferenceDetailsResponse
                {
                    Id = e.RowKey,
                    Name = e.Name,
                    Value = e.Value
                }));
        }

        return Ok(fruitList);
    }
}

