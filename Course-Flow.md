# PL - 900 Table of Contents

## Session 1

### Power Platform Intro

* Pricing guide
* Admin portal
  * Environments
  * On-prem data gateway
  * DLP policies
* Groups
  * Create Azure AD group

### Power Apps

* MS Access
  * Components
* Dataverse
  * New tables
    * Relationships
  * Import
* Create Device Model canvas app
  * Publish & share
* Model-driven app
* Portal app
  * Authentication
* AI Builder
  * Train form model
* Mobile app

### Power Automate

* Logic Apps
* Cloud flows w/ AI Builder
* Desktop apps
  * Power Automate Desktop
  * On-Prem Gateway

### Cert Prep

* Practice questions
  * Item types analysis
* Practice exam review
* Cloud labs




















## Session 2

### Review

* Button flow
  * My Text input
  * Translate text into another language
  * Send me an email notification
    * Subj: Detected language
    * Body: Text
* AI Builder form recognizer
  * Train up model
  * Create flow that calls model
    * Instant flow (Form File Content)
    * Process and save information from forms
    * Send an email notification
      * INVOICE value, confidence score From value
* CertBot Flow
  * Power Virtual Agents trigger (text Input, Email input from user)
  * Send an email notification v3

### Power Virtual Agents

* Create CertBot
  * Topic "CertInfo"
    * Triggers: cert, certs, certifications, help, testing, exam
    * Message with question choices: Azure, Microsoft 365, Power Platform
      * save response as certchoice
    * Question: What's your email identify email, then (emailVar)
    * PVA action
      * Input (text) gets value from emailVar
    * Message we sent message to emailVar
    * end conversation
    * handoff
  * Test
  * Monitor
  * Channels
  * Add chatbot to portal app

### Power BI

* Show Azure dashboards
* * Import CSVS
* change date format; remove first column
* Model tab > Create relationship
  * Country_Name and Country_Region
* Stacked bar chart
  * Axis (Country_Region)
  * Values (Confirmed)
  * Filter Confirmed, filter type Top 10 by value Confirmed
* Pie chart
  * Legend (Country_Region)
  * Values (Active)
  * Filter Active, filter type Top N (10), by value Active Apply
* Publish
* Create Dashboard

* Create report in the cloud
  * Filled map
  * 12-31 Lat & Long_ to Lat and Long fields
  * Location: Country_Region
  * Legend: Incident_Rate

* Add Power BI tile to canvas app
* Add dashboard to model-driven app


### Exam Prep

* Practice questions
* Online testing
*




























