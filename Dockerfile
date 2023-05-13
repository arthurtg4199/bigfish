FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 5178

ENV ASPNETCORE_URLS=http://+:5178

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["bigfish.csproj", "./"]
RUN dotnet restore "bigfish.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "bigfish.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "bigfish.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "bigfish.dll"]
