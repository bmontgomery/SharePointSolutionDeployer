# SharePoint Solution Deployer

This PowerShell script helps you deploy SharePoint solutions. It will retract, remove, add, and re-deploy solutions in one script.

## Usage

Place this script alongside a SharePoint Solution WSP file.

Open SharePoint Management Shell. Change to the directory which holds the deploy.ps1 script and the SharePoint Solution WSP file. Run the following command:

    .\deploy.ps1 -SolutionName MySharePointSolution -WebAppName http://sharepointserver

This will uninstall the current solution (if it is already installed) and install the WSP in its place.
