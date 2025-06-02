using Scalar.AspNetCore;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddOpenApi();
builder.Services.AddControllers();


var app = builder.Build();

app.MapOpenApi();
app.MapScalarApiReference("/scalar", opts =>
{
    opts.DarkMode = true;
});

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
