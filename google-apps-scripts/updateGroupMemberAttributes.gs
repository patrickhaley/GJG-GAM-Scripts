/**
 * Automatically updates AWS QuickSight roles for users in a specific Google Workspace group,
 * while excluding members of another group. This script is intended to facilitate SSO integration 
 * with AWS QuickSight.
 *
 * This script, designed to be run on a schedule within Google Apps Script, automates the provisioning
 * of user access to AWS QuickSight through SSO. Detailed in the AWS blog
 * (https://aws.amazon.com/blogs/big-data/configure-an-automated-email-sync-for-federated-sso-users-to-access-amazon-quicksight/),
 * it syncs IAM role and IdP information to users within a specific Google Workspace group, excluding
 * members of another designated group. This is part of the SSO access setup required in QuickSight.
 *
 * Primarily, the script assigns the 'QuickSight-Reader-Role' to user profiles, mapping ARNs for the IAM user
 * role and ARN Identity Provider to the required PrincipalTag:Email, facilitating automated user email
 * creation in QuickSight SSO. For other access levels, such as 'QuickSight-Author-Role' or 'QuickSight-Admin-Role',
 * manual updates can be made in Google Workspace Directory settings under the SSO QuickSight schema.
 *
 * The script is meant to be run on a recurring schedule, ensuring continuous updates for new users. This
 * automated approach is crucial for large organizations where manual provisioning is inefficient.
 *
 * Ensure the IdP and roles are correctly configured as per AWS documentation:
 * https://docs.aws.amazon.com/quicksight/latest/user/jit-email-syncing.html.
 *
 * The script is hosted on GitHub and can be found here: https://github.com/patrickhaley/GJG-GAM-Scripts/blob/main/google-apps-scripts/updateGroupMemberAttributes.gs
 */

function updateGroupMemberAttributes() {
  // Define the email addresses of the main group and the exclusion group.
  var mainGroupEmail = "PRIMARY_GROUP@YOURDOMAIN.COM"; // Main group to process.
  var excludeGroupEmail = "EXCLUSION_GROUP@YOURDOMAIN.COM"; // Exclusion group.

  // Define the role ARN to be assigned to the users.
  var roleName = "AWS_IAM_ROLE_ARN,AWS_IAM_IDP_ARN";

  // Schema and field name in Google Workspace Directory for QuickSight role.
  var schemaName = "SSO";
  var fieldName = "QuickSight";

  // Fetch members of the main group and the exclusion group.
  var mainGroupMembers = AdminDirectory.Members.list(mainGroupEmail).members || [];
  var excludeGroupMembers = AdminDirectory.Members.list(excludeGroupEmail).members || [];

  // Create a Set for quick lookup of exclusion group members.
  var excludeEmails = new Set(excludeGroupMembers.map((member) => member.email));

  // Iterate over each member of the main group.
  mainGroupMembers.forEach((member) => {
    var userEmail = member.email; // Email of the current member.

    // Check if the member is part of the exclusion group.
    if (excludeEmails.has(userEmail)) {
      console.log(userEmail + " is already in the exclusions group, skipping.");
      return; // Skip updating this member.
    }

    try {
      // Retrieve the user's current Google Workspace profile details.
      var user = AdminDirectory.Users.get(userEmail);

      // Prepare or update the custom schema for QuickSight role assignment.
      var customSchemas = user.customSchemas || {};
      customSchemas[schemaName] = customSchemas[schemaName] || {};
      customSchemas[schemaName][fieldName] = [{ value: roleName }]; // Set the role.

      // Update the user profile in Google Workspace Directory with the new role.
      AdminDirectory.Users.update({ customSchemas: customSchemas }, userEmail);
      console.log("Updated QuickSight Role for " + userEmail);
    } catch (e) {
      // Log errors if the updating process fails.
      console.log("Error updating " + userEmail + ": " + e.message);
    }
  });
}