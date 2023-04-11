# Getting Started with Github Actions

This example tutorial shows three big ways of running jobs in github actions

## Using another github action

The easiest way to run a job is with an action already made, there are three types of actions:
- Officially made by github in "actions/"
- Action made by a verified marketplace user
- Third party actions

### Official
The most common action you will probably use is the checkout action that checkout your repository in your runner
```YAML
- uses: actions/checkout@v3
```
An action for seting up node js, the with keyword allow you to specify arguments for the actions, in this case the node version
```YAML
 - name: Use Node.js ${{ matrix.node-version }}
   uses: actions/setup-node@v3
   with:
     node-version: ${{ matrix.node-version }}
```

      
### Verified

Made by AWS to configure your credentials, starting with aws-actions instead of just actions
```YAML
- name: Configure AWS credentials
  uses: aws-actions/configure-aws-credentials@v1
  with:
    aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
    aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
    aws-region: 'eu-central-1'
```

## Manual bash scripting

The easiest way directly write bash to run some commands:
```YAML
run: echo "Hello World!"
```
codeQL is a security tool for discovering vulnerabilities and we want to install and run it using bash commands.  

In this example:
- Download and unzip codeQL
- Use the codeQL executable to download a codeQL extensions for javascript
- Create a database for our code located in src/
- Analyse the database to check if there is any vulnerabilities
```YAML
  codeql:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v2
      - name: Install dependencies
        run: |
            wget -q https://github.com/github/codeql-cli-binaries/releases/download/v2.12.3/codeql-linux64.zip
            unzip codeql-linux64.zip
              
      - name: CodeQL for js  
        run: |
           ./codeql/codeql pack download codeql/javascript-queries
           ./codeql/./codeql database create -l javascript ./db -s src/
            
      - name: CodeQL analysis 
        run: ./codeql/./codeql database analyze --format=CSV --output=output.csv db
```

## Running local actions

You can make [custom actions](https://docs.github.com/en/actions/creating-actions/about-custom-actions) using [Docker](https://docs.github.com/en/actions/creating-actions/creating-a-docker-container-action) or [Javascript](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action):

In this cases you specify directly the local directory where the action is located
```YAML
- name: Use whispers in docker
  uses: ./WhispersModule/
```

Inside the WhispersModule directory:

action.yml with metadata about your action:
```YAML
name: "Whispers"
description: 'Simple whispers checking for leaked secrets'
author: 'Epita GDSC <gdsc.epita@gmail.com>'
runs:
  using: docker
  image: Dockerfile
```
It needs a dockerfile:
```Dockerfile
FROM python:3.8

ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
```

An entrypoint script where you can put whatever bash commands / running other executables:
```bash
#!/bin/sh -l
pip install whispers
output=$(whispers src/)
if [ "$output" = "[]" ]
then
	exit 0
fi
echo "Whispers error: $output"
exit 1
```
Warning don't forget to make it an executable or else you will get a permission error:
```bash
$ git add entrypoint.sh
$ git update-index --chmod=+x entrypoint.sh
```
