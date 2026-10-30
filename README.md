# Closed-Loop Autonomous Tier-1 Service Desk Remediation

**Student:** Gospel Achuenu  
**Degree:** BSc (Hons) Information Technology, Teesside University  
**Supervisor:** Mansha Nawaz  
**Project Ethics ID:** 36399 (Category 1)

## Project Overview
This repository contains the architecture assets, database definitions, synthetic evaluation datasets, and allowlisted remediation runbooks for the undergraduate dissertation: *Investigation into the Efficacy, Security, and Latency of Closed-Loop Autonomous Tier-1 Service Desk Remediation in Hybrid Enterprise Environments*.

## Core MVP Scope
- **Identity & Access Governance:** Parameter-validated Active Directory account unlock gated by time-bound email OTP verification challenges.
- **Endpoint Maintenance:** Automated client storage purge targeting allowlisted transient directories (`$env:TEMP`, `C:\Windows\Temp`, `SoftwareDistribution\Download`) with reclaimed megabytes and return codes logged to SQL.
- **Execution Architecture:** Host-only Windows 10 Pro VM sandbox with least-privilege service accounts and strict `.ps1` allowlisting.

## Repository Contents
- `/database`: 3NF relational schemas for users, incident tracking, audit trails, and internal runbook mappings.
- `/scripts`: Pre-approved, allowlisted PowerShell runbooks executed via Power Automate.
- `/dataset`: Synthetic Mockaroo test datasets (100-incident benchmark across MVP scenarios).
