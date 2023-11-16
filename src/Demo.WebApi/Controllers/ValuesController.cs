using Azure.Data.Tables;
using Azure.Identity;
using Demo.WebApi.DataTransferObjects;
using Demo.WebApi.Entities;
using Microsoft.AspNetCore.Mvc;

namespace Demo.WebApi.Controllers;

[Route("api/[controller]")]
[ApiController]
public class ValuesController : ControllerBase
{
    private readonly IConfiguration _configuration;

    [HttpGet]
    public async Task<IActionResult> Get()
    {
        var storageAccountName = _configuration["AzureStorageAccountName"];
        var tableStorageUri = new Uri($"https://{storageAccountName}.table.core.windows.net");
        var credentials = new ChainedTokenCredential(
            new ManagedIdentityCredential(),
            new AzureCliCredential(),
            new VisualStudioCredential(),
            new VisualStudioCodeCredential());
        var tableClient = new TableClient(tableStorageUri, "apivalues", credentials);

        var fruitList = new List<FruitDto>();

        await foreach (var page in tableClient.QueryAsync<FruitTableEntity>().AsPages())
        {
            fruitList.AddRange(
                page.Values.Select(e => new FruitDto
                {
                    Id = e.RowKey,
                    Name = e.Name,
                    Color = e.Color
                }));
        }

        return Ok(fruitList);
    }

    public ValuesController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

}

