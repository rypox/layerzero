#!/bin/bash

# make sample request to proxmox api
# run it on any host with network access to your proxmox host

# Proxmox API settings
PROXMOX_HOST=
API_USER=
API_PASSWORD=
# Load environment variables from .env file
set -a
source .env
set +a

# Step 1: Log in and get the ticket and CSRFPreventionToken
response=$(curl -k -s -d "username=${API_USER}&password=${API_PASSWORD}" "${PROXMOX_HOST}/api2/json/access/ticket")

# Extract ticket and CSRF token using jq (make sure jq is installed)
TICKET=$(echo $response | jq -r '.data.ticket')
CSRF_TOKEN=$(echo $response | jq -r '.data.CSRFPreventionToken')

# Print tokens for verification
echo "Ticket: $TICKET"
echo "CSRF Token: $CSRF_TOKEN"

#now make api request
COOKIE="PVEAuthCookie=${TICKET}"
curl -k -b "$COOKIE" -H "CSRFPreventionToken: $CSRF_TOKEN" "${PROXMOX_HOST}/api2/json/nodes"
