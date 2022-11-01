---
title:  Dealing with Set-Output Depreciation Warnings in Terraform github-actions
authorId: simon_timms
date: 2022-11-01
originalurl: https://blog.simontimms.com/2022/11/01/set-output-terraform
mode: public
---



I've got a build that is running terraform on github actions (I actually have loads of them) and I've been noticing that they are very chatty about warnings now. 

![](/images/2022-11-01-set-output-terraform.md/2022-11-01-06-46-18.png))

The warning is 

```
The `set-output` command is deprecated and will be disabled soon. Please upgrade to using Environment Files. For more information see: https://github.blog/changelog/2022-10-11-github-actions-deprecating-save-state-and-set-output-commands/
```

The history here without reading that link is basically that github are changing how we push variables to the pipeline for use in later steps. There were some security implications with the old approach and the new approach should be better

```yml
- name: Save variable
  run: echo "SOMENAME=PICKLE" >> $GITHUB_STATE

- name: Set output
  run: echo "SOMENAME=PICKLE" >> $GITHUB_OUTPUT
  ```

  Problem was that the steps on which I was having trouble didn't obviously use the `set-output` command. 
  
  ```yml
 ...
- name: Init Terraform
  run: terraform init 
- name: Validate Terraform
  run: terraform validate
...        
```
  
  I had to dig a bit to find out that it was actually the `terraform` command that was causing the problem. See as part of the build I install the terraform cli using the 

  ```yml
  - name: HashiCorp - Setup Terraform
    uses: hashicorp/setup-terraform@v2.0.2
    with:
        terraform_version: 1.1.9
        terraform_wrapper: true
```

Turns out that as of writing the latest version of the wrapper installed by the setup-terraform task makes use of an older version of the `@actions/core` package. This package is what is used to set the output and before version 1.10 it did so using `set-output`. A fix has been merged into the setup-terraform project but no update released yet. 

For now I found that I had no need for the wrapper so I disabled it with 

```yml
  - name: HashiCorp - Setup Terraform
    uses: hashicorp/setup-terraform@v2.0.2
    with:
        terraform_version: 1.1.9
        terraform_wrapper: false
```

but for future readers if there is a more recent version of setup-terraform than 2.0.2 then you can update to that to remove the warnings. Now my build is clean 

![](/images/2022-11-01-set-output-terraform.md/2022-11-01-06-57-27.png))
