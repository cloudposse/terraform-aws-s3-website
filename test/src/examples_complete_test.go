package test

import (
	"math/rand"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

var letterRunes = []rune("abcdefghijklmnopqrstuvwxyz1234567890")

func RandStringRunes(n int) string {
	rand.Seed(time.Now().UnixNano())
	b := make([]rune, n)
	for i := range b {
		b[i] = letterRunes[rand.Intn(len(letterRunes))]
	}
	return string(b)
}

func TestExamplesComplete(t *testing.T) {
	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
	}

	terraform.Init(t, terraformOptions)
	// Run tests in parallel
	t.Run("Enabled", testExamplesCompleteEnabled)
	t.Run("Disabled", testExamplesCompleteDisabled)
}

// Test the Terraform module in examples/complete using Terratest.
func testExamplesCompleteEnabled(t *testing.T) {
	t.Parallel()

	testName := "s3-website-test-" + RandStringRunes(10)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
		Vars: map[string]interface{}{
			"name":     testName,
			"hostname": testName + ".testing.cloudposse.co",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	hostname := terraform.Output(t, terraformOptions, "hostname")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, testName+".testing.cloudposse.co", hostname)

	// Run `terraform output` to get the value of an output variable
	s3BucketName := terraform.Output(t, terraformOptions, "s3_bucket_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, testName+".testing.cloudposse.co", s3BucketName)

	// Run `terraform output` to get the value of an output variable
	s3BucketDomainName := terraform.Output(t, terraformOptions, "s3_bucket_domain_name")
	// Verify we're getting back the outputs we expect
	assert.Equal(t, testName+".testing.cloudposse.co.s3.amazonaws.com", s3BucketDomainName)
}

// Test the Terraform module in examples/complete using Terratest, but with the root module disabled.
func testExamplesCompleteDisabled(t *testing.T) {
	t.Parallel()

	testName := "s3-website-test-" + RandStringRunes(10)

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../examples/complete",
		Upgrade:      true,
		EnvVars: map[string]string{
			"TF_CLI_ARGS": "-state=terraform-disabled-test.tfstate",
		},
		// Variables to pass to our Terraform code using -var-file options
		VarFiles: []string{"fixtures.us-west-1.tfvars"},
		Vars: map[string]interface{}{
			"enabled":  "false",
			"name":     testName,
			"hostname": testName + ".testing.cloudposse.co",
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.Apply(t, terraformOptions)

	// Run `terraform output` to get the value of an output variable
	s3BucketDomainName := terraform.Output(t, terraformOptions, "s3_bucket_domain_name")
	// Verify we're getting back the outputs we expect
	assert.Empty(t, s3BucketDomainName)
}
