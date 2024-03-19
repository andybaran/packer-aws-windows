packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
    windows-update = {
      version = " >= 0.14.1"
      source  = "github.com/rgl/windows-update"
    }
  }
}

locals { 
  timestamp = regex_replace(timestamp(), "[- TZ:]", "") 
  }

// Cloud Specific Settings to enable builds
source "amazon-ebs" "windows" {
  ami_name              = "windows-packer-${local.timestamp}"
  instance_type         = "t2.medium"
  region                = var.region
   source_ami_filter {
    filters = {
      name                = "Windows_Server-2022-English-Full-Base-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  //These will essentially delete the current version of the resulting AMI along with it's snapshots each time a Packer build is run
  force_deregister      = true
  force_delete_snapshot = true

  tags = {
    Base_AMI_ID   = "{{ .SourceAMI }}"
    Base_AMI_Name = "{{ .SourceAMIName }}"
  }

  snapshot_tags = {
    Name    = "Windows 2022 Base"
    purpose = "Boundary team RDP testing"
  }

// Communicator Settings and Credentials
  user_data_file = "./bootstrap_win.txt"
  communicator   = "winrm"
  winrm_use_ssl = "true"
  winrm_insecure = "true"
  winrm_timeout = "6m"
  winrm_username = "Administrator"

}

build {
  name    = "windows-packer-${local.timestamp}" //ToDo: There has to be a better way to reference this value as it appearso n line 18
  sources = ["source.amazon-ebs.windows"]
  /* HCP Packer not needed at this time
  hcp_packer_registry {
    bucket_name = "windows"
    description = "Windows Server Golden Images for use in Production."

    bucket_labels = {
      "team" = "Windows Admin Team"
    }
    build_labels = {
      "os-version" = "Desktop Experience"
      "os"         = "Server 2022"
      "build-time" = timestamp()
    }
  }
*/

  /* Uncomment this to install the latest updates as part of the image build process
  provisioner "windows-update" {
    pause_before    = "30s"
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*VMware*'",
      "exclude:$_.Title -like '*Preview*'",
      "exclude:$_.Title -like '*Defender*'",
      "exclude:$_.InstallationBehavior.CanRequestUserInput",
      "include:$true"
    ]
    restart_timeout = "120m"
  }
  */

  /* Install Chocolately image manager and  set OOBE
  provisioner "powershell" {
    inline = ["Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))",
                "if( Test-Path $Env:SystemRoot\\windows\\system32\\Sysprep\\unattend.xml ){ rm $Env:SystemRoot\\windows\\system32\\Sysprep\\unattend.xml -Force}",
                "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
                "while($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; Write-Output $imageState.ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Start-Sleep -s 10 } else { break } }"]
  }
  */
}