#! /bin/bash
# Purpose: Update Org Units for all users based on Group Membership.
# Note: Org units should always be updated in order of offices, masters, corporate, special.
#
# Usage:
# 1. Update California
/home/patrick/bin/gamadv-xtd3/gam update ou "/California" add group 
ca_all_users
/home/patrick/bin/gamadv-xtd3/gam update ou "/California" add group 
ca_master_users
# 2. Update Colorado
/home/patrick/bin/gamadv-xtd3/gam update ou "/Colorado" add group 
co_all_users
/home/patrick/bin/gamadv-xtd3/gam update ou "/Colorado" add group 
co_master_users
# 3. Update Florida
/home/patrick/bin/gamadv-xtd3/gam update ou "/Florida" add group 
se_all_users
/home/patrick/bin/gamadv-xtd3/gam update ou "/Florida" add group 
se_master_users
# 4. Update Indiana
/home/patrick/bin/gamadv-xtd3/gam update ou "/Indiana" add group 
indiana_all_users
/home/patrick/bin/gamadv-xtd3/gam update ou "/Indiana" add group 
indiana_master_users
# 5. Update Texas
/home/patrick/bin/gamadv-xtd3/gam update ou "/Texas" add group 
scent_all_users
/home/patrick/bin/gamadv-xtd3/gam update ou "/Texas" add group 
scent_master_users
# 6. Update Corporate
/home/patrick/bin/gamadv-xtd3/gam update ou "/Corporate" add group 
corporate_users
# 7. Remove users from other groups who need 2SV disabled
/home/patrick/bin/gamadv-xtd3/gam update ou "/2SV Disabled" add group 
2sv-disabled