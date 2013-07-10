Param([string]$solutionName = "TeamDynamixWebParts.wsp",
      [string]$webAppName = "http://tdsharepoint")

# get a reference to the solution
$sln = Get-SPSolution $solutionName

function Get-ScriptDirectory
{
  $Invocation = (Get-Variable MyInvocation -Scope 1).Value
  Split-Path $Invocation.MyCommand.Path
}

function WaitForJob($solution, $message) {
  $timeout = 120
  $counter = 0

  while ($solution.JobExists -and $counter -lt $timeout) {

    echo " > $message..."
    start-sleep -s 5
    $counter += 5
  }

  if ($counter -ge $timeout) {
    Throw " ERROR: Timeout $message."
  }
}

if ($sln -ne $null) {
  # uninstall the solution from appplications
  Uninstall-SPSolution -Identity $solutionName -WebApplication $webAppName -Confirm:$false

  echo "Started solution retraction..."
  WaitForJob $sln "Retraction in progress"

  # remove the solution from SharePoint
  Remove-SPSolution $solutionName -Confirm:$false

  echo "Started solution removal..."
  WaitForJob $sln "Removal in progress"
}

# add the soltuion back to SharePoint
echo "Started adding solution..."
$solutionPath = Get-ScriptDirectory
$solutionpath += "\$solutionName"
$newSln = Add-SPSolution -Literal $solutionPath

# deploy the solution to all applications
$newSln | Install-SPSolution -GACDeployment -AllWebApplications

echo "Started solution installation..."
WaitForJob $newSln "Installation in progress"