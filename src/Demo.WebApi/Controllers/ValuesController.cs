namespace Demo.WebApi.Controllers;

public class ValuesController: ApiController {
    [HttpGet]
    public string Get() {
        return "Hello World";
    }
}