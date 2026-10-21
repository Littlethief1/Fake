function Show-Notification {
    [cmdletbinding()]
    Param (
        [string]$ToastTitle,
        [string]$ToastText,
        [string]$ImageFileName
    )

    [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime] > $null
    
    $Template = [Windows.UI.Notifications.ToastNotificationManager]::GetTemplateContent([Windows.UI.Notifications.ToastTemplateType]::ToastImageAndText02)
    
# Ensure it falls back to the current directory if $PSScriptRoot is empty
    $ScriptDir = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Definition }
    $FullPath = Join-Path $ScriptDir $ImageFileName

    # Set the Image path node
    $ImageNode = $Template.GetElementsByTagName('image').Item(0)
    $ImageNode.SetAttribute('src', $FullPath) > $null

    # Set the Title and Text nodes safely
    $TextNodes = $Template.GetElementsByTagName('text')
    $TextNodes.Item(0).AppendChild($Template.CreateTextNode($ToastTitle)) > $null
    $TextNodes.Item(1).AppendChild($Template.CreateTextNode($ToastText)) > $null

    $Toast = [Windows.UI.Notifications.ToastNotification]::new($Template)
    $Toast.Tag = "PowerShell"
    $Toast.Group = "PowerShell"
    
    $AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
    $Notifier = [Windows.UI.Notifications.ToastNotificationManager]::CreateToastNotifier($AppId)
    $Notifier.Show($Toast)
}


Show-Notification -ToastTitle "Your device's security is comprimised" -ToastText "Access to this PC has been blocked" -ImageFileName "Notif.png"
