# Workflow 2: Steps to publish a package workflow

## Add a workflow that publishes an PyPy package and creates
1. Register a test.pypy account: https://test.pypi.org/account/register/ and add an API Token in your account https://test.pypi.org/manage/account/
2. **Setting -> Secrets and variables -> Actions -> New Repository Secret**: Add a new repository secret in your repository with the name **TEST_PYPI_API_TOKEN**  
3. Add a workflow file at this directory `.github/workflows/release.yml`:
    - Checkout
    - Set up python
    - Install build dependencies `setuptools wheel build` 
    - Publish the package to pypy with this actions `pypa/gh-action-pypi-publish@release/v1` with password and repository_url (https://test.pypi.org/legacy/)

    
        <details>
        <summary><b>Click here to view file contents to copy:</b></summary>
        </br>

      ```yaml
      # This workflow will create a PyPy package

      name: Publish

      on:
        push:
          # branches to consider in the event; optional, defaults to all
          branches:
            [master, main]

      jobs:
        build-and-publish:
          runs-on: ubuntu-latest
          steps:
            - name: Checkout
              uses: actions/checkout@v2
            
            - name: Set up Python
              uses: actions/setup-python@v1
              with:
                python-version: '3.x'
            - name: Install build dependencies
              run: python -m pip install -U setuptools wheel build
            - name: Build a binary wheel and a source tarball
              run: >-
                python -m
                build
                --sdist
                --wheel
                --outdir dist/
                .
            - name: Publish distribution 📦 to Test PyPI
              uses: pypa/gh-action-pypi-publish@release/v1
              with:
                password: ${{ secrets.TEST_PYPI_API_TOKEN }}
                repository_url: https://test.pypi.org/legacy/
      ```
    </details>



## Watch your actions come to life!

1. Merge the pull request and check that your workflow completes successfully
2. Check on the `Action` tab that the release action has completed
3. Check on pypy that your package is visible

## Use your package

You can now download and use your python package:  
`python3 -m pip install --index-url https://test.pypi.org/simple/ your-package`
```python
import example.simple
print(example.simple.say("Hello"))
```


