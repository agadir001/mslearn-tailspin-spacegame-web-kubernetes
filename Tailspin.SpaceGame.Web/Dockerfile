FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY Tailspin.SpaceGame.Web.csproj .

RUN dir -s
RUN dotnet restore "Tailspin.SpaceGame.Web.csproj"
COPY . .
RUN dir -s
# WORKDIR "/src/Tailspin.SpaceGame.Web"
RUN dir -s
RUN dotnet build "Tailspin.SpaceGame.Web.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "Tailspin.SpaceGame.Web.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Tailspin.SpaceGame.Web.dll"]
