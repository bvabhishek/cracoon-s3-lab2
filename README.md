## Let's Now check how we can attack the bucket created by Bob 

* Unravel the Mystery of "misconfiguredacl":

Venture into the kingdom of "misconfiguredacl," where Authenticated Users gained unintended FULL_CONTROL permissions. Engage in the lab to unravel the mystery, understand ACL misconfigurations, and fortify your buckets against unauthorized access.


# Follow the below instructions given to solve this Lab

```

* Step 1 Clone the repository 

```bash
git clone https://github.com/bvabhishek/cracoon-s3-lab2.git
```
* Step 2: Change Directory

```bash
cd cracoon-S3-lab2/
```
* Step 3: Initialise terraform 

```bash
terraform init
```

* Step 4: Run `terraform apply -auto-approve`

```bash
terraform apply -auto-approve
```

* Step 5: Export bucket name created by Bob 

```bash
export s3bucket=<bucketname> 
```

* Step 6: Lets try to enumerate the bucket if its open to world

```bash
aws s3 ls s3://$s3bucket --no-sign-request

```

* Step 7: Now, since we know there is access control being placed, Lets try using our own AWS credentials to check it

```bash
aws configure 
```
Note: It should look something like below or default user creds also works for this lab
$ aws configure --profile User1
        AWS Access Key ID [****************TASE]: AKIAWRMAXKKJHASDQWE
        AWS Secret Access Key [****************4JqH]: HF6RSqXN+0vNZbI345sdfbxvx6c0yS1qin
        Default region name: `us-west-2` (Please use `us-west-2` region for this lab)
        Default output format: `json`


* Step 8: Lets try to list the objects 

```bash
aws s3 ls s3://$s3bucket
```
if profile is created

```bash
aws s3 ls s3://$s3bucket --profile ProfileName
```


* By this we know that the Bob has created some security control - Access Control List in place to protect the bucket from being accessed by any user but unaware that bucket with ACL AuthenticatedUser group can accessed by any user with AWS credentials. which leads to Vulnerabilities such as 

* Broken Authentication
* Sensitive Information Disclosure 
