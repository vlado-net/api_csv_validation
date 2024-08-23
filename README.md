# Data Validation Script

This repository contains a Bash script that validates data in a CSV file against data retrieved from a JSON API. The script is designed to be run in a Unix-like environment, such as macOS or Linux.

## Prerequisites

Before running the script, ensure you have the following installed on your system:

- **Bash**: The script is written in Bash, which is typically installed by default on Unix-like systems.
- **jq**: A command-line JSON processor that is used in the script to parse API responses.

You can install `jq` on macOS using Homebrew:

```bash
brew install jq
```

## Usage

### 1. Make the Script Executable

First, navigate to the directory where the script is located and make the script executable:

  ```bash
  chmod +x script.sh
  ```

### 2. Running the Script

You can run the script by providing a numeric argument that corresponds to the `id` you want to validate. The script accepts values between `1` and `10`.

  ```bash
  bash script.sh <number>
  ```

Replace `<number>` with the ID you want to validate.

### Example Commands

- To validate the data for ID `1`:

  ```bash
  bash script.sh 1
  ```

## Script Details

The script performs the following actions:

1. **Validates Input**: Ensures that a numeric argument is provided and that it falls within the range of 1 to 10.
2. **Reads the CSV File**: Searches for a row in `data_source.csv` where the `id` matches the provided number.
3. **Calls the API**: Retrieves data from the API endpoint `https://jsonplaceholder.typicode.com/comments/<number>` where `<number>` is the provided ID.
4. **Compares Data**: Compares the data from the CSV with the API response, checking `postId`, `name`, `email`, and `body`.
5. **Outputs Results**: The script prints whether the validation is successful or not for each field.

## Troubleshooting

- **Permission Denied**: If you encounter a "Permission denied" error, make sure the script is executable using `chmod +x script.sh`.
- **jq Not Found**: If `jq` is not installed, you can install it using Homebrew:

  ```bash
  brew install jq
  ```

- **File Not Found**: Ensure that the `data_source.csv` file is located in the same directory as the script or provide the correct path to the file in the script.

## Continuous Integration/Continuous Deployment (CI/CD)

Inside the `.github/workflows` directory, a file named `validate-data.yml` is located.

## Explanation of Workflow

**Triggering Events**: The workflow is triggered on every push or pull request to the `master` branch.

**Job Definition**: The validate job runs on the ubuntu-latest environment.

**Steps:** 
1. **Checkout the Repository**: Uses the `actions/checkout@v3` action to clone your repository.
2. **Set up `jq`**: Installs `jq` on the runner.
3. **Run the Validation Script**: Grants execution permission to `script.sh` file and runs it with an argument (e.g., 2). 

GitHub Actions will automatically run the workflow whenever a push or pull request is made to `master` branch.

**Monitoring**: GitHub Actions provides a detailed log for each workflow run, allowing to monitor and debug any issues.

**Notifications**: Can be configured for failed runs so that the team is alerted to the issues immediately.

