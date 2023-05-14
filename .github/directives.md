
### Directive 
A directive is a specific keyword or construct used to define the structure and behavior of a workflow

### Parameter
A parameter refers to a configurable value that is provided as input to a directive or action. Parameters allow you to customize the behavior of workflows and actions based on specific requirements.
    
    - `runs-on` is a parameter rather than a directive in GitHub Actions. It is used within the jobs directive to specify the type of virtual environment or runner on which a job will execute. The runs-on parameter allows you to define the operating system and version, such as ubuntu-latest, windows-latest, or macos-latest, for the job to run on.

    Here's an example of how runs-on is used within the jobs directive:

        ```
        jobs:
        build:
            runs-on: ubuntu-latest
            steps:
            - name: Checkout repository
                uses: actions/checkout@v2
            - name: Build
                run: npm run build
        ```

## Directives

### name: The name directive is used to provide a descriptive name for a step or a job in a workflow. It helps in identifying and distinguishing different steps or jobs in the workflow. For example:


```
steps:
  - name: Build
    run: npm run build
```

### on: The on directive is used to define the events that will trigger the workflow. It specifies the event(s) that will initiate the execution of the workflow. For example, push, pull_request, or a specific branch. Multiple events can be specified using an array. For example:

```
on:
  push:
    branches:
      - main
```

### jobs: The jobs directive is used to define one or more jobs in a workflow. Each job represents a set of steps that should be executed in parallel or sequentially. Jobs can be used to perform different tasks or stages of the workflow. For example:

```
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repository
        uses: actions/checkout@v2
      - name: Build
        run: npm run build
```

### steps: The steps directive is used to define a sequence of steps that should be executed within a job. Each step represents an individual task or action to be performed. Steps can include commands, scripts, or other actions. For example:

```
steps:
  - name: Checkout repository
    uses: actions/checkout@v2
  - name: Build
    run: npm run build
```

### env: The env directive is used to define environment variables that can be accessed during the execution of the workflow. It allows you to set environment-specific configurations or pass sensitive information securely using GitHub Secrets. For example:

```
env:
  MY_VARIABLE: some-value
  API_KEY: ${{ secrets.API_KEY }}
```

### if: The if directive is used to conditionally execute a step or a job based on a specified condition. It allows you to control the flow of the workflow based on certain criteria. The condition can be an expression that evaluates to either true or false. For example:

```
steps:
  - name: Build
    run: npm run build
    if: env.BRANCH == 'main'
```

### run: The run directive is used to define the shell commands or scripts to be executed within a step. It allows you to run arbitrary commands or scripts as part of the workflow. For example:

```
steps:
  - name: Build
    run: npm run build
```

### uses: The uses directive is used to include an external action or a reusable action defined in a repository. It allows you to leverage pre-existing actions or custom actions in your workflow. The uses directive specifies the repository and the path to the action. For example:

```
steps:
  - name: Use external action
    uses: actions/setup-node@v2
```