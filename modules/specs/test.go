package test

import (
	"fmt"
	"testing"
	"time"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

func TestGCPModule(t *testing.T) {
	terraformOptions := &terraform.Options{
		TerraformDir: ".",
		Vars: map[string]interface{}{
		},
	}

	defer func() {
		terraform.Destroy(t, terraformOptions)
	}()
	terraform.Init(t, terraformOptions)
	terraform.Apply(t, terraformOptions)

	publicIp := terraform.Output(t, terraformOptions, "aws_web_master_ip")

	url := fmt.Sprintf("http://%s", publicIp)

	maxRetries := 30
	timeBetweenRetries := 5 * time.Second

	http_helper.HttpGetWithRetryWithCustomValidation(t, url, maxRetries, timeBetweenRetries, validate)
	//http_helper.HttpGetWithRetry(t, url, nil, 200, "Hello, World!", 30, 5*time.Second)
}

func validate(status int, _ string) bool {
	return status == 200
}