# Mueve los mods de la lista a la carpeta "mods" de la instalacion "zombies".
# Busca cada .jar dentro de la carpeta zombies (sin entrar en "mods") y en Descargas.
# Uso:  powershell -ExecutionPolicy Bypass -File .\mover-mods-zombies.ps1
#       (anade -Copiar para copiar en vez de mover, o -Origen "C:\otra\carpeta")

param(
    [string]$Instancia = "$env:APPDATA\.minecraft\installations\forge\zombies",
    [string[]]$Origen = @(),
    [switch]$Copiar
)

$mods = @(
    'alexsmobs-1.22.9'
    'AmbientSounds_FORGE_v6.3.8_mc1.20.1'
    'balm-forge-1.20.1-7.3.44'
    'bettervillage-forge-1.20.1-3.3.1-all'
    'Chunky-1.3.146'
    'citadel-2.6.3-1.20.1'
    'CreativeCore_FORGE_v2.12.40_mc1.20.1'
    'cristellib-1.1.6-forge'
    'cupboard-1.20.1-4.0'
    'curios-forge-5.14.1+1.20.1'
    'Data_Anchor-forge-1.20.1-1.0.0.22'
    'easy-villagers-forge-1.20.1-1.1.39'
    'embeddium-0.3.31+mc1.20.1'
    'entityculling-forge-1.10.5-mc1.20.1'
    'Essential-1.4.1.1-1.20.1'
    'expanded_ecosphere-3.2.4-forge'
    'explosiveenhancement-1.1.0-1.20.1-client-and-server'
    'Fastload-Reforged-mc1.20.1-3.4.0'
    'ferritecore-6.0.1-forge'
    'framework-forge-1.20.1-0.8.0'
    'geckolib-forge-1.20.1-4.8.4'
    'gravestone-forge-1.20.1-1.0.35'
    'guardvillagers-1.20.1-1.6.18'
    'HopoBetterRuinedPortals-[1.20-1.20.2]-1.3.7c'
    'HopoBetterUnderwaterRuins-[1.20.1-1.20.4]-1.1.5b'
    'immersive_aircraft-1.4.1+1.20.1-forge'
    'immersive_machinery-0.2.0+1.20.1-forge'
    'Jade-1.20.1-Forge-11.13.3'
    'jei-1.20.1-forge-15.49.0.191'
    'libraryferret-forge-1.20.1-4.0.0'
    'lootintegrations-1.20.1-4.7'
    'lukis-grand-capitals-1.1.3'
    'MutantMonsters-v8.0.8-1.20.1-Forge'
    'Mutants Buff 1.5.10 - 1.20.1'
    'naturalist-5.0pre2+forge-1.20.1'
    'oculus-mc1.20.1-1.8.0'
    'Paraglider-forge-20.1.3'
    'PresenceFootsteps-1.20.1-1.9.1-beta.1'
    'projectvibrantjourneys-1.20.1-6.3.0'
    'PuzzlesLib-v8.1.33-1.20.1-Forge'
    'radium-mc1.20.1-0.12.4+git.26c9d8e'
    'sophisticatedbackpacks-1.20.1-3.24.67.2109'
    'sophisticatedcore-1.20.1-1.3.83.2295'
    'sound-physics-remastered-forge-1.20.1-1.5.1'
    'Terralith_1.20.x_v2.5.4'
    'tidal-towns-1.3.4'
    'uncrafteverything-2.2.1+1.20.1-forge'
    'valarian_conquest-4.2.2-forge-1.20.1'
    'waystones-forge-1.20.1-14.1.20'
    'xaerominimap-forge-1.20.1-26.4.2'
)

$destino = Join-Path $Instancia 'mods'
if (-not (Test-Path -LiteralPath $destino)) {
    Write-Host "No existe la carpeta de destino: $destino" -ForegroundColor Red
    exit 1
}

if ($Origen.Count -eq 0) {
    $Origen = @($Instancia, (Join-Path $env:USERPROFILE 'Downloads'))
}

# Todos los .jar/.zip de los origenes, sin mirar lo que ya esta en mods
$candidatos = foreach ($o in $Origen) {
    if (Test-Path -LiteralPath $o) {
        Get-ChildItem -LiteralPath $o -Recurse -File -Include *.jar, *.zip -ErrorAction SilentlyContinue |
            Where-Object { -not $_.FullName.StartsWith($destino + '\', [StringComparison]::OrdinalIgnoreCase) }
    }
}

$hechos = 0; $yaEstaban = 0; $faltan = @()
foreach ($m in $mods) {
    if ((Test-Path -LiteralPath (Join-Path $destino "$m.jar")) -or (Test-Path -LiteralPath (Join-Path $destino "$m.zip"))) {
        Write-Host "[ya en mods] $m" -ForegroundColor DarkGray
        $yaEstaban++
        continue
    }
    $archivo = $candidatos | Where-Object { $_.BaseName -eq $m } | Select-Object -First 1
    if (-not $archivo) {
        $faltan += $m
        continue
    }
    $final = Join-Path $destino $archivo.Name
    if ($Copiar) {
        Copy-Item -LiteralPath $archivo.FullName -Destination $final
        Write-Host "[copiado] $($archivo.Name)" -ForegroundColor Green
    } else {
        Move-Item -LiteralPath $archivo.FullName -Destination $final
        Write-Host "[movido]  $($archivo.Name)" -ForegroundColor Green
    }
    $hechos++
}

Write-Host ""
Write-Host "Colocados en mods: $hechos | Ya estaban: $yaEstaban | No encontrados: $($faltan.Count)"
if ($faltan.Count -gt 0) {
    Write-Host "No encontre estos (descargalos o indica otra carpeta con -Origen):" -ForegroundColor Yellow
    $faltan | ForEach-Object { Write-Host "  - $_" -ForegroundColor Yellow }
}
