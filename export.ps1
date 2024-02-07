$certs = Get-ChildItem Cert:\CurrentUser\CA -Recurse
$ca_idx = 14
$sw_idx = 17
$start_idx = 3
$export_path = "[REDACTED]"

foreach ($cert in $certs) {

	if ($cert.Subject.Contains("DOD ID CA")) {

		$newStr = ""
		foreach ($char in $cert.Subject[$start_idx..$ca_idx]) {

			$newStr = $newStr + $char

		}
		echo "[*] Exporting $newStr"
		try {

			$b64cert = @"
-----BEGIN CERTIFICATE
$([Convert]::ToBase64String($cert.Export('Cert'), [System.Base64FormattingOptions]::InsertLineBreaks))
-----END CERTIFICATE-----
"@
			Set-Content -Path "$export_path\$newStr.cer" -Value $b64cert
		} catch {

			echo "[!] Could not export $newStr"

		}

	} elseif ($cert.Subject.Contains("DOD ID SW")) {

		$newStr = ""
		foreach ($char in $cert.Subject[$start_idx..$sw_idx]) {

			$newStr = $newStr + $char

		}
		echo "[*] Exporting $newStr"
		try {

			$b64cert = @"
-----BEGIN CERTIFICATE-----
$([Convert]::ToBase64String($cert.Export("Cert"), [System.Base64FormattingOptions]::InsertLineBreaks))
-----END CERTIFICATE-----
"@
			Set-Content -Path "$export_path\$newStr.cer" -Value $b64cert
		} catch {

			echo "[!] Could not export $newStr"

		}

	}

}
