# VCU_Health_Hacks
2019 VCU Health Hacks Competition

Plan to build two apps. 
One. Patient Engagement
Use R's rtweet package to setup up a mailbox for users to tweet status to. Status can be based on prescriptions, diet, exercise, mental health, or any other topic provider/physician is interested in tracking.
Plan to create a data visualization using shape files in the form of a patient..with NLP and sentiment analysis feeding the various states/colors of the visualization.

Two. Pharmacogenomics lookup. 
Take a patient's prescription data from EHR and match to FDA's Clinical Pharmacogenomics Implementation Consortium (CPIC) Guidelines. https://cpicpgx.org/genes-drugs/
Using Ancestry.com DNA report for lookup to CPIC Guideline and then alert notification.
Plan to use a simple rshiny app for this.

AWS box setup for the analytics (RStudio) and hosting of applications.
Twitter interface for capturing tweets completed.
AWS Simple Email Service (SES) setup for receiving and processing Ancestry.com DNA extracts.

Need to do next:
1. Nodejs script to pull in EHR data to simulate Apple's patient portal API.
2. NLP logic for translating tweets to sentiment analysis and color states of visualization.
3. Shape files and visualization for Patient Engagement UI.
4. Rshiny UI for CPIC Card/mobile app.

Please find me if you would like to work on this over the next two days!!!


