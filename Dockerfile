# Use official ERPNext image with latest v15 version
FROM frappe/erpnext:v15.88.1

USER root

# Install git and other dependencies including mysql client for Insights
RUN apt-get update && \
    apt-get install -y git pkg-config default-libmysqlclient-dev build-essential && \
    rm -rf /var/lib/apt/lists/*

USER frappe

WORKDIR /home/frappe/frappe-bench

# Install HRMS (latest v15) - skip assets build
RUN bench get-app --branch version-15 --skip-assets hrms https://github.com/frappe/hrms.git

# Install CRM (latest) - skip assets build  
RUN bench get-app --branch main --skip-assets crm https://github.com/frappe/crm.git

# Install Insights (latest v3) - skip assets build
RUN bench get-app --branch version-3 --skip-assets insights https://github.com/frappe/insights.git

# Install ERPNext Indonesia Localization - skip assets build
RUN bench get-app --branch develop --skip-assets erpnext_indonesia_localization https://github.com/agile-technica/erpnext-indonesia-localization.git

# Set proper permissions
USER frappe

WORKDIR /home/frappe/frappe-bench

# Labels for better image management
LABEL maintainer="PatraG"
LABEL version="v15-latest"
LABEL description="ERPNext v15 with HRMS, CRM, Insights, and Indonesia Localization"
