<# Declarations and Includes #>
$InputError = ""

<# Functions #>

function Show-Console
{
    param ([Switch]$Show,[Switch]$Hide)
    if (-not ("Console.Window" -as [type])) { 

        Add-Type -Name Window -Namespace Console -MemberDefinition '
        [DllImport("Kernel32.dll")]
        public static extern IntPtr GetConsoleWindow();

        [DllImport("user32.dll")]
        public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
        '
    }

    if ($Show)
    {
        $consolePtr = [Console.Window]::GetConsoleWindow()

        # Hide = 0,
        # ShowNormal = 1,
        # ShowMinimized = 2,
        # ShowMaximized = 3,
        # Maximize = 3,
        # ShowNormalNoActivate = 4,
        # Show = 5,
        # Minimize = 6,
        # ShowMinNoActivate = 7,
        # ShowNoActivate = 8,
        # Restore = 9,
        # ShowDefault = 10,
        # ForceMinimized = 11

        $null = [Console.Window]::ShowWindow($consolePtr, 5)
    }

    if ($Hide)
    {
        $consolePtr = [Console.Window]::GetConsoleWindow()
        #0 hide
        $null = [Console.Window]::ShowWindow($consolePtr, 0)
    }
}


$GoSerial = {
    $InputError = ""

<# Convert Temperature ####################################################### #>
    try {
        if ($StandardsBox.Text -eq "US"){
            # check for bounds
            if ( ([int]$temperatureField.Text -lt -67) -or ([int]$temperatureField.Text -gt 390)){ throw }

            # Convert Value
            $Temperature = [math]::Round( (([int]$temperatureField.Text*10)+670)/18 )
        }

        else {
            # check for bounds
            if ( ([int]$temperatureField.Text -lt -55) -or ([int]$temperatureField.Text -gt 199)){ throw }

            # Convert Value
            $Temperature = [math]::Round( (([int]$temperatureField.Text*10)+550)/10 )
        }

        $Temperature = [int]$Temperature
        $Temperature = [char]$Temperature
    }
    catch { $InputError = "Invalid input in Temperature box" }

<# Convert Wind Speed ####################################################### #>
    try {
        if ($StandardsBox.Text -eq "US"){
            
            # check for bounds
            if ( ([int]$WindSpeedField.Text -lt 0) -or ([int]$WindSpeedField.Text -gt 99)){ throw }
            
            # Convert Value
            $WindSpeed = ([int]$WindSpeedField.Text*2)
            $WindSpeed = [int]$WindSpeed
            $WindSpeed = [char]$WindSpeed
        }

        else {
            # check for bounds
            if ( ([int]$WindSpeedField.Text -lt 0) -or ([int]$WindSpeedField.Text -gt 99)){ throw }
            $WindSpeed = [int]$WindSpeedField.Text

            # Convert Value
            $WindSpeed = $WindSpeed/0.813
            $WindSpeed = [int]$WindSpeed
            $WindSpeed = [char]$WindSpeed
        }
    }
    catch { $InputError = "Invalid input in Wind Speed Box" }


<# Convert Wind Direction ####################################################### #>
    try {
    switch ($WinDirField.Text)
        {
            "Calm" { $WindDir = [char]24 }
            "N"    { $WindDir = [char]23 }
            "NE"   { $WindDir = [char]21 }
            "E"    { $WindDir = [char]29 }
            "SE"   { $WindDir = [char]25 }
            "S"    { $WindDir = [char]27 }
            "SW"   { $WindDir = [char]26 }
            "W"    { $WindDir = [char]30 }
            "NW"   { $WindDir = [char]22 }
        }
    }
    catch {$InputError = "Invalid input in Wind Direction Box"}

<# Convert Barometer ####################################################### #>
    try {
        if ($StandardsBox.Text -eq "US"){
            
            # check for bounds
            if ( ([int]$BarometerField1.Text -lt 29) -or ([int]$BarometerField1.Text -gt 31)){ throw }
            if ( ([int]$BarometerField2.Text -lt 0) -or ([int]$BarometerField2.Text -gt 99)){ throw }

            # get upper value, subtract 29, multiply by 100
            $UpperNumber = ([int]$BarometerField1.Text - 29) * 100

            #Get lower number, add to upper number
            $Barometer = [int]$BarometerField2.Text + [int]$UpperNumber
        }

        else {
            # check for bounds
            if ( ([int]$BarometerField1.Text -lt 98) -or ([int]$BarometerField1.Text -gt 106)){ throw }
            if ( ([int]$BarometerField2.Text -lt 0) -or ([int]$BarometerField2.Text -gt 9)){ throw }
            
            # get upper value
            $UpperNumber = ([int]$BarometerField1.Text )

            # get lower value
            $LowerNumber = ([int]$BarometerField2.Text / 10)
            $Barometer = ((($UpperNumber + $LowerNumber)*10)-983)*2.953488372093023
        }

        if ($Barometer -gt 254){ $Barometer = 254 }
        if ($Barometer -lt 0){ $Barometer = 0 }

        $Barometer = [int]$Barometer
        $Barometer = [char]$Barometer
    }
    catch { $InputError = "Invalid input in Barometer box"  }


<# Convert Humidity ####################################################### #>
    try {
        if ( ([int]$HumidityField.Text -lt 0) -or ([int]$HumidityField.Text -gt 99)){ throw }
        $Humidity = $HumidityField.Text
        $Humidity = [int]$Humidity
        $Humidity = [char]$Humidity
    }
    catch { $InputError = "Invalid input in Humidity Box" }

<# Convert Rain ####################################################### #>


<# Send Data! ######################################################## #>
if (!$InputError){
        $COMPort = [string]$COMBox.text
        $StatusLabel.Text = "Opening Port..."
        $port= new-Object System.IO.Ports.SerialPort $COMPort,150,0,8,1
        $port.Encoding = [System.Text.Encoding]::GetEncoding(28591)
        $port.open()

        $Magic1 = [char]0xFF
        $Magic2 = [char]0xFA
        $Magic3 = [char]0xF5

        $Rain = [char]2
        $End=[char]0

        $Message = $Magic1+$Magic2+$Magic3+$Temperature+$WindDir+$Humidity+$WindSpeed+$Barometer+$Rain+$End+$End+$End+$End

        $StatusLabel.Text = "Sending..."
        $port.Write($Message)
        $port.Write($Message)

        $port.Close()
        $StatusLabel.Text = "Sent!" 
    }
    else { $StatusLabel.Text = $InputError }
}


<# Form Code #>

show-console -hide


$Column1X = 120
$Column2X = 170
$WinWidth = 480
$WinHeight = 280

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
$Form = New-Object system.Windows.Forms.Form
$Form.Text = "SpectraGen 4B Local WX" <# title bar #>
$Form.Width = $WinWidth
$Form.Height = $WinHeight

$Form.minimumSize = New-Object System.Drawing.Size($WinWidth,$WinHeight) 
$Form.maximumSize = New-Object System.Drawing.Size($WinWidth,$WinHeight) 

$Form.StartPosition = "CenterScreen"

$StandardsLabel = New-Object System.Windows.Forms.Label
$StandardsLabel.Text = "Standard"
$StandardsLabel.AutoSize = $true
$StandardsLabel.Location = New-Object System.Drawing.Point(10,15)
$Form.Controls.Add($StandardsLabel)

$StandardsBox = New-Object System.Windows.Forms.ComboBox
$StandardsBox.Location = New-Object System.Drawing.Point($Column1X,15)
$StandardsBox.Size = New-Object System.Drawing.Size(60,20)
$StandardsBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList;
$StandardsBox.Height = 80
[void] $StandardsBox.Items.Add('US')
[void] $StandardsBox.Items.Add('Metric')
$StandardsBox.SelectedIndex = 0
$form.Controls.Add($StandardsBox)

$COMLabel = New-Object System.Windows.Forms.Label
$COMLabel.Text = "COM Port
Machine is hard coded
to 150,8,N,1. Not all ports
support this speed."

$COMLabel.AutoSize = $true
$COMLabel.Location = New-Object System.Drawing.Point(240,15)
$Form.Controls.Add($COMLabel)

$COMBox = New-Object System.Windows.Forms.ComboBox
$COMBox.Location = New-Object System.Drawing.Point(240,95)
$COMBox.Size = New-Object System.Drawing.Size(60,20)
$COMBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList;
$COMBox.Height = 80

$ports = Get-WMIObject Win32_pnpentity | ? Caption -like "*(COM*"
foreach ($port in $ports){
    $port = [string]$port.Caption
    $start = $port.IndexOf("(")
    $end = $port.IndexOf(")")
    $len = $end - $start
    $name = $port.substring($start+1, $len-1)
    [void] $COMBox.Items.Add($name)
}

$COMBox.SelectedIndex = 0
$form.Controls.Add($COMBox)

$temperatureField = New-Object System.Windows.Forms.TextBox
$temperatureField.Location = New-Object System.Drawing.Point($Column1X,40)
$temperatureField.Size = New-Object System.Drawing.Size(40,20)
$Form.Controls.Add($temperatureField)

$TemperatureLabel = New-Object System.Windows.Forms.Label
$TemperatureLabel.Text = "Temperature"
$TemperatureLabel.AutoSize = $true
$TemperatureLabel.Location = New-Object System.Drawing.Point(10,40)
$Form.Controls.Add($TemperatureLabel)

$WindSpeedField = New-Object System.Windows.Forms.TextBox
$WindSpeedField.Location = New-Object System.Drawing.Point($Column1X,65)
$WindSpeedField.Size = New-Object System.Drawing.Size(40,20)
$Form.Controls.Add($WindSpeedField)

$WindSpeedLabel = New-Object System.Windows.Forms.Label
$WindSpeedLabel.Text = "Wind Speed"
$WindSpeedLabel.AutoSize = $true
$WindSpeedLabel.Location = New-Object System.Drawing.Point(10,65)
$Form.Controls.Add($WindSpeedLabel)

$WinDirField = New-Object System.Windows.Forms.ComboBox
$WinDirField.Location = New-Object System.Drawing.Point($Column1X,90)
$WinDirField.Size = New-Object System.Drawing.Size(60,20)
$WinDirField.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList;
$WinDirField.Height = 80
[void] $WinDirField.Items.Add('Calm')
[void] $WinDirField.Items.Add('N')
[void] $WinDirField.Items.Add('NE')
[void] $WinDirField.Items.Add('E')
[void] $WinDirField.Items.Add('SE')
[void] $WinDirField.Items.Add('S')
[void] $WinDirField.Items.Add('SW')
[void] $WinDirField.Items.Add('W')
[void] $WinDirField.Items.Add('NW')
$WinDirField.SelectedIndex = 0
$form.Controls.Add($WinDirField)

$WindDirLabel = New-Object System.Windows.Forms.Label
$WindDirLabel.Text = "Wind Direction"
$WindDirLabel.AutoSize = $true
$WindDirLabel.Location = New-Object System.Drawing.Point(10,90)
$Form.Controls.Add($WindDirLabel)

$HumidityField = New-Object System.Windows.Forms.TextBox
$HumidityField.Location = New-Object System.Drawing.Point($Column1X,115)
$HumidityField.Size = New-Object System.Drawing.Size(40,20)
$Form.Controls.Add($HumidityField)

$HumidityLabel = New-Object System.Windows.Forms.Label
$HumidityLabel.Text = "Humidity"
$HumidityLabel.AutoSize = $true
$HumidityLabel.Location = New-Object System.Drawing.Point(10,115)
$Form.Controls.Add($HumidityLabel)

$BarometerField1 = New-Object System.Windows.Forms.TextBox
$BarometerField1.Location = New-Object System.Drawing.Point($Column1X,140)
$BarometerField1.Size = New-Object System.Drawing.Size(40,20)
$Form.Controls.Add($BarometerField1)

$BarometerDot = New-Object System.Windows.Forms.Label
$BarometerDot.Text = "."
$BarometerDot.AutoSize = $true
$BarometerDot.Location = New-Object System.Drawing.Point(($Column2X-9),140)
$Form.Controls.Add($BarometerDot)

$BarometerField2 = New-Object System.Windows.Forms.TextBox
$BarometerField2.Location = New-Object System.Drawing.Point($Column2X,140)
$BarometerField2.Size = New-Object System.Drawing.Size(40,20)
$Form.Controls.Add($BarometerField2)

$BarometerLabel = New-Object System.Windows.Forms.Label
$BarometerLabel.Text = "Barometer"
$BarometerLabel.AutoSize = $true
$BarometerLabel.Location = New-Object System.Drawing.Point(10,140)
$Form.Controls.Add($BarometerLabel)

$StatusLabel = New-Object System.Windows.Forms.Label
$StatusLabel.Text = "Ready"
$StatusLabel.AutoSize = $true
$StatusLabel.Location = New-Object System.Drawing.Point(15,200)
$StatusLabel.Size = New-Object System.Drawing.Size(320,23)
$Form.Controls.Add($StatusLabel)

$Submit = New-Object System.Windows.Forms.Button
$Submit.Location = New-Object System.Drawing.Point(15,170)
$Submit.Size = New-Object System.Drawing.Size(120,23)
$Submit.Text = "Send"
$Submit.Add_Click($GoSerial)
$Form.Controls.Add($Submit)
$Form.TopMost = $true

$Form.ShowDialog()
