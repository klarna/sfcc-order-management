[<img src="https://osm.klarnaservices.com/images/badges/klarna_v2_1.svg" alt="Klarna" width="200">](https://klarna.com)

# Klarna Order Management App for Salesforce Commerce Cloud

## Overview
The Klarna OMS App integrates Salesforce Order Management System (OMS) with Klarna payment solutions. It offers pre-built templates and flows for efficient order handling.

## Key Features
- **Pre-built Flows**: Create, cancel, and return orders with ease.
- **Invocable Actions**: Update order amounts and cancel orders.
- **Payment Gateway Integration**: Includes `KLA_KlarnaAdapter` for fund captures and refunds.
- **Klarna-specific Subflows**: Simplify cancel orders and release unused funds.

## Installation Steps
1. **Setup Requirements**:
   - Klarna SFCC Cartridge installed.
   - OMS enabled and orders flowing into SFOMS.
   - Enable OMS in **B2C Commerce Business Manager**.

2. **Install Code**:
   - Clone the repository and authorize your org.
   - Deploy with `sfdx force:source:deploy -p force-app --targetusername sandboxOrg`.

3. **Configure**:
   - Set up **Named Credential** and **Payment Gateway**.
   - Update permissions for `kpOrderID` and `lineItemJSON`.
   - Reactivate the B2C Commerce Connection.

## Deployment to Production
Promote from sandbox to production using Change Sets or Salesforce CLI. For details, see the [Salesforce Deployment Guide](https://help.salesforce.com/s/articleView?id=sf.deploy_overview.htm&type=5).

## Documentation
- [Klarna Order Management for Salesforce Commerce Cloud](https://docs.klarna.com/platform-solutions/e-commerce-platforms/salesforce-commerce-cloud/order-management)
- [Salesforce Order Management Flows](https://help.salesforce.com/articleView?id=om_configure_om_flows.htm)

## Support
For assistance, email **commercecloud@klarna.com** or check Klarna's status at [status.klarna.com](http://status.klarna.com/).
