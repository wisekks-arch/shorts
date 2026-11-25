$ErrorActionPreference = 'Continue'
$port = 5050
$scriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { (Get-Location).Path }

$mimeTypes = @{
    '.html' = 'text/html; charset=utf-8'
    '.htm'  = 'text/html; charset=utf-8'
    '.css'  = 'text/css; charset=utf-8'
    '.js'   = 'application/javascript; charset=utf-8'
    '.json' = 'application/json; charset=utf-8'
    '.png'  = 'image/png'
    '.jpg'  = 'image/jpeg'
    '.jpeg' = 'image/jpeg'
    '.gif'  = 'image/gif'
    '.svg'  = 'image/svg+xml'
    '.ico'  = 'image/x-icon'
    '.mp4'  = 'video/mp4'
    '.webm' = 'video/webm'
    '.mp3'  = 'audio/mpeg'
    '.wav'  = 'audio/wav'
    '.woff' = 'font/woff'
    '.woff2'= 'font/woff2'
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$port/")
$listener.Prefixes.Add("http://127.0.0.1:$port/")

try {
    $listener.Start()
    Write-Host "==========================================================" -ForegroundColor Cyan
    Write-Host " [ShortsMaker] 유튜브 쇼츠 자동 제작기 로컬 서버 실행 중" -ForegroundColor Green
    Write-Host " 로컬 주소: http://localhost:$port" -ForegroundColor Yellow
    Write-Host " 종료하려면 Ctrl + C를 누르세요." -ForegroundColor Gray
    Write-Host "==========================================================" -ForegroundColor Cyan

    Start-Process "http://localhost:$port"

    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $rawUrl = $request.RawUrl.Split('?')[0]
        if ($rawUrl -eq '/api/tts') {
            try {
                Add-Type -AssemblyName System.Speech
                Add-Type -AssemblyName System.Web
                $queryStr = if ($request.RawUrl.Contains('?')) { $request.RawUrl.Split('?')[1] } else { '' }
                $qs = [System.Web.HttpUtility]::ParseQueryString($queryStr)
                $ttsText = $qs['text']
                $rateVal = 1
                if ($qs['rate']) {
                    $parsedRate = 1.0
                    if ([double]::TryParse($qs['rate'], [ref]$parsedRate)) {
                        $rateVal = [int][Math]::Round(($parsedRate - 1.0) * 5)
                        $rateVal = [Math]::Max(-5, [Math]::Min(5, $rateVal))
                    }
                }
                $synth = New-Object System.Speech.Synthesis.SpeechSynthesizer
                $koVoice = $synth.GetInstalledVoices() | Where-Object { $_.VoiceInfo.Culture.Name -like 'ko*' } | Select-Object -First 1
                if ($koVoice) { $synth.SelectVoice($koVoice.VoiceInfo.Name) }
                $synth.Rate = $rateVal
                $ms = New-Object System.IO.MemoryStream
                $synth.SetOutputToWaveStream($ms)
                if ($ttsText) { $synth.Speak($ttsText) }
                $synth.Dispose()
                $wavBytes = $ms.ToArray()
                $ms.Dispose()
                $response.ContentType = 'audio/wav'
                $response.AddHeader("Access-Control-Allow-Origin", "*")
                $response.ContentLength64 = $wavBytes.Length
                $response.OutputStream.Write($wavBytes, 0, $wavBytes.Length)
                $response.StatusCode = 200
            } catch {
                $response.StatusCode = 500
                $errBytes = [System.Text.Encoding]::UTF8.GetBytes("TTS Error: $_")
                $response.ContentType = "text/plain; charset=utf-8"
                $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
            }
            $response.OutputStream.Close()
            continue
        }

        if ($rawUrl -eq '/' -or $rawUrl -eq '') {
            $rawUrl = '/index.html'
        }

        $localPath = Join-Path $scriptDir ($rawUrl.TrimStart('/'))

        if (Test-Path $localPath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($localPath).ToLower()
            $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { 'application/octet-stream' }
            $response.ContentType = $mime
            $response.AddHeader("Access-Control-Allow-Origin", "*")

            $bytes = [System.IO.File]::ReadAllBytes($localPath)
            $response.ContentLength64 = $bytes.Length
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
            $response.StatusCode = 200
        } else {
            $response.StatusCode = 404
            $msg = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found: $rawUrl")
            $response.ContentType = "text/plain; charset=utf-8"
            $response.ContentLength64 = $msg.Length
            $response.OutputStream.Write($msg, 0, $msg.Length)
        }

        $response.OutputStream.Close()
    }
} catch {
    Write-Host "서버 실행 중 오류 발생: $_" -ForegroundColor Red
} finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    $listener.Close()
}

