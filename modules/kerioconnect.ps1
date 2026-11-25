Function KerioConnectReport()
{
    $htmlTable = ''

    foreach ($config in $aKerioConnectLogfile) {
        # Liste für alle gesammelten Einträge über alle Konfigurationen hinweg
        $allEntries = [System.Collections.Generic.List[PSCustomObject]]::new()

        # 1. Zu prüfende Dateien ermitteln (Hauptdatei + erste rotierte Datei, falls vorhanden)
        $filesToCheck = @($config.Path)
        $rotatedPath = "$($config.Path).1"
        if (Test-Path $rotatedPath) {
            $filesToCheck += $rotatedPath
        }

        # Zeitgrenze berechnen (jetzt minus X Stunden)
        $thresholdTime = (Get-Date).AddHours(-$config.LastHours)

        foreach ($file in $filesToCheck) {
            if (-not (Test-Path $file)) { continue }

            # Datei zeilenweise einlesen (schont den Arbeitsspeicher bei großen Logs)
            $stream = [System.IO.File]::Open($file, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read, [System.IO.FileShare]::ReadWrite)
            $reader = [System.IO.StreamReader]::new($stream)
            try {
                while (($line = $reader.ReadLine()) -ne $null) {
                    # 2. Log-Zeile parsen: Erwartetes Format z.B. "[16/Nov/2026 11:18:26][1576] Text..."
                    if ($line -match '^\[([^\]]+)\](.*)$') {
                        $dateString = $Matches[1]
                        $logText    = $Matches[2]

                        # Datum im Format "16/Nov/2026 11:18:26" mit englischer InvariantCulture parsen
                        $parseSuccess = $false
                        $parsedDate   = $null
                        try {
                            $parsedDate = [datetime]::ParseExact(
                                $dateString,
                                'dd/MMM/yyyy HH:mm:ss',
                                [System.Globalization.CultureInfo]::InvariantCulture
                            )
                            $parseSuccess = $true
                        } catch {
                            $parseSuccess = $false
                        }

                        # 3. Zeitfilter prüfen (nur Einträge der letzten X Stunden)
                        if ($parseSuccess -and ($parsedDate -ge $thresholdTime)) {

                            # 4. Filter-Matching (mindestens ein Filter muss matchen, falls Filter vorhanden sind)
                            $matchFound = $false
                            if (-not $config.Include -or $config.Include.Count -eq 0) {
                                $matchFound = $true # Wenn kein Filter definiert ist, alles übernehmen
                            } else {
                                foreach ($pattern in $config.Include) {
                                    if ($line -match $pattern) {
                                        $matchFound = $true
                                        break
                                    }
                                }
                            }

                            # Wenn Match erfolgreich, zum Ergebnis hinzufügen
                            if ($matchFound) {
                                $allEntries.Add([PSCustomObject]@{
                                    SortDate      = $parsedDate
                                    FormattedTime = $parsedDate.ToString('yyyy-MM-dd HH:mm:ss')
                                    Text          = $logText # Alternativ $line, wenn der Zeitstempel im Text bleiben soll
                                })
                            }
                        }
                    }
                }
            }
            finally {
                $reader.Dispose()
                $stream.Dispose()
            }
        }

        if (-not $allEntries.Count -eq 0) {
            # 5. Nach Datum und Uhrzeit aufsteigend sortieren
            $sortedEntries = $allEntries | Sort-Object SortDate

            # 6. Als HTML-Tabelle ausgeben (2 Spalten: Datum und Uhrzeit, Text)
            $htmlTable += $sortedEntries | Select-Object `
                @{Name='Time&nbsp;generated&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'; Expression={$_.FormattedTime}},
                @{Name=$config.Title + ' Message'; Expression={$_.Text}} |
                ConvertTo-Html -Fragment
        }
    }

    # Ausgabe des HTML-Codes
    if ($htmlTable -eq '') {
        $htmlTable = '<h3>KerioConnect</h3><p>No entries found.</p>' + $htmlTable
    } else {
        $htmlTable = '<h3>KerioConnect</h3>' + $htmlTable
    }

    return $htmlTable
}
