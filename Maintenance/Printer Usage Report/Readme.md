# Printer Usage Report
Version 2, November 2018, James Pearman

## Purpose
This script generates a report on printer usage from a print server on printers using a particular IP range.The script generates a report from the operational printer event logs, saves them as a .csv and emails that report to the address you enter it to go to.

## What you Need
Make sure you have operation print event logging enabled and the log file is big enough for your needs.

## Changes from V1
The following has been added:
- Ability to email reports
- Use of IP range as opposed to printer name
- Interactive date input for the start and end of the report instead of editing the script.
