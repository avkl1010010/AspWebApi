# Use the official ASP.NET Core runtime as a base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Use the .NET SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["MyAspNetCoreApi/MyAspNetCoreApi.csproj", "MyAspNetCoreApi/"]
RUN dotnet restore "MyAspNetCoreApi/MyAspNetCoreApi.csproj"
COPY . .
WORKDIR "/src/MyAspNetCoreApi"
RUN dotnet build -c Release -o /app/build

FROM build AS publish
RUN dotnet publish -c Release -o /app/publish

# Final stage to run the application
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MyAspNetCoreApi.dll"]
