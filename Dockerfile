FROM mcr.microsoft.com/dotnet/sdk:6.0 as build
WORKDIR /src
COPY BlazorServerAppInContainer.csproj .
RUN dotnet restore BlazorServerAppInContainer.csproj
COPY . .
RUN dotnet build "BlazorServerAppInContainer.csproj" -c Release -o /app/build

FROM build as publish
RUN dotnet publish "BlazorServerAppInContainer.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:6.0 as final
WORKDIR /app
EXPOSE 80
EXPOSE 443
COPY --from=publish /app/publish .
ENTRYPOINT [ "dotnet", "BlazorServerAppInContainer.dll" ]