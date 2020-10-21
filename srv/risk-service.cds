using { sap.ui.riskmanagement as my } from '../db/schema';
using {  API_BUSINESS_PARTNER as external } from '../srv/external/API_BUSINESS_PARTNER.csn';
@path: 'service/risk'
service RiskService {
  entity Risks @(restrict : [
            {
                grant : [ 'READ' ],
                to : [ 'RiskViewer' ]
            },
            {
                grant : [ '*' ],
                to : [ 'RiskManager' ]
            }
        ]) as projection on my.Risks;
    //annotate Risks with @odata.draft.enabled; 
  entity Mitigations @(restrict : [
            {
                grant : [ 'READ' ],
                to : [ 'RiskViewer' ]
            },
            {
                grant : [ '*' ],
                to : [ 'RiskManager' ]
            }
        ]) as projection on my.Mitigations;
    annotate Mitigations with @odata.draft.enabled;
    entity BusinessPartners @(restrict : [
            {
                grant : [ 'READ' ],
                to : [ 'RiskViewer' ]
            },
            {
                grant : [ '*' ],
                to : [ 'RiskManager' ]
            }
        ]) as projection on my.BusinessPartners
    annotate BusinessPartners with @odata.draft.enabled;
    @readonly entity API_BusinessPartner as projection on external.A_BusinessPartner{
     key BusinessPartner,
     LastName,
     FirstName
    }
 // entity BusinessPartners as projection on my.BusinessPartners; 
}