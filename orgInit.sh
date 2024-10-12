sf demoutil org create scratch -f config/project-scratch-def.json -d 2 -s -p concierge -e de.mo
sfdx force:package:install --package 04t4P000002qm6f --noprompt --wait 50

# to get access to audit field create
sf project deploy start -p securityStuff/
# give the admin knowledge permission
sf data update record -s User -w "Name='User User'" -v "UserPermissionsKnowledgeUser=true"

sf project deploy start
sf org assign permset -n solutions

# add a background option to settings
sf data create record -s cncrgdemo2__Background_Settings__c -v "cncrgdemo2__Background_File_Type__c=Image cncrgdemo2__File_Location__c=newBackground Name=NewBackground"
sf data bulk upsert -f data/Knowledge__kav.csv -i id -s Knowledge__kav --wait 30

sf apex run -f scripts/conciergeSetup.cls
sf automig load -d data2

sfdx shane:data:favorite -o Knowledge__kav -w "title='Flickering Monitor'"
sfdx shane:listview:favorite -t Open_IT_Tickets -o Case
sfdx shane:listview:favorite -t published_articles -o Knowledge__kav -l "Published Articles" 
sfdx shane:tab:favorite -t cncrgdemo2__Cadalys_Concierge -l "Concierge in Lightning"
sfdx shane:tab:favorite -t cncrgdemo2__Concierge_Settings -l "Concierge Settings"

sf org open -p lightning/n/cncrgdemo2__Cadalys_Concierge
