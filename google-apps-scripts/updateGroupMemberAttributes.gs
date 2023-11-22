/**
 * Scheduled SSO Provisioning and Role Mapping Script for AWS QuickSight in Google Workspace
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
 * The script is hosted on GitHub and can be found here: https://github.com/patrickhaley/GJG-GAM-Scripts/blob/main/google-apps-scripts/updateGroupMemberAttributes
 */

function updateGroupMemberAttributes() {
  // Define the main group and the group used for exclusion.
  var mainGroupEmail = "main_group@yourdomain.com"; // Email of the main group to to find members.
  var excludeGroupEmail = "exclusion_group@yourdomain.com"; // Email of the group used for exclusion.

  // Role details to be assigned.
  var roleName =
    "arn_aws_iam_role,arn_aws_iam_idp"; // ARN for QuickSight roles; Manually add Author or Admin role to user to skip updates. See https://aws.amazon.com/blogs/big-data/configure-an-automated-email-sync-for-federated-sso-users-to-access-amazon-quicksight/
  var schemaName = "SSO"; // The name of the custom schema.
  var fieldName = "QuickSight"; // The field within the custom schema to be updated.

  // Fetch the members of the main group.
  var mainGroupMembers = AdminDirectory.Members.list(mainGroupEmail).members;
  // Fetch the members of the exclusion group.
  var excludeGroupMembers =
    AdminDirectory.Members.list(excludeGroupEmail).members;

  // Create a Set of email addresses for efficient lookup to check exclusion.
  var excludeEmails = new Set(
    excludeGroupMembers.map((member) => member.email)
  );

  // Check if the main group has members.
  if (!mainGroupMembers || mainGroupMembers.length === 0) {
    Logger.log("No members found in the main group.");
    return; // Exit if no members are found.
  }

  // Iterate over each member of the main group.
  mainGroupMembers.forEach((member) => {
    var userEmail = member.email; // Email address of the current member.

    // Skip the update process for members who are also in the exclude group.
    if (excludeEmails.has(userEmail)) {
      Logger.log(
        `${userEmail} is a member of ${excludeGroupEmail}, skipping update.`
      );
      return; // Continue to the next iteration.
    }

    // Retrieve detailed information of the user.
    var user = AdminDirectory.Users.get(userEmail);

    // Ensure that the custom schema structure is present for the user.
    user.customSchemas = user.customSchemas || {};
    user.customSchemas[schemaName] = user.customSchemas[schemaName] || {};

    // Update the QuickSight field in the custom schema with the new role.
    user.customSchemas[schemaName][fieldName] = [{ value: roleName }];
    AdminDirectory.Users.update(user, userEmail); // Apply the update to the user.
    Logger.log("Updated QuickSight Role for " + userEmail); // Log the update action.
  });
}