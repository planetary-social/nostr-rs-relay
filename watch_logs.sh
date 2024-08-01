#!/bin/bash
date
ssh admin@olympics2024.nos.social "sudo tail -f /var/log/syslog " | grep strfry
