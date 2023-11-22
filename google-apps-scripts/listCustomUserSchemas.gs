/**
 * Lists all custom user schemas in the Google Workspace domain.
 * 
 * This script is used to retrieve and log all custom user schemas defined in the Google Workspace domain.
 * It is helpful for administrators who need to manage or review custom schema configurations,
 * such as checking the structure or existence of specific schemas.
 */
 
function listCustomUserSchemas() {
  var customerID = 'CUSTOMER_ID'; // Replace with your specific customer ID

  // Retrieve the list of custom schemas for the given customer ID
  var schemas = AdminDirectory.Schemas.list(customerID);
  
  // Check if any custom schemas are found
  if (schemas.schemas && schemas.schemas.length > 0) {
    Logger.log('Custom Schemas:');
    // Iterate through each schema and log its details
    for (var i = 0; i < schemas.schemas.length; i++) {
      var schema = schemas.schemas[i];
      Logger.log(schema.schemaName + ' (' + schema.schemaId + '):');
      Logger.log(JSON.stringify(schema, null, 2)); // Pretty print the schema object
    }
  } else {
    // Log if no custom schemas are found
    Logger.log('No custom schemas found.');
  }
}
