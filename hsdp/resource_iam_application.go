package hsdp

import (
	"github.com/hashicorp/terraform/helper/schema"
	"github.com/hsdp/go-hsdp-api/iam"
)

func resourceIAMApplication() *schema.Resource {
	return &schema.Resource{
		Importer: &schema.ResourceImporter{
			State: schema.ImportStatePassthrough,
		},

		Create: resourceIAMApplicationCreate,
		Read:   resourceIAMApplicationRead,
		Update: resourceIAMApplicationUpdate,
		Delete: resourceIAMApplicationDelete,

		Schema: map[string]*schema.Schema{
			"name": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
			"description": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
			"proposition_id": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
			"global_reference_id": &schema.Schema{
				Type:     schema.TypeString,
				Required: true,
			},
		},
	}
}

func resourceIAMApplicationCreate(d *schema.ResourceData, m interface{}) error {
	client := m.(*iam.Client)
	var app iam.Application
	app.Name = d.Get("name").(string)
	app.Description = d.Get("description").(string)
	app.PropositionID = d.Get("proposition_id").(string)
	app.GlobalReferenceID = d.Get("global_reference_id").(string)

	createdApp, _, err := client.Applications.CreateApplication(app)
	if err != nil {
		return err
	}
	d.SetId(createdApp.ID)
	d.Set("name", createdApp.Name)
	d.Set("description", createdApp.Description)
	d.Set("proposition_id", createdApp.PropositionID)
	d.Set("global_reference_id", createdApp.GlobalReferenceID)
	return nil
}

func resourceIAMApplicationRead(d *schema.ResourceData, m interface{}) error {
	client := m.(*iam.Client)

	id := d.Id()
	app, _, err := client.Applications.GetApplicationByID(id)
	if err != nil {
		return err
	}
	d.Set("name", app.Name)
	d.Set("description", app.Description)
	d.Set("proposition_id", app.PropositionID)
	d.Set("global_reference_id", app.GlobalReferenceID)
	return nil
}

func resourceIAMApplicationUpdate(d *schema.ResourceData, m interface{}) error {
	if !d.HasChange("description") {
		return nil
	}
	client := m.(*iam.Client)
	var app iam.Application
	app.ID = d.Id()
	app.Description = d.Get("description").(string)
	_, _, err := client.Applications.UpdateApplication(app)
	if err != nil {
		return err
	}
	return nil
}

func resourceIAMApplicationDelete(d *schema.ResourceData, m interface{}) error {
	return nil
}
