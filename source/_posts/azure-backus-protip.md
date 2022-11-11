---
title:  Removing Azure Backups in Terraform
 make note of the resource identifier
authorId: simon_timms
date: 2022-11-11
originalurl: https://blog.simontimms.com/2022/11/11/azure-backus-protip
mode: public
---



If you have a VM backup in your Terraform state and need to get rid of it be aware that it is probably going to break your [deployment pipeline](https://blog.simontimms.com/2022/11/01/theory-of-terraform-github.-actions/). The reason is that Terraform will delete the item but then find that the resource still there. This is because backup deletion takes a while (say 14 days). Eventually the backup will delete but not before Terraform times out. 

The solution I'm using is to just go in an manually delete the backup from the terraform state to unblock my pipelines. 

```bash
terraform state list | grep <name of your backup>

terraform state rm <found resource identifier>
```

Editing Terraform state seems scary but it's not too bad after you do it a bit. Take backups!